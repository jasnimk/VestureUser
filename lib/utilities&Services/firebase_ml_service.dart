// // import 'dart:io';
// // import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

// // class FirebaseMLService {
// //   final imageLabeler =
// //       ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.7));

// //   Future<List<String>> detectLabels(File image) async {
// //     try {
// //       final inputImage = InputImage.fromFile(image);
// //       final labels = await imageLabeler.processImage(inputImage);

// //       // Extract label text and filter out low confidence labels
// //       return labels.map((label) => label.label.toLowerCase()).toList();
// //     } catch (e) {
// //       print('Error in detectLabels: $e');
// //       rethrow;
// //     } finally {
// //       imageLabeler.close();
// //     }
// //   }

// //   void dispose() {
// //     imageLabeler.close();
// //   }
// // }
// import 'dart:io';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

// class FirebaseMLService {
//   final imageLabeler =
//       ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.7));

//   Future<List<ImageLabel>> detectLabels(File image) async {
//     try {
//       final inputImage = InputImage.fromFile(image);
//       final labels = await imageLabeler.processImage(inputImage);

//       // Print detected labels for debugging
//       for (ImageLabel label in labels) {
//         print('Label: ${label.label}, Confidence: ${label.confidence}');
//       }

//       return labels;
//     } catch (e) {
//       print('Error in detectLabels: $e');
//       rethrow;
//     } finally {
//       imageLabeler.close();
//     }
//   }

//   void dispose() {
//     imageLabeler.close();
//   }
// }
import 'dart:io';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class FirebaseMLService {
  final imageLabeler = ImageLabeler(
      options: ImageLabelerOptions(
    confidenceThreshold: 0.6, // Lowered threshold to get more labels
  ));

  late final ObjectDetector objectDetector;

  FirebaseMLService() {
    final options = ObjectDetectorOptions(
        mode: DetectionMode.single,
        classifyObjects: true,
        multipleObjects: true);
    objectDetector = ObjectDetector(options: options);
  }

  Future<Map<String, double>> analyzeImage(File image) async {
    try {
      final inputImage = InputImage.fromFile(image);
      Map<String, double> allDetections = {};

      // Get image labels
      final labels = await imageLabeler.processImage(inputImage);
      for (ImageLabel label in labels) {
        allDetections[label.label.toLowerCase()] = label.confidence;
      }

      // Get object detections
      final objects = await objectDetector.processImage(inputImage);
      for (DetectedObject object in objects) {
        for (Label label in object.labels) {
          allDetections[label.text.toLowerCase()] = label.confidence;
        }
      }

      print('\n=== All Detected Features ===');
      allDetections.forEach((key, value) {
        print('$key: ${(value * 100).toStringAsFixed(2)}%');
      });

      return allDetections;
    } catch (e) {
      print('Error in analyzeImage: $e');
      rethrow;
    } finally {
      imageLabeler.close();
      objectDetector.close();
    }
  }
}
