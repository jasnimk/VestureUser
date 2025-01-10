// import 'dart:io';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/models/product_filter.dart';
// import 'package:vesture_firebase_user/models/product_model.dart';
// import 'package:vesture_firebase_user/repository/product_repo.dart';
// import 'product_event.dart';
// import 'product_state.dart';

// class ProductBloc extends Bloc<ProductEvent, ProductState> {
//   final ProductRepository _productRepository;
//   List<ProductModel> _originalProducts = [];
//   ProductFilter? _currentFilter;
//   List<ProductModel> _searchResults = [];
//   bool _isSearchActive = false;

//   ProductBloc({required ProductRepository productRepository})
//       : _productRepository = productRepository,
//         super(ProductInitialState()) {
//     on<FetchProductsEvent>(_onFetchProducts);
//     on<FetchProductsByCategoryEvent>(_onFetchProductsByCategory);
//     on<SearchProductsEvent>(_onSearchProducts);

//     on<SortProductsEvent>(_onSortProducts);

//     on<InitializeFiltersEvent>(_onInitializeFilters);
//     on<ApplyFiltersEvent>(_onApplyFilters);
//     on<ClearFiltersEvent>(_onClearFilters);
//     on<UpdateFilterEvent>(_onUpdateFilter);
//     on<VisualSearchEvent>(_onVisualSearch);
//     on<FetchProductsByBrandEvent>(_onFetchProductsByBrand);
//     on<FetchBrandsEvent>(_onFetchBrands);
//   }
//   Future<void> _onSearchProducts(
//       SearchProductsEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(ProductLoadingState());
//       final products = await _productRepository.searchProducts(event.query);
//       _searchResults = products;
//       _isSearchActive = true;
//       emit(ProductLoadedState(
//           products: products,
//           filter: _currentFilter,
//           isSearchActive: true // Add this flag to track search state
//           ));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onSortProducts(
//       SortProductsEvent event, Emitter<ProductState> emit) async {
//     try {
//       final sortedProducts = await _productRepository.sortProducts(
//         products: event.products,
//         sortOption: event.sortOption,
//       );

//       emit(ProductLoadedState(products: sortedProducts));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onInitializeFilters(
//       InitializeFiltersEvent event, Emitter<ProductState> emit) async {
//     try {
//       if (_originalProducts.isEmpty) {
//         _originalProducts = await _productRepository.fetchProducts();
//       }
//       _currentFilter =
//           await _productRepository.getInitialFilter(_originalProducts);
//       emit(ProductLoadedState(
//         products: _originalProducts,
//         filter: _currentFilter,
//       ));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onClearFilters(
//       ClearFiltersEvent event, Emitter<ProductState> emit) async {
//     try {
//       _currentFilter =
//           await _productRepository.getInitialFilter(_originalProducts);
//       emit(ProductLoadedState(
//         products: _originalProducts,
//         filter: _currentFilter,
//       ));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onUpdateFilter(
//       UpdateFilterEvent event, Emitter<ProductState> emit) async {
//     _currentFilter = event.updatedFilter;
//     if (state is ProductLoadedState) {
//       emit(ProductLoadedState(
//         products: (state as ProductLoadedState).products,
//         filter: _currentFilter,
//       ));
//     }
//   }

//   Future<void> _onFetchProductsByBrand(
//       FetchProductsByBrandEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(ProductLoadingState());
//       final products =
//           await _productRepository.fetchProductsByBrand(event.brandId);
//       _originalProducts = List.from(products);
//       emit(ProductLoadedState(products: products));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onFetchBrands(
//       FetchBrandsEvent event, Emitter<ProductState> emit) async {
//     try {
//       final brands = await _productRepository.fetchBrands();
//       emit(BrandsLoadedState(brands: brands));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onFetchProducts(
//       FetchProductsEvent event, Emitter<ProductState> emit) async {
//     print('Fetch Products Event Triggered'); // Add this line

//     try {
//       emit(ProductLoadingState());
//       final products = await _productRepository.fetchProducts();

//       _originalProducts = List.from(products);
//       emit(ProductLoadedState(products: products));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onApplyFilters(
//       ApplyFiltersEvent event, Emitter<ProductState> emit) async {
//     try {
//       if (_originalProducts.isEmpty) {
//         final products = await _productRepository.fetchProducts();
//         _originalProducts = List.from(products);
//       }

//       final filteredProducts = await _productRepository.applyFilters(
//         _originalProducts,
//         event.filter,
//       );

//       emit(ProductLoadedState(
//         products: filteredProducts,
//         filter: event.filter,
//       ));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onFetchProductsByCategory(
//       FetchProductsByCategoryEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(ProductLoadingState());
//       final products =
//           await _productRepository.fetchProductsByCategory(event.categoryId);
//       emit(ProductLoadedState(products: products));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onVisualSearch(
//       VisualSearchEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(VisualSearchLoadingState());

//       final products = await _productRepository.searchByImage(event.image);

//       emit(VisualSearchLoadedState(products: products));
//     } catch (e) {
//       emit(VisualSearchErrorState(errorMessage: e.toString()));
//     }
//   }
// }

// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/models/product_filter.dart';
// import 'package:vesture_firebase_user/models/product_model.dart';
// import 'package:vesture_firebase_user/repository/product_repo.dart';
// import 'product_event.dart';
// import 'product_state.dart';

// class ProductBloc extends Bloc<ProductEvent, ProductState> {
//   final ProductRepository _productRepository;
//   List<ProductModel> _originalProducts = [];
//   ProductFilter? _currentFilter;
//   List<ProductModel> _searchResults = [];
//   bool _isSearchActive = false;
//   String _searchQuery = '';

//   ProductBloc({required ProductRepository productRepository})
//       : _productRepository = productRepository,
//         super(ProductInitialState()) {
//     on<FetchProductsEvent>(_onFetchProducts);
//     on<FetchProductsByCategoryEvent>(_onFetchProductsByCategory);
//     on<SearchProductsEvent>(_onSearchProducts);
//     on<SortProductsEvent>(_onSortProducts);
//     on<InitializeFiltersEvent>(_onInitializeFilters);
//     on<ApplyFiltersEvent>(_onApplyFilters);
//     on<ClearFiltersEvent>(_onClearFilters);
//     on<UpdateFilterEvent>(_onUpdateFilter);
//     on<VisualSearchEvent>(_onVisualSearch);
//     on<FetchProductsByBrandEvent>(_onFetchProductsByBrand);
//     on<FetchBrandsEvent>(_onFetchBrands);
//   }

//   Future<void> _onSearchProducts(
//       SearchProductsEvent event, Emitter<ProductState> emit) async {
//     try {
//       // If search query hasn't changed, don't search again
//       if (_searchQuery == event.query) {
//         return; // Skip if the query hasn't changed
//       }

//       _searchQuery = event.query; // Update the query

//       emit(ProductLoadingState());
//       final products = await _productRepository.searchProducts(event.query);
//       _searchResults = products;
//       _isSearchActive = true;
//       emit(ProductLoadedState(
//         products: products,
//         filter: _currentFilter,
//         isSearchActive: true,
//       ));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onSortProducts(
//       SortProductsEvent event, Emitter<ProductState> emit) async {
//     try {
//       final sortedProducts = await _productRepository.sortProducts(
//         products: event.products,
//         sortOption: event.sortOption,
//       );

//       emit(ProductLoadedState(products: sortedProducts));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onInitializeFilters(
//       InitializeFiltersEvent event, Emitter<ProductState> emit) async {
//     try {
//       if (_originalProducts.isEmpty) {
//         _originalProducts = await _productRepository.fetchProducts();
//       }
//       _currentFilter =
//           await _productRepository.getInitialFilter(_originalProducts);
//       emit(ProductLoadedState(
//         products: _originalProducts,
//         filter: _currentFilter,
//       ));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onClearFilters(
//       ClearFiltersEvent event, Emitter<ProductState> emit) async {
//     try {
//       // Only apply clear filter if it's necessary
//       if (_currentFilter == null) return;

//       _currentFilter =
//           await _productRepository.getInitialFilter(_originalProducts);
//       emit(ProductLoadedState(
//         products: _originalProducts,
//         filter: _currentFilter,
//       ));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onUpdateFilter(
//       UpdateFilterEvent event, Emitter<ProductState> emit) async {
//     // Only update filter if it's different from the current one
//     if (_currentFilter != event.updatedFilter) {
//       _currentFilter = event.updatedFilter;
//       emit(ProductLoadedState(
//         products: (state as ProductLoadedState).products,
//         filter: _currentFilter,
//       ));
//     }
//   }

//   Future<void> _onFetchProductsByBrand(
//       FetchProductsByBrandEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(ProductLoadingState());
//       final products =
//           await _productRepository.fetchProductsByBrand(event.brandId);
//       _originalProducts = List.from(products);
//       emit(ProductLoadedState(products: products));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onFetchBrands(
//       FetchBrandsEvent event, Emitter<ProductState> emit) async {
//     try {
//       final brands = await _productRepository.fetchBrands();
//       emit(BrandsLoadedState(brands: brands));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onFetchProducts(
//       FetchProductsEvent event, Emitter<ProductState> emit) async {
//     print('Fetch Products Event Triggered');

//     try {
//       emit(ProductLoadingState());
//       final products = await _productRepository.fetchProducts();

//       if (!ListEquality().equals(_originalProducts, products)) {
//         _originalProducts = List.from(products);
//         emit(ProductLoadedState(products: products));
//       }
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onApplyFilters(
//       ApplyFiltersEvent event, Emitter<ProductState> emit) async {
//     try {
//       // Avoid unnecessary fetch if products and filter are already available
//       if (_originalProducts.isEmpty) {
//         final products = await _productRepository.fetchProducts();
//         _originalProducts = List.from(products);
//       }

//       // Apply the filter only if there are changes
//       final filteredProducts = await _productRepository.applyFilters(
//         _originalProducts,
//         event.filter,
//       );

//       // Check if the filter is already applied, avoid re-applying it
//       if (_currentFilter != event.filter) {
//         _currentFilter = event.filter;
//       }

//       // Emit the filtered state
//       emit(ProductLoadedState(
//         products: filteredProducts,
//         filter: _currentFilter,
//       ));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onFetchProductsByCategory(
//       FetchProductsByCategoryEvent event, Emitter<ProductState> emit) async {
//     try {
//       // Check if the products are already fetched for this category
//       if (_originalProducts.isEmpty) {
//         emit(ProductLoadingState());
//         final products =
//             await _productRepository.fetchProductsByCategory(event.categoryId);
//         _originalProducts = List.from(products);
//         emit(ProductLoadedState(products: products));
//       } else {
//         // Avoid re-fetching if already fetched
//         // Filter products based on categoryId or subcategoryId
//         final filteredProducts = _originalProducts.where((product) {
//           return product.parentCategoryId == event.categoryId ||
//               product.subCategoryId == event.categoryId;
//         }).toList();
//         emit(ProductLoadedState(products: filteredProducts));
//       }
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onVisualSearch(
//       VisualSearchEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(VisualSearchLoadingState());

//       final products = await _productRepository.searchByImage(event.image);

//       emit(VisualSearchLoadedState(products: products));
//     } catch (e) {
//       emit(VisualSearchErrorState(errorMessage: e.toString()));
//     }
//   }
// }
