// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:like_button/like_button.dart';
// import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_bloc.dart';
// import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_event.dart';
// import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_state.dart';
// import 'package:vesture_firebase_user/bloc/product_details/bloc/product_details_bloc.dart';
// import 'package:vesture_firebase_user/bloc/product_details/bloc/product_details_event.dart';
// import 'package:vesture_firebase_user/bloc/product_details/bloc/product_details_state.dart';
// import 'package:vesture_firebase_user/repository/cart_repo.dart';
// import 'package:vesture_firebase_user/repository/fav_repository.dart';
// import 'package:vesture_firebase_user/utilities/color_utility.dart';
// import 'package:vesture_firebase_user/widgets/bottom_sheet_size.dart';
// import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
// import 'package:vesture_firebase_user/widgets/custom_button.dart';
// import 'package:vesture_firebase_user/widgets/price_display.dart';
// import 'package:vesture_firebase_user/widgets/textwidget.dart';

// class ProductDetailsPage extends StatelessWidget {
//   final String productId;

//   const ProductDetailsPage({super.key, required this.productId});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//             create: (context) =>
//                 ProductDetailsBloc(cartRepository: CartRepository())
//                   ..add(FetchProductDetailsEvent(productId: productId))),
//         BlocProvider(
//             create: (context) =>
//                 FavoriteBloc(favoriteRepository: FavoriteRepository())),
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
//                     bool isFavorite = favoriteState is FavoriteStatusState
//                         ? favoriteState.isFavorite
//                         : false;

//                     return SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildProductImageSection(
//                             imageUrls: selectedVariant.imageUrls,
//                             isFavorite: isFavorite,
//                             onFavoriteChanged: (newFavoriteState) {
//                               if (newFavoriteState) {
//                                 // Add to favorites directly
//                                 context
//                                     .read<FavoriteBloc>()
//                                     .add(ToggleFavoriteEvent(
//                                       productId: productId,
//                                       variant: selectedVariant,
//                                       sizeStock: selectedSize!,
//                                       context: context,
//                                     ));
//                               } else {
//                                 // Remove from favorites with confirmation
//                                 _showConfirmationDialog(
//                                   context: context,
//                                   title: 'Remove from Favorites',
//                                   content:
//                                       'Are you sure you want to remove this item from favorites?',
//                                   onConfirm: () {
//                                     context
//                                         .read<FavoriteBloc>()
//                                         .add(ToggleFavoriteEvent(
//                                           productId: productId,
//                                           variant: selectedVariant,
//                                           sizeStock: selectedSize!,
//                                           context: context,
//                                         ));
//                                   },
//                                 );
//                               }
//                             },
//                           ),

//                           // _buildProductImageSection(
//                           //   imageUrls: selectedVariant.imageUrls,
//                           //   isFavorite: isFavorite,
//                           //   onFavoriteTap: () {
//                           //     if (!isFavorite) {
//                           //       showCustomBottomSheet(
//                           //         context: context,
//                           //         availableSizes: selectedVariant.sizeStocks,
//                           //         initialSelectedSize: selectedSize,
//                           //         onSizeSelected: (size) {
//                           //           context.read<ProductDetailsBloc>().add(
//                           //               SelectSizeEvent(selectedSize: size));
//                           //           context
//                           //               .read<FavoriteBloc>()
//                           //               .add(CheckFavoriteStatusEvent(
//                           //                 productId: productId,
//                           //                 variantId: selectedVariant.id,
//                           //                 size: size.size,
//                           //               ));
//                           //         },
//                           //         actionButtonLabel: "Add to Favorites",
//                           //         actionCallback: (size) {
//                           //           context
//                           //               .read<FavoriteBloc>()
//                           //               .add(ToggleFavoriteEvent(
//                           //                 productId: productId,
//                           //                 variant: selectedVariant,
//                           //                 sizeStock: size,
//                           //                 context: context,
//                           //               ));
//                           //         },
//                           //         isCartAction: false,
//                           //       );
//                           //     } else {
//                           //       _showConfirmationDialog(
//                           //           context: context,
//                           //           title: 'Remove from Favorites',
//                           //           content:
//                           //               'Are you sure you want to remove this item from favorites?',
//                           //           onConfirm: () {
//                           //             context
//                           //                 .read<FavoriteBloc>()
//                           //                 .add(ToggleFavoriteEvent(
//                           //                   productId: productId,
//                           //                   variant: selectedVariant,
//                           //                   sizeStock: selectedSize!,
//                           //                   context: context,
//                           //                 ));
//                           //           });
//                           //     }
//                           //   },
//                           // ),
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
//                                     Column(
//                                       children: [
//                                         Text(
//                                           product.productName,
//                                           style: headerStyling(),
//                                         ),
//                                         Text(
//                                           product.brandName ?? 'Unknown Brand',
//                                           style: subHeaderStyling(),
//                                         ),
//                                         const Text(
//                                           '⭐⭐⭐⭐⭐(5)',
//                                           style: TextStyle(fontSize: 10),
//                                         )
//                                       ],
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child:
//                                           ProductPriceDisplay(product: product),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           customDivider(),
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
//                                     context.read<ProductDetailsBloc>().add(
//                                           AddToCartEvent(
//                                             product: product,
//                                             selectedVariant: selectedVariant,
//                                             selectedSize: selectedSize,
//                                             quantity: 1,
//                                           ),
//                                         );
//                                   },
//                                   isCartAction: true,
//                                 );
//                               },
//                               icon: FontAwesomeIcons.cartShopping,
//                               height: 50,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 50,
//                           )
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

//   _buildProductImageSection({
//     required List<String> imageUrls,
//     required bool isFavorite,
//     required ValueChanged<bool> onFavoriteChanged,
//   }) {
//     return Stack(
//       children: [
//         SizedBox(
//           height: 400,
//           child: PageView.builder(
//             itemCount: imageUrls.length,
//             itemBuilder: (context, index) {
//               return InteractiveViewer(
//                 panEnabled: true, // Enable dragging
//                 boundaryMargin:
//                     const EdgeInsets.all(20), // Set margins for panning
//                 minScale: 0.1, // Minimum zoom
//                 maxScale: 3.0, // Maximum zoom
//                 child: Image.memory(
//                   base64Decode(imageUrls[index]),
//                   fit: BoxFit.cover,
//                   errorBuilder: (ctx, error, st) {
//                     return const Icon(Icons.image_not_supported);
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//         Positioned(
//           bottom: 10,
//           right: 10,
//           child: LikeButton(
//             isLiked: isFavorite,
//             onTap: (bool isLiked) async {
//               onFavoriteChanged(!isLiked);
//               return !isLiked; // Return the new favorite state
//             },
//             likeBuilder: (bool isLiked) {
//               return Icon(
//                 isLiked ? Icons.favorite : Icons.favorite_border,
//                 color: const Color.fromRGBO(196, 28, 13, 0.829),
//                 size: 30,
//               );
//             },
//             circleColor:
//                 const CircleColor(start: Colors.red, end: Colors.redAccent),
//             bubblesColor: const BubblesColor(
//               dotPrimaryColor: Colors.redAccent,
//               dotSecondaryColor: Colors.red,
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   // _buildProductImageSection(
//   //     {required List<String> imageUrls,
//   //     required bool isFavorite,
//   //     required VoidCallback onFavoriteTap}) {
//   //   return Stack(
//   //     children: [
//   //       SizedBox(
//   //         height: 400,
//   //         child: PageView.builder(
//   //           itemCount: imageUrls.length,
//   //           itemBuilder: (context, index) {
//   //             return InteractiveViewer(
//   //               panEnabled: true, // Enable dragging
//   //               boundaryMargin: EdgeInsets.all(20), // Set margins for panning
//   //               minScale: 0.1, // Minimum zoom
//   //               maxScale: 3.0, // Maximum zoom
//   //               child: Image.memory(
//   //                 base64Decode(imageUrls[index]),
//   //                 fit: BoxFit.cover,
//   //                 errorBuilder: (ctx, error, st) {
//   //                   return const Icon(Icons.image_not_supported);
//   //                 },
//   //               ),
//   //             );
//   //           },
//   //         ),
//   //       ),
//   //       Positioned(
//   //         bottom: 10,
//   //         right: 10,
//   //         child: GestureDetector(
//   //           onTap: onFavoriteTap,
//   //           child: FaIcon(
//   //             isFavorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
//   //             color: const Color.fromRGBO(196, 28, 13, 0.829),
//   //             size: 20,
//   //           ),
//   //         ),
//   //       )
//   //     ],
//   //   );
//   // }

//   _showConfirmationDialog(
//       {required BuildContext context,
//       required String title,
//       required String content,
//       required VoidCallback onConfirm}) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: Text(title, style: headerStyling()),
//           content: Text(content, style: styling()),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel', style: styling(color: Colors.grey)),
//               onPressed: () => Navigator.of(dialogContext).pop(),
//             ),
//             TextButton(
//               child: Text('Confirm', style: styling(color: Colors.red)),
//               onPressed: () {
//                 onConfirm();
//                 Navigator.of(dialogContext).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// product_details_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_bloc.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_event.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_state.dart';
import 'package:vesture_firebase_user/bloc/product_details/bloc/product_details_bloc.dart';
import 'package:vesture_firebase_user/bloc/product_details/bloc/product_details_event.dart';
import 'package:vesture_firebase_user/bloc/product_details/bloc/product_details_state.dart';
import 'package:vesture_firebase_user/repository/cart_repo.dart';
import 'package:vesture_firebase_user/repository/fav_repository.dart';
import 'package:vesture_firebase_user/widgets/product_details_widgets.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                ProductDetailsBloc(cartRepository: CartRepository())
                  ..add(FetchProductDetailsEvent(productId: productId))),
        BlocProvider(
            create: (context) =>
                FavoriteBloc(favoriteRepository: FavoriteRepository())),
      ],
      child: Scaffold(
        appBar: buildCustomAppBar(context: context, title: 'Product Details'),
        body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
          builder: (context, productState) {
            if (productState is ProductDetailsLoadingState) {
              return Center(
                child: customSpinkitLoaderWithType(
                  context: context,
                  type: SpinkitType.threeBounce,
                  color: Colors.red,
                  size: 60.0,
                ),
              );
            }

            if (productState is ProductDetailsErrorState) {
              return Center(
                child: Text(
                  'Error: ${productState.errorMessage}',
                  style: headerStyling(color: Colors.red),
                ),
              );
            }

            if (productState is ProductDetailsLoadedState) {
              final product = productState.product;
              final selectedVariant = productState.selectedVariant;
              final selectedSize = productState.selectedSize;

              return BlocProvider(
                create: (context) =>
                    FavoriteBloc(favoriteRepository: FavoriteRepository())
                      ..add(CheckFavoriteStatusEvent(
                        productId: productId,
                        variantId: selectedVariant.id,
                        size: selectedSize!.size,
                      )),
                child: BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, favoriteState) {
                    bool isFavorite = favoriteState is FavoriteStatusState
                        ? favoriteState.isFavorite
                        : false;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductImageSection(
                            imageUrls: selectedVariant.imageUrls,
                            isFavorite: isFavorite,
                            productId: productId,
                            selectedVariant: selectedVariant,
                            selectedSize: selectedSize!,
                          ),
                          ProductInfoSection(
                            product: product,
                          ),
                          customDivider(),
                          ColorVariantSection(
                            availableVariants: productState.availableVariants,
                            selectedVariant: selectedVariant,
                            onVariantSelected: (variant) {
                              context.read<ProductDetailsBloc>().add(
                                    SelectColorVariantEvent(
                                      selectedVariant: variant,
                                    ),
                                  );
                            },
                          ),
                          customDivider(),
                          ProductDescriptionSection(
                            description: product.description,
                          ),
                          const SizedBox(height: 10),
                          AddToCartButton(
                            context: context,
                            product: product,
                            selectedVariant: selectedVariant,
                            selectedSize: selectedSize,
                          ),
                          const SizedBox(height: 50)
                        ],
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
