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
