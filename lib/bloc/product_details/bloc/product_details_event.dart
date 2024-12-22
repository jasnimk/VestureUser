import 'package:vesture_firebase_user/models/product_model.dart';

abstract class ProductDetailsEvent {}

class FetchProductDetailsEvent extends ProductDetailsEvent {
  final String productId;

  FetchProductDetailsEvent({required this.productId});
}

class SelectColorVariantEvent extends ProductDetailsEvent {
  final Variant selectedVariant;

  SelectColorVariantEvent({required this.selectedVariant});
}

class SelectSizeEvent extends ProductDetailsEvent {
  final SizeStockModel selectedSize;

  SelectSizeEvent({required this.selectedSize});
}

class AddToCartEvent extends ProductDetailsEvent {
  final ProductModel product;
  final Variant selectedVariant;
  final SizeStockModel selectedSize;
  final int quantity;

  AddToCartEvent({
    required this.product,
    required this.selectedVariant,
    required this.selectedSize,
    this.quantity = 1,
  });
}
