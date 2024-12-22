// // // Widget favoritesFilterSortRow({
// // //   required BuildContext context,
// // //   required VoidCallback onFilterPressed,
// // //   required VoidCallback onSortPressed,
// // // }) {
// // //   return Padding(
// // //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
// // //     child: Card(
// // //       shape: const BeveledRectangleBorder(),
// // //       shadowColor: const Color.fromRGBO(196, 28, 13, 0.829),
// // //       child: Row(
// // //         mainAxisAlignment:
// // //             MainAxisAlignment.spaceEvenly, // Changed to spaceEvenly
// // //         children: [
// // //           TextButton.icon(
// // //             onPressed: onFilterPressed,
// // //             icon: const Icon(Icons.filter_list),
// // //             label: const Text("Filters"),
// // //           ),
// // //           TextButton.icon(
// // //             onPressed: () {
// // //               final currentState = context.read<FavoriteBloc>().state;
// // //               if (currentState is FavoritesLoadedState) {
// // //                 // Show bottom sheet directly here
// // //                 _showSortBottomSheet(context, currentState.products);
// // //               }
// // //             },
// // //             icon: const Icon(Icons.sort),
// // //             label: const Text("Sort By"),
// // //           ),
// // //         ],
// // //       ),
// // //     ),
// // //   );
// // // }

// // // void _showSortBottomSheet(BuildContext context, List<ProductModel> products) {
// // //   showModalBottomSheet(
// // //     context: context,
// // //     builder: (context) => Container(
// // //       padding: const EdgeInsets.all(16),
// // //       child: Column(
// // //         mainAxisSize: MainAxisSize.min,
// // //         children: [
// // //           Text(
// // //             'Sort By',
// // //             style: TextStyle(
// // //               fontSize: 18,
// // //               fontWeight: FontWeight.bold,
// // //             ),
// // //           ),
// // //           const SizedBox(height: 16),
// // //           ListTile(
// // //             leading: const Icon(Icons.arrow_upward),
// // //             title: const Text('Price: Low to High'),
// // //             onTap: () {
// // //               context.read<FavoriteBloc>().add(
// // //                     SortFavoritesEvent(
// // //                       sortOption: 'price: lowest to high',
// // //                       products: products,
// // //                     ),
// // //                   );
// // //               Navigator.pop(context);
// // //             },
// // //           ),
// // //           ListTile(
// // //             leading: const Icon(Icons.arrow_downward),
// // //             title: const Text('Price: High to Low'),
// // //             onTap: () {
// // //               context.read<FavoriteBloc>().add(
// // //                     SortFavoritesEvent(
// // //                       sortOption: 'price: highest to low',
// // //                       products: products,
// // //                     ),
// // //                   );
// // //               Navigator.pop(context);
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //     ),
// // //   );
// // // }
// //  Future<List<ProductModel>> sortFavorites({
// //     required List<ProductModel> products,
// //     required String sortOption,
// //   }) async {
// //     if (products.isEmpty) return products;

// //     List<ProductModel> sortedList = List.from(products);

// //     switch (sortOption.toLowerCase()) {
// //       case 'price: lowest to high':
// //         sortedList.sort((a, b) {
// //           double priceA = _findLowestPrice(a);
// //           double priceB = _findLowestPrice(b);
// //           return priceA.compareTo(priceB);
// //         });
// //         break;
// //       case 'price: highest to low':
// //         sortedList.sort((a, b) {
// //           double priceA = _findLowestPrice(a);
// //           double priceB = _findLowestPrice(b);
// //           return priceB.compareTo(priceA);
// //         });
// //         break;
// //     }

// //     return sortedList;
// //   }

// //   double _findLowestPrice(ProductModel product) {
// //     if (product.variants == null || product.variants!.isEmpty) {
// //       return 0.0;
// //     }

// //     double lowestPrice = double.infinity;
// //     for (var variant in product.variants!) {
// //       for (var sizeStock in variant.sizeStocks) {
// //         if (sizeStock.baseprice < lowestPrice) {
// //           lowestPrice = sizeStock.baseprice;
// //         }
// //       }
// //     }
// //     return lowestPrice == double.infinity ? 0.0 : lowestPrice;
// //   }
//   Future<void> _onSortFavorites(
//       SortFavoritesEvent event, Emitter<FavoriteState> emit) async {
//     try {
//       emit(FavoriteLoadingState()); // Add loading state
//       final sortedProducts = await _favoriteRepository.sortFavorites(
//         products: event.products,
//         sortOption: event.sortOption,
//       );
//       emit(FavoritesLoadedState(products: sortedProducts));
//     } catch (e) {
//       print('Error sorting favorites: $e'); // Add error logging
//       emit(FavoriteErrorState(errorMessage: e.toString()));
//     }
//   }
