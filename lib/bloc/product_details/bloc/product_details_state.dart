import 'package:vesture_firebase_user/models/product_model.dart';

abstract class ProductDetailsState {}

class ProductDetailsInitialState extends ProductDetailsState {}

class ProductDetailsLoadingState extends ProductDetailsState {}

class ProductDetailsLoadedState extends ProductDetailsState {
  final ProductModel product;
  final Variant selectedVariant;
  final SizeStockModel? selectedSize;
  final List<Variant> availableVariants;

  ProductDetailsLoadedState({
    required this.product,
    required this.selectedVariant,
    this.selectedSize,
    required this.availableVariants,
  });
}

class SizeSelectedState extends ProductDetailsState {
  final SizeStockModel selectedSize;

  SizeSelectedState(this.selectedSize);
}

class ProductDetailsErrorState extends ProductDetailsState {
  final String errorMessage;

  ProductDetailsErrorState({required this.errorMessage});
}

class AddToCartSuccessState extends ProductDetailsState {
  final String message;

  AddToCartSuccessState({required this.message});
}

class AddToCartErrorState extends ProductDetailsState {
  final String errorMessage;

  AddToCartErrorState({required this.errorMessage});
}
