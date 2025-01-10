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
    context
        .read<ProductBloc>()
        .add(FetchProductsByCategoryEvent(categoryId: widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    CategoryModel categoryModel = CategoryModel(id: widget.categoryId);
    return Scaffold(
      appBar: buildCustomAppBar(context: context, title: 'Category Products'),
      body: Column(
        children: [
          CustomSearch(
            categoryId: widget.categoryId,
          ),
          // customSearchField(context, categor: categoryModel),
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
