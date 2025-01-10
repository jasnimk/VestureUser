import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesture_firebase_user/bloc/product_details/bloc/product_details_bloc.dart';
import 'package:vesture_firebase_user/bloc/product_details/bloc/product_details_event.dart';
import 'package:vesture_firebase_user/models/product_model.dart';
import 'package:vesture_firebase_user/utilities&Services/color_utility.dart';
import 'package:vesture_firebase_user/widgets/bottom_sheet_size.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/price_display.dart';
import 'package:vesture_firebase_user/widgets/product_like_button.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class ProductImageSection extends StatelessWidget {
  final List<String> imageUrls;
  final bool isFavorite;
  final String productId;
  final Variant selectedVariant;
  final SizeStockModel selectedSize;

  const ProductImageSection({
    super.key,
    required this.imageUrls,
    required this.isFavorite,
    required this.productId,
    required this.selectedVariant,
    required this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.1,
                maxScale: 3.0,
                child: Image.memory(
                  base64Decode(imageUrls[index]),
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, st) {
                    return const Icon(Icons.image_not_supported);
                  },
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: ProductLikeButton(
            isFavorite: isFavorite,
            productId: productId,
            selectedVariant: selectedVariant,
            selectedSize: selectedSize,
          ),
        )
      ],
    );
  }
}

class ProductInfoSection extends StatelessWidget {
  final ProductModel product;

  const ProductInfoSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    product.productName,
                    style: headerStyling(),
                  ),
                  Text(
                    product.brandName ?? 'Unknown Brand',
                    style: subHeaderStyling(),
                  ),
                  const Text(
                    '⭐⭐⭐⭐⭐(5)',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductPriceDisplay(product: product),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ColorVariantSection extends StatelessWidget {
  final List<Variant> availableVariants;
  final Variant selectedVariant;
  final Function(Variant) onVariantSelected;

  const ColorVariantSection({
    Key? key,
    required this.availableVariants,
    required this.selectedVariant,
    required this.onVariantSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Color', style: styling()),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableVariants.length,
              itemBuilder: (context, index) {
                final variant = availableVariants[index];
                return GestureDetector(
                  onTap: () => onVariantSelected(variant),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: ColorUtil.getColorFromName(variant.color),
                      shape: BoxShape.circle,
                      border: selectedVariant.id == variant.id
                          ? Border.all(color: Colors.white, width: 1)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDescriptionSection extends StatelessWidget {
  final String description;

  const ProductDescriptionSection({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Description',
            style: subHeaderStyling(),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: styling(fontSize: 12),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class AddToCartButton extends StatelessWidget {
  final BuildContext context;
  final ProductModel product;
  final Variant selectedVariant;
  final SizeStockModel selectedSize;

  const AddToCartButton({
    Key? key,
    required this.context,
    required this.product,
    required this.selectedVariant,
    required this.selectedSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: customButton(
        context: context,
        text: "Add to Cart",
        onPressed: () {
          showCustomBottomSheet(
            context: context,
            availableSizes: selectedVariant.sizeStocks,
            initialSelectedSize: selectedSize,
            onSizeSelected: (selectedSize) {
              context.read<ProductDetailsBloc>().add(
                    SelectSizeEvent(selectedSize: selectedSize),
                  );
            },
            actionButtonLabel: "Add to Cart",
            actionCallback: (selectedSize) {
              context.read<ProductDetailsBloc>().add(
                    AddToCartEvent(
                      product: product,
                      selectedVariant: selectedVariant,
                      selectedSize: selectedSize,
                      quantity: 1,
                    ),
                  );
            },
            //isCartAction: true,
          );
        },
        icon: FontAwesomeIcons.cartShopping,
        height: 50,
      ),
    );
  }
}
