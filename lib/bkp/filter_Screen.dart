// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:vesture_firebase_user/bloc/Product/product_bloc.dart';
// // import 'package:vesture_firebase_user/bloc/Product/product_event.dart';
// // import 'package:vesture_firebase_user/models/product_filter.dart';

// // class FilterScreen extends StatefulWidget {
// //   final ProductFilter initialFilter;
// //   const FilterScreen({
// //     Key? key,
// //     required this.initialFilter,
// //   }) : super(key: key);

// //   @override
// //   State<FilterScreen> createState() => _FilterScreenState();
// // }

// // class _FilterScreenState extends State<FilterScreen> {
// //   late ProductFilter currentFilter;
// //   late Future<FilterData> filterDataFuture;

// //   @override
// //   void initState() {
// //     super.initState();
// //     currentFilter = widget.initialFilter;
// //     filterDataFuture = _loadFilterData();
// //   }

// //   Future<FilterData> _loadFilterData() async {
// //     final firestore = FirebaseFirestore.instance;

// //     // Fetch price range
// //     final productsSnapshot = await firestore
// //         .collection('sizes_and_stocks')
// //         .orderBy('baseprice')
// //         .get();

// //     double minPrice = double.infinity;
// //     double maxPrice = 0;

// //     for (var doc in productsSnapshot.docs) {
// //       final price = (doc.data()['baseprice'] as num).toDouble();
// //       if (price < minPrice) minPrice = price;
// //       if (price > maxPrice) maxPrice = price;
// //     }

// //     // Fetch colors
// //     final variantsSnapshot = await firestore.collection('variants').get();
// //     final colors = variantsSnapshot.docs
// //         .map((doc) => doc.data()['color'] as String)
// //         .toSet()
// //         .toList();

// //     // Fetch sizes
// //     final sizesSnapshot = await firestore.collection('sizes_and_stocks').get();
// //     final sizes = sizesSnapshot.docs
// //         .map((doc) => doc.data()['size'] as String)
// //         .toSet()
// //         .toList();

// //     // Fetch categories
// //     final categoriesSnapshot = await firestore
// //         .collection('categories')
// //         .where('isActive', isEqualTo: true)
// //         .get();
// //     final categories = ['All']..addAll(
// //         categoriesSnapshot.docs.map((doc) => doc.data()['name'] as String));

// //     // Fetch brands
// //     final brandsSnapshot = await firestore.collection('brands').get();
// //     final brands = brandsSnapshot.docs
// //         .map((doc) => doc.data()['brandName'] as String)
// //         .toList();

// //     return FilterData(
// //       priceRange: RangeValues(minPrice, maxPrice),
// //       colors: colors,
// //       sizes: sizes,
// //       categories: categories,
// //       brands: brands,
// //     );
// //   }

// //   Widget _buildPriceRangeSection(RangeValues priceRange) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Text(
// //             'Price Range',
// //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //         RangeSlider(
// //           values: RangeValues(
// //             currentFilter.priceRange.start
// //                 .clamp(priceRange.start, priceRange.end),
// //             currentFilter.priceRange.end
// //                 .clamp(priceRange.start, priceRange.end),
// //           ),
// //           min: priceRange.start,
// //           max: priceRange.end,
// //           onChanged: (values) {
// //             setState(() {
// //               currentFilter = ProductFilter(
// //                 priceRange: RangeValues(
// //                   values.start.clamp(priceRange.start, priceRange.end),
// //                   values.end.clamp(priceRange.start, priceRange.end),
// //                 ),
// //                 selectedColors: currentFilter.selectedColors,
// //                 selectedSizes: currentFilter.selectedSizes,
// //                 selectedBrands: currentFilter.selectedBrands,
// //                 selectedCategory: currentFilter.selectedCategory,
// //               );
// //             });
// //           },
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildColorsSection(List<String> colors) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Text(
// //             'Colors',
// //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //         Wrap(
// //           spacing: 8,
// //           children: colors.map((color) {
// //             final isSelected = currentFilter.selectedColors.contains(color);
// //             return ChoiceChip(
// //               label: Text(color),
// //               selected: isSelected,
// //               onSelected: (selected) {
// //                 setState(() {
// //                   if (selected) {
// //                     currentFilter.selectedColors.add(color);
// //                   } else {
// //                     currentFilter.selectedColors.remove(color);
// //                   }
// //                 });
// //               },
// //             );
// //           }).toList(),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildSizesSection(List<String> sizes) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Text(
// //             'Sizes',
// //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //         Wrap(
// //           spacing: 8,
// //           children: sizes.map((size) {
// //             final isSelected = currentFilter.selectedSizes.contains(size);
// //             return ChoiceChip(
// //               label: Text(size),
// //               selected: isSelected,
// //               onSelected: (selected) {
// //                 setState(() {
// //                   if (selected) {
// //                     currentFilter.selectedSizes.add(size);
// //                   } else {
// //                     currentFilter.selectedSizes.remove(size);
// //                   }
// //                 });
// //               },
// //             );
// //           }).toList(),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildCategorySection(List<String> categories) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Text(
// //             'Category',
// //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //         DropdownButton<String>(
// //           value: categories.contains(currentFilter.selectedCategory)
// //               ? currentFilter.selectedCategory
// //               : categories.first, // Fallback to the first category if no match
// //           items: categories.map((category) {
// //             return DropdownMenuItem(
// //               value: category,
// //               child: Text(category),
// //             );
// //           }).toList(),
// //           onChanged: (value) {
// //             setState(() {
// //               currentFilter = ProductFilter(
// //                 priceRange: currentFilter.priceRange,
// //                 selectedColors: currentFilter.selectedColors,
// //                 selectedSizes: currentFilter.selectedSizes,
// //                 selectedBrands: currentFilter.selectedBrands,
// //                 selectedCategory: value!,
// //               );
// //             });
// //           },
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildBrandSection(List<String> brands) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Text(
// //             'Brands',
// //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //         Wrap(
// //           spacing: 8,
// //           children: brands.map((brand) {
// //             final isSelected = currentFilter.selectedBrands.contains(brand);
// //             return ChoiceChip(
// //               label: Text(brand),
// //               selected: isSelected,
// //               onSelected: (selected) {
// //                 setState(() {
// //                   if (selected) {
// //                     currentFilter.selectedBrands.add(brand);
// //                   } else {
// //                     currentFilter.selectedBrands.remove(brand);
// //                   }
// //                 });
// //               },
// //             );
// //           }).toList(),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildDivider() => const Divider(height: 1, thickness: 1);
// // // In FilterScreen, modify _buildBottomButtons()

// //   Widget _buildBottomButtons() {
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           OutlinedButton(
// //             onPressed: () {
// //               setState(() {
// //                 currentFilter = widget.initialFilter;
// //               });
// //             },
// //             child: const Text('Clear'),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               context.read<ProductBloc>().add(
// //                     ApplyFiltersEvent(
// //                       filter: currentFilter,
// //                     ),
// //                   );
// //               Navigator.pop(context);
// //             },
// //             child: const Text('Apply'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back, color: Colors.black),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //         title: const Text(
// //           'Filters',
// //           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
// //         ),
// //       ),
// //       body: FutureBuilder<FilterData>(
// //         future: filterDataFuture,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           }

// //           final filterData = snapshot.data!;

// //           return SingleChildScrollView(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 _buildPriceRangeSection(filterData.priceRange),
// //                 _buildDivider(),
// //                 _buildColorsSection(filterData.colors),
// //                 _buildDivider(),
// //                 _buildSizesSection(filterData.sizes),
// //                 _buildDivider(),
// //                 _buildCategorySection(filterData.categories),
// //                 _buildDivider(),
// //                 _buildBrandSection(filterData.brands),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //       bottomNavigationBar: _buildBottomButtons(),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/bloc/cubit/filter_cubit.dart';
// import 'package:vesture_firebase_user/bloc/cubit/filter_state.dart';
// import 'package:vesture_firebase_user/models/product_filter.dart';

// class FilterScreen extends StatelessWidget {
//   final ProductFilter initialFilter;

//   const FilterScreen({Key? key, required this.initialFilter}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Filters'),
//       ),
//       body: BlocBuilder<FilterCubit, FilterState>(
//         builder: (context, state) {
//           if (state is FilterLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is FilterLoaded) {
//             return _buildFilterBody(context, state);
//           } else if (state is FilterError) {
//             return Center(child: Text('Error: ${state.message}'));
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//       bottomNavigationBar: _buildBottomButtons(context),
//     );
//   }

//   Widget _buildFilterBody(BuildContext context, FilterLoaded state) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildPriceRangeSection(state.priceRange, context),
//           _buildColorsSection(state.colors),
//           _buildSizesSection(state.sizes),
//           _buildCategorySection(state.categories),
//           _buildBrandSection(state.brands),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomButtons(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         OutlinedButton(
//           onPressed: () {
//             BlocProvider.of<FilterCubit>(context).updateFilter(initialFilter);
//           },
//           child: const Text('Clear'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text('Apply'),
//         ),
//       ],
//     );
//   }

//   Widget _buildPriceRangeSection(RangeValues priceRange, BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Price Range',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           RangeSlider(
//             values: priceRange,
//             min: 0,
//             max: 1000,
//             divisions: 10,
//             labels: RangeLabels(
//               '\$${priceRange.start.toStringAsFixed(0)}',
//               '\$${priceRange.end.toStringAsFixed(0)}',
//             ),
//             onChanged: (newRange) {
//               BlocProvider.of<FilterCubit>(context)
//                   .updateFilter(ProductFilter(priceRange: newRange));
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildColorsSection(List<String> colors) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Colors',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           Wrap(
//             spacing: 8.0,
//             children: colors.map((color) {
//               return FilterChip(
//                 label: Text(color),
//                 onSelected: (isSelected) {
//                   // handle color selection
//                 },
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSizesSection(List<String> sizes) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Sizes',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           Wrap(
//             spacing: 8.0,
//             children: sizes.map((size) {
//               return FilterChip(
//                 label: Text(size),
//                 onSelected: (isSelected) {
//                   // handle size selection
//                 },
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategorySection(List<String> categories) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Categories',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           Wrap(
//             spacing: 8.0,
//             children: categories.map((category) {
//               return FilterChip(
//                 label: Text(category),
//                 onSelected: (isSelected) {
//                   // handle category selection
//                 },
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBrandSection(List<String> brands) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Brands',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           Wrap(
//             spacing: 8.0,
//             children: brands.map((brand) {
//               return FilterChip(
//                 label: Text(brand),
//                 onSelected: (isSelected) {
//                   // handle brand selection
//                 },
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

  // Future<List<ProductModel>> applyFilters(
  //     List<ProductModel> products, ProductFilter filter) async {
  //   return products.where((product) {
  //     double productMinPrice = double.infinity;
  //     double productMaxPrice = 0;

  //     for (var variant in product.variants ?? []) {
  //       for (var sizeStock in variant.sizeStocks) {
  //         if (sizeStock.baseprice < productMinPrice) {
  //           productMinPrice = sizeStock.baseprice;
  //         }
  //         if (sizeStock.baseprice > productMaxPrice) {
  //           productMaxPrice = sizeStock.baseprice;
  //         }
  //       }
  //     }

  //     if (productMaxPrice < filter.priceRange.start ||
  //         productMinPrice > filter.priceRange.end) {
  //       return false;
  //     }
  //     if (filter.selectedBrands.isNotEmpty) {
  //       final productBrand = product.brandName?.toLowerCase().trim();
  //       final selectedBrands = filter.selectedBrands
  //           .map((brand) => brand.toLowerCase().trim())
  //           .toSet();

  //       if (productBrand == null || !selectedBrands.contains(productBrand)) {
  //         return false;
  //       }
  //     }

  //     if (filter.selectedCategory.isNotEmpty &&
  //         filter.selectedCategory != 'All') {

  //       String selectedCategory = filter.selectedCategory.toLowerCase().trim();
  //       String parentCategory =
  //           (product.parentCategoryId ?? '').toLowerCase().trim();
  //       String subCategory = (product.subCategoryId ?? '').toLowerCase().trim();

  //       bool categoryMatch = parentCategory == selectedCategory ||
  //           subCategory == selectedCategory;

  //       if (!categoryMatch) {
  //         return false;
  //       }
  //     }

  //     if (filter.selectedColors.isNotEmpty) {
  //       bool hasMatchingColor = false;
  //       for (var variant in product.variants ?? []) {
  //         final variantColor = variant.color.toLowerCase().trim();
  //         final selectedColors =
  //             filter.selectedColors.map((c) => c.toLowerCase().trim()).toSet();

  //          if (selectedColors.contains(variantColor)) {
  //           hasMatchingColor = true;
  //           break;
  //         }
  //       }
  //       if (!hasMatchingColor) {
  //          return false;
  //       }
  //     }

  //     if (filter.selectedSizes.isNotEmpty) {
  //       bool hasMatchingSize = false;
  //       for (var variant in product.variants ?? []) {
  //         for (var sizeStock in variant.sizeStocks) {
  //           final stockSize = sizeStock.size.toLowerCase().trim();
  //           final selectedSizes =
  //               filter.selectedSizes.map((s) => s.toLowerCase().trim()).toSet();

  //             if (selectedSizes.contains(stockSize)) {
  //             hasMatchingSize = true;
  //             break;
  //           }
  //         }
  //         if (hasMatchingSize) break;
  //       }
  //       if (!hasMatchingSize) {
  //         return false;
  //       }
  //     }

  //     return true;
  //   }).toList();
  // }
