import 'package:equatable/equatable.dart';
import 'package:vesture_firebase_user/models/product_model.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitialState extends FavoriteState {}

class FavoriteLoadingState extends FavoriteState {}

class FavoriteStatusState extends FavoriteState {
  final bool isFavorite;

  const FavoriteStatusState({required this.isFavorite});

  @override
  List<Object> get props => [isFavorite];
}

class FavoriteErrorState extends FavoriteState {
  final String errorMessage;

  const FavoriteErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class FavoritesLoadedState extends FavoriteState {
  final List<ProductModel> products;

  const FavoritesLoadedState({required this.products});

  @override
  List<Object> get props => [products];
}
