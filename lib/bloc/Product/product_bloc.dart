import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/models/product_filter.dart';
import 'package:vesture_firebase_user/models/product_model.dart';
import 'package:vesture_firebase_user/repository/product_repo.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  List<ProductModel> _originalProducts = [];
  ProductFilter? _currentFilter;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitialState()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<FetchProductsByCategoryEvent>(_onFetchProductsByCategory);
    on<SearchProductsEvent>(_onSearchProducts);

    on<SortProductsEvent>(_onSortProducts);

    on<InitializeFiltersEvent>(_onInitializeFilters);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<ClearFiltersEvent>(_onClearFilters);
    on<UpdateFilterEvent>(_onUpdateFilter);
    on<VisualSearchEvent>(_onVisualSearch);
  }
  Future<void> _onSortProducts(
      SortProductsEvent event, Emitter<ProductState> emit) async {
    try {
      final sortedProducts = await _productRepository.sortProducts(
        products: event.products,
        sortOption: event.sortOption,
      );

      emit(ProductLoadedState(products: sortedProducts));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onInitializeFilters(
      InitializeFiltersEvent event, Emitter<ProductState> emit) async {
    try {
      if (_originalProducts.isEmpty) {
        _originalProducts = await _productRepository.fetchProducts();
      }
      _currentFilter =
          await _productRepository.getInitialFilter(_originalProducts);
      emit(ProductLoadedState(
        products: _originalProducts,
        filter: _currentFilter,
      ));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onClearFilters(
      ClearFiltersEvent event, Emitter<ProductState> emit) async {
    try {
      _currentFilter =
          await _productRepository.getInitialFilter(_originalProducts);
      emit(ProductLoadedState(
        products: _originalProducts,
        filter: _currentFilter,
      ));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateFilter(
      UpdateFilterEvent event, Emitter<ProductState> emit) async {
    _currentFilter = event.updatedFilter;
    if (state is ProductLoadedState) {
      emit(ProductLoadedState(
        products: (state as ProductLoadedState).products,
        filter: _currentFilter,
      ));
    }
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoadingState());
      final products = await _productRepository.fetchProducts();

      _originalProducts = List.from(products);
      emit(ProductLoadedState(products: products));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onApplyFilters(
      ApplyFiltersEvent event, Emitter<ProductState> emit) async {
    try {
      if (_originalProducts.isEmpty) {
        final products = await _productRepository.fetchProducts();
        _originalProducts = List.from(products);
      }

      final filteredProducts = await _productRepository.applyFilters(
        _originalProducts,
        event.filter,
      );

      emit(ProductLoadedState(
        products: filteredProducts,
        filter: event.filter,
      ));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchProductsByCategory(
      FetchProductsByCategoryEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoadingState());
      final products =
          await _productRepository.fetchProductsByCategory(event.categoryId);
      emit(ProductLoadedState(products: products));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onSearchProducts(
      SearchProductsEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoadingState());
      final products = await _productRepository.searchProducts(event.query);
      emit(ProductLoadedState(products: products));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onVisualSearch(
      VisualSearchEvent event, Emitter<ProductState> emit) async {
    try {
      emit(VisualSearchLoadingState());

      // Perform the visual search using the repository
      final products =
          await _productRepository.searchByImage(event.image as File);

      emit(VisualSearchLoadedState(products: products));
    } catch (e) {
      emit(VisualSearchErrorState(errorMessage: e.toString()));
    }
  }
}
