import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_bloc.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_event.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_state.dart';
import 'package:vesture_firebase_user/repository/fav_repository.dart';
import 'package:vesture_firebase_user/screens/product_Details.dart';
import 'package:vesture_firebase_user/widgets/product_like_button.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

buildProductGridItem({
  required BuildContext context,
  required dynamic product,
  VoidCallback? onTap,
}) {
  final defaultImages = product.getDefaultImages();
  final defaultPrice = product.getDefaultPrice();
  final defaultVariant = product.variants.first;
  final defaultSize = defaultVariant.sizeStocks.first;

  return BlocProvider(
    create: (context) => FavoriteBloc(favoriteRepository: FavoriteRepository())
      ..add(CheckFavoriteStatusEvent(
        productId: product.id!,
        variantId: defaultVariant.id,
        size: defaultSize.size,
      )),
    child: BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, favoriteState) {
        bool isFavorite = favoriteState is FavoriteStatusState
            ? favoriteState.isFavorite
            : false;

        return GestureDetector(
          onTap: onTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailsPage(productId: product.id!),
                  ),
                );
              },
          child: SizedBox(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
              ),
              elevation: 2,
              shadowColor: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: defaultImages.isNotEmpty
                            ? Image.memory(
                                base64Decode(defaultImages.first),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported);
                                },
                              )
                            : const Icon(Icons.image_not_supported),
                      ),
                      Positioned(
                        top: -3,
                        right: -6,
                        child: Container(
                          height: 38,
                          width: 28,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 227, 192, 192),
                              borderRadius: BorderRadius.circular(5)),
                          child: ProductLikeButton(
                            isFavorite: isFavorite,
                            productId: product.id!,
                            selectedVariant: defaultVariant,
                            selectedSize: defaultSize,
                            size: 18,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName,
                          style: styling(
                            fontFamily: 'Poppins-Bold',
                            fontSize: 20,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.brandName ?? 'Unknown Brand',
                          style: styling(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${defaultPrice.toStringAsFixed(2)}',
                          style: styling(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

buildProductGridView({
  required List<dynamic> products,
  required BuildContext context,
  VoidCallback? Function(dynamic product)? onItemTap,
}) {
  return AnimationLimiter(
    child: GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(milliseconds: 400),
          columnCount: 2,
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: buildProductGridItem(
                context: context,
                product: product,
                onTap: onItemTap != null ? () => onItemTap(product) : null,
              ),
            ),
          ),
        );
      },
    ),
  );
}

buildLoadingIndicator({
  required BuildContext context,
  SpinkitType type = SpinkitType.pulse,
  Color color = Colors.red,
  double size = 60.0,
}) {
  return Center(
    child: customSpinkitLoaderWithType(
      context: context,
      type: type,
      color: color,
      size: size,
    ),
  );
}

buildErrorWidget(String errorMessage) {
  return Center(
    child: Text(
      'Error: $errorMessage',
      style: const TextStyle(color: Colors.red),
    ),
  );
}

buildEmptyStateWidget({
  required String message,
  String? subMessage,
  String? imagePath,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
            imagePath ?? 'assets/animations/Animation - 1735364832916.json'),
        Text(
          message,
          style: styling(
            fontFamily: 'Poppins-Bold',
            fontSize: 16,
            color: Color.fromRGBO(196, 28, 13, 0.829),
          ),
        ),
        if (subMessage != null)
          Text(
            subMessage,
            style: styling(
              fontFamily: 'Poppins-Regular',
              fontSize: 14,
            ),
          ),
      ],
    ),
  );
}
