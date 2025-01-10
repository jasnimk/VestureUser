import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/models/product_filter.dart';
import 'package:vesture_firebase_user/utilities&Services/color_utility.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class FilterWidgets {
  static Widget buildPriceRangeSection(
    RangeValues priceRange,
    ProductFilter currentFilter,
    Function(ProductFilter) onFilterChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price Range',
                style: headerStyling(),
              ),
              Text(
                '\₹${currentFilter.priceRange.start.toStringAsFixed(0)} - \₹${currentFilter.priceRange.end.toStringAsFixed(0)}',
                style: styling(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: RangeSlider(
                  values: RangeValues(
                    currentFilter.priceRange.start
                        .clamp(priceRange.start, priceRange.end),
                    currentFilter.priceRange.end
                        .clamp(priceRange.start, priceRange.end),
                  ),
                  min: priceRange.start,
                  max: priceRange.end,
                  onChanged: (values) {
                    onFilterChanged(
                      ProductFilter(
                        priceRange: RangeValues(
                          values.start.clamp(priceRange.start, priceRange.end),
                          values.end.clamp(priceRange.start, priceRange.end),
                        ),
                        selectedColors: currentFilter.selectedColors,
                        selectedSizes: currentFilter.selectedSizes,
                        selectedBrands: currentFilter.selectedBrands,
                        selectedCategory: currentFilter.selectedCategory,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildColorsSection(
    List<String> colors,
    ProductFilter currentFilter,
    Function(ProductFilter) onFilterChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Colors',
            style: headerStyling(),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: colors.map((color) {
              final isSelected = currentFilter.selectedColors.contains(color);
              return GestureDetector(
                onTap: () {
                  final updatedColors =
                      Set<String>.from(currentFilter.selectedColors);
                  if (isSelected) {
                    updatedColors.remove(color);
                  } else {
                    updatedColors.add(color);
                  }
                  onFilterChanged(
                    ProductFilter(
                      priceRange: currentFilter.priceRange,
                      selectedColors: updatedColors,
                      selectedSizes: currentFilter.selectedSizes,
                      selectedBrands: currentFilter.selectedBrands,
                      selectedCategory: currentFilter.selectedCategory,
                    ),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16.0, left: 10, right: 4),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: ColorUtil.getColorFromName(color),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  static Widget buildSizesSection(
    List<String> sizes,
    ProductFilter currentFilter,
    Function(ProductFilter) onFilterChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Sizes',
            style: headerStyling(),
          ),
        ),
        Wrap(
          spacing: 8,
          children: sizes.map((size) {
            final isSelected = currentFilter.selectedSizes.contains(size);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChoiceChip(
                label: Text(
                  size,
                  style: styling(),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  final updatedSizes =
                      Set<String>.from(currentFilter.selectedSizes);
                  if (selected) {
                    updatedSizes.add(size);
                  } else {
                    updatedSizes.remove(size);
                  }
                  onFilterChanged(
                    ProductFilter(
                      priceRange: currentFilter.priceRange,
                      selectedColors: currentFilter.selectedColors,
                      selectedSizes: updatedSizes,
                      selectedBrands: currentFilter.selectedBrands,
                      selectedCategory: currentFilter.selectedCategory,
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  static Widget buildCategorySection(
    List<String> categories,
    ProductFilter currentFilter,
    Function(ProductFilter) onFilterChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Category',
            style: headerStyling(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: DropdownButton<String>(
            value: categories.contains(currentFilter.selectedCategory)
                ? currentFilter.selectedCategory
                : categories.first,
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(
                  category,
                  style: styling(),
                ),
              );
            }).toList(),
            onChanged: (value) {
              onFilterChanged(
                ProductFilter(
                  priceRange: currentFilter.priceRange,
                  selectedColors: currentFilter.selectedColors,
                  selectedSizes: currentFilter.selectedSizes,
                  selectedBrands: currentFilter.selectedBrands,
                  selectedCategory: value!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static Widget buildBrandSection(
    List<String> brands,
    ProductFilter currentFilter,
    Function(ProductFilter) onFilterChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Brands',
            style: headerStyling(),
          ),
        ),
        Wrap(
          spacing: 8,
          children: brands.map((brand) {
            final isSelected = currentFilter.selectedBrands.contains(brand);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChoiceChip(
                label: Text(
                  brand,
                  style: styling(),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  final updatedBrands =
                      Set<String>.from(currentFilter.selectedBrands);
                  if (selected) {
                    updatedBrands.add(brand);
                  } else {
                    updatedBrands.remove(brand);
                  }
                  onFilterChanged(
                    ProductFilter(
                      priceRange: currentFilter.priceRange,
                      selectedColors: currentFilter.selectedColors,
                      selectedSizes: currentFilter.selectedSizes,
                      selectedBrands: updatedBrands,
                      selectedCategory: currentFilter.selectedCategory,
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  static Widget buildDivider() => const Divider(height: 1, thickness: 1);

  static Widget buildBottomButtons(
    BuildContext context,
    ProductFilter currentFilter,
    ProductFilter initialFilter,
    Function(ProductFilter) onFilterChanged,
    Function() onApply,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 25),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: customButton(
                context: context,
                text: 'Clear',
                onPressed: () {
                  final clearedFilter = ProductFilter(
                    priceRange: RangeValues(0, 100000),
                    // priceRange: initialFilter.priceRange,
                    selectedColors: {},
                    selectedSizes: {},
                    selectedBrands: {},
                    selectedCategory: '',
                  );
                  onFilterChanged(clearedFilter);
                },
                height: 50),
          ),
          Expanded(
            child: customButton(
                context: context,
                text: 'Apply',
                onPressed: onApply,
                //width: 100,
                height: 50),
          ),
        ],
      ),
    );
  }
}
