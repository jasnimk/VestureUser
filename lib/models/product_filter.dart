import 'package:flutter/material.dart';

class ProductFilter {
  final RangeValues priceRange;
  final Set<String> selectedColors;
  final Set<String> selectedSizes;
  final Set<String> selectedBrands;
  final String selectedCategory;

  ProductFilter({
    required this.priceRange,
    Set<String>? selectedColors,
    Set<String>? selectedSizes,
    Set<String>? selectedBrands,
    this.selectedCategory = 'All',
  })  : selectedColors = selectedColors ?? {},
        selectedSizes = selectedSizes ?? {},
        selectedBrands = selectedBrands ?? {};

  ProductFilter copyWith({
    RangeValues? priceRange,
    Set<String>? selectedColors,
    Set<String>? selectedSizes,
    Set<String>? selectedBrands,
    String? selectedCategory,
  }) {
    return ProductFilter(
      priceRange: priceRange ?? this.priceRange,
      selectedColors: selectedColors ?? this.selectedColors,
      selectedSizes: selectedSizes ?? this.selectedSizes,
      selectedBrands: selectedBrands ?? this.selectedBrands,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class FilterData {
  final RangeValues priceRange;
  final List<String> colors;
  final List<String> sizes;
  final List<String> categories;
  final List<String> brands;

  FilterData({
    required this.priceRange,
    required this.colors,
    required this.sizes,
    required this.categories,
    required this.brands,
  });
}
