import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
import 'package:vesture_firebase_user/bloc/Product/product_state.dart';
import 'package:vesture_firebase_user/models/category_model.dart';
import 'package:vesture_firebase_user/models/product_filter.dart';
import 'package:vesture_firebase_user/screens/filter_screen.dart';
import 'package:vesture_firebase_user/screens/product_Details.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/custom_search.dart';
import 'package:vesture_firebase_user/widgets/custom_snackbar.dart';
import 'package:vesture_firebase_user/widgets/details_widgets.dart';
import 'package:vesture_firebase_user/widgets/sheet_sort.dart';

/// A screen displaying the products of a specific category with filter and sorting options.
class CategoryProductDetailsScreen extends StatefulWidget {
  final String categoryId;

  const CategoryProductDetailsScreen({super.key, required this.categoryId});

  @override
  _CategoryProductDetailsScreenState createState() =>
      _CategoryProductDetailsScreenState();
}

class _CategoryProductDetailsScreenState
    extends State<CategoryProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch products based on the category ID when the screen is initialized.
    context
        .read<ProductBloc>()
        .add(FetchProductsByCategoryEvent(categoryId: widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context: context, title: 'Category Products'),
      body: Column(
        children: [
          CustomSearch(
            categoryId: widget.categoryId,
          ),
          // Filter and Sort options row
          customFilterSortRow(
            context: context,
            onFilterPressed: () {
              final currentState = context.read<ProductBloc>().state;
              if (currentState is ProductLoadedState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterScreen(
                      initialFilter: currentState.filter ??
                          ProductFilter(
                            priceRange: RangeValues(0, 100000000),
                            selectedColors: {},
                            selectedSizes: {},
                            selectedBrands: {},
                            selectedCategory: '',
                          ),
                    ),
                  ),
                );
              } else {
                CustomSnackBar.show(
                  context,
                  message: 'Please wait while products are loading...!',
                  textColor: Colors.white,
                );
              }
            },
            onSortPressed: () {
              // Show bottom sheet to sort products based on selected option
              showSortBottomSheet(
                context,
                (sortOption) {
                  final currentState = context.read<ProductBloc>().state;
                  if (currentState is ProductLoadedState) {
                    context.read<ProductBloc>().add(SortProductsEvent(
                        sortOption: sortOption,
                        products: currentState.products));
                  }
                },
              );
            },
          ),
          // BlocBuilder to manage different product loading states
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoadingState) {
                return Expanded(child: buildLoadingIndicator(context: context));
              }

              if (state is ProductErrorState) {
                return Expanded(child: buildErrorWidget(state.errorMessage));
              }

              if (state is ProductLoadedState) {
                if (state.products.isEmpty) {
                  return Expanded(
                      child: buildEmptyStateWidget(
                          message: 'No products in this category',
                          subMessage: 'Please check back later',
                          imagePath:
                              'assets/animations/Animation - 1735366182958.json'));
                }

                return Expanded(
                    child: buildProductGridView(
                        products: state.products,
                        context: context,
                        onItemTap: (product) {
                          // Navigate to product details screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetailsPage(
                                      productId: product.id!)));
                          return null;
                        }));
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
