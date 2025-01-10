// home/bloc/home_state.dart
import 'package:vesture_firebase_user/models/brand_model.dart';
import 'package:vesture_firebase_user/models/category_model.dart';
import 'package:vesture_firebase_user/models/coupon_model.dart';
import 'package:vesture_firebase_user/models/offer_model.dart';
import 'package:vesture_firebase_user/models/product_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

class HomeLoaded extends HomeState {
  final List<CategoryModel> categories;
  final Map<String, ProductModel> categoryProducts;
  final List<OfferModel> activeOffers;
  final Map<String, ProductModel> offerProducts;
  final List<CouponModel> activeCoupons;
  final List<BrandModel> brands;
  final Map<String, List<CategoryModel>> couponCategories;
  final Map<String, Map<String, List<String>>> couponCategoryImages;

  HomeLoaded({
    required this.categories,
    required this.categoryProducts,
    required this.activeOffers,
    required this.offerProducts,
    required this.activeCoupons,
    this.brands = const [],
    this.couponCategories = const {},
    this.couponCategoryImages = const {},
  });

  HomeLoaded copyWith({
    List<CategoryModel>? categories,
    Map<String, ProductModel>? categoryProducts,
    List<OfferModel>? activeOffers,
    Map<String, ProductModel>? offerProducts,
    List<CouponModel>? activeCoupons,
    List<BrandModel>? brands,
    Map<String, List<CategoryModel>>? couponCategories,
    Map<String, Map<String, List<String>>>? couponCategoryImages,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      categoryProducts: categoryProducts ?? this.categoryProducts,
      activeOffers: activeOffers ?? this.activeOffers,
      offerProducts: offerProducts ?? this.offerProducts,
      activeCoupons: activeCoupons ?? this.activeCoupons,
      brands: brands ?? this.brands,
      couponCategories: couponCategories ?? this.couponCategories,
      couponCategoryImages: couponCategoryImages ?? this.couponCategoryImages,
    );
  }
}
