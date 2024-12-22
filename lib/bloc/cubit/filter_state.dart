// States
import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/models/product_filter.dart';

abstract class FilterState {}

class FilterLoading extends FilterState {}

class FilterLoaded extends FilterState {
  final RangeValues priceRange;
  final List<String> colors;
  final List<String> sizes;
  final List<String> categories;
  final List<String> brands;

  FilterLoaded({
    required this.priceRange,
    required this.colors,
    required this.sizes,
    required this.categories,
    required this.brands,
  });
}

class FilterUpdated extends FilterState {
  final ProductFilter newFilter;

  FilterUpdated({required this.newFilter});
}

class FilterError extends FilterState {
  final String message;

  FilterError({required this.message});
}
