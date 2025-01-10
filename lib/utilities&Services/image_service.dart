// // // import 'dart:io';
// // // import 'package:tflite_flutter/tflite_flutter.dart';
// // // import 'package:image/image.dart' as img;

// // // class ImageSearchService {
// // //   late Interpreter _interpreter;

// // //   Future<void> initialize() async {
// // //     _interpreter = await Interpreter.fromAsset('assets/mobilenet_v2.tflite');
// // //   }

// // //   Future<List<String>> getImageFeatures(File imageFile) async {
// // //     // Load and preprocess image
// // //     final image = img.decodeImage(await imageFile.readAsBytes())!;
// // //     final resized = img.copyResize(image, width: 224, height: 224);

// // //     // Convert to float array and normalize
// // //     var input = List.generate(
// // //       1,
// // //       (index) => List.generate(
// // //         224,
// // //         (y) => List.generate(
// // //           224,
// // //           (x) {
// // //             final pixel = resized.getPixel(x, y);
// // //             return [
// // //               img.getRed(pixel) / 255.0,
// // //               img.getGreen(pixel) / 255.0,
// // //               img.getBlue(pixel) / 255.0,
// // //             ];
// // //           },
// // //         ),
// // //       ),
// // //     );

// // //     // Run inference
// // //     var output = List.filled(1 * 1000, 0).reshape([1, 1000]);
// // //     _interpreter.run(input, output);

// // //     // Get top predictions
// // //     final features = <String>[];
// // //     // Convert output to meaningful labels using a label map
// // //     // Add your label mapping logic here

// // //     return features;
// // //   }

// // //   void dispose() {
// // //     _interpreter.close();
// // //   }
// // // }
// // import 'dart:io';
// // import 'package:tflite_flutter/tflite_flutter.dart';
// // import 'package:image/image.dart' as img;

// // class ImageSearchService {
// //   late Interpreter _interpreter;

// //   Future<void> initialize() async {
// //     _interpreter = await Interpreter.fromAsset('assets/mobilenet_v2.tflite');
// //   }

// //   Future<List<String>> getImageFeatures(File imageFile) async {
// //     // Load and preprocess image
// //     final image = img.decodeImage(await imageFile.readAsBytes())!;
// //     final resized = img.copyResize(image, width: 224, height: 224);

// //     // Convert to float array and normalize
// //     var input = List.generate(
// //       1,
// //       (index) => List.generate(
// //         224,
// //         (y) => List.generate(
// //           224,
// //           (x) {
// //             final pixel = resized.getPixel(x, y);
// //             return [
// //               pixel.r / 255.0, // Red component
// //               pixel.g / 255.0, // Green component
// //               pixel.b / 255.0, // Blue component
// //             ];
// //           },
// //         ),
// //       ),
// //     );

// //     // Run inference
// //     var output = List.filled(1 * 1000, 0).reshape([1, 1000]);
// //     _interpreter.run(input, output);

// //     // Get top predictions
// //     final features = <String>[];
// //     // TODO: Add label mapping logic here
// //     // Example:
// //     // final scores = output[0];
// //     // for (var i = 0; i < scores.length; i++) {
// //     //   if (scores[i] > threshold) {
// //     //     features.add(labelMap[i]);
// //     //   }
// //     // }

// //     return features;
// //   }

// //   void dispose() {
// //     _interpreter.close();
// //   }
// // }
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;

// class ProductVariant {
//   final String id;
//   final String color;
//   final Map<String, int> sizeStock;

//   ProductVariant({
//     required this.id,
//     required this.color,
//     required this.sizeStock,
//   });
// }

// class ProductModel {
//   final String id;
//   final String name;
//   final String description;
//   final List<String> categories;
//   final double price;
//   final List<String> images;
//   final bool isActive;

//   ProductModel({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.categories,
//     required this.price,
//     required this.images,
//     required this.isActive,
//   });
// }

// class ImageSearchResult {
//   final List<String> categories;
//   final Map<String, double> colors;
//   final double confidence;

//   ImageSearchResult({
//     required this.categories,
//     required this.colors,
//     required this.confidence,
//   });
// }

// class EnhancedImageSearchService {
//   late Interpreter _interpreter;
//   late Map<int, String> _labelMap;
//   final double _confidenceThreshold = 0.7;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> initialize() async {
//     try {
//       // Initialize TFLite
//       _interpreter = await Interpreter.fromAsset('assets/mobilenet_v2.tflite');

//       // Initialize label map - customize these categories based on your product catalog
//       _labelMap = {
//         0: 't-shirt',
//         1: 'dress',
//         2: 'pants',
//         3: 'shoes',
//         // Add more mappings based on your model's output classes
//       };

//       print('Image search service initialized successfully');
//     } catch (e) {
//       print('Failed to initialize image search service: $e');
//       rethrow;
//     }
//   }

//   Future<ImageSearchResult> analyzeImage(File imageFile) async {
//     try {
//       // 1. Extract features using TFLite
//       final features = await _extractFeatures(imageFile);

//       // 2. Extract colors
//       final colors = await _extractColors(imageFile);

//       // 3. Combine results
//       return ImageSearchResult(
//         categories: features.categories,
//         colors: colors,
//         confidence: features.confidence,
//       );
//     } catch (e) {
//       print('Error analyzing image: $e');
//       rethrow;
//     }
//   }

//   Future<({List<String> categories, double confidence})> _extractFeatures(
//       File imageFile) async {
//     // Load and preprocess image
//     final image = img.decodeImage(await imageFile.readAsBytes())!;
//     final resized = img.copyResize(image, width: 224, height: 224);

//     // Prepare input data
//     var input = List.generate(
//       1,
//       (index) => List.generate(
//         224,
//         (y) => List.generate(
//           224,
//           (x) {
//             final pixel = resized.getPixel(x, y);
//             return [
//               pixel.r / 255.0,
//               pixel.g / 255.0,
//               pixel.b / 255.0,
//             ];
//           },
//         ),
//       ),
//     );

//     // Run inference
//     var output = List.filled(1 * 1000, 0.0).reshape([1, 1000]);
//     _interpreter.run(input, output);

//     // Process results
//     final List<String> detectedCategories = [];
//     double maxConfidence = 0.0;

//     for (var i = 0; i < output[0].length; i++) {
//       final confidence = output[0][i];
//       if (confidence > _confidenceThreshold && _labelMap.containsKey(i)) {
//         detectedCategories.add(_labelMap[i]!);
//         if (confidence > maxConfidence) {
//           maxConfidence = confidence;
//         }
//       }
//     }

//     return (categories: detectedCategories, confidence: maxConfidence);
//   }

//   Future<Map<String, double>> _extractColors(File imageFile) async {
//     final image = img.decodeImage(await imageFile.readAsBytes())!;
//     final resized = img.copyResize(image, width: 100, height: 100);

//     Map<String, int> colorCounts = {};
//     int totalPixels = resized.width * resized.height;

//     for (int y = 0; y < resized.height; y++) {
//       for (int x = 0; x < resized.width; x++) {
//         final pixel = resized.getPixel(x, y);
//         final color = _getNormalizedColorName(
//             pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());
//         colorCounts[color] = (colorCounts[color] ?? 0) + 1;
//       }
//     }

//     // Convert counts to percentages
//     Map<String, double> colorPercentages = {};
//     colorCounts.forEach((color, count) {
//       colorPercentages[color] = count / totalPixels;
//     });

//     return colorPercentages;
//   }

//   Future<List<ProductVariant>> _fetchVariantsWithSizeStocks(
//       String productId) async {
//     try {
//       final variantsSnapshot = await _firestore
//           .collection('products')
//           .doc(productId)
//           .collection('variants')
//           .get();

//       return variantsSnapshot.docs.map((doc) {
//         final data = doc.data();
//         return ProductVariant(
//           id: doc.id,
//           color: data['color'] ?? '',
//           sizeStock: Map<String, int>.from(data['sizeStock'] ?? {}),
//         );
//       }).toList();
//     } catch (e) {
//       print('Error fetching variants: $e');
//       rethrow;
//     }
//   }

//   ProductModel _convertToProductModel(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return ProductModel(
//       id: doc.id,
//       name: data['name'] ?? '',
//       description: data['description'] ?? '',
//       categories: List<String>.from(data['categories'] ?? []),
//       price: (data['price'] ?? 0.0).toDouble(),
//       images: List<String>.from(data['images'] ?? []),
//       isActive: data['isActive'] ?? false,
//     );
//   }

//   String _getNormalizedColorName(int r, int g, int b) {
//     // Convert RGB to HSV
//     final max = [r, g, b].reduce((a, b) => a > b ? a : b) / 255.0;
//     final min = [r, g, b].reduce((a, b) => a < b ? a : b) / 255.0;
//     final delta = max - min;

//     double hue = 0;
//     if (delta != 0) {
//       if (max == r / 255.0) {
//         hue = 60 * (((g - b) / 255.0) / delta);
//       } else if (max == g / 255.0) {
//         hue = 60 * (((b - r) / 255.0) / delta + 2);
//       } else {
//         hue = 60 * (((r - g) / 255.0) / delta + 4);
//       }
//       if (hue < 0) hue += 360;
//     }

//     final saturation = max == 0 ? 0 : delta / max;
//     final value = max;

//     // Color classification logic
//     if (value < 0.2) return 'black';
//     if (value > 0.9 && saturation < 0.1) return 'white';
//     if (saturation < 0.1) return value < 0.5 ? 'gray-dark' : 'gray-light';

//     // Hue-based classification
//     if (hue <= 30 || hue > 330) return value < 0.6 ? 'brown' : 'red';
//     if (hue <= 90) return 'yellow';
//     if (hue <= 150) return 'green';
//     if (hue <= 210) return 'cyan';
//     if (hue <= 270) return 'blue';
//     if (hue <= 330) return 'purple';

//     return 'other';
//   }

//   Future<List<ProductModel>> searchProducts(
//       ImageSearchResult searchResult) async {
//     try {
//       // 1. First filter by categories
//       var query = _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .where('categories', arrayContainsAny: searchResult.categories);

//       // 2. Get initial results
//       final querySnapshot = await query.get();

//       // 3. Score and filter results based on colors and features
//       final scoredProducts = await Future.wait(
//         querySnapshot.docs.map((doc) async {
//           // Get product variants
//           final variants = await _fetchVariantsWithSizeStocks(doc.id);

//           // Calculate color match score
//           double colorScore = _calculateColorMatchScore(
//             searchResult.colors,
//             variants.map((v) => v.color).toSet(),
//           );

//           // Calculate category match score
//           double categoryScore = searchResult.categories
//                   .where((c) =>
//                       (doc.data() as Map<String, dynamic>)['categories']
//                           .contains(c))
//                   .length /
//               searchResult.categories.length;

//           // Combined score (adjust weights as needed)
//           double totalScore = (colorScore * 0.6) + (categoryScore * 0.4);

//           return (doc: doc, score: totalScore);
//         }),
//       );

//       // 4. Sort by score and return top results
//       scoredProducts.sort((a, b) => b.score.compareTo(a.score));

//       // 5. Convert to product models (keep only products with score > threshold)
//       return scoredProducts
//           .where((item) => item.score > 0.3)
//           .map((item) => _convertToProductModel(item.doc))
//           .toList();
//     } catch (e) {
//       print('Error searching products: $e');
//       rethrow;
//     }
//   }

//   double _calculateColorMatchScore(
//       Map<String, double> searchColors, Set<String> productColors) {
//     double score = 0;
//     for (var searchColor in searchColors.entries) {
//       if (productColors
//           .any((prodColor) => _areColorsRelated(searchColor.key, prodColor))) {
//         score += searchColor.value;
//       }
//     }
//     return score;
//   }

//   bool _areColorsRelated(String color1, String color2) {
//     final colorGroups = {
//       'red': ['red', 'maroon', 'crimson', 'burgundy'],
//       'blue': ['blue', 'navy', 'azure', 'indigo'],
//       'green': ['green', 'olive', 'emerald', 'forest'],
//       'yellow': ['yellow', 'gold', 'mustard'],
//       'purple': ['purple', 'violet', 'lavender'],
//       'pink': ['pink', 'rose', 'salmon', 'coral'],
//       'brown': ['brown', 'tan', 'beige', 'khaki'],
//       'gray': ['gray-light', 'gray-dark', 'silver', 'charcoal'],
//       'white': ['white', 'ivory', 'cream'],
//       'black': ['black', 'jet', 'onyx'],
//     };

//     color1 = color1.toLowerCase();
//     color2 = color2.toLowerCase();

//     // Check if colors are in the same group
//     return colorGroups.values
//         .any((group) => group.contains(color1) && group.contains(color2));
//   }

//   void dispose() {
//     _interpreter.close();
//   }
// }
