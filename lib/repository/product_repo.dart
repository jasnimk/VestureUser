import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/models/offer_model.dart';
import 'package:vesture_firebase_user/models/product_filter.dart';
import 'package:vesture_firebase_user/models/product_model.dart';
import 'package:vesture_firebase_user/repository/product_repo.dart';
import 'package:vesture_firebase_user/utilities/color_service.dart';
import 'package:vesture_firebase_user/utilities/google_services.dart';

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

extension VisualSearchRepository on ProductRepository {
  Future<List<ProductModel>> searchByImage(File image) async {
    try {
      final visionService = GoogleVisionService();
      final labels = await visionService.detectLabels(image);
      print('Labels received from Vision API: $labels');

      final labelWords = _processLabels(labels);
      print('Processed label words: $labelWords');

      final querySnapshot = await _firestore
          .collection('products')
          .where('isActive', isEqualTo: true)
          .get();
      print('Total products fetched: ${querySnapshot.docs.length}');

      final scoredProducts = querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            final searchKeywords =
                _processKeywords(data['searchKeywords'] as List? ?? []);
            final score = _calculateMatchScore(labelWords, searchKeywords);
            return ScoredProduct(doc, score);
          })
          .where((product) => product.score > 0)
          .toList();

      // Sort by score in descending order
      scoredProducts.sort((a, b) => b.score.compareTo(a.score));
      print('Matched products count: ${scoredProducts.length}');

      return _mapProducts(scoredProducts.map((sp) => sp.doc).toList());
    } catch (e) {
      print('Error in searchByImage: $e');
      rethrow;
    }
  }

  List<String> _processLabels(List<String> labels) {
    return labels
        .expand((label) => label.toLowerCase().split(' '))
        .map((word) => word.replaceAll(RegExp(r'[^\w\s]+'), ''))
        .where((word) => word.isNotEmpty)
        .toSet()
        .toList();
  }

  List<String> _processKeywords(List<dynamic> keywords) {
    return keywords
        .map((k) =>
            k.toString().toLowerCase().replaceAll(RegExp(r'[^\w\s]+'), ''))
        .toList();
  }

  double _calculateMatchScore(
      List<String> labelWords, List<String> searchKeywords) {
    double score = 0.0;
    int commonWords = 0;

    for (var labelWord in labelWords) {
      // Exact match has highest weight
      if (searchKeywords.contains(labelWord)) {
        score += 1.0;
        commonWords++;
        continue;
      }

      // Partial matches with length consideration
      for (var keyword in searchKeywords) {
        if (keyword.contains(labelWord) || labelWord.contains(keyword)) {
          // Calculate similarity based on length difference
          double lengthScore = 1 -
              (labelWord.length - keyword.length).abs() /
                  max(labelWord.length, keyword.length);
          score += 0.5 * lengthScore;
          commonWords++;
          break;
        }
      }
    }

    // Boost score based on proportion of common words
    double commonWordRatio =
        commonWords / max(labelWords.length, searchKeywords.length);
    return score * (1 + commonWordRatio);
  }
}

class ScoredProduct {
  final QueryDocumentSnapshot doc;
  final double score;

  ScoredProduct(this.doc, this.score);
}

// extension VisualSearchRepository on ProductRepository {
//   Future<List<ProductModel>> searchByImage(File image) async {
//     try {
//       final visionService = GoogleVisionService();
//       final labels = await visionService.detectLabels(image);
//       print('Labels received from Vision API: $labels');

//       // Split labels into individual words and normalize
//       final labelWords = labels
//           .expand((label) => label.toLowerCase().split(' '))
//           .map((word) => word.replaceAll(RegExp(r'[^\w\s]+'), ''))
//           .where((word) => word.isNotEmpty)
//           .toSet()
//           .toList();

//       print('Processed label words: $labelWords');

//       final querySnapshot = await _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .get();

//       print('Total products fetched: ${querySnapshot.docs.length}');

//       final products = querySnapshot.docs.where((doc) {
//         final data = doc.data();
//         final searchKeywords = (data['searchKeywords'] as List? ?? [])
//             .map((k) =>
//                 k.toString().toLowerCase().replaceAll(RegExp(r'[^\w\s]+'), ''))
//             .toList();

//         print('Product ${doc.id} keywords: $searchKeywords');

//         bool hasMatch = false;
//         for (var labelWord in labelWords) {
//           // Check for exact matches first
//           if (searchKeywords.contains(labelWord)) {
//             hasMatch = true;
//             break;
//           }
//           // Then check for partial matches
//           if (searchKeywords.any((keyword) =>
//               keyword.contains(labelWord) || labelWord.contains(keyword))) {
//             hasMatch = true;
//             break;
//           }
//         }

//         print('Product ${doc.id} matches: $hasMatch');
//         return hasMatch;
//       }).toList();

//       print('Matched products count: ${products.length}');
//       return _mapProducts(products);
//     } catch (e) {
//       print('Error in searchByImage: $e');
//       rethrow;
//     }
//   }
// }
// extension VisualSearchRepository on ProductRepository {
//   Future<List<ProductModel>> searchByImage(File image) async {
//     try {
//       final visionService = GoogleVisionService();
//       final labels = await visionService.detectLabels(image);
//       print('Labels received from Vision API: $labels');

//       final querySnapshot = await _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .get();

//       print('Total products fetched: ${querySnapshot.docs.length}');

//       final products = querySnapshot.docs.where((doc) {
//         final data = doc.data();
//         final searchKeywords = (data['searchKeywords'] as List? ?? [])
//             .map((k) => k.toString().toLowerCase())
//             .toList();

//         print('Product ${doc.id} keywords: $searchKeywords');

//         final matches = labels
//             .where((label) => searchKeywords.any((keyword) =>
//                 label.toLowerCase().contains(keyword.toLowerCase())))
//             .toList();

//         print('Matching labels for product ${doc.id}: $matches');

//         return matches.isNotEmpty;
//       }).toList();

//       print('Matched products count: ${products.length}');

//       return _mapProducts(products);
//     } catch (e, stackTrace) {
//       print('Error in searchByImage: $e');
//       print('Stack trace: $stackTrace');
//       rethrow;
//     }
//   }
// }
// extension VisualSearchRepository on ProductRepository {
//   Future<List<ProductModel>> searchByImage(File image) async {
//     try {
//       final visionService = GoogleVisionService();
//       final labels = await visionService.detectLabels(image);

//       // Search for products matching the detected labels
//       final querySnapshot = await _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .get();

//       final products = querySnapshot.docs.where((doc) {
//         final data = doc.data();
//         final searchKeywords = (data['searchKeywords'] as List? ?? [])
//             .map((k) => k.toString().toLowerCase())
//             .toList();

//         return labels.any((label) => searchKeywords
//             .any((keyword) => keyword.contains(label.toLowerCase())));
//       }).toList();

//       return _mapProducts(products);
//     } catch (e) {
//       print('Error in searchByImage: $e');
//       rethrow;
//     }
//   }
// }
// extension VisualSearchRepository on ProductRepository {
//   Future<List<ProductModel>> searchByImage(File image) async {
//     try {
//       final mlService = FirebaseMLService();
//       final labels = await mlService.detectLabels(image);
//       mlService.dispose();

//       // Search for products matching the detected labels
//       final querySnapshot = await _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .get();

//       final products = querySnapshot.docs.where((doc) {
//         final data = doc.data();
//         final searchKeywords = (data['searchKeywords'] as List? ?? [])
//             .map((k) => k.toString().toLowerCase())
//             .toList();

//         // Enhanced matching logic
//         return labels.any((label) {
//           // Check for exact matches first
//           if (searchKeywords.contains(label)) return true;

//           // Then check for partial matches
//           return searchKeywords.any(
//               (keyword) => keyword.contains(label) || label.contains(keyword));
//         });
//       }).toList();

//       return _mapProducts(products);
//     } catch (e) {
//       print('Error in searchByImage: $e');
//       rethrow;
//     }
//   }
// }
// extension VisualSearchRepository on ProductRepository {
//   Future<List<ProductModel>> searchByImage(File image) async {
//     try {
//       final mlService = FirebaseMLService();
//       final labels = await mlService.detectLabels(image);
//       mlService.dispose();

//       // Extract relevant labels for product search
//       final searchLabels = labels
//           .where((label) => label.confidence > 0.7)
//           .map((label) => label.label.toLowerCase())
//           .toList();

//       print('Searching for products with labels: $searchLabels');

//       final querySnapshot = await _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .get();

//       final products = querySnapshot.docs.where((doc) {
//         final data = doc.data();
//         final searchKeywords = (data['searchKeywords'] as List? ?? [])
//             .map((k) => k.toString().toLowerCase())
//             .toList();

//         print('Product ${doc.id} keywords: $searchKeywords');

//         final matches = searchLabels
//             .where((label) => searchKeywords.any((keyword) =>
//                 keyword.contains(label) || label.contains(keyword)))
//             .toList();

//         if (matches.isNotEmpty) {
//           print('Matched labels for product ${doc.id}: $matches');
//         }

//         return matches.isNotEmpty;
//       }).toList();

//       return _mapProducts(products);
//     } catch (e) {
//       print('Error in searchByImage: $e');
//       rethrow;
//     }
//   }
// // }
// extension VisualSearchRepository on ProductRepository {
//   Future<List<ProductModel>> searchByImage(File image) async {
//     try {
//       final mlService = FirebaseMLService();
//       final labels = await mlService.detectLabels(image);
//       mlService.dispose();

//       // Print all detected labels with confidence scores
//       print('\n=== Detected Labels ===');
//       for (var label in labels) {
//         print('Label: ${label.label}');
//         print('Confidence: ${(label.confidence * 100).toStringAsFixed(2)}%');
//         print('---------------------');
//       }

//       // Convert labels to search terms
//       final searchLabels = labels
//           .where((label) => label.confidence > 0.7)
//           .map((label) => label.label.toLowerCase())
//           .toList();

//       print('\n=== Search Labels Used ===');
//       print(searchLabels);

//       final querySnapshot = await _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .get();

//       print('\n=== Searching Products ===');
//       final products = querySnapshot.docs.where((doc) {
//         final data = doc.data();
//         final productName = data['productName'] ?? '';
//         final searchKeywords = (data['searchKeywords'] as List? ?? [])
//             .map((k) => k.toString().toLowerCase())
//             .toList();

//         print('\nChecking Product: $productName');
//         print('Keywords: $searchKeywords');

//         final matches = searchLabels.where((label) {
//           final isMatch = searchKeywords.any(
//               (keyword) => keyword.contains(label) || label.contains(keyword));
//           if (isMatch) {
//             print('✓ Matched label: $label');
//           }
//           return isMatch;
//         }).toList();

//         if (matches.isNotEmpty) {
//           print('Found ${matches.length} matches for this product');
//         } else {
//           print('No matches found for this product');
//         }

//         return matches.isNotEmpty;
//       }).toList();

//       print('\n=== Search Results ===');
//       print('Found ${products.length} matching products');

//       return _mapProducts(products);
//     } catch (e) {
//       print('\n=== Error in searchByImage ===');
//       print(e);
//       rethrow;
//     }
//   }
// // }
// extension VisualSearchRepository on ProductRepository {
//   Future<List<ProductModel>> searchByImage(File image) async {
//     try {
//       final mlService = FirebaseMLService();
//       final detections = await mlService.analyzeImage(image);

//       // Filter high-confidence detections
//       final highConfidenceDetections = detections.entries
//           .where((e) => e.value > 0.7)
//           .toList()
//         ..sort((a, b) => b.value.compareTo(a.value));

//       print('\n=== High Confidence Detections ===');
//       for (var detection in highConfidenceDetections) {
//         print(
//             '${detection.key}: ${(detection.value * 100).toStringAsFixed(2)}%');
//       }

//       // Get all products
//       final querySnapshot = await _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .get();

//       // Score each product based on matching keywords
//       final scoredProducts = querySnapshot.docs
//           .map((doc) {
//             final data = doc.data();
//             final productName =
//                 (data['productName'] as String? ?? '').toLowerCase();
//             final description =
//                 (data['description'] as String? ?? '').toLowerCase();
//             final searchKeywords = Set<String>.from(
//                 (data['searchKeywords'] as List? ?? [])
//                     .map((k) => k.toString().toLowerCase()));

//             // Calculate match score
//             double score = 0;
//             final matches = <String>[];

//             for (var detection in highConfidenceDetections) {
//               final label = detection.key;
//               final confidence = detection.value;

//               // Check exact matches
//               if (searchKeywords.contains(label)) {
//                 score += confidence * 2;
//                 matches.add('$label (exact)');
//               }
//               // Check product name
//               else if (productName.contains(label)) {
//                 score += confidence * 1.5;
//                 matches.add('$label (name)');
//               }
//               // Check description
//               else if (description.contains(label)) {
//                 score += confidence;
//                 matches.add('$label (description)');
//               }
//               // Check partial matches in keywords
//               else if (searchKeywords
//                   .any((k) => k.contains(label) || label.contains(k))) {
//                 score += confidence * 0.5;
//                 matches.add('$label (partial)');
//               }
//             }

//             print('\nProduct: ${data['productName']}');
//             print('Score: ${score.toStringAsFixed(2)}');
//             print('Matches: $matches');

//             return MapEntry(doc, score);
//           })
//           .where((entry) =>
//               entry.value > 0.5) // Only keep products with good matches
//           .toList()
//         ..sort((a, b) => b.value.compareTo(a.value)); // Sort by score

//       final matchingDocs = scoredProducts.map((e) => e.key).toList();

//       print('\n=== Final Results ===');
//       print('Found ${matchingDocs.length} matching products');

//       return _mapProducts(matchingDocs);
//     } catch (e) {
//       print('Error in searchByImage: $e');
//       rethrow;
//     }
//   }
// // }
// extension ColorBasedSearchRepository on ProductRepository {
//   Future<List<ProductModel>> searchByImage(File image) async {
//     try {
//       final colorService = ColorSearchService();
//       final dominantColors = colorService.extractDominantColors(image);

//       print('\n=== Detected Colors ===');
//       dominantColors.forEach((color, percentage) {
//         print('$color: ${(percentage * 100).toStringAsFixed(2)}%');
//       });

//       // Lower threshold for color matching
//       final significantColors = dominantColors.entries
//           .where((entry) => entry.value > 0.03) // 3% threshold
//           .map((entry) => entry.key)
//           .toList();

//       print('\n=== Significant Colors for Search ===');
//       print(significantColors);

//       // First get all products
//       final querySnapshot = await _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .get();

//       // Create a list to store products with their variants
//       List<QueryDocumentSnapshot> matchingProducts = [];

//       // For each product, fetch its variants and check colors
//       for (var doc in querySnapshot.docs) {
//         // Fetch variants for this product
//         final variants = await _fetchVariantsWithSizeStocks(doc.id);

//         // Extract colors from variants
//         final productColors = variants
//             .map((variant) => variant.color.toLowerCase())
//             .where((color) => color.isNotEmpty)
//             .toSet()
//             .toList();

//         print('\nProduct: ${doc.data()['productName']}');
//         print('Product colors: $productColors');

//         // Check if any significant colors match this product's colors
//         bool hasMatchingColor = significantColors.any((searchColor) {
//           return productColors.any((productColor) {
//             final normalizedProductColor = normalizeColorName(productColor);
//             final normalizedSearchColor = searchColor.toLowerCase();
//             final isMatch = normalizedProductColor == normalizedSearchColor;
//             if (isMatch) {
//               print('Match found: $searchColor matches with $productColor');
//             }
//             return isMatch;
//           });
//         });

//         if (hasMatchingColor) {
//           matchingProducts.add(doc);
//         }
//       }

//       print('\n=== Search Results ===');
//       print('Found ${matchingProducts.length} matching products');

//       return _mapProducts(matchingProducts);
//     } catch (e) {
//       print('Error in searchByImage: $e');
//       rethrow;
//     }
//   }

//   String normalizeColorName(String color) {
//     final colorMappings = {
//       'white': ['white', 'ivory', 'cream', 'off-white'],
//       'black': ['black', 'jet', 'onyx'],
//       'gray-light': ['light gray', 'silver', 'light grey', 'pearl'],
//       'gray-dark': ['dark gray', 'charcoal', 'dark grey', 'slate'],
//       'blue': ['blue', 'navy', 'azure', 'indigo', 'royal'],
//       'red': ['red', 'maroon', 'crimson', 'burgundy'],
//       'green': ['green', 'olive', 'emerald', 'forest'],
//       'yellow': ['yellow', 'gold', 'mustard'],
//       'purple': ['purple', 'violet', 'lavender', 'plum'],
//       'pink': ['pink', 'rose', 'salmon', 'coral'],
//       'brown': ['brown', 'tan', 'khaki', 'beige'],
//       'cyan': ['cyan', 'turquoise', 'aqua', 'teal']
//     };

//     color = color.toLowerCase().trim();
//     for (var entry in colorMappings.entries) {
//       if (entry.value.contains(color)) {
//         return entry.key;
//       }
//     }
//     return color;
//   }
// }
