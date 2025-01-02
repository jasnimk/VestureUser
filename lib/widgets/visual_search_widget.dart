// // Create a visual search widget
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:image_picker/image_picker.dart';

// class VisualSearchModal extends StatefulWidget {
//   final Function(File) onSearch;

//   const VisualSearchModal({Key? key, required this.onSearch}) : super(key: key);

//   @override
//   State<VisualSearchModal> createState() => _VisualSearchModalState();
// }

// class _VisualSearchModalState extends State<VisualSearchModal> {
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? image = await _picker.pickImage(source: source);
//       if (image != null) {
//         widget.onSearch(File(image.path));
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//             leading: const Icon(Icons.camera_alt),
//             title: const Text('Take a Photo'),
//             onTap: () => _pickImage(ImageSource.camera),
//           ),
//           ListTile(
//             leading: const Icon(Icons.photo_library),
//             title: const Text('Choose from Gallery'),
//             onTap: () => _pickImage(ImageSource.gallery),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class VisualSearchModal extends StatefulWidget {
  final Function(File) onSearch;

  const VisualSearchModal({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<VisualSearchModal> createState() => _VisualSearchModalState();
}

class _VisualSearchModalState extends State<VisualSearchModal> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isSearching = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1000,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        // Automatically start search when image is selected
        _startSearch(image);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _startSearch(XFile image) {
    setState(() => _isSearching = true);
    widget.onSearch(File(image.path));
    // Close modal to show results in main UI
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Choose Image',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
