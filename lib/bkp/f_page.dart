// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_state.dart';
// import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_bloc.dart';
// import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_event.dart';
// import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_state.dart';
// import 'package:vesture_firebase_user/repository/fav_repository.dart';
// import 'package:vesture_firebase_user/screens/product_Details.dart';
// import 'package:vesture_firebase_user/screens/shopping_page.dart';
// import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
// import 'package:vesture_firebase_user/widgets/fab.dart';
// import 'package:vesture_firebase_user/widgets/sheet_sort.dart';
// import 'package:vesture_firebase_user/widgets/textwidget.dart';
// import 'dart:convert';

// class FavoritesPage extends StatelessWidget {
//   const FavoritesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           FavoriteBloc(favoriteRepository: FavoriteRepository())
//             ..add(FetchFavoritesEvent()),
//       child: Scaffold(
//         appBar: buildCustomAppBar(
//           context: context,
//           title: 'My Favorites',
//           showBackButton: true,
//         ),
//         body: Column(
//           children: [
//             // customSearchField(context),
//             customFilterSortRow(
//               context: context,
//               onFilterPressed: () {},
//               onSortPressed: () {
//                 {
//                   print('Sort button pressed'); // Add this line
//                   showSortBottomSheet(
//                     context,
//                     (sortOption) {
//                       print(
//                           'Sort option selected: $sortOption'); // Add this line
//                       final currentState = context.read<FavoriteBloc>().state;
//                       if (currentState is FavoritesLoadedState) {
//                         print(
//                             'Current state is FavoritesLoadedState'); // Add this line
//                         context.read<FavoriteBloc>().add(SortFavoritesEvent(
//                             sortOption: sortOption,
//                             products: currentState.products));
//                       } else {
//                         print(
//                             'Current state is NOT FavoritesLoadedState: ${currentState.runtimeType}'); // Add this line
//                       }
//                     },
//                   );
//                 }
//                 ;
//               },
//             ),
//             BlocBuilder<FavoriteBloc, FavoriteState>(
//               builder: (context, state) {
//                 if (state is FavoriteLoadingState) {
//                   return Flexible(
//                     fit: FlexFit.tight,
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

//                 if (state is FavoriteErrorState) {
//                   return Center(
//                     child: Text(
//                       'Error: ${state.errorMessage}',
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   );
//                 }

//                 if (state is FavoritesLoadedState) {
//                   if (state.products.isEmpty) {
//                     return Flexible(
//                       fit: FlexFit.tight,
//                       child: Center(
//                         child: Column(
//                           spacing: 10,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'No favorite products found!',
//                               style: styling(
//                                 fontFamily: 'Poppins-Bold',
//                                 fontSize: 16,
//                                 color: Color.fromRGBO(196, 28, 13, 0.829),
//                               ),
//                             ),
//                           ],
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
//                                           product.brandName ?? 'Unknown Brand',
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
//         floatingActionButton: BlocBuilder<FavoriteBloc, FavoriteState>(
//           builder: (context, state) {
//             if (state is FavoritesLoadedState && state.products.isEmpty) {
//               return BubblingFAB(
//                 onPressed: () {
//                   Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
//                     return ShoppingPage();
//                   }));
//                 },
//                 icon: Icons.shop,
//                 backgroundColor: const Color.fromRGBO(196, 28, 13, 0.829),
//                 iconColor: Colors.white,
//                 scaleStart: 1.0,
//                 scaleEnd: 1.1,
//                 duration: const Duration(milliseconds: 1500),
//               );
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }
// }



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_event.dart';
// import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_state.dart';
// import 'package:vesture_firebase_user/models/favorite_model.dart';
// import 'package:vesture_firebase_user/models/product_model.dart';

// class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   FavoriteBloc() : super(FavoriteInitialState()) {
//     on<CheckFavoriteStatusEvent>(_onCheckFavoriteStatus);
//     on<ToggleFavoriteEvent>(_onToggleFavorite);
//     on<FetchFavoritesEvent>(_onFetchFavorites);
//   }

//   Future<void> _onCheckFavoriteStatus(
//       CheckFavoriteStatusEvent event, Emitter<FavoriteState> emit) async {
//     try {
//       emit(FavoriteLoadingState());

//       final user = _auth.currentUser;
//       if (user == null) {
//         emit(const FavoriteStatusState(isFavorite: false));
//         return;
//       }

//       final favoriteDoc = await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('favorites')
//           .where('productId', isEqualTo: event.productId)
//           .where('variantId', isEqualTo: event.variantId)
//           .where('size', isEqualTo: event.size)
//           .get();

//       emit(FavoriteStatusState(isFavorite: favoriteDoc.docs.isNotEmpty));
//     } catch (e) {
//       print('Error checking favorite status: $e');
//       emit(FavoriteErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onToggleFavorite(
//       ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
//     try {
//       emit(FavoriteLoadingState());

//       final user = _auth.currentUser;
//       if (user == null) {
//         emit(const FavoriteStatusState(isFavorite: false));
//         return;
//       }

//       final favoriteCollection =
//           _firestore.collection('users').doc(user.uid).collection('favorites');

//       final favorite = Favorite(
//         productId: event.productId,
//         variantId: event.variant.id,
//         size: event.sizeStock.size,
//         variant: event.variant,
//         price: event.sizeStock.baseprice,
//       );

//       final favoriteQuery = await favoriteCollection
//           .where('productId', isEqualTo: favorite.productId)
//           .where('variantId', isEqualTo: favorite.variantId)
//           .where('size', isEqualTo: favorite.size)
//           .get();

//       if (favoriteQuery.docs.isNotEmpty) {
//         // Check if context is available for showing dialog
//         bool confirmRemove = event.context != null
//             ? await _showRemoveFavoriteDialog(event.context!)
//             : true;

//         if (confirmRemove) {
//           await favoriteQuery.docs.first.reference.delete();
//           emit(const FavoriteStatusState(isFavorite: false));
//         } else {
//           emit(const FavoriteStatusState(isFavorite: true));
//         }
//       } else {
//         await favoriteCollection.add(favorite.toFirestore());
//         emit(const FavoriteStatusState(isFavorite: true));
//       }
//     } catch (e) {
//       print('Favorite Toggle Error: $e');
//       emit(FavoriteErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onFetchFavorites(
//       FetchFavoritesEvent event, Emitter<FavoriteState> emit) async {
//     try {
//       emit(FavoriteLoadingState());

//       final user = _auth.currentUser;
//       if (user == null) {
//         emit(const FavoritesLoadedState(products: []));
//         return;
//       }

//       final favoritesQuery = await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('favorites')
//           .get();

//       final favorites = favoritesQuery.docs
//           .map((doc) => Favorite.fromFirestore(doc))
//           .toList();

//       final uniqueProductIds = favorites.map((f) => f.productId).toSet();

//       List<ProductModel> favoriteProducts = [];

//       for (final productId in uniqueProductIds) {
//         try {
//           final productDoc =
//               await _firestore.collection('products').doc(productId).get();

//           if (!productDoc.exists) {
//             continue;
//           }
//           final variantsSnapshot = await _firestore
//               .collection('variants')
//               .where('productId', isEqualTo: productId)
//               .get();

//           List<Variant> variants = [];
//           for (var variantDoc in variantsSnapshot.docs) {
//             final sizeStocksSnapshot = await _firestore
//                 .collection('sizes_and_stocks')
//                 .where('variantId', isEqualTo: variantDoc.id)
//                 .get();

//             final sizeStocks = sizeStocksSnapshot.docs
//                 .map((doc) => SizeStockModel.fromMap(doc.data(), doc.id))
//                 .toList();

//             variants.add(
//                 Variant.fromMap(variantDoc.data(), variantDoc.id, sizeStocks));
//           }
//           String? brandName;
//           final brandDoc = await _firestore
//               .collection('brands')
//               .doc(productDoc.data()?['brandId'])
//               .get();

//           brandName = brandDoc.data()?['name'] ??
//               brandDoc.data()?['brandName'] ??
//               brandDoc.data()?['title'] ??
//               'Unknown Brand';

//           final product =
//               ProductModel.fromFirestore(productDoc, variants, brandName);
//           favoriteProducts.add(product);
//         } catch (productFetchError) {
//           print('Error fetching product $productId: $productFetchError');
//         }
//       }

//       emit(FavoritesLoadedState(products: favoriteProducts));
//     } catch (e) {
//       print('Error fetching favorites: $e');
//       emit(FavoriteErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<bool> _showRemoveFavoriteDialog(BuildContext context) async {
//     return await showDialog<bool>(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Remove from Favorites'),
//             content: const Text(
//                 'Are you sure you want to remove this item from favorites?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(true),
//                 child: const Text('Confirm'),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }
// }