// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Widget customSearchField(BuildContext context) {
//   TextEditingController _searchController = TextEditingController();

//   // Function for voice search - add your logic here
//   void _voiceSearch() {
//     print("Voice search activated");
//   }

//   // Function for image search - add your logic here
//   void _imageSearch() {
//     print("Image search activated");
//   }

//   return Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: Row(
//       children: [
//         IconButton(
//           icon: const Icon(FontAwesomeIcons.microphone), // Voice search icon
//           onPressed: _voiceSearch,
//         ),
//         IconButton(
//           icon: const Icon(FontAwesomeIcons.image), // Image search icon
//           onPressed: _imageSearch,
//         ),
//         Expanded(
//           child: TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintText: 'Search...',
//               suffixIcon: IconButton(
//                 icon:
//                     const Icon(FontAwesomeIcons.magnifyingGlass), // Search icon
//                 onPressed: () {
//                   print("Search triggered: ${_searchController.text}");
//                 },
//               ),
//               border: const OutlineInputBorder(),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

Widget customSearchField(BuildContext context) {
  TextEditingController _searchController = TextEditingController();

  // Function for voice search - add your logic here
  void _voiceSearch() {
    print("Voice search activated");
  }

  // Function for image search - add your logic here
  void _imageSearch() {
    print("Image search activated");
  }

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: styling(fontFamily: 'Poppins-Regular', color: Colors.grey),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.microphone,
                size: 15,
              ), // Voice search icon
              onPressed: _voiceSearch,
              iconSize: 20,
            ),
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.camera,
                size: 15,
              ), // Image search icon
              onPressed: _imageSearch,
              iconSize: 20,
            ),
          ],
        ),
        suffixIcon: IconButton(
          icon: const Icon(
            FontAwesomeIcons.magnifyingGlass,
            size: 15,
          ), // Search icon
          onPressed: () {
            // print("Search triggered: ${_searchController.text}");
          },
        ),
        border: const OutlineInputBorder(),
      ),
    ),
  );
}
