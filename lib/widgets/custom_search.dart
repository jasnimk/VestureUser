// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // // // import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
// // // // import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
// // // // import 'package:vesture_firebase_user/bloc/bloc/categories_bloc.dart';
// // // // import 'package:vesture_firebase_user/bloc/bloc/categories_event.dart';
// // // // import 'package:vesture_firebase_user/models/category_model.dart';
// // // // import 'package:vesture_firebase_user/widgets/textwidget.dart';

// // // // Widget customSearchField(
// // // //   BuildContext context, {
// // // //   CategoryModel? categor,
// // // //   bool isCategorySearch = false,
// // // //   void Function(String)? onSearch,
// // // // }) {
// // // //   final TextEditingController _searchController = TextEditingController();

// // // //   // void _voiceSearch() {
// // // //   //   print("Voice search activated");
// // // //   // }

// // // //   // // Function for image search - add your logic here
// // // //   // void _imageSearch() {
// // // //   //   print("Image search activated");
// // // //   // }

// // // //   void performSearch(String query) {
// // // //     query = query.trim().toLowerCase();
// // // //     print('Search Query: $query');

// // // //     if (isCategorySearch) {
// // // //       context.read<CategoryBloc>().add(SearchCategoriesEvent(query: query));
// // // //     } else {
// // // //       if (query.isNotEmpty) {
// // // //         context.read<ProductBloc>().add(SearchProductsEvent(query: query));
// // // //       } else {
// // // //         context.read<ProductBloc>().add(FetchProductsEvent());
// // // //       }
// // // //     }
// // // //   }

// // // //   return Padding(
// // // //     padding: const EdgeInsets.all(16.0),
// // // //     child: TextField(
// // // //       controller: _searchController,
// // // //       decoration: InputDecoration(
// // // //         hintText: 'Search',
// // // //         hintStyle: styling(fontFamily: 'Poppins-Regular', color: Colors.grey),
// // // //         prefixIcon: Row(
// // // //           mainAxisSize: MainAxisSize.min,
// // // //           children: [
// // // //             IconButton(
// // // //               icon: const Icon(
// // // //                 FontAwesomeIcons.microphone,
// // // //                 size: 15,
// // // //               ),
// // // //               onPressed: () {},
// // // //               iconSize: 20,
// // // //             ),
// // // //             IconButton(
// // // //               icon: const Icon(
// // // //                 FontAwesomeIcons.camera,
// // // //                 size: 15,
// // // //               ),
// // // //               onPressed: () {},
// // // //               iconSize: 20,
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         suffixIcon: IconButton(
// // // //           icon: const Icon(
// // // //             FontAwesomeIcons.magnifyingGlass,
// // // //             size: 15,
// // // //           ),
// // // //           onPressed: () => performSearch(_searchController.text),
// // // //         ),
// // // //         border: const OutlineInputBorder(),
// // // //       ),
// // // //       onChanged: performSearch,
// // // //       onSubmitted: performSearch,
// // // //     ),
// // // //   );
// // // // }
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // // import 'package:speech_to_text/speech_to_text.dart' as stt; // Import the package
// // // import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
// // // import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
// // // import 'package:vesture_firebase_user/bloc/bloc/categories_bloc.dart';
// // // import 'package:vesture_firebase_user/bloc/bloc/categories_event.dart';
// // // import 'package:vesture_firebase_user/models/category_model.dart';
// // // import 'package:vesture_firebase_user/widgets/textwidget.dart';

// // // Widget customSearchField(
// // //   BuildContext context, {
// // //   CategoryModel? categor,
// // //   bool isCategorySearch = false,
// // //   void Function(String)? onSearch,
// // // }) {
// // //   final TextEditingController _searchController = TextEditingController();
// // //   final stt.SpeechToText _speech = stt.SpeechToText(); // Initialize SpeechToText
// // //   bool _isListening = false; // Track if the mic is active

// // //   void performSearch(String query) {
// // //     query = query.trim().toLowerCase();
// // //     print('Search Query: $query');

// // //     if (isCategorySearch) {
// // //       context.read<CategoryBloc>().add(SearchCategoriesEvent(query: query));
// // //     } else {
// // //       if (query.isNotEmpty) {
// // //         context.read<ProductBloc>().add(SearchProductsEvent(query: query));
// // //       } else {
// // //         context.read<ProductBloc>().add(FetchProductsEvent());
// // //       }
// // //     }
// // //   }

// // //   Future<void> _voiceSearch() async {
// // //     if (!_isListening && await _speech.initialize()) {
// // //       _isListening = true;
// // //       _speech.listen(onResult: (result) {
// // //         String query = result.recognizedWords;
// // //         _searchController.text = query; // Update the search bar
// // //         performSearch(query); // Perform the search
// // //       });
// // //     } else {
// // //       _speech.stop(); // Stop listening
// // //       _isListening = false;
// // //     }
// // //   }

// // //   return Padding(
// // //     padding: const EdgeInsets.all(16.0),
// // //     child: TextField(
// // //       controller: _searchController,
// // //       decoration: InputDecoration(
// // //         hintText: 'Search',
// // //         hintStyle: styling(fontFamily: 'Poppins-Regular', color: Colors.grey),
// // //         prefixIcon: Row(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             IconButton(
// // //               icon: const Icon(
// // //                 FontAwesomeIcons.microphone,
// // //                 size: 15,
// // //               ),
// // //               onPressed: _voiceSearch, // Attach voice search function
// // //               iconSize: 20,
// // //             ),
// // //             IconButton(
// // //               icon: const Icon(
// // //                 FontAwesomeIcons.camera,
// // //                 size: 15,
// // //               ),
// // //               onPressed: () {}, // Placeholder for image search
// // //               iconSize: 20,
// // //             ),
// // //           ],
// // //         ),
// // //         suffixIcon: IconButton(
// // //           icon: const Icon(
// // //             FontAwesomeIcons.magnifyingGlass,
// // //             size: 15,
// // //           ),
// // //           onPressed: () => performSearch(_searchController.text),
// // //         ),
// // //         border: const OutlineInputBorder(),
// // //       ),
// // //       onChanged: performSearch,
// // //       onSubmitted: performSearch,
// // //     ),
// // //   );
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:speech_to_text/speech_to_text.dart' as stt;
// // import 'package:avatar_glow/avatar_glow.dart';
// // import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
// // import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
// // import 'package:vesture_firebase_user/bloc/bloc/categories_bloc.dart';
// // import 'package:vesture_firebase_user/bloc/bloc/categories_event.dart';
// // import 'package:vesture_firebase_user/widgets/textwidget.dart'; // Add this package for mic animation

// // class VoiceSearchField extends StatefulWidget {
// //   final bool isCategorySearch;
// //   final Function(String)? onSearch;

// //   const VoiceSearchField({
// //     Key? key,
// //     this.isCategorySearch = false,
// //     this.onSearch,
// //   }) : super(key: key);

// //   @override
// //   State<VoiceSearchField> createState() => _VoiceSearchFieldState();
// // }

// // class _VoiceSearchFieldState extends State<VoiceSearchField> {
// //   final TextEditingController _searchController = TextEditingController();
// //   final stt.SpeechToText _speech = stt.SpeechToText();
// //   bool _isListening = false;
// //   String _lastWords = '';

// //   void performSearch(String query) {
// //     query = query.trim().toLowerCase();
// //     print('Search Query: $query');

// //     if (widget.isCategorySearch) {
// //       context.read<CategoryBloc>().add(SearchCategoriesEvent(query: query));
// //     } else {
// //       if (query.isNotEmpty) {
// //         context.read<ProductBloc>().add(SearchProductsEvent(query: query));
// //       } else {
// //         context.read<ProductBloc>().add(FetchProductsEvent());
// //       }
// //     }

// //     if (widget.onSearch != null) {
// //       widget.onSearch!(query);
// //     }
// //   }

// //   Future<void> _toggleListening() async {
// //     if (!_isListening) {
// //       var available = await _speech.initialize(
// //         onStatus: (status) {
// //           print('Speech recognition status: $status');
// //           if (status == 'done' || status == 'notListening') {
// //             setState(() => _isListening = false);
// //           }
// //         },
// //         onError: (error) {
// //           print('Speech recognition error: $error');
// //           setState(() => _isListening = false);
// //         },
// //       );

// //       if (available) {
// //         setState(() => _isListening = true);
// //         _speech.listen(
// //           onResult: (result) {
// //             setState(() {
// //               _lastWords = result.recognizedWords;
// //               _searchController.text = _lastWords;
// //               if (result.finalResult) {
// //                 performSearch(_lastWords);
// //               }
// //             });
// //           },
// //         );
// //       }
// //     } else {
// //       setState(() => _isListening = false);
// //       _speech.stop();
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Column(
// //         children: [
// //           TextField(
// //             controller: _searchController,
// //             decoration: InputDecoration(
// //               hintText: 'Search',
// //               hintStyle: styling(
// //                 fontFamily: 'Poppins-Regular',
// //                 color: Colors.grey,
// //               ),
// //               prefixIcon: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   AvatarGlow(
// //                     animate: _isListening,
// //                     glowColor: Theme.of(context).primaryColor,
// //                     //   endRadius: 25.0,
// //                     duration: const Duration(milliseconds: 2000),
// //                     // repeatPauseDuration: const Duration(milliseconds: 100),
// //                     repeat: true,
// //                     child: IconButton(
// //                       icon: Icon(
// //                         _isListening
// //                             ? FontAwesomeIcons.stop
// //                             : FontAwesomeIcons.microphone,
// //                         size: 15,
// //                         color: _isListening
// //                             ? Theme.of(context).primaryColor
// //                             : null,
// //                       ),
// //                       onPressed: _toggleListening,
// //                       iconSize: 20,
// //                     ),
// //                   ),
// //                   IconButton(
// //                     icon: const Icon(
// //                       FontAwesomeIcons.camera,
// //                       size: 15,
// //                     ),
// //                     onPressed: () {},
// //                     iconSize: 20,
// //                   ),
// //                 ],
// //               ),
// //               suffixIcon: IconButton(
// //                 icon: const Icon(
// //                   FontAwesomeIcons.magnifyingGlass,
// //                   size: 15,
// //                 ),
// //                 onPressed: () => performSearch(_searchController.text),
// //               ),
// //               border: const OutlineInputBorder(),
// //             ),
// //             onChanged: performSearch,
// //             onSubmitted: performSearch,
// //           ),
// //           if (_isListening)
// //             Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: Text(
// //                 'Listening...',
// //                 style: TextStyle(
// //                   color: Theme.of(context).primaryColor,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _speech.stop();
// //     _searchController.dispose();
// //     super.dispose();
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
// import 'package:vesture_firebase_user/bloc/bloc/categories_bloc.dart';
// import 'package:vesture_firebase_user/bloc/bloc/categories_event.dart';
// import 'package:vesture_firebase_user/models/category_model.dart';
// import 'package:vesture_firebase_user/widgets/textwidget.dart';
// import 'package:vesture_firebase_user/widgets/voice_search.dart';

// Widget customSearchField(
//   BuildContext context, {
//   CategoryModel? categor,
//   bool isCategorySearch = false,
//   void Function(String)? onSearch,
// }) {
//   final TextEditingController _searchController = TextEditingController();

//   void performSearch(String query) {
//     query = query.trim().toLowerCase();
//     print('Search Query: $query');

//     if (isCategorySearch) {
//       context.read<CategoryBloc>().add(SearchCategoriesEvent(query: query));
//     } else {
//       if (query.isNotEmpty) {
//         context.read<ProductBloc>().add(SearchProductsEvent(query: query));
//       } else {
//         context.read<ProductBloc>().add(FetchProductsEvent());
//       }
//     }
//   }

//   return Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: SingleChildScrollView(
//       child: TextField(
//         controller: _searchController,
//         decoration: InputDecoration(
//           hintText: 'Search',
//           hintStyle: styling(fontFamily: 'Poppins-Regular', color: Colors.grey),
//           prefixIcon: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: const Icon(
//                   FontAwesomeIcons.microphone,
//                   size: 15,
//                 ),
//                 onPressed: () {
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     builder: (context) => VoiceSearchModal(
//                       searchController: _searchController,
//                       onSearch: performSearch,
//                     ),
//                   );
//                 },
//                 iconSize: 20,
//               ),
//               IconButton(
//                 icon: const Icon(
//                   FontAwesomeIcons.camera,
//                   size: 15,
//                 ),
//                 onPressed: () {},
//                 iconSize: 20,
//               ),
//             ],
//           ),
//           suffixIcon: IconButton(
//             icon: const Icon(
//               FontAwesomeIcons.magnifyingGlass,
//               size: 15,
//             ),
//             onPressed: () => performSearch(_searchController.text),
//           ),
//           border: const OutlineInputBorder(),
//         ),
//         onChanged: performSearch,
//         onSubmitted: performSearch,
//       ),
//     ),
//   );
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/categories_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/categories_event.dart';
import 'package:vesture_firebase_user/models/category_model.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';
import 'package:vesture_firebase_user/widgets/visual_search_widget.dart';
import 'package:vesture_firebase_user/widgets/voice_search.dart';

class CustomSearch extends StatefulWidget {
  final bool isCategorySearch;
  final CategoryModel? category;
  final Function(String)? onSearch;

  const CustomSearch({
    Key? key,
    this.isCategorySearch = false,
    this.category,
    this.onSearch,
  }) : super(key: key);

  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

// class _CustomSearchState extends State<CustomSearch> {
//   final TextEditingController _searchController = TextEditingController();
//   void _handleVisualSearch(File image) {
//     context.read<ProductBloc>().add(VisualSearchEvent(image: image));
//   }

//   void performSearch(String query) {
//     query = query.trim().toLowerCase();

//     if (widget.isCategorySearch) {
//       context.read<CategoryBloc>().add(SearchCategoriesEvent(query: query));
//     } else {
//       if (query.isNotEmpty) {
//         context.read<ProductBloc>().add(SearchProductsEvent(query: query));
//       } else {
//         context.read<ProductBloc>().add(FetchProductsEvent());
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: TextField(
//         controller: _searchController,
//         decoration: InputDecoration(
//           hintText: 'Search',
//           hintStyle: styling(fontFamily: 'Poppins-Regular', color: Colors.grey),
//           prefixIcon: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: const Icon(FontAwesomeIcons.microphone, size: 15),
//                 onPressed: () {
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     builder: (context) => VoiceSearchModal(
//                       searchController: _searchController,
//                       onSearch: performSearch,
//                     ),
//                   );
//                 },
//                 iconSize: 20,
//               ),
//               IconButton(
//                 icon: const Icon(FontAwesomeIcons.camera, size: 15),
//                 onPressed: () {
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     builder: (context) => VisualSearchModal(
//                       onSearch: _handleVisualSearch,
//                     ),
//                   );
//                 },
//                 iconSize: 20,
//               ),
//             ],
//           ),
//           suffixIcon: IconButton(
//             icon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 15),
//             onPressed: () => performSearch(_searchController.text),
//           ),
//           border: const OutlineInputBorder(),
//         ),
//         onChanged: performSearch,
//         onSubmitted: performSearch,
//       ),
//     );
//   }
// }
class _CustomSearchState extends State<CustomSearch> {
  final TextEditingController _searchController = TextEditingController();

  void _handleVisualSearch(File image) {
    context.read<ProductBloc>().add(VisualSearchEvent(image: image));
  }

  void performSearch(String query) {
    query = query.trim().toLowerCase();
    if (widget.isCategorySearch) {
      context.read<CategoryBloc>().add(SearchCategoriesEvent(query: query));
    } else {
      if (query.isNotEmpty) {
        context.read<ProductBloc>().add(SearchProductsEvent(query: query));
      }
      // Remove the automatic FetchProductsEvent when query is empty
    }
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<ProductBloc>().add(FetchProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
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
                icon: const Icon(FontAwesomeIcons.microphone, size: 15),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => VoiceSearchModal(
                      searchController: _searchController,
                      onSearch: performSearch,
                    ),
                  );
                },
                iconSize: 20,
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.camera, size: 15),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => VisualSearchModal(
                      onSearch: _handleVisualSearch,
                    ),
                  );
                },
                iconSize: 20,
              ),
            ],
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, size: 15),
                  onPressed: _clearSearch,
                ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 15),
                onPressed: () => performSearch(_searchController.text),
              ),
            ],
          ),
          border: const OutlineInputBorder(),
        ),
        onSubmitted: performSearch, // Only keep onSubmitted
      ),
    );
  }
}
