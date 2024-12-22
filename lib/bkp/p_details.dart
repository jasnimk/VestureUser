// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_bloc.dart';
// import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_event.dart';
// import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_state.dart';
// import 'package:vesture_firebase_user/bloc/product_details/bloc/product_details_bloc.dart';
// import 'package:vesture_firebase_user/bloc/product_details/bloc/product_details_event.dart';
// import 'package:vesture_firebase_user/bloc/product_details/bloc/product_details_state.dart';
// import 'package:vesture_firebase_user/repository/fav_repository.dart';
// import 'package:vesture_firebase_user/utilities/color_utility.dart';
// import 'package:vesture_firebase_user/widgets/bottom_sheet_size.dart';
// import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
// import 'package:vesture_firebase_user/widgets/custom_button.dart';
// import 'package:vesture_firebase_user/widgets/textwidget.dart';

// class ProductDetailsPage extends StatelessWidget {
//   final String productId;

//   const ProductDetailsPage({super.key, required this.productId});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => ProductDetailsBloc()
//             ..add(FetchProductDetailsEvent(productId: productId)),
//         ),
//         BlocProvider(
//           create: (context) =>
//               FavoriteBloc(favoriteRepository: FavoriteRepository()),
//         ),
//       ],
//       child: Scaffold(
//         appBar: buildCustomAppBar(context: context, title: 'Product Details'),
//         body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
//           builder: (context, productState) {
//             if (productState is ProductDetailsLoadingState) {
//               return Center(
//                 child: customSpinkitLoaderWithType(
//                   context: context,
//                   type: SpinkitType.threeBounce,
//                   color: Colors.red,
//                   size: 60.0,
//                 ),
//               );
//             }

//             if (productState is ProductDetailsErrorState) {
//               return Center(
//                 child: Text(
//                   'Error: ${productState.errorMessage}',
//                   style: headerStyling(color: Colors.red),
//                 ),
//               );
//             }

//             if (productState is ProductDetailsLoadedState) {
//               final product = productState.product;
//               final selectedVariant = productState.selectedVariant;
//               final selectedSize = productState.selectedSize;

//               return BlocProvider(
//                 create: (context) =>
//                     FavoriteBloc(favoriteRepository: FavoriteRepository())
//                       ..add(CheckFavoriteStatusEvent(
//                         productId: productId,
//                         variantId: selectedVariant.id,
//                         size: selectedSize!.size,
//                       )),
//                 child: BlocBuilder<FavoriteBloc, FavoriteState>(
//                   builder: (context, favoriteState) {
//                     bool isFavorite = false;
//                     if (favoriteState is FavoriteStatusState) {
//                       isFavorite = favoriteState.isFavorite;
//                     }

//                     return SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Stack(
//                             children: [
//                               SizedBox(
//                                 height: 400,
//                                 child: PageView.builder(
//                                   itemCount: selectedVariant.imageUrls.length,
//                                   itemBuilder: (context, index) {
//                                     return Image.memory(
//                                       base64Decode(
//                                           selectedVariant.imageUrls[index]),
//                                       fit: BoxFit.cover,
//                                       errorBuilder:
//                                           (context, error, stackTrace) {
//                                         return const Icon(
//                                             Icons.image_not_supported);
//                                       },
//                                     );
//                                   },
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 10,
//                                 right: 10,
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // If not already in favorites, show bottom sheet
//                                     if (!isFavorite) {
//                                       showCustomBottomSheet(
//                                         context: context,
//                                         availableSizes:
//                                             selectedVariant.sizeStocks,
//                                         initialSelectedSize: selectedSize,
//                                         onSizeSelected: (selectedSize) {
//                                           context
//                                               .read<ProductDetailsBloc>()
//                                               .add(
//                                                 SelectSizeEvent(
//                                                     selectedSize: selectedSize),
//                                               );

//                                           // Check favorite status for the selected size
//                                           context.read<FavoriteBloc>().add(
//                                                 CheckFavoriteStatusEvent(
//                                                   productId: productId,
//                                                   variantId: selectedVariant.id,
//                                                   size: selectedSize.size,
//                                                 ),
//                                               );
//                                         },
//                                         actionButtonLabel: "Add to Favorites",
//                                         actionCallback: (selectedSize) {
//                                           // Trigger toggle favorite event
//                                           context.read<FavoriteBloc>().add(
//                                                 ToggleFavoriteEvent(
//                                                   productId: productId,
//                                                   variant: selectedVariant,
//                                                   sizeStock: selectedSize,
//                                                   context:
//                                                       context, // Pass context for dialog
//                                                 ),
//                                               );
//                                         },
//                                       );
//                                     } else {
//                                       // Directly toggle for already favorited item
//                                       context.read<FavoriteBloc>().add(
//                                             ToggleFavoriteEvent(
//                                               productId: productId,
//                                               variant: selectedVariant,
//                                               sizeStock:
//                                                   selectedSize!, // Use the current selected size
//                                               context:
//                                                   context, // Pass context for dialog
//                                             ),
//                                           );
//                                     }
//                                   },
//                                   child: FaIcon(
//                                     isFavorite
//                                         ? FontAwesomeIcons.solidHeart
//                                         : FontAwesomeIcons.heart,
//                                     color: const Color.fromRGBO(
//                                         196, 28, 13, 0.829),
//                                     size: 20,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16.0, vertical: 10),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       product.productName,
//                                       style: headerStyling(),
//                                     ),
//                                     Text(
//                                       '₹ ${selectedVariant.sizeStocks.first.baseprice.toStringAsFixed(2)}',
//                                       style: headerStyling(fontSize: 18),
//                                     ),
//                                   ],
//                                 ),
//                                 Text(
//                                   product.brandName ?? 'Unknown Brand',
//                                   style: subHeaderStyling(),
//                                 ),
//                                 const Text(
//                                   '⭐⭐⭐⭐⭐(5)',
//                                   style: TextStyle(fontSize: 10),
//                                 )
//                               ],
//                             ),
//                           ),
//                           customDivider(),
//                           // Color Variants
//                           Padding(
//                             padding:
//                                 const EdgeInsets.only(left: 16.0, right: 16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Color', style: styling()),
//                                 SizedBox(
//                                   height: 60,
//                                   child: ListView.builder(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount:
//                                         productState.availableVariants.length,
//                                     itemBuilder: (context, index) {
//                                       final variant =
//                                           productState.availableVariants[index];
//                                       return GestureDetector(
//                                         onTap: () {
//                                           context
//                                               .read<ProductDetailsBloc>()
//                                               .add(
//                                                 SelectColorVariantEvent(
//                                                   selectedVariant: variant,
//                                                 ),
//                                               );
//                                         },
//                                         child: Container(
//                                           margin: const EdgeInsets.all(8),
//                                           width: 30,
//                                           height: 30,
//                                           decoration: BoxDecoration(
//                                             color: ColorUtil.getColorFromName(
//                                                 variant.color),
//                                             shape: BoxShape.circle,
//                                             border:
//                                                 selectedVariant.id == variant.id
//                                                     ? Border.all(
//                                                         color: Colors.white,
//                                                         width: 1)
//                                                     : null,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           customDivider(),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Product Description',
//                                   style: subHeaderStyling(),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Text(
//                                   product.description,
//                                   style: styling(fontSize: 12),
//                                   textAlign: TextAlign.justify,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 16.0),
//                             child: customButton(
//                               context: context,
//                               text: "Add to Cart",
//                               onPressed: () {
//                                 showCustomBottomSheet(
//                                   context: context,
//                                   availableSizes: selectedVariant.sizeStocks,
//                                   initialSelectedSize: selectedSize,
//                                   onSizeSelected: (selectedSize) {
//                                     context.read<ProductDetailsBloc>().add(
//                                           SelectSizeEvent(
//                                               selectedSize: selectedSize),
//                                         );
//                                   },
//                                   actionButtonLabel: "Add to Cart",
//                                   actionCallback: (selectedSize) {
//                                     // Implement add to cart logic
//                                   },
//                                 );
//                               },
//                               icon: FontAwesomeIcons.cartShopping,
//                               height: 50,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }

//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }
// }
