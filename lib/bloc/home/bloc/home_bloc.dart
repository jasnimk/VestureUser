// home_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:vesture_firebase_user/models/category_model.dart';
import 'package:vesture_firebase_user/models/product_model.dart';
import 'package:vesture_firebase_user/repository/home_repo.dart';
import './home_event.dart';
import './home_state.dart';

// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   final HomeRepository repository;

//   HomeBloc({required this.repository}) : super(HomeInitial()) {
//     on<LoadHomeData>(_onLoadHomeData);
//     on<RefreshHomeData>(_onRefreshHomeData);
//     on<CopyCouponCode>(_onCopyCouponCode);
//   }

//   Future<void> _onLoadHomeData(
//       LoadHomeData event, Emitter<HomeState> emit) async {
//     try {
//       emit(HomeLoading());

//       // Load categories and their random products
//       final categories = await repository.getParentCategories().first;
//       Map<String, ProductModel> categoryProducts = {};

//       for (var category in categories) {
//         if (category.id != null) {
//           final products =
//               await repository.getRandomProductsForCategory(category.id!);
//           if (products.isNotEmpty) {
//             categoryProducts[category.id!] = products.first;
//           }
//         }
//       }

//       // Load active offers and their products
//       final activeOffers = await repository.getActiveOffers().first;
//       Map<String, ProductModel> offerProducts = {};

//       for (var offer in activeOffers) {
//         if (offer.id != null) {
//           final product = await repository.getRandomProductForOffer(offer);
//           if (product != null) {
//             offerProducts[offer.id!] = product;
//           }
//         }
//       }

//       // Load active coupons
//       final activeCoupons = await repository.getActiveCoupons().first;

//       emit(HomeLoaded(
//         categories: categories,
//         categoryProducts: categoryProducts,
//         activeOffers: activeOffers,
//         offerProducts: offerProducts,
//         activeCoupons: activeCoupons,
//       ));
//     } catch (e) {
//       emit(HomeError(e.toString()));
//     }
//   }

//   Future<void> _onRefreshHomeData(
//       RefreshHomeData event, Emitter<HomeState> emit) async {
//     try {
//       if (state is HomeLoaded) {
//         final currentState = state as HomeLoaded;
//         emit(HomeLoaded(
//           categories: currentState.categories,
//           categoryProducts: currentState.categoryProducts,
//           activeOffers: currentState.activeOffers,
//           offerProducts: currentState.offerProducts,
//           activeCoupons: currentState.activeCoupons,
//         ));
//       }
//       add(LoadHomeData());
//     } catch (e) {
//       emit(HomeError(e.toString()));
//     }
//   }

//   Future<void> _onCopyCouponCode(
//       CopyCouponCode event, Emitter<HomeState> emit) async {
//     await Clipboard.setData(ClipboardData(text: event.couponCode));
//   }
// }
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<CopyCouponCode>(_onCopyCouponCode);
  }

  // Future<void> _onLoadHomeData(
  //     LoadHomeData event, Emitter<HomeState> emit) async {
  //   try {
  //     emit(HomeLoading());

  //     // Load categories and their random products
  //     final categories = await repository.getParentCategories().first;
  //     Map<String, ProductModel> categoryProducts = {};

  //     for (var category in categories) {
  //       if (category.id != null) {
  //         final products =
  //             await repository.getRandomProductsForCategory(category.id!);
  //         if (products.isNotEmpty) {
  //           categoryProducts[category.id!] = products.first;
  //         }
  //       }
  //     }

  //     // Load active offers and their products
  //     final activeOffers = await repository.getActiveOffers().first;
  //     Map<String, ProductModel> offerProducts = {};

  //     for (var offer in activeOffers) {
  //       if (offer.id != null) {
  //         final product = await repository.getRandomProductForOffer(offer);
  //         if (product != null) {
  //           offerProducts[offer.id!] = product;
  //         }
  //       }
  //     }

  //     // Load active coupons
  //     final activeCoupons = await repository.getActiveCoupons().first;

  //     // Load brands
  //     final brands = await repository.getActiveBrands().first;

  //     // Load coupon categories
  //     Map<String, List<CategoryModel>> couponCategories = {};
  //     for (var coupon in activeCoupons) {
  //       if (coupon.id != null) {
  //         final categories = await repository.getCouponCategories(coupon.id!);
  //         couponCategories[coupon.id!] = categories;
  //       }
  //     }

  //     emit(HomeLoaded(
  //       categories: categories,
  //       categoryProducts: categoryProducts,
  //       activeOffers: activeOffers,
  //       offerProducts: offerProducts,
  //       activeCoupons: activeCoupons,
  //       brands: brands,
  //       couponCategories: couponCategories,
  //     ));
  //   } catch (e) {
  //     emit(HomeError(e.toString()));
  //   }
  // }

  Future<void> _onLoadHomeData(
      LoadHomeData event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoading());

      // Load categories and their random products
      final categories = await repository.getParentCategories().first;
      Map<String, ProductModel> categoryProducts = {};

      for (var category in categories) {
        if (category.id != null) {
          final products =
              await repository.getRandomProductsForCategory(category.id!);
          if (products.isNotEmpty) {
            categoryProducts[category.id!] = products.first;
          }
        }
      }

      // Load active offers and their products
      final activeOffers = await repository.getActiveOffers().first;
      Map<String, ProductModel> offerProducts = {};

      for (var offer in activeOffers) {
        if (offer.id != null) {
          final product = await repository.getRandomProductForOffer(offer);
          if (product != null) {
            offerProducts[offer.id!] = product;
          }
        }
      }

      // Load active coupons
      final activeCoupons = await repository.getActiveCoupons().first;

      final brands = await repository.getActiveBrands().first;

      Map<String, List<CategoryModel>> couponCategories = {};
      Map<String, Map<String, List<String>>> couponCategoryImages = {};

      for (var coupon in activeCoupons) {
        if (coupon.id != null) {
          final categories = await repository.getCouponCategories(coupon.id!);
          couponCategories[coupon.id!] = categories;

          final images = await repository.getCouponCategoryImages(coupon.id!);
          couponCategoryImages[coupon.id!] = images;
        }
      }

      emit(HomeLoaded(
        categories: categories,
        categoryProducts: categoryProducts,
        activeOffers: activeOffers,
        offerProducts: offerProducts,
        activeCoupons: activeCoupons,
        brands: brands,
        couponCategories: couponCategories,
        couponCategoryImages: couponCategoryImages,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshHomeData(
      RefreshHomeData event, Emitter<HomeState> emit) async {
    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        // Preserve current state while refreshing
        emit(currentState);
      }
      add(LoadHomeData());
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onCopyCouponCode(
      CopyCouponCode event, Emitter<HomeState> emit) async {
    await Clipboard.setData(ClipboardData(text: event.couponCode));
  }
}
