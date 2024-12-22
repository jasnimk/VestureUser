import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/categories_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/categories_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/categories_state.dart';
import 'package:vesture_firebase_user/screens/shopping_page.dart';
import 'package:vesture_firebase_user/screens/categories_shop.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/custom_search.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/details_widgets.dart';
import 'package:vesture_firebase_user/widgets/search_sec.dart';

class ShopCategories extends StatefulWidget {
  const ShopCategories({super.key});

  @override
  _ShopCategoriesState createState() => _ShopCategoriesState();
}

class _ShopCategoriesState extends State<ShopCategories> {
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context: context, title: 'Category List'),
      body: Column(
        children: [
          secondarySearchField(
            context,
            isCategorySearch: true,
            onSearch: (query) {
              context
                  .read<CategoryBloc>()
                  .add(SearchCategoriesEvent(query: query));
              setState(() {
                _isSearching = query.isNotEmpty;
              });
            },
          ),
          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, categoryState) {
                if (categoryState is CategoryLoadingState) {
                  return buildLoadingIndicator(context: context);
                }
                if (categoryState is CategoryLoadedState ||
                    categoryState is CategorySearchState) {
                  final categories = categoryState is CategoryLoadedState
                      ? categoryState.categories
                      : (categoryState as CategorySearchState).searchResults;

                  if (categories.isEmpty) {
                    return Center(
                      child: Text(
                        _isSearching
                            ? 'No categories found matching your search'
                            : 'No categories available',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    itemCount: categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: customButton(
                            borderRadius: 5,
                            height: 55,
                            context: context,
                            text: 'View All Products',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => const ShoppingPage(),
                                ),
                              );
                            },
                          ),
                        );
                      }

                      final category = categories[index - 1];
                      return ListTile(
                        title: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => CategoryProductDetailsScreen(
                                categoryId: category.id!,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
