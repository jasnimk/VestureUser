import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:vesture_firebase_user/widgets/custom_capture.dart';

Widget profileImageCard(String imageUrl) {
  return cardWithRectangularBorder(
    child: InkWell(
      onTap: () {
        showImageSourceDialog(context as BuildContext);
      },
      child: CircleAvatar(
        radius: 50,
        backgroundImage: imageUrl.isNotEmpty
            ? FileImage(File(imageUrl))
            : const AssetImage('assets/Images/profile.jpg') as ImageProvider,
        backgroundColor: Colors.grey.shade200,
      ),
    ),
  );
}


Widget profileTextCard(String text, VoidCallback onTap) {
  return cardWithRectangularBorder(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    ),
  );
}

// Helper function for creating cards with rectangular borders
Widget cardWithRectangularBorder({required Widget child}) {
  return Card(
    elevation: 3,
    margin: const EdgeInsets.only(bottom: 16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(
        color: Colors.grey.shade300,
        width: 1,
      ),
    ),
    child: child,
  );
}
