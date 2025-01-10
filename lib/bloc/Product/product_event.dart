import 'dart:io';
import 'dart:ui';

import 'package:vesture_firebase_user/models/product_filter.dart';
import 'package:vesture_firebase_user/models/product_model.dart';

abstract class ProductEvent {}

class FetchProductsEvent extends ProductEvent {}

class FetchProductsByCategoryEvent extends ProductEvent {
  final String categoryId;
  FetchProductsByCategoryEvent({required this.categoryId});
}

class FetchCategoriesEvent extends ProductEvent {}

class SearchProductsEvent extends ProductEvent {
  final String query;
  final String? categoryId; // Add categoryId parameter

  SearchProductsEvent({
    required this.query,
    this.categoryId, // Make it optional
  });
}

class SortProductsEvent extends ProductEvent {
  final String sortOption;
  final List<ProductModel> products;

  SortProductsEvent({required this.sortOption, required this.products});
}

// Separate filter-related events
class InitializeFiltersEvent extends ProductEvent {}

class ApplyFiltersEvent extends ProductEvent {
  final ProductFilter filter;
  ApplyFiltersEvent({required this.filter});
}

class ClearFiltersEvent extends ProductEvent {}

class UpdateFilterEvent extends ProductEvent {
  final ProductFilter updatedFilter;
  UpdateFilterEvent({required this.updatedFilter});
}

class VisualSearchEvent extends ProductEvent {
  final File image;
  final String? categoryId; // Add categoryId parameter

  VisualSearchEvent({
    required this.image,
    this.categoryId, // Make it optional
  });
}

class ClearSearchEvent extends ProductEvent {}

class FetchProductsByBrandEvent extends ProductEvent {
  final String brandId;

  FetchProductsByBrandEvent({required this.brandId});
}

class FetchBrandsEvent extends ProductEvent {}
