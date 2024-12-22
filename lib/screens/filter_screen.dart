// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
// import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
// import 'package:vesture_firebase_user/models/product_filter.dart';
// import 'package:vesture_firebase_user/repository/filter_repo.dart';

// class FilterScreen extends StatefulWidget {
//   final ProductFilter initialFilter;
//   const FilterScreen({
//     Key? key,
//     required this.initialFilter,
//   }) : super(key: key);

//   @override
//   State<FilterScreen> createState() => _FilterScreenState();
// }

// class _FilterScreenState extends State<FilterScreen> {
//   late ProductFilter currentFilter;
//   late Future<FilterData> filterDataFuture;
//   late FilterRepository filterRepository;

//   @override
//   void initState() {
//     super.initState();
//     currentFilter = widget.initialFilter;
//     filterRepository = FilterRepository();
//     filterDataFuture = filterRepository.fetchFilterData();
//   }

//   Widget _buildPriceRangeSection(RangeValues priceRange) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text(
//             'Price Range',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//         RangeSlider(
//           values: RangeValues(
//             currentFilter.priceRange.start
//                 .clamp(priceRange.start, priceRange.end),
//             currentFilter.priceRange.end
//                 .clamp(priceRange.start, priceRange.end),
//           ),
//           min: priceRange.start,
//           max: priceRange.end,
//           onChanged: (values) {
//             setState(() {
//               currentFilter = ProductFilter(
//                 priceRange: RangeValues(
//                   values.start.clamp(priceRange.start, priceRange.end),
//                   values.end.clamp(priceRange.start, priceRange.end),
//                 ),
//                 selectedColors: currentFilter.selectedColors,
//                 selectedSizes: currentFilter.selectedSizes,
//                 selectedBrands: currentFilter.selectedBrands,
//                 selectedCategory: currentFilter.selectedCategory,
//               );
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildColorsSection(List<String> colors) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text(
//             'Colors',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//         Wrap(
//           spacing: 8,
//           children: colors.map((color) {
//             final isSelected = currentFilter.selectedColors.contains(color);
//             return ChoiceChip(
//               label: Text(color),
//               selected: isSelected,
//               onSelected: (selected) {
//                 setState(() {
//                   if (selected) {
//                     currentFilter.selectedColors.add(color);
//                   } else {
//                     currentFilter.selectedColors.remove(color);
//                   }
//                 });
//               },
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildSizesSection(List<String> sizes) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text(
//             'Sizes',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//         Wrap(
//           spacing: 8,
//           children: sizes.map((size) {
//             final isSelected = currentFilter.selectedSizes.contains(size);
//             return ChoiceChip(
//               label: Text(size),
//               selected: isSelected,
//               onSelected: (selected) {
//                 setState(() {
//                   if (selected) {
//                     currentFilter.selectedSizes.add(size);
//                   } else {
//                     currentFilter.selectedSizes.remove(size);
//                   }
//                 });
//               },
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildCategorySection(List<String> categories) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text(
//             'Category',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//         DropdownButton<String>(
//           value: categories.contains(currentFilter.selectedCategory)
//               ? currentFilter.selectedCategory
//               : categories.first,
//           items: categories.map((category) {
//             return DropdownMenuItem(
//               value: category,
//               child: Text(category),
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               currentFilter = ProductFilter(
//                 priceRange: currentFilter.priceRange,
//                 selectedColors: currentFilter.selectedColors,
//                 selectedSizes: currentFilter.selectedSizes,
//                 selectedBrands: currentFilter.selectedBrands,
//                 selectedCategory: value!,
//               );
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildBrandSection(List<String> brands) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text(
//             'Brands',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//         Wrap(
//           spacing: 8,
//           children: brands.map((brand) {
//             final isSelected = currentFilter.selectedBrands.contains(brand);
//             return ChoiceChip(
//               label: Text(brand),
//               selected: isSelected,
//               onSelected: (selected) {
//                 setState(() {
//                   if (selected) {
//                     currentFilter.selectedBrands.add(brand);
//                   } else {
//                     currentFilter.selectedBrands.remove(brand);
//                   }
//                 });
//               },
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildDivider() => const Divider(height: 1, thickness: 1);

//   Widget _buildBottomButtons() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           OutlinedButton(
//             onPressed: () {
//               setState(() {
//                 currentFilter = widget.initialFilter;
//               });
//             },
//             child: const Text('Clear'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               context.read<ProductBloc>().add(
//                     ApplyFiltersEvent(
//                       filter: currentFilter,
//                     ),
//                   );
//               Navigator.pop(context);
//             },
//             child: const Text('Apply'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Filters',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
//         ),
//       ),
//       body: FutureBuilder<FilterData>(
//         future: filterDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           final filterData = snapshot.data!;

//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildPriceRangeSection(filterData.priceRange),
//                 _buildDivider(),
//                 _buildColorsSection(filterData.colors),
//                 _buildDivider(),
//                 _buildSizesSection(filterData.sizes),
//                 _buildDivider(),
//                 _buildCategorySection(filterData.categories),
//                 _buildDivider(),
//                 _buildBrandSection(filterData.brands),
//               ],
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: _buildBottomButtons(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
import 'package:vesture_firebase_user/models/product_filter.dart';
import 'package:vesture_firebase_user/repository/filter_repo.dart';
import 'package:vesture_firebase_user/widgets/filter_screen_widgets.dart';

class FilterScreen extends StatefulWidget {
  final ProductFilter initialFilter;
  const FilterScreen({
    Key? key,
    required this.initialFilter,
  }) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late ProductFilter currentFilter;
  late Future<FilterData> filterDataFuture;
  late FilterRepository filterRepository;

  @override
  void initState() {
    super.initState();
    currentFilter = widget.initialFilter;
    filterRepository = FilterRepository();
    filterDataFuture = filterRepository.fetchFilterData();
  }

  void _updateFilter(ProductFilter newFilter) {
    setState(() {
      currentFilter = newFilter;
    });
  }

  void _applyFilters() {
    context.read<ProductBloc>().add(
          ApplyFiltersEvent(
            filter: currentFilter,
          ),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filters',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: FutureBuilder<FilterData>(
        future: filterDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final filterData = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterWidgets.buildPriceRangeSection(
                  filterData.priceRange,
                  currentFilter,
                  _updateFilter,
                ),
                FilterWidgets.buildDivider(),
                FilterWidgets.buildColorsSection(
                  filterData.colors,
                  currentFilter,
                  _updateFilter,
                ),
                FilterWidgets.buildDivider(),
                FilterWidgets.buildSizesSection(
                  filterData.sizes,
                  currentFilter,
                  _updateFilter,
                ),
                FilterWidgets.buildDivider(),
                FilterWidgets.buildCategorySection(
                  filterData.categories,
                  currentFilter,
                  _updateFilter,
                ),
                FilterWidgets.buildDivider(),
                FilterWidgets.buildBrandSection(
                  filterData.brands,
                  currentFilter,
                  _updateFilter,
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: FilterWidgets.buildBottomButtons(
        context,
        currentFilter,
        widget.initialFilter,
        _updateFilter,
        _applyFilters,
      ),
    );
  }
}
