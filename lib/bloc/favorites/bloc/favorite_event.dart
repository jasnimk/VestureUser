import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/models/product_model.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class FetchFavoritesEvent extends FavoriteEvent {}

class CheckFavoriteStatusEvent extends FavoriteEvent {
  final String productId;
  final String variantId;
  final String size;

  const CheckFavoriteStatusEvent({
    required this.productId,
    required this.variantId,
    required this.size,
  });

  @override
  List<Object> get props => [productId, variantId, size];
}

class ToggleFavoriteEvent extends FavoriteEvent {
  final String productId;
  final Variant variant;
  final SizeStockModel sizeStock;
  final BuildContext? context;

  const ToggleFavoriteEvent(
      {required this.productId,
      required this.variant,
      required this.sizeStock,
      this.context});

  @override
  List<Object> get props => [productId, variant, sizeStock];
}

class SortFavoritesEvent extends FavoriteEvent {
  final String sortOption;
  final List<ProductModel> products;

  const SortFavoritesEvent({required this.sortOption, required this.products});

  @override
  List<Object> get props => [sortOption, products];
}

class SearchFavoritesEvent extends FavoriteEvent {
  final String query;
  final List<ProductModel> products;

  SearchFavoritesEvent({
    required this.query,
    required this.products,
  });
}
