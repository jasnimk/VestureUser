import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
import 'package:vesture_firebase_user/bloc/Product/product_state.dart';
import 'package:vesture_firebase_user/models/product_filter.dart';
import 'package:vesture_firebase_user/screens/filter_screen.dart';
import 'package:vesture_firebase_user/screens/product_Details.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/custom_search.dart';
import 'package:vesture_firebase_user/widgets/custom_snackbar.dart';
import 'package:vesture_firebase_user/widgets/details_widgets.dart';
import 'package:vesture_firebase_user/widgets/sheet_sort.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initialize products and filters
    context.read<ProductBloc>().add(FetchProductsEvent());
    context.read<ProductBloc>().add(InitializeFiltersEvent());
  }

  void _handleFilterPress(BuildContext context) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context: context, title: 'Shopping Page'),
      body: Column(
        children: [
          customSearchField(context),
          customFilterSortRow(
            context: context,
            onFilterPressed: () => _handleFilterPress(context),
            onSortPressed: () {
              showSortBottomSheet(
                context,
                (sortOption) {
                  final currentState = context.read<ProductBloc>().state;
                  if (currentState is ProductLoadedState) {
                    context.read<ProductBloc>().add(
                          SortProductsEvent(
                            sortOption: sortOption,
                            products: currentState.products,
                          ),
                        );
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
                      message: _isSearching
                          ? 'No products found matching your search'
                          : 'No products available',
                    ),
                  );
                }

                return Expanded(
                  child: buildProductGridView(
                    products: state.products,
                    context: context,
                    onItemTap: (product) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(productId: product.id!),
                        ),
                      );
                      return null;
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
