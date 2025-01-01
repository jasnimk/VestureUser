import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/models/offer_model.dart';
import 'package:vesture_firebase_user/models/product_filter.dart';
import 'package:vesture_firebase_user/models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final categoriesSnapshot = await _firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .get();

      final activeCategoryIds =
          categoriesSnapshot.docs.map((doc) => doc.id).toList();

      final productsSnapshot = await _firestore
          .collection('products')
          .where('isActive', isEqualTo: true)
          .where('parentCategoryId', whereIn: activeCategoryIds)
          .get();

      return _mapProducts(productsSnapshot.docs);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> fetchProductsByCategory(String categoryId) async {
    try {
      final parentCategoryQuery = _firestore
          .collection('products')
          .where('isActive', isEqualTo: true)
          .where('parentCategoryId', isEqualTo: categoryId)
          .get();

      final subCategoryQuery = _firestore
          .collection('products')
          .where('isActive', isEqualTo: true)
          .where('subCategoryId', isEqualTo: categoryId)
          .get();

      final querySnapshots =
          await Future.wait([parentCategoryQuery, subCategoryQuery]);

      final combinedDocs =
          querySnapshots.expand((snapshot) => snapshot.docs).toSet().toList();

      return _mapProducts(combinedDocs);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final lowerCaseQuery = query.toLowerCase().trim();

      var querySnapshot = await _firestore
          .collection('products')
          .where('searchKeywords', arrayContains: lowerCaseQuery)
          .where('isActive', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        querySnapshot = await _firestore
            .collection('products')
            .where('isActive', isEqualTo: true)
            .get();
      }

      final filteredDocs = querySnapshot.docs.where((doc) {
        final data = doc.data();
        final searchKeywords = (data['searchKeywords'] as List? ?? [])
            .map((k) => k.toString().toLowerCase())
            .toList();

        return searchKeywords
                .any((keyword) => keyword.contains(lowerCaseQuery)) ||
            (data['productName'] as String?)
                    ?.toLowerCase()
                    .contains(lowerCaseQuery) ==
                true ||
            (data['description'] as String?)
                    ?.toLowerCase()
                    .contains(lowerCaseQuery) ==
                true;
      }).toList();

      return _mapProducts(filteredDocs);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Variant>> _fetchVariantsWithSizeStocks(String productId) async {
    try {
      final variantsSnapshot = await _firestore
          .collection('variants')
          .where('productId', isEqualTo: productId)
          .get();

      List<Variant> variants = [];
      for (var variantDoc in variantsSnapshot.docs) {
        final sizeStocksSnapshot = await _firestore
            .collection('sizes_and_stocks')
            .where('variantId', isEqualTo: variantDoc.id)
            .get();

        List<SizeStockModel> sizeStocks = sizeStocksSnapshot.docs
            .map((doc) => SizeStockModel.fromMap(doc.data(), doc.id))
            .toList();

        variants
            .add(Variant.fromMap(variantDoc.data(), variantDoc.id, sizeStocks));
      }
      return variants;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> _fetchBrandName(DocumentSnapshot doc) async {
    try {
      final docData = doc.data() as Map<String, dynamic>?;
      if (docData?['brandId'] == null) return null;

      final brandDoc =
          await _firestore.collection('brands').doc(docData!['brandId']).get();

      return brandDoc.data()?['brandName'] ?? 'Unknown Brand';
    } catch (e) {
      return 'Unknown Brand';
    }
  }

  Future<List<ProductModel>> sortProducts(
      {required List<ProductModel> products,
      required String sortOption}) async {
    switch (sortOption) {
      case 'Price: lowest to high':
        return _sortByPriceLowestToHighest(products);
      case 'Price: highest to low':
        return _sortByPriceHighestToLowest(products);
      case 'Rating: highest first':
      default:
        return products;
    }
  }

  List<ProductModel> _sortByPriceLowestToHighest(List<ProductModel> products) {
    List<ProductModel> sortedProducts = List.from(products);
    sortedProducts.sort((a, b) {
      double priceA = a.getDefaultPrice();
      double priceB = b.getDefaultPrice();
      return priceA.compareTo(priceB);
    });
    return sortedProducts;
  }

  List<ProductModel> _sortByPriceHighestToLowest(List<ProductModel> products) {
    List<ProductModel> sortedProducts = List.from(products);
    sortedProducts.sort((a, b) {
      double priceA = a.getDefaultPrice();
      double priceB = b.getDefaultPrice();
      return priceB.compareTo(priceA);
    });
    return sortedProducts;
  }

  Future<List<ProductModel>> applyFilters(
      List<ProductModel> products, ProductFilter filter) async {
    List<ProductModel> filteredProducts = [];

    for (var product in products) {
      // Price filter
      double productMinPrice = double.infinity;
      double productMaxPrice = 0;

      for (var variant in product.variants ?? []) {
        for (var sizeStock in variant.sizeStocks) {
          if (sizeStock.baseprice < productMinPrice) {
            productMinPrice = sizeStock.baseprice;
          }
          if (sizeStock.baseprice > productMaxPrice) {
            productMaxPrice = sizeStock.baseprice;
          }
        }
      }

      if (productMaxPrice < filter.priceRange.start ||
          productMinPrice > filter.priceRange.end) {
        continue;
      }

      if (filter.selectedBrands.isNotEmpty) {
        final productBrand = product.brandName?.toLowerCase().trim();
        final selectedBrands = filter.selectedBrands
            .map((brand) => brand.toLowerCase().trim())
            .toSet();

        if (productBrand == null || !selectedBrands.contains(productBrand)) {
          continue;
        }
      }

      if (filter.selectedCategory.isNotEmpty &&
          filter.selectedCategory != 'All') {
        bool categoryMatch = false;
        String selectedCategory = filter.selectedCategory.toLowerCase().trim();

        if (product.parentCategoryId != null) {
          final parentCategoryDoc = await _firestore
              .collection('categories')
              .doc(product.parentCategoryId)
              .get();
          String parentCategoryName =
              (parentCategoryDoc.data()?['name'] ?? '').toLowerCase().trim();
          if (parentCategoryName == selectedCategory) {
            categoryMatch = true;
          }
        }

        if (!categoryMatch && product.subCategoryId != null) {
          final subCategoryDoc = await _firestore
              .collection('categories')
              .doc(product.subCategoryId)
              .get();
          String subCategoryName =
              (subCategoryDoc.data()?['name'] ?? '').toLowerCase().trim();
          if (subCategoryName == selectedCategory) {
            categoryMatch = true;
          }
        }

        if (!categoryMatch) {
          continue;
        }
      }

      if (filter.selectedColors.isNotEmpty) {
        bool hasMatchingColor = false;
        for (var variant in product.variants ?? []) {
          final variantColor = variant.color.toLowerCase().trim();
          final selectedColors =
              filter.selectedColors.map((c) => c.toLowerCase().trim()).toSet();

          if (selectedColors.contains(variantColor)) {
            hasMatchingColor = true;
            break;
          }
        }
        if (!hasMatchingColor) {
          continue;
        }
      }

      if (filter.selectedSizes.isNotEmpty) {
        bool hasMatchingSize = false;
        for (var variant in product.variants ?? []) {
          for (var sizeStock in variant.sizeStocks) {
            final stockSize = sizeStock.size.toLowerCase().trim();
            final selectedSizes =
                filter.selectedSizes.map((s) => s.toLowerCase().trim()).toSet();

            if (selectedSizes.contains(stockSize)) {
              hasMatchingSize = true;
              break;
            }
          }
          if (hasMatchingSize) break;
        }
        if (!hasMatchingSize) {
          continue;
        }
      }

      filteredProducts.add(product);
    }

    return filteredProducts;
  }

  Future<ProductFilter> getInitialFilter(List<ProductModel> products) async {
    double minPrice = double.infinity;
    double maxPrice = 0;

    for (var product in products) {
      double price = product.getDefaultPrice();
      if (price < minPrice) minPrice = price;
      if (price > maxPrice) maxPrice = price;
    }

    return ProductFilter(
      priceRange: RangeValues(minPrice, maxPrice),
      selectedColors: {},
      selectedSizes: {},
      selectedBrands: {},
      selectedCategory: '',
    );
  }

  Future<double> fetchCategoryOffer(
      String? parentCategoryId, String? subCategoryId) async {
    try {
      final offerQuery = await FirebaseFirestore.instance
          .collection('offers')
          .where('isActive', isEqualTo: true)
          .get();

      double maxOffer = 0.0;
      final now = DateTime.now();

      for (var doc in offerQuery.docs) {
        final offer = OfferModel.fromFirestore(doc);

        if (!offer.validFrom.isBefore(now) || !offer.validTo.isAfter(now)) {
          continue;
        }

        if (subCategoryId != null && offer.subCategoryId == subCategoryId) {
          double newOffer = offer.discount;

          maxOffer = newOffer > maxOffer ? newOffer : maxOffer;
          continue;
        }

        if (parentCategoryId != null &&
            offer.parentCategoryId == parentCategoryId &&
            offer.subCategoryId == null) {
          double newOffer = offer.discount;
          maxOffer = newOffer > maxOffer ? newOffer : maxOffer;
        }
      }

      return maxOffer;
    } catch (e) {
      return 0.0;
    }
  }

  Future<List<ProductModel>> _mapProducts(
      List<QueryDocumentSnapshot> docs) async {
    List<ProductModel> products = [];

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;

      final variants = await _fetchVariantsWithSizeStocks(doc.id);
      final brandName = await _fetchBrandName(doc);

      double finalOffer = await fetchCategoryOffer(
          data['parentCategoryId'], data['subCategoryId']);

      products.add(
          ProductModel.fromFirestore(doc, variants, brandName, finalOffer));
    }

    return products;
  }
}
