// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_state.dart';
// import 'package:vesture_firebase_user/models/category_model.dart';
// import 'package:vesture_firebase_user/screens/product_Details.dart';
// import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
// import 'package:vesture_firebase_user/widgets/sheet_sort.dart';
// import 'package:vesture_firebase_user/widgets/textwidget.dart';
// import 'dart:convert';

// class CategoryProductPage extends StatefulWidget {
//   final CategoryModel category;

//   const CategoryProductPage({super.key, required this.category});

//   @override
//   _CategoryProductPageState createState() => _CategoryProductPageState();
// }

// class _CategoryProductPageState extends State<CategoryProductPage> {
//   late ProductBloc _productBloc;
//   List<dynamic> _currentProducts = [];
//   String _currentSearchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _productBloc = context.read<ProductBloc>();
//     _productBloc
//         .add(FetchProductsByCategoryEvent(categoryId: widget.category.id!));
//   }

//   void _onSearchQueryChanged(String query) {
//     setState(() {
//       _currentSearchQuery = query.trim().toLowerCase();
//     });

//     if (_currentSearchQuery.isEmpty) {
//       // If search query is empty, fetch products for the category again
//       _productBloc
//           .add(FetchProductsByCategoryEvent(categoryId: widget.category.id!));
//     } else {
//       // Perform search event
//       _productBloc.add(SearchProductsEvent(query: _currentSearchQuery));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _productBloc,
//       child: Scaffold(
//         appBar:
//             buildCustomAppBar(context: context, title: widget.category.name),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search in ${widget.category.name}',
//                   hintStyle: styling(
//                       fontFamily: 'Poppins-Regular', color: Colors.grey),
//                   suffixIcon: const Icon(Icons.search),
//                   border: const OutlineInputBorder(),
//                 ),
//                 onChanged: _onSearchQueryChanged,
//                 onSubmitted: _onSearchQueryChanged,
//               ),
//             ),
//             customFilterSortRow(
//               context: context,
//               onFilterPressed: () {

//               },
//               onSortPressed: () {
//                 showSortBottomSheet(
//                   context,
//                   (sortOption) {
//                     final currentState = context.read<ProductBloc>().state;
//                     if (currentState is ProductLoadedState) {

//                       context.read<ProductBloc>().add(SortProductsEvent(
//                           sortOption: sortOption,
//                           products: currentState.products));
//                     }
//                   },
//                 );
//               },
//             ),
//             BlocConsumer<ProductBloc, ProductState>(
//               listener: (context, state) {
//                 if (state is ProductLoadedState) {
//                   setState(() {
//                     _currentProducts = state.products;
//                   });
//                 }
//               },
//               builder: (context, state) {
//                 if (state is ProductLoadingState) {
//                   return Expanded(
//                     child: Center(
//                       child: customSpinkitLoaderWithType(
//                         context: context,
//                         type: SpinkitType.fadingCube,
//                         color: Colors.red,
//                         size: 60.0,
//                       ),
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

//                 final filteredProducts = _currentProducts.where((product) {
//                   final categoryMatch =
//                       product.parentCategoryId == widget.category.id ||
//                           product.subCategoryId == widget.category.id;

//                   if (!categoryMatch) return false;

//                   if (_currentSearchQuery.isEmpty) return true;

//                   return product.productName
//                           .toLowerCase()
//                           .contains(_currentSearchQuery) ||
//                       (product.brandName
//                               ?.toLowerCase()
//                               .contains(_currentSearchQuery) ??
//                           false) ||
//                       (product.description
//                               ?.toLowerCase()
//                               .contains(_currentSearchQuery) ??
//                           false);
//                 }).toList();

//                 // If no products found
//                 if (filteredProducts.isEmpty) {
//                   return Expanded(
//                     child: Center(
//                       child: Text(
//                         _currentSearchQuery.isNotEmpty
//                             ? 'No products found for "${_currentSearchQuery}"'
//                             : 'No products found in ${widget.category.name}',
//                         style: styling(
//                           fontFamily: 'Poppins-Bold',
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   );
//                 }

//                 return Expanded(
//                   child: GridView.builder(
//                     padding: const EdgeInsets.all(10),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 0.65,
//                       crossAxisSpacing: 2,
//                       mainAxisSpacing: 2,
//                     ),
//                     itemCount: filteredProducts.length,
//                     itemBuilder: (context, index) {
//                       final product = filteredProducts[index];
//                       final defaultImages = product.getDefaultImages();
//                       final defaultPrice = product.getDefaultPrice();

//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ProductDetailsPage(
//                                       productId: product.id!)));
//                         },
//                         child: SizedBox(
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(1),
//                             ),
//                             elevation: 2,
//                             shadowColor: Colors.red,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 AspectRatio(
//                                   aspectRatio: 1,
//                                   child: defaultImages.isNotEmpty
//                                       ? Image.memory(
//                                           base64Decode(defaultImages.first),
//                                           fit: BoxFit.cover,
//                                           errorBuilder:
//                                               (context, error, stackTrace) {
//                                             return const Icon(
//                                                 Icons.image_not_supported);
//                                           },
//                                         )
//                                       : const Icon(Icons.image_not_supported),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Text(
//                                         '⭐⭐⭐⭐⭐(5)',
//                                         style: TextStyle(fontSize: 10),
//                                       ),
//                                       Text(
//                                         product.productName,
//                                         style: styling(
//                                           fontFamily: 'Poppins-Bold',
//                                           fontSize: 20,
//                                         ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         product.brandName ?? 'Unknown Brand',
//                                         style: styling(
//                                           fontFamily: 'Poppins-Regular',
//                                           fontSize: 12,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         '\₹${defaultPrice.toStringAsFixed(2)}',
//                                         style: styling(
//                                           fontFamily: 'Poppins-Regular',
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
