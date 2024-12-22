// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_state.dart';
// import 'package:vesture_firebase_user/screens/product_Details.dart';
// import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
// import 'package:vesture_firebase_user/widgets/custom_search.dart';
// import 'package:vesture_firebase_user/widgets/sheet_sort.dart';
// import 'package:vesture_firebase_user/widgets/textwidget.dart';

// class ShoppingPage extends StatelessWidget {
//   const ShoppingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ProductBloc()..add(FetchProductsEvent()),
//       child: Scaffold(
//         appBar: buildCustomAppBar(context: context, title: 'Shopping Page'),
//         body: Column(
//           children: [
//             customSearchField(context),
// customFilterSortRow(
//   context: context,
//   onFilterPressed: () {
//     // Add filtering logic here
//   },
//   onSortPressed: () {
//     // Trigger the bottom sheet for sorting
//     showSortBottomSheet(
//       context,
//       (sortOption) {
//         // Handle the selected sort option
//         print('Selected Sort Option: $sortOption');
//       },
//     );
//   },
// ),
//             BlocBuilder<ProductBloc, ProductState>(
//               builder: (context, state) {
//                 print('Current Product State: $state');
// if (state is ProductLoadingState) {
//   return Expanded(
//     child: Center(
//         child: customSpinkitLoaderWithType(
//       context: context,
//       type: SpinkitType.fadingCube,
//       color: Colors.red,
//       size: 60.0,
//     )),
//   );
// }
//                 if (state is ProductLoadingState) {
//                   return Expanded(
//                     child: Center(
//                       child:
//                           CircularProgressIndicator(), // More standard loading indicator
//                     ),
//                   );
//                 }

//                 if (state is ProductErrorState) {
//                   return Expanded(
//                     child: Center(
//                       child: Text(
//                         'Error: ${state.errorMessage}',
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                     ),
//                   );
//                 }

//                 if (state is ProductLoadedState) {
//                   if (state.products.isEmpty) {
//                     return Expanded(
//                       child: Center(
//                         child: Text(
//                           'No products found matching your search',
//                           style: styling(
//                               fontFamily: 'Poppins-Regular',
//                               color: Colors.grey),
//                         ),
//                       ),
//                     );
//                   }
//                   return Expanded(
//                     child: GridView.builder(
//                       padding: const EdgeInsets.all(10),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         childAspectRatio: 0.65,
//                         crossAxisSpacing: 2,
//                         mainAxisSpacing: 2,
//                       ),
//                       itemCount: state.products.length,
//                       itemBuilder: (context, index) {
//                         final product = state.products[index];
//                         final defaultImages = product.getDefaultImages();
//                         final defaultPrice = product.getDefaultPrice();

//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => ProductDetailsPage(
//                                         productId: product.id!)));
//                           },
//                           child: SizedBox(
//                             child: Card(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(1),
//                               ),
//                               elevation: 2,
//                               shadowColor: Colors.red,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   AspectRatio(
//                                     aspectRatio: 1,
//                                     child: defaultImages.isNotEmpty
//                                         ? Image.memory(
//                                             base64Decode(defaultImages.first),
//                                             fit: BoxFit.cover,
//                                             errorBuilder:
//                                                 (context, error, stackTrace) {
//                                               return const Icon(
//                                                   Icons.image_not_supported);
//                                             },
//                                           )
//                                         : const Icon(Icons.image_not_supported),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const Text(
//                                           '⭐⭐⭐⭐⭐(5)',
//                                           style: TextStyle(fontSize: 10),
//                                         ),
//                                         Text(
//                                           product.productName,
//                                           style: styling(
//                                             fontFamily: 'Poppins-Bold',
//                                             fontSize: 20,
//                                           ),
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           product.brandName ??
//                                               'Unknown Brand', // Updated this line
//                                           style: styling(
//                                             fontFamily: 'Poppins-Regular',
//                                             fontSize: 12,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           '\₹${defaultPrice.toStringAsFixed(2)}',
//                                           style: styling(
//                                             fontFamily: 'Poppins-Regular',
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }

//                 return const SizedBox.shrink();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// // }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_state.dart';
// import 'package:vesture_firebase_user/models/product_model.dart';
// import 'package:vesture_firebase_user/screens/product_Details.dart';
// import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
// import 'package:vesture_firebase_user/widgets/custom_search.dart';
// import 'package:vesture_firebase_user/widgets/sheet_sort.dart';
// import 'package:vesture_firebase_user/widgets/textwidget.dart';

// class ShoppingPage extends StatefulWidget {
//   const ShoppingPage({super.key});

//   @override
//   _ShoppingPageState createState() => _ShoppingPageState();
// }

// class _ShoppingPageState extends State<ShoppingPage> {
//   bool _isSearching = false;

//   @override
//   void initState() {
//     super.initState();
//     context.read<ProductBloc>().add(FetchProductsEvent());
//   }

//   Widget _buildProductGrid(List<ProductModel> products) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(10),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 0.65,
//         crossAxisSpacing: 2,
//         mainAxisSpacing: 2,
//       ),
//       itemCount: products.length,
//       itemBuilder: (context, index) {
//         final product = products[index];
//         final defaultImages = product.getDefaultImages();
//         final defaultPrice = product.getDefaultPrice();

//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     ProductDetailsPage(productId: product.id!),
//               ),
//             );
//           },
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(1),
//             ),
//             elevation: 2,
//             shadowColor: Colors.red,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AspectRatio(
//                   aspectRatio: 1,
//                   child: defaultImages.isNotEmpty
//                       ? Image.memory(
//                           base64Decode(defaultImages.first),
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return const Icon(Icons.image_not_supported);
//                           },
//                         )
//                       : const Icon(Icons.image_not_supported),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         '⭐⭐⭐⭐⭐(5)',
//                         style: TextStyle(fontSize: 10),
//                       ),
//                       Text(
//                         product.productName,
//                         style: styling(
//                           fontFamily: 'Poppins-Bold',
//                           fontSize: 20,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         product.brandName ?? 'Unknown Brand',
//                         style: styling(
//                           fontFamily: 'Poppins-Regular',
//                           fontSize: 12,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '\₹${defaultPrice.toStringAsFixed(2)}',
//                         style: styling(
//                           fontFamily: 'Poppins-Regular',
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildCustomAppBar(context: context, title: 'Shopping Page'),
//       body: Column(
//         children: [
//           customSearchField(context),
//           customFilterSortRow(
//             context: context,
//             onFilterPressed: () {},
//             onSortPressed: () {
//               showSortBottomSheet(
//                 context,
//                 (sortOption) {
//                   final currentState = context.read<ProductBloc>().state;
//                   if (currentState is ProductLoadedState) {
//                     // Dispatch sort event with current products
//                     context.read<ProductBloc>().add(SortProductsEvent(
//                         sortOption: sortOption,
//                         products: currentState.products));
//                   }
//                 },
//               );
//             },
//           ),
//           BlocBuilder<ProductBloc, ProductState>(
//             builder: (context, state) {
//               if (state is ProductLoadingState) {
//                 return Expanded(
//                   child: Center(
//                       child: customSpinkitLoaderWithType(
//                     context: context,
//                     type: SpinkitType.fadingCube,
//                     color: Colors.red,
//                     size: 30.0,
//                   )),
//                 );
//               }

//               if (state is ProductErrorState) {
//                 return Expanded(
//                   child: Center(
//                     child: Text(
//                       'Error: ${state.errorMessage}',
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 );
//               }

//               if (state is ProductLoadedState) {
//                 if (state.products.isEmpty) {
//                   return Expanded(
//                     child: Center(
//                       child: Text(
//                         _isSearching
//                             ? 'No products found matching your search'
//                             : 'No products available',
//                         style: styling(
//                           fontFamily: 'Poppins-Regular',
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                   );
//                 }

//                 return Expanded(
//                   child: _buildProductGrid(state.products),
//                 );
//               }

//               return const SizedBox.shrink();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ShoppingPage extends StatefulWidget {
//   const ShoppingPage({super.key});

//   @override
//   _ShoppingPageState createState() => _ShoppingPageState();
// }

// class _ShoppingPageState extends State<ShoppingPage> {
//   bool _isSearching = false;

//   @override
//   void initState() {
//     super.initState();
//     context.read<ProductBloc>().add(FetchProductsEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildCustomAppBar(context: context, title: 'Shopping Page'),
//       body: Column(
//         children: [
//           customSearchField(context),
//           customFilterSortRow(
//             context: context,
//             onFilterPressed: () {
//               final currentState =
//                   context.read<ProductBloc>().state; // Get the current state
//               if (currentState is ProductLoadedState) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => FilterScreen(
//                       initialFilter: currentState.filter ??
//                           ProductFilter(
//                               priceRange: RangeValues(0, 100000000),
//                               selectedColors: {},
//                               selectedSizes: {},
//                               selectedBrands: {},
//                               selectedCategory: ''),
//                      // onApply: (ProductFilter newFilter) {
//                         context.read<ProductBloc>().add(
//                               ApplyFiltersEvent(
//                                 filter: newFilter,
//                                 products: currentState.products,
//                               ),
//                             );
//                       },
//                     ),
//                   ),
//                 );
//               }
//             },
//             onSortPressed: () {
//               showSortBottomSheet(
//                 context,
//                 (sortOption) {
//                   final currentState = context.read<ProductBloc>().state;
//                   if (currentState is ProductLoadedState) {
//                     context.read<ProductBloc>().add(SortProductsEvent(
//                         sortOption: sortOption,
//                         products: currentState.products));
//                   }
//                 },
//               );
//             },
//           ),
//           BlocBuilder<ProductBloc, ProductState>(
//             builder: (context, state) {
//               if (state is ProductLoadingState) {
//                 return Expanded(child: buildLoadingIndicator(context: context));
//               }

//               if (state is ProductErrorState) {
//                 return Expanded(child: buildErrorWidget(state.errorMessage));
//               }

//               if (state is ProductLoadedState) {
//                 if (state.products.isEmpty) {
//                   return Expanded(
//                       child: buildEmptyStateWidget(
//                           message: _isSearching
//                               ? 'No products found matching your search'
//                               : 'No products available'));
//                 }

//                 return Expanded(
//                     child: buildProductGridView(
//                         products: state.products,
//                         context: context,
//                         onItemTap: (product) {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ProductDetailsPage(
//                                       productId: product.id!)));
//                         }));
//               }

//               return const SizedBox.shrink();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
