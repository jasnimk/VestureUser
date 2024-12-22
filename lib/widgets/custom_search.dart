import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/categories_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/categories_event.dart';
import 'package:vesture_firebase_user/models/category_model.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

Widget customSearchField(
  BuildContext context, {
  CategoryModel? categor,
  bool isCategorySearch = false,
  void Function(String)? onSearch,
}) {
  final TextEditingController _searchController = TextEditingController();


  // void _voiceSearch() {
  //   print("Voice search activated");
  // }

  // // Function for image search - add your logic here
  // void _imageSearch() {
  //   print("Image search activated");
  // }



  void performSearch(String query) {
    query = query.trim().toLowerCase();
    print('Search Query: $query');

    if (isCategorySearch) {
      // If it's a category search
      context.read<CategoryBloc>().add(SearchCategoriesEvent(query: query));
    } else {
      // Existing product search logic
      if (query.isNotEmpty) {
        context.read<ProductBloc>().add(SearchProductsEvent(query: query));
      } else {
        context.read<ProductBloc>().add(FetchProductsEvent());
      }
    }
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
              onPressed: (){},
              iconSize: 20,
            ),
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.camera,
                size: 15,
              ), // Image search icon
              onPressed:(){},
              iconSize: 20,
            ),
          ],
        ),
        suffixIcon: IconButton(
          icon: const Icon(
            FontAwesomeIcons.magnifyingGlass,
            size: 15,
          ), // Search icon
          onPressed: () => performSearch(_searchController.text),
        ),
        border: const OutlineInputBorder(),
      ),
      onChanged: performSearch, 
      onSubmitted: performSearch, 
    ),
  );
}
