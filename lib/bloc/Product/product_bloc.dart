// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/models/product_filter.dart';
// import 'package:vesture_firebase_user/models/product_model.dart';
// import 'package:vesture_firebase_user/repository/product_repo.dart';
// import 'package:vesture_firebase_user/screens/shopping_page.dart';
// import 'product_event.dart';
// import 'product_state.dart';

// class ProductBloc extends Bloc<ProductEvent, ProductState> {
//   final ProductRepository _productRepository;
//   List<ProductModel> _originalProducts = [];
//   List<ProductModel> _currentProducts = [];
//   ProductFilter? _currentFilter;
//   List<ProductModel> _searchResults = [];
//   bool _isSearchActive = false;
//   ProductFilterType _currentFilterType = ProductFilterType.none;
//   String? _currentCategoryId;
// String? _currentBrandId;
//   String? _currentSearchQuery;

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
//     on<ClearSearchEvent>(_onClearSearch);
//   }
//   Future<void> _onSearchProducts(
//       SearchProductsEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(ProductLoadingState());
//       _currentSearchQuery = event.query;
//       _isSearchActive = true;

//       // Use the repository's existing search method with category if needed
//       final searchResults = await _productRepository.searchProducts(
//         event.query,
//         categoryId: _currentFilterType == ProductFilterType.category
//             ? _currentCategoryId
//             : null,
//       );

//       // If we're in brand view, filter the search results by brand
//       List<ProductModel> finalResults = searchResults;
//       if (_currentFilterType == ProductFilterType.brand &&
//           _currentBrandId != null) {
//         finalResults = searchResults
//             .where((product) => product.brandId == _currentBrandId)
//             .toList();
//       }

//       _currentProducts = finalResults;
//       emit(ProductLoadedState(
//         products: finalResults,
//         filter: _currentFilter,
//         isSearchActive: true,
//         searchQuery: event.query,
//       ));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onClearSearch(
//       ClearSearchEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(ProductLoadingState());
//       _currentSearchQuery = null;
//       _isSearchActive = false;

//       // Restore the original product list based on current filter type
//       List<ProductModel> products = [];
//       switch (_currentFilterType) {
//         case ProductFilterType.category:
//           if (_currentCategoryId != null) {
//             products = await _productRepository
//                 .fetchProductsByCategory(_currentCategoryId!);
//           }
//           break;
//         case ProductFilterType.brand:
//           if (_currentBrandId != null) {
//             products =
//                 await _productRepository.fetchProductsByBrand(_currentBrandId!);
//           }
//           break;
//         case ProductFilterType.none:
//           products = await _productRepository.fetchProducts();
//           break;
//       }

//       _currentProducts = products;
//       _originalProducts = products;

//       emit(ProductLoadedState(
//         products: products,
//         filter: _currentFilter,
//         isSearchActive: false,
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
//         // Fetch products based on current filter type
//         switch (_currentFilterType) {
//           case ProductFilterType.category:
//             if (_currentCategoryId != null) {
//               _originalProducts = await _productRepository
//                   .fetchProductsByCategory(_currentCategoryId!);
//             }
//             break;
//           case ProductFilterType.brand:
//             if (_currentBrandId != null) {
//               _originalProducts = await _productRepository
//                   .fetchProductsByBrand(_currentBrandId!);
//             }
//             break;
//           case ProductFilterType.none:
//             _originalProducts = await _productRepository.fetchProducts();
//             break;
//         }
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

// Future<void> _onFetchProductsByBrand(
//     FetchProductsByBrandEvent event, Emitter<ProductState> emit) async {
//   try {
//     emit(ProductLoadingState());
//     _currentFilterType = ProductFilterType.brand;
//     _currentBrandId = event.brandId;
//     _currentCategoryId = null;
//     _isSearchActive = false;
//     _currentSearchQuery = null;

//     final products =
//         await _productRepository.fetchProductsByBrand(event.brandId);
//     _originalProducts = products;
//     _currentProducts = products;

//     emit(ProductLoadedState(
//       products: products,
//       filter: _currentFilter,
//       isSearchActive: false,
//     ));
//   } catch (e) {
//     emit(ProductErrorState(errorMessage: e.toString()));
//   }
// }

//   // Future<void> _onFetchProductsByBrand(
//   //     FetchProductsByBrandEvent event, Emitter<ProductState> emit) async {
//   //   try {
//   //     emit(ProductLoadingState());
//   //     _currentFilterType = ProductFilterType.brand;
//   //     _currentBrandId = event.brandId;
//   //     _originalProducts = []; // Reset products to force new fetch
//   //     final products =
//   //         await _productRepository.fetchProductsByBrand(event.brandId);
//   //     _originalProducts = products;
//   //     emit(ProductLoadedState(products: products));
//   //   } catch (e) {
//   //     emit(ProductErrorState(errorMessage: e.toString()));
//   //   }
//   // }

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
//     try {
//       emit(ProductLoadingState());
//       _currentFilterType = ProductFilterType.none;
//       _currentCategoryId = null;
//       _currentBrandId = null;
//       _isSearchActive = false;
//       _currentSearchQuery = null;

//       final products = await _productRepository.fetchProducts();
//       _originalProducts = products;
//       _currentProducts = products;

//       emit(ProductLoadedState(
//         products: products,
//         filter: _currentFilter,
//         isSearchActive: false,
//       ));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }
//   // Future<void> _onFetchProducts(
//   //     FetchProductsEvent event, Emitter<ProductState> emit) async {
//   //   try {
//   //     emit(ProductLoadingState());
//   //     _currentFilterType = ProductFilterType.none;
//   //     _currentCategoryId = null;
//   //     _currentBrandId = null;
//   //     _originalProducts = []; // Reset products to force new fetch
//   //     final products = await _productRepository.fetchProducts();
//   //     _originalProducts = products;
//   //     emit(ProductLoadedState(products: products));
//   //   } catch (e) {
//   //     emit(ProductErrorState(errorMessage: e.toString()));
//   //   }
//   // }

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
//       _currentFilterType = ProductFilterType.category;
//       _currentCategoryId = event.categoryId;
//       _currentBrandId = null;
//       _isSearchActive = false;
//       _currentSearchQuery = null;

//       final products =
//           await _productRepository.fetchProductsByCategory(event.categoryId);
//       _originalProducts = products;
//       _currentProducts = products;

//       emit(ProductLoadedState(
//         products: products,
//         filter: _currentFilter,
//         isSearchActive: false,
//       ));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }
//   // Future<void> _onFetchProductsByCategory(
//   //     FetchProductsByCategoryEvent event, Emitter<ProductState> emit) async {
//   //   try {
//   //     emit(ProductLoadingState());
//   //     _currentFilterType = ProductFilterType.category;
//   //     _currentCategoryId = event.categoryId;
//   //     _originalProducts = []; // Reset products to force new fetch
//   //     final products =
//   //         await _productRepository.fetchProductsByCategory(event.categoryId);
//   //     _originalProducts = products;
//   //     emit(ProductLoadedState(products: products));
//   //   } catch (e) {
//   //     emit(ProductErrorState(errorMessage: e.toString()));
//   //   }
//   // }

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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/models/product_filter.dart';
import 'package:vesture_firebase_user/models/product_model.dart';
import 'package:vesture_firebase_user/repository/product_repo.dart';
import 'package:vesture_firebase_user/screens/shopping_page.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  List<ProductModel> _originalProducts = [];
  List<ProductModel> _currentProducts = [];
  ProductFilter? _currentFilter;
  bool _isSearchActive = false;
  ProductFilterType _currentFilterType = ProductFilterType.none;
  String? _currentCategoryId;
  String? _currentSearchQuery;
  String? _currentBrandId;

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
    on<ClearSearchEvent>(_onClearSearch);
    on<FetchProductsByBrandEvent>(_onFetchProductsByBrand);

    // on<FetchProductsByCategoryEvent>(_onFetchProductsByCategory);
  }

  Future<void> _onSearchProducts(
      SearchProductsEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoadingState());
      _currentSearchQuery = event.query;
      _isSearchActive = true;

      final searchResults = await _productRepository.searchProducts(
        event.query,
        categoryId: _currentFilterType == ProductFilterType.category
            ? _currentCategoryId
            : null,
      );

      _currentProducts = searchResults;
      emit(ProductLoadedState(
        products: searchResults,
        filter: _currentFilter,
        isSearchActive: true,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchProductsByBrand(
      FetchProductsByBrandEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoadingState());
      _currentFilterType = ProductFilterType.brand;
      _currentBrandId = event.brandId;
      _currentCategoryId = null;
      _isSearchActive = false;
      _currentSearchQuery = null;

      final products =
          await _productRepository.fetchProductsByBrand(event.brandId);
      _originalProducts = products;
      _currentProducts = products;

      emit(ProductLoadedState(
        products: products,
        filter: _currentFilter,
        isSearchActive: false,
      ));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onClearSearch(
      ClearSearchEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoadingState());
      _currentSearchQuery = null;
      _isSearchActive = false;

      List<ProductModel> products = [];
      switch (_currentFilterType) {
        case ProductFilterType.category:
          if (_currentCategoryId != null) {
            products = await _productRepository
                .fetchProductsByCategory(_currentCategoryId!);
          }
          break;
        case ProductFilterType.none:
          products = await _productRepository.fetchProducts();
          break;
        case ProductFilterType.brand:
          // TODO: Handle this case.
          throw UnimplementedError();
      }

      _currentProducts = products;
      _originalProducts = products;

      emit(ProductLoadedState(
        products: products,
        filter: _currentFilter,
        isSearchActive: false,
      ));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onSortProducts(
      SortProductsEvent event, Emitter<ProductState> emit) async {
    try {
      final sortedProducts = await _productRepository.sortProducts(
        products: event.products,
        sortOption: event.sortOption,
      );

      emit(ProductLoadedState(
        products: sortedProducts,
        filter: _currentFilter,
        isSearchActive: _isSearchActive,
        searchQuery: _currentSearchQuery,
      ));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onInitializeFilters(
      InitializeFiltersEvent event, Emitter<ProductState> emit) async {
    try {
      if (_originalProducts.isEmpty) {
        switch (_currentFilterType) {
          case ProductFilterType.category:
            if (_currentCategoryId != null) {
              _originalProducts = await _productRepository
                  .fetchProductsByCategory(_currentCategoryId!);
            }
            break;
          case ProductFilterType.none:
            _originalProducts = await _productRepository.fetchProducts();
            break;
          case ProductFilterType.brand:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      }

      _currentFilter =
          await _productRepository.getInitialFilter(_originalProducts);
      emit(ProductLoadedState(
        products: _originalProducts,
        filter: _currentFilter,
        isSearchActive: _isSearchActive,
        searchQuery: _currentSearchQuery,
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
        isSearchActive: _isSearchActive,
        searchQuery: _currentSearchQuery,
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
        isSearchActive: _isSearchActive,
        searchQuery: _currentSearchQuery,
      ));
    }
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoadingState());
      _currentFilterType = ProductFilterType.none;
      _currentCategoryId = null;
      _isSearchActive = false;
      _currentSearchQuery = null;

      final products = await _productRepository.fetchProducts();
      _originalProducts = products;
      _currentProducts = products;

      emit(ProductLoadedState(
        products: products,
        filter: _currentFilter,
        isSearchActive: false,
      ));
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
        isSearchActive: _isSearchActive,
        searchQuery: _currentSearchQuery,
      ));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchProductsByCategory(
      FetchProductsByCategoryEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoadingState());
      _currentFilterType = ProductFilterType.category;
      _currentCategoryId = event.categoryId;
      _isSearchActive = false;
      _currentSearchQuery = null;

      final products =
          await _productRepository.fetchProductsByCategory(event.categoryId);
      _originalProducts = products;
      _currentProducts = products;

      emit(ProductLoadedState(
        products: products,
        filter: _currentFilter,
        isSearchActive: false,
      ));
    } catch (e) {
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onVisualSearch(
      VisualSearchEvent event, Emitter<ProductState> emit) async {
    try {
      emit(VisualSearchLoadingState());
      final products = await _productRepository.searchByImage(event.image);
      emit(VisualSearchLoadedState(products: products));
    } catch (e) {
      emit(VisualSearchErrorState(errorMessage: e.toString()));
    }
  }
}
