// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';

// class ImageRecognitionService {
//   static const String modelPath =
//       'assets/models/mobilenet_v2_1.0_224_quant.tflite';
//   static const String labelPath = 'assets/labels/clothing_labels.txt';

//   Interpreter? _interpreter;
//   List<String>? _labels;

//   Future<void> initialize() async {
//     try {
//       // Load TFLite model
//       final modelFile = await _loadModelFile();
//       if (!await modelFile.exists()) {
//         throw Exception('Model file not found at ${modelFile.path}');
//       }

//       final interpreterOptions = InterpreterOptions()
//         ..threads = 4; // Optimize for modern mobile devices

//       _interpreter =
//           await Interpreter.fromFile(modelFile, options: interpreterOptions);
//       print(
//           'Model loaded successfully. Input shape: ${_interpreter!.getInputTensor(0).shape}');
//       print('Output shape: ${_interpreter!.getOutputTensor(0).shape}');

//       // Load labels
//       _labels = await _loadLabels();
//       print('Labels loaded successfully. Total labels: ${_labels!.length}');
//     } catch (e) {
//       print('Error initializing TFLite: $e');
//       rethrow;
//     }
//   }

//   Future<File> _loadModelFile() async {
//     final tempDir = await getTemporaryDirectory();
//     final modelFile = File('${tempDir.path}/mobilenet_v2.tflite');

//     try {
//       // Only copy if the file doesn't exist
//       if (!await modelFile.exists()) {
//         final byteData = await rootBundle.load(modelPath);
//         await modelFile.writeAsBytes(byteData.buffer.asUint8List());
//         print('Model file copied to: ${modelFile.path}');
//       }
//       return modelFile;
//     } catch (e) {
//       print('Error loading model file: $e');
//       rethrow;
//     }
//   }

//   Future<List<String>> _loadLabels() async {
//     try {
//       final labelData = await rootBundle.loadString(labelPath);
//       return labelData
//           .split('\n')
//           .where((label) => label.isNotEmpty)
//           .map((label) => label.trim())
//           .toList();
//     } catch (e) {
//       print('Error loading labels: $e');
//       rethrow;
//     }
//   }

//   Future<List<DetectedLabel>> detectClothing(File imageFile) async {
//     if (_interpreter == null || _labels == null) {
//       throw Exception('ImageRecognitionService not initialized');
//     }

//     try {
//       final image = img.decodeImage(await imageFile.readAsBytes());
//       if (image == null) throw Exception('Failed to decode image');

//       // Preprocess image
//       final processedImage = _preprocessImage(image);

//       // Prepare output buffer
//       final outputShape = _interpreter!.getOutputTensor(0).shape;
//       final outputSize = outputShape.reduce((a, b) => a * b);
//       final outputBuffer = List<double>.filled(outputSize, 0);

//       // Run inference
//       _interpreter!.run(processedImage, outputBuffer);

//       // Process results
//       return _processResults(outputBuffer);
//     } catch (e) {
//       print('Error detecting clothing: $e');
//       rethrow;
//     }
//   }

//   List<double> _preprocessImage(img.Image image) {
//     // Resize image to match model input
//     final resized = img.copyResize(image, width: 224, height: 224);

//     // Convert to float array and normalize
//     final buffer = List<double>.filled(1 * 224 * 224 * 3, 0);
//     var index = 0;

//     for (var y = 0; y < 224; y++) {
//       for (var x = 0; x < 224; x++) {
//         final pixel = resized.getPixel(x, y);
//         // Normalize to [-1, 1]
//         buffer[index++] = (pixel.r - 127.5) / 127.5;
//         buffer[index++] = (pixel.g - 127.5) / 127.5;
//         buffer[index++] = (pixel.b - 127.5) / 127.5;
//       }
//     }

//     return buffer;
//   }

//   List<DetectedLabel> _processResults(List<double> outputBuffer) {
//     if (_labels == null) throw Exception('Labels not loaded');

//     final List<DetectedLabel> results = [];

//     // Convert raw output to label-confidence pairs
//     for (var i = 0; i < outputBuffer.length && i < _labels!.length; i++) {
//       results.add(DetectedLabel(
//         label: _labels![i],
//         confidence: outputBuffer[i],
//       ));
//     }

//     // Sort by confidence and return top 5
//     results.sort((a, b) => b.confidence.compareTo(a.confidence));
//     return results.take(5).toList();
//   }

//   void dispose() {
//     _interpreter?.close();
//     _interpreter = null;
//   }
// }

// class DetectedLabel {
//   final String label;
//   final double confidence;

//   DetectedLabel({
//     required this.label,
//     required this.confidence,
//   });

//   @override
//   String toString() => '$label (${(confidence * 100).toStringAsFixed(1)}%)';
// }
