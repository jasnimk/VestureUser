// import 'dart:io';
// import 'package:image/image.dart' as img;

// class ColorSearchService {
//   Map<String, double> extractDominantColors(File imageFile) {
//     final image = img.decodeImage(imageFile.readAsBytesSync())!;
//     final resized = img.copyResize(image, width: 100, height: 100);

//     Map<String, int> colorCounts = {};
//     int totalPixels = resized.width * resized.height;

//     for (int y = 0; y < resized.height; y++) {
//       for (int x = 0; x < resized.width; x++) {
//         final pixel = resized.getPixel(x, y);
//         final color =
//             _getColorName(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());
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

//   String _getColorName(int r, int g, int b) {
//     // Normalize RGB values to 0-1 range
//     double rNorm = r / 255.0;
//     double gNorm = g / 255.0;
//     double bNorm = b / 255.0;

//     // Calculate HSV values
//     double max = [rNorm, gNorm, bNorm].reduce((a, b) => a > b ? a : b);
//     double min = [rNorm, gNorm, bNorm].reduce((a, b) => a < b ? a : b);
//     double delta = max - min;

//     double hue = 0;
//     if (delta != 0) {
//       if (max == rNorm) {
//         hue = ((gNorm - bNorm) / delta) % 6;
//       } else if (max == gNorm) {
//         hue = (bNorm - rNorm) / delta + 2;
//       } else {
//         hue = (rNorm - gNorm) / delta + 4;
//       }
//       hue *= 60;
//       if (hue < 0) hue += 360;
//     }

//     double saturation = max == 0 ? 0 : delta / max;
//     double value = max;

//     // Color classification based on HSV
//     if (value < 0.2) return 'black';
//     if (value > 0.9 && saturation < 0.1) return 'white';
//     if (saturation < 0.1) {
//       if (value < 0.5) return 'gray-dark';
//       return 'gray-light';
//     }

//     // Hue-based classification
//     if (hue <= 30 || hue > 330) {
//       if (value < 0.6) return 'brown';
//       if (saturation < 0.4) return 'pink';
//       return 'red';
//     }
//     if (hue <= 90) return 'yellow';
//     if (hue <= 150) return 'green';
//     if (hue <= 210) return 'cyan';
//     if (hue <= 270) return 'blue';
//     if (hue <= 330) return 'purple';

//     return 'other';
//   }
// }
