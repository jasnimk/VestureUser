import 'package:vesture_firebase_user/models/category_model.dart';
import 'package:vesture_firebase_user/models/product_filter.dart';
import 'package:vesture_firebase_user/models/product_model.dart';

abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<ProductModel> products;
  final ProductFilter? filter;
  final bool isSearchActive;
  final String? searchQuery;

  ProductLoadedState({
    required this.products,
    this.filter,
    this.isSearchActive = false,
    this.searchQuery,
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

class VisualSearchLoadingState extends ProductState {}

class VisualSearchLoadedState extends ProductState {
  final List<ProductModel> products;

  VisualSearchLoadedState({required this.products});
}

class VisualSearchErrorState extends ProductState {
  final String errorMessage;

  VisualSearchErrorState({required this.errorMessage});
}

// In product_state.dart, add this new state:
class BrandsLoadedState extends ProductState {
  final List<Map<String, String>> brands;

  BrandsLoadedState({required this.brands});
}
