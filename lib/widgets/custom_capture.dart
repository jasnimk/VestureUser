import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_bloc.dart';
import 'package:vesture_firebase_user/bloc/authentication/authentication_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/userprofile_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/userprofile_event.dart';
import 'package:vesture_firebase_user/screens/login_screen.dart';

Future<void> showImageSourceDialog(BuildContext context) async {
  final ImagePicker _picker = ImagePicker();
  final profileBloc = context.read<ProfileBloc>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: Theme.of(context).textTheme.labelLarge!.color,
              ),
              title: Text(
                'Take Photo',
                style: TextStyle(
                    color: Theme.of(context).textTheme.labelLarge!.color),
              ),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  final File imagePath = File(image.path);
                  print('Picked image path: $imagePath');
                  final bytes = await imagePath.readAsBytes();
                  String base64Image = base64Encode(bytes);
                  profileBloc.add(UpdateProfile(imageUrl: base64Image));
                }
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_album,
                color: Theme.of(context).textTheme.labelLarge!.color,
              ),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(
                    color: Theme.of(context).textTheme.labelLarge!.color),
              ),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  final File imagePath = File(image.path);
                  print('Picked image path: $imagePath');
                  final bytes = await imagePath.readAsBytes();
                  String base64Image = base64Encode(bytes);
                  profileBloc.add(UpdateProfile(imageUrl: base64Image));
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

showEditNameDialog(BuildContext context, String currentName) {
  final TextEditingController nameController =
      TextEditingController(text: currentName);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return AlertDialog(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        title: Text(
          'Edit Name',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.red,
          ),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Enter new name',
            labelStyle: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode ? Colors.white70 : Colors.black,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode ? Colors.white : Colors.blue,
              ),
            ),
          ),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context
                    .read<ProfileBloc>()
                    .add(UpdateProfile(name: nameController.text));
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.red,
              ),
            ),
          ),
        ],
      );
    },
  );
}

showDeleteConfirmation(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        title: Text(
          'Confirm Logout',
          style:
              TextStyle(color: Theme.of(context).textTheme.labelLarge!.color),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style:
              TextStyle(color: Theme.of(context).textTheme.labelLarge!.color),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel',
                style: TextStyle(
                    color: Theme.of(context).textTheme.labelLarge!.color)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text('Logout',
                style: TextStyle(
                    color: Theme.of(context).textTheme.labelLarge!.color)),
          ),
        ],
      );
    },
  );
}
