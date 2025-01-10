import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/models/offer_model.dart';
import 'package:vesture_firebase_user/models/product_filter.dart';
import 'package:vesture_firebase_user/models/product_model.dart';
import 'package:vesture_firebase_user/utilities&Services/google_services.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, String> _brandNameCache = {};
  final Map<String, double> _categoryOfferCache = {};

  // Add cache duration constants
  static const Duration brandCacheDuration = Duration(hours: 1);
  static const Duration offerCacheDuration = Duration(minutes: 15);

  // Add cache timestamp tracking
  final Map<String, DateTime> _brandCacheTimestamps = {};
  final Map<String, DateTime> _offerCacheTimestamps = {};

  Future<List<ProductModel>> fetchProducts() async {
    try {
      // Create both queries
      final Future<QuerySnapshot<Map<String, dynamic>>> productsSnapshot =
          _firestore
              .collection('products')
              .where('isActive', isEqualTo: true)
              .get();

      final Future<QuerySnapshot<Map<String, dynamic>>> categoriesSnapshot =
          _firestore
              .collection('categories')
              .where('isActive', isEqualTo: true)
              .get();

      // Wait for both queries with explicit typing
      final List<QuerySnapshot<Map<String, dynamic>>> results =
          await Future.wait<QuerySnapshot<Map<String, dynamic>>>([
        productsSnapshot,
        categoriesSnapshot,
      ]);

      // Extract results
      final QuerySnapshot<Map<String, dynamic>> productsResult = results[0];
      final QuerySnapshot<Map<String, dynamic>> categoriesResult = results[1];

      // Process results
      final activeCategoryIds =
          categoriesResult.docs.map((doc) => doc.id).toSet();

      final activeProducts = productsResult.docs.where((doc) {
        final data = doc.data();
        return activeCategoryIds.contains(data['parentCategoryId']);
      }).toList();

      return _mapProducts(activeProducts);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> _mapProducts(
      List<QueryDocumentSnapshot> docs) async {
    if (docs.isEmpty) return [];

    try {
      // 1. Create batch queries for variants and size stocks
      final productIds = docs.map((doc) => doc.id).toList();

      // Split into chunks of 10 for Firestore limits
      final chunks = _chunkList(productIds, 10);

      // 2. Fetch variants and size stocks in parallel for each chunk
      final allVariants = <QueryDocumentSnapshot>[];
      final allSizeStocks = <QueryDocumentSnapshot>[];

      for (var chunk in chunks) {
        final variantsQuery = _firestore
            .collection('variants')
            .where('productId', whereIn: chunk)
            .get();

        final results = await variantsQuery;
        allVariants.addAll(results.docs);

        if (results.docs.isNotEmpty) {
          final variantIds = results.docs.map((doc) => doc.id).toList();
          final variantChunks = _chunkList(variantIds, 10);

          for (var variantChunk in variantChunks) {
            final stocksQuery = _firestore
                .collection('sizes_and_stocks')
                .where('variantId', whereIn: variantChunk)
                .get();

            final stockResults = await stocksQuery;
            allSizeStocks.addAll(stockResults.docs);
          }
        }
      }

      // 3. Create efficient lookup maps
      final variantsByProduct = _groupVariantsByProduct(allVariants);
      final sizeStocksByVariant = _groupSizeStocksByVariant(allSizeStocks);

      // 4. Process products in parallel
      final productFutures = docs.map((doc) async {
        final productId = doc.id;
        final productVariants = variantsByProduct[productId] ?? [];

        final variants = productVariants.map((variantDoc) {
          final variantId = variantDoc.id;
          final sizeStocks = sizeStocksByVariant[variantId] ?? [];
          return Variant.fromMap(
              variantDoc.data() as Map<String, dynamic>, variantId, sizeStocks);
        }).toList();

        final brandName = await _fetchBrandNameWithCache(doc);
        final data = doc.data() as Map<String, dynamic>;
        final offer = await _fetchCategoryOfferWithCache(
            data['parentCategoryId'], data['subCategoryId']);

        return ProductModel.fromFirestore(doc, variants, brandName, offer);
      });

      return await Future.wait(productFutures);
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to chunk lists
  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    final chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  // Helper method to group variants by product
  Map<String, List<QueryDocumentSnapshot>> _groupVariantsByProduct(
      List<QueryDocumentSnapshot> variants) {
    final map = <String, List<QueryDocumentSnapshot>>{};
    for (var variant in variants) {
      final data = variant.data() as Map<String, dynamic>;
      final productId = data['productId'] as String;
      map[productId] ??= [];
      map[productId]!.add(variant);
    }
    return map;
  }

  // Helper method to group size stocks by variant
  Map<String, List<SizeStockModel>> _groupSizeStocksByVariant(
      List<QueryDocumentSnapshot> sizeStocks) {
    final map = <String, List<SizeStockModel>>{};
    for (var stock in sizeStocks) {
      final data = stock.data() as Map<String, dynamic>;
      final variantId = data['variantId'] as String;
      map[variantId] ??= [];
      map[variantId]!.add(SizeStockModel.fromMap(data, stock.id));
    }
    return map;
  }

  // Improved brand name caching with expiration
  Future<String?> _fetchBrandNameWithCache(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>?;
    if (data?['brandId'] == null) return null;

    final brandId = data!['brandId'];
    final now = DateTime.now();

    // Check if cache is valid
    if (_brandNameCache.containsKey(brandId) &&
        _brandCacheTimestamps.containsKey(brandId) &&
        now.difference(_brandCacheTimestamps[brandId]!) < brandCacheDuration) {
      return _brandNameCache[brandId];
    }

    // Fetch and update cache
    final brandDoc = await _firestore.collection('brands').doc(brandId).get();
    final brandName = brandDoc.data()?['brandName'] ?? 'Unknown Brand';
    _brandNameCache[brandId] = brandName;
    _brandCacheTimestamps[brandId] = now;

    return brandName;
  }

  // Improved category offer caching with expiration
  Future<double> _fetchCategoryOfferWithCache(
      String? parentCategoryId, String? subCategoryId) async {
    if (parentCategoryId == null && subCategoryId == null) return 0.0;

    final cacheKey = '${parentCategoryId}_${subCategoryId}';
    final now = DateTime.now();

    // Check if cache is valid
    if (_categoryOfferCache.containsKey(cacheKey) &&
        _offerCacheTimestamps.containsKey(cacheKey) &&
        now.difference(_offerCacheTimestamps[cacheKey]!) < offerCacheDuration) {
      return _categoryOfferCache[cacheKey]!;
    }

    // Fetch and update cache
    final offer = await fetchCategoryOffer(parentCategoryId, subCategoryId);
    _categoryOfferCache[cacheKey] = offer;
    _offerCacheTimestamps[cacheKey] = now;

    return offer;
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

  Future<List<ProductModel>> searchProducts(String query,
      {String? categoryId}) async {
    try {
      final lowerCaseQuery = query.toLowerCase().trim();

      // Base query
      Query productsQuery =
          _firestore.collection('products').where('isActive', isEqualTo: true);

      if (categoryId != null) {
        productsQuery =
            productsQuery.where('parentCategoryId', isEqualTo: categoryId);
      }

      final querySnapshot = await productsQuery.get();

      // Filter in memory for better search
      final filteredDocs = querySnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) return false;

        final searchTerms = [
          data['productName']?.toString().toLowerCase() ?? '',
          data['description']?.toString().toLowerCase() ?? '',
          ...(data['searchKeywords'] as List? ?? [])
              .map((k) => k.toString().toLowerCase())
        ];

        return searchTerms.any((term) => term.contains(lowerCaseQuery));
      }).toList();

      return _mapProducts(filteredDocs);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> sortProducts({
    required List<ProductModel> products,
    required String sortOption,
  }) async {
    // Create a copy to avoid modifying the original list
    final sortedProducts = List<ProductModel>.from(products);

    switch (sortOption) {
      case 'Price: lowest to high':
        sortedProducts
            .sort((a, b) => a.getDefaultPrice().compareTo(b.getDefaultPrice()));
      case 'Price: highest to low':
        sortedProducts
            .sort((a, b) => b.getDefaultPrice().compareTo(a.getDefaultPrice()));
      case 'Rating: highest first':
      default:
        // Keep original order or implement rating sort if needed
        break;
    }

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

  Future<List<ProductModel>> fetchProductsByBrand(String brandId) async {
    try {
      final productsSnapshot = await _firestore
          .collection('products')
          .where('isActive', isEqualTo: true)
          .where('brandId', isEqualTo: brandId)
          .get();

      return _mapProducts(productsSnapshot.docs);
    } catch (e) {
      rethrow;
    }
  }
}

extension VisualSearchRepository on ProductRepository {
  Future<List<ProductModel>> searchByImage(File image) async {
    try {
      final visionService = GoogleVisionService();
      final labels = await visionService.detectLabels(image);

      // Fetch all products first
      final allProducts = await fetchProducts();
      if (allProducts.isEmpty) {
        return [];
      }

      // Create a scoring system for products
      final scoredProducts = allProducts.map((product) {
        double score = 0.0;
        final searchKeywords = [
          ...(product.toMap()['searchKeywords'] as List? ?? []),
          product.productName ?? '',
          product.description ?? '',
          ...?product.variants?.map((v) => v.color),
          product.brandName ?? '',
        ].map((s) => s.toString().toLowerCase()).toList();

        // Calculate score based on matching labels
        for (final label in labels) {
          final labelText = label.toLowerCase();
          for (final keyword in searchKeywords) {
            // Exact match gets higher score
            if (keyword == labelText) {
              score += 1.0;
            }
            // Partial match gets lower score
            else if (keyword.contains(labelText) ||
                labelText.contains(keyword)) {
              score += 0.5;
            }
          }
        }

        return MapEntry(product, score);
      }).toList();

      // Sort by score and filter out zero scores
      scoredProducts.sort((a, b) => b.value.compareTo(a.value));
      final results = scoredProducts
          .where((entry) => entry.value > 0)
          .map((entry) => entry.key)
          .toList();

      // Return top matches or empty list if no matches
      return results.take(20).toList();
    } catch (e) {
      rethrow;
    }
  }
}
