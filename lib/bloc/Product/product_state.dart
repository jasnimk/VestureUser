import 'package:vesture_firebase_user/models/category_model.dart';
import 'package:vesture_firebase_user/models/product_filter.dart';
import 'package:vesture_firebase_user/models/product_model.dart';

abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<ProductModel> products;
  final ProductFilter? filter;

  ProductLoadedState({
    required this.products,
    this.filter,
  });
}

class ProductErrorState extends ProductState {
  final String errorMessage;

  ProductErrorState({required this.errorMessage});
}

// product_state.dart
class ProductCategoriesLoadedState extends ProductState {
  final List<CategoryModel> categories;

  ProductCategoriesLoadedState({required this.categories});
}
