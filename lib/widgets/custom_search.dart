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
  final String? categoryId; // Add categoryId parameter
  final CategoryModel? category;
  final Function(String)? onSearch;

  const CustomSearch({
    Key? key,
    this.isCategorySearch = false,
    this.categoryId, // Add this parameter
    this.category,
    this.onSearch,
  }) : super(key: key);

  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  final TextEditingController _searchController = TextEditingController();

  void _handleVisualSearch(File image) {
    context.read<ProductBloc>().add(VisualSearchEvent(
          image: image,
          categoryId: widget.categoryId, // Pass categoryId to visual search
        ));
  }

  void performSearch(String query) {
    query = query.trim().toLowerCase();
    if (widget.isCategorySearch) {
      context.read<CategoryBloc>().add(SearchCategoriesEvent(query: query));
    } else {
      if (query.isNotEmpty) {
        context.read<ProductBloc>().add(SearchProductsEvent(
              query: query,
              categoryId: widget.categoryId, // Pass categoryId to search
            ));
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    if (widget.categoryId != null) {
      // If in category view, fetch category products
      context
          .read<ProductBloc>()
          .add(FetchProductsByCategoryEvent(categoryId: widget.categoryId!));
    } else {
      // Otherwise fetch all products
      context.read<ProductBloc>().add(FetchProductsEvent());
    }
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
        onSubmitted: performSearch,
      ),
    );
  }
}
