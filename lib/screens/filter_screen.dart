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
    super.key,
    required this.initialFilter,
  });

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
