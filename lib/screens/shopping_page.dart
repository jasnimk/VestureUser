import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
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
import 'package:vesture_firebase_user/widgets/textwidget.dart';

// class ShoppingPage extends StatefulWidget {
//   const ShoppingPage({super.key});

//   @override
//   _ShoppingPageState createState() => _ShoppingPageState();
// }

// class _ShoppingPageState extends State<ShoppingPage> {
//   bool _isSearching = false;
//   bool _isVisualSearchActive = false;

//   @override
//   void initState() {
//     super.initState();

//     context.read<ProductBloc>().add(FetchProductsEvent());
//     context.read<ProductBloc>().add(InitializeFiltersEvent());
//   }

// void _handleFilterPress(BuildContext context) {
//   final currentState = context.read<ProductBloc>().state;
//   if (currentState is ProductLoadedState) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FilterScreen(
//           initialFilter: currentState.filter ??
//               ProductFilter(
//                 priceRange: RangeValues(0, 100000000),
//                 selectedColors: {},
//                 selectedSizes: {},
//                 selectedBrands: {},
//                 selectedCategory: '',
//               ),
//         ),
//       ),
//     );
//   } else {
//     CustomSnackBar.show(
//       context,
//       message: 'Please wait while products are loading...!',
//       textColor: Colors.white,
//     );
//   }
// }

// Widget _buildVisualSearchBanner() {
//   return Container(
//     padding: const EdgeInsets.all(8),
//     color: Theme.of(context).primaryColor.withValues(),
//     child: Row(
//       children: [
//         const Icon(
//           Icons.camera_alt,
//           color: Colors.white,
//         ),
//         const SizedBox(width: 8),
//         Text(
//           'Visual Search Results',
//           style: styling(color: Colors.white),
//         ),
//         const Spacer(),
//         TextButton(
//           onPressed: () {
//             setState(() => _isVisualSearchActive = false);
//             context.read<ProductBloc>().add(FetchProductsEvent());
//           },
//           child: Text('Clear', style: styling(color: Colors.white)),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildEmptyState(String message, String imagePath) {
//   return LayoutBuilder(
//     builder: (context, constraints) {
//       return SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             minHeight: constraints.maxHeight,
//           ),
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 200,
//                     child: Lottie.asset(imagePath),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     message,
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildCustomAppBar(context: context, title: 'Shopping Page'),
//       body: SafeArea(
//         child: Column(
//           children: [
//             const CustomSearch(),
//             customFilterSortRow(
//               context: context,
//               onFilterPressed: () => _handleFilterPress(context),
//               onSortPressed: () {
//                 showSortBottomSheet(
//                   context,
//                   (sortOption) {
//                     final currentState = context.read<ProductBloc>().state;
//                     if (currentState is ProductLoadedState) {
//                       context.read<ProductBloc>().add(
//                             SortProductsEvent(
//                               sortOption: sortOption,
//                               products: currentState.products,
//                             ),
//                           );
//                     }
//                   },
//                 );
//               },
//             ),
//             if (_isVisualSearchActive) _buildVisualSearchBanner(),
//             Expanded(
//               child: BlocConsumer<ProductBloc, ProductState>(
//                 listener: (context, state) {
//                   if (state is VisualSearchLoadingState) {
//                     setState(() => _isVisualSearchActive = true);
//                   }
//                 },
//                 builder: (context, state) {
//                   if (state is ProductLoadingState ||
//                       state is VisualSearchLoadingState) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: 175,
//                           child: Lottie.asset(
//                               'assets/animations/Animation - 1735834925724.json'),
//                         ),
//                       ],
//                     );
//                   }

//                   if (state is ProductErrorState ||
//                       state is VisualSearchErrorState) {
//                     return buildErrorWidget(state is ProductErrorState
//                         ? state.errorMessage
//                         : (state as VisualSearchErrorState).errorMessage);
//                   }

//                   if (state is ProductLoadedState ||
//                       state is VisualSearchLoadedState) {
//                     final products = state is ProductLoadedState
//                         ? state.products
//                         : (state as VisualSearchLoadedState).products;

//                     if (products.isEmpty) {
//                       return _buildEmptyState(
//                         _isSearching
//                             ? 'No products found matching your search'
//                             : 'No products available',
//                         'assets/animations/Animation - 1735366182958.json',
//                       );
//                     }

//                     return buildProductGridView(
//                       products: products,
//                       context: context,
//                       onItemTap: (product) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 ProductDetailsPage(productId: product.id!),
//                           ),
//                         );
//                         return null;
//                       },
//                     );
//                   }

//                   return const SizedBox.shrink();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

enum ProductFilterType { none, brand, category }

class ShoppingPage extends StatefulWidget {
  final String? brandId;
  final String? categoryId;
  final String? title;
  final ProductFilterType filterType;

  const ShoppingPage({
    super.key,
    this.brandId,
    this.categoryId,
    this.title,
    this.filterType = ProductFilterType.none,
  });

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  bool _isSearching = false;
  bool _isVisualSearchActive = false;

  @override
  void initState() {
    super.initState();
    // Only dispatch one event based on the filter type
    switch (widget.filterType) {
      case ProductFilterType.brand:
        if (widget.brandId != null) {
          context.read<ProductBloc>().add(
                FetchProductsByBrandEvent(brandId: widget.brandId!),
              );
        }
        break;
      case ProductFilterType.category:
        if (widget.categoryId != null) {
          context.read<ProductBloc>().add(
                FetchProductsByCategoryEvent(categoryId: widget.categoryId!),
              );
        }
        break;
      case ProductFilterType.none:
        context.read<ProductBloc>().add(FetchProductsEvent());
        break;
    }
  }

  String get _emptyStateMessage {
    switch (widget.filterType) {
      case ProductFilterType.brand:
        return 'No products available for this brand';
      case ProductFilterType.category:
        return 'No products available in this category';
      case ProductFilterType.none:
        return _isSearching
            ? 'No products found matching your search'
            : 'No products available';
    }
  }

  Widget _buildEmptyState(String message, String imagePath) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Lottie.asset(imagePath),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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

  Widget _buildVisualSearchBanner() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).primaryColor.withValues(),
      child: Row(
        children: [
          const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            'Visual Search Results',
            style: styling(color: Colors.white),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              setState(() => _isVisualSearchActive = false);
              context.read<ProductBloc>().add(FetchProductsEvent());
            },
            child: Text('Clear', style: styling(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context: context,
        title: widget.title ?? 'Shopping Page',
        showBackButton: widget.filterType != ProductFilterType.none,
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (widget.filterType == ProductFilterType.none)
              const CustomSearch(),
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
            if (_isVisualSearchActive) _buildVisualSearchBanner(),
            Expanded(
              child: BlocConsumer<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is VisualSearchLoadingState) {
                    setState(() => _isVisualSearchActive = true);
                  }
                },
                builder: (context, state) {
                  if (state is ProductLoadingState ||
                      state is VisualSearchLoadingState) {
                    return Center(
                      child: SizedBox(
                        height: 175,
                        child: Lottie.asset(
                          'assets/animations/Animation - 1735834925724.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }

                  if (state is ProductErrorState ||
                      state is VisualSearchErrorState) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: buildErrorWidget(state is ProductErrorState
                          ? state.errorMessage
                          : (state as VisualSearchErrorState).errorMessage),
                    );
                  }

                  if (state is ProductLoadedState ||
                      state is VisualSearchLoadedState) {
                    final products = state is ProductLoadedState
                        ? state.products
                        : (state as VisualSearchLoadedState).products;

                    if (products.isEmpty) {
                      return _buildEmptyState(
                        _emptyStateMessage,
                        'assets/animations/Animation - 1735366182958.json',
                      );
                    }

                    return buildProductGridView(
                      products: products,
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
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void navigateToBrandProducts(
    BuildContext context, String brandId, String brandName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ShoppingPage(
        brandId: brandId,
        title: brandName,
        filterType: ProductFilterType.brand,
      ),
    ),
  );
}

void navigateToCategoryProducts(
    BuildContext context, String categoryId, String categoryName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ShoppingPage(
        categoryId: categoryId,
        title: categoryName,
        filterType: ProductFilterType.category,
      ),
    ),
  );
}
