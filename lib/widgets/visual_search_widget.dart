import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class VisualSearchModal extends StatefulWidget {
  final Function(File) onSearch;

  const VisualSearchModal({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<VisualSearchModal> createState() => _VisualSearchModalState();
}

class _VisualSearchModalState extends State<VisualSearchModal> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1000,
      );

      if (image != null) {
        setState(() {});

        _startSearch(image);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _startSearch(XFile image) {
    widget.onSearch(File(image.path));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Choose Image', style: headerStyling()),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: customButton(
                      fontSize: 12,
                      height: 50,
                      context: context,
                      text: 'Camera',
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: FontAwesomeIcons.camera)),
              const SizedBox(width: 16),
              Expanded(
                  child: customButton(
                      fontSize: 12,
                      height: 50,
                      context: context,
                      text: 'Gallery',
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: FontAwesomeIcons.photoFilm)),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
