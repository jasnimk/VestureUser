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
import 'package:vesture_firebase_user/widgets/similar_products.dart';
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
                        spacing: 5,
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
                          AddToCartButton(
                            context: context,
                            product: product,
                            selectedVariant: selectedVariant,
                            selectedSize: selectedSize,
                          ),
                          customDivider(),
                          SimilarProductsList(
                            currentProductId: productId,
                            categoryId: product.subCategoryId ??
                                product.parentCategoryId!,
                          ),
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
