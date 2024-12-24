import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
    return products.where((product) {
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
        return false;
      }
      if (filter.selectedBrands.isNotEmpty) {
        final productBrand = product.brandName?.toLowerCase().trim();
        final selectedBrands = filter.selectedBrands
            .map((brand) => brand.toLowerCase().trim())
            .toSet();

        if (productBrand == null || !selectedBrands.contains(productBrand)) {
          return false;
        }
      }

      if (filter.selectedCategory.isNotEmpty &&
          filter.selectedCategory != 'All') {
        print('=== Category Filter Debug ===');
        print('Selected Category ID: "${filter.selectedCategory}"');
        print('Product: ${product.productName}');
        print('Parent Category ID: "${product.parentCategoryId}"');
        print('Sub Category ID: "${product.subCategoryId}"');

        String selectedCategory = filter.selectedCategory.toLowerCase().trim();
        String parentCategory =
            (product.parentCategoryId ?? '').toLowerCase().trim();
        String subCategory = (product.subCategoryId ?? '').toLowerCase().trim();

        print('After normalization:');
        print('Selected Category: "$selectedCategory"');
        print('Parent Category: "$parentCategory"');
        print('Sub Category: "$subCategory"');

        bool categoryMatch = parentCategory == selectedCategory ||
            subCategory == selectedCategory;

        print('Category Match: $categoryMatch');
        print('========================');

        if (!categoryMatch) {
          print('Failed category filter');
          return false;
        }
      }

      if (filter.selectedColors.isNotEmpty) {
        bool hasMatchingColor = false;
        for (var variant in product.variants ?? []) {
          final variantColor = variant.color.toLowerCase().trim();
          final selectedColors =
              filter.selectedColors.map((c) => c.toLowerCase().trim()).toSet();

          print('Checking color: $variantColor against $selectedColors');
          if (selectedColors.contains(variantColor)) {
            hasMatchingColor = true;
            break;
          }
        }
        if (!hasMatchingColor) {
          print('Failed color filter');
          return false;
        }
      }

      if (filter.selectedSizes.isNotEmpty) {
        bool hasMatchingSize = false;
        for (var variant in product.variants ?? []) {
          for (var sizeStock in variant.sizeStocks) {
            final stockSize = sizeStock.size.toLowerCase().trim();
            final selectedSizes =
                filter.selectedSizes.map((s) => s.toLowerCase().trim()).toSet();

            print('Checking size: $stockSize against $selectedSizes');
            if (selectedSizes.contains(stockSize)) {
              hasMatchingSize = true;
              break;
            }
          }
          if (hasMatchingSize) break;
        }
        if (!hasMatchingSize) {
          print('Failed size filter');
          return false;
        }
      }

      print('Product passed all filters');
      return true;
    }).toList();
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
      print(
          'Fetching offer for parentCategoryId: $parentCategoryId and subCategoryId: $subCategoryId');
      final offerQuery = await FirebaseFirestore.instance
          .collection('offers')
          .where('isActive', isEqualTo: true)
          .get();

      double maxOffer = 0.0;
      final now = DateTime.now();

      for (var doc in offerQuery.docs) {
        final offer = OfferModel.fromFirestore(doc);
        print('Checking offer: ${offer.id}');

        // Skip expired or future offers
        if (!offer.validFrom.isBefore(now) || !offer.validTo.isAfter(now)) {
          continue;
        }

        // Check for exact subcategory match first (highest priority)
        if (subCategoryId != null && offer.subCategoryId == subCategoryId) {
          double newOffer = offer.discount;
          maxOffer = newOffer > maxOffer ? newOffer : maxOffer;
          print('Applied specific subcategory offer: $newOffer%');
          continue; // Skip other checks if we found a subcategory match
        }

        // Check for parent category offer only if no subcategory offer was found
        // and only if the offer is explicitly for the parent category with no subcategory
        if (parentCategoryId != null &&
            offer.parentCategoryId == parentCategoryId &&
            offer.subCategoryId == null) {
          double newOffer = offer.discount;
          maxOffer = newOffer > maxOffer ? newOffer : maxOffer;
          print('Applied parent category offer: $newOffer%');
        }
      }

      print('Final offer determined: $maxOffer%');
      return maxOffer;
    } catch (e) {
      print('Error fetching offer: $e');
      return 0.0;
    }
  }

  Future<List<ProductModel>> _mapProducts(
      List<QueryDocumentSnapshot> docs) async {
    List<ProductModel> products = [];

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      print('\nProcessing product: ${data['productName']}');
      print('Parent Category ID: ${data['parentCategoryId']}');
      print('Sub Category ID: ${data['subCategoryId']}');

      final variants = await _fetchVariantsWithSizeStocks(doc.id);
      final brandName = await _fetchBrandName(doc);

      // Fetch the specific offer for this product using the correct category and subcategory
      double finalOffer = await fetchCategoryOffer(
          data['parentCategoryId'], data['subCategoryId']);

      print('Final offer applied: $finalOffer');
      products.add(
          ProductModel.fromFirestore(doc, variants, brandName, finalOffer));
    }

    return products;
  }

  // Future<double> _fetchCategoryOffer(String categoryId) async {
  //   try {
  //     print('Fetching offer for categoryId: $categoryId'); // Debug log

  //     final offerQuery = await _firestore
  //         .collection('offers')
  //         .where('isActive', isEqualTo: true)
  //         .where('offerType', isEqualTo: 'Category')
  //         .get();

  //     print('Found ${offerQuery.docs.length} active offers'); // Debug log

  //     double maxOffer = 0.0;
  //     final now = DateTime.now();

  //     for (var doc in offerQuery.docs) {
  //       final offer = OfferModel.fromFirestore(doc);
  //       print('Checking offer: ${offer.id}'); // Debug log
  //       print(
  //           'Category IDs - Parent: ${offer.parentCategoryId}, Sub: ${offer.subCategoryId}');
  //       print('Checking against category: $categoryId');

  //       if ((offer.parentCategoryId == categoryId ||
  //               offer.subCategoryId == categoryId) &&
  //           offer.validFrom.isBefore(now) &&
  //           offer.validTo.isAfter(now)) {
  //         print(
  //             'Found matching offer with discount: ${offer.discount}'); // Debug log
  //         if (offer.discount > maxOffer) {
  //           maxOffer = offer.discount;
  //         }
  //       }
  //     }

  //     print('Final offer for category $categoryId: $maxOffer'); // Debug log
  //     return maxOffer;
  //   } catch (e) {
  //     print('Error fetching offer: $e');
  //     return 0.0;
  //   }
  // }

  // Future<List<ProductModel>> _mapProducts(
  //     List<QueryDocumentSnapshot> docs) async {
  //   List<ProductModel> products = [];

  //   for (var doc in docs) {
  //     final data = doc.data() as Map<String, dynamic>;
  //     print('\nProcessing product: ${data['productName']}');
  //     print('Parent Category ID: ${data['parentCategoryId']}');
  //     print('Sub Category ID: ${data['subCategoryId']}');

  //     final variants = await _fetchVariantsWithSizeStocks(doc.id);
  //     final brandName = await _fetchBrandName(doc);

  //     // Calculate offer using the enhanced method
  //     double finalOffer = await ProductModel.calculateCategoryOffer(
  //       _firestore,
  //       data['parentCategoryId'],
  //       data['subCategoryId'],
  //     );

  //     print('Final offer applied: $finalOffer');
  //     products.add(
  //         ProductModel.fromFirestore(doc, variants, brandName, finalOffer));
  //   }

  //   return products;
  // }
}
