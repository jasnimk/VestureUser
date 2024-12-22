import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_event.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_state.dart';
import 'package:vesture_firebase_user/models/favorite_model.dart';
import 'package:vesture_firebase_user/repository/fav_repository.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository _favoriteRepository;

  FavoriteBloc({required FavoriteRepository favoriteRepository})
      : _favoriteRepository = favoriteRepository,
        super(FavoriteInitialState()) {
    on<CheckFavoriteStatusEvent>(_onCheckFavoriteStatus);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<FetchFavoritesEvent>(_onFetchFavorites);

    on<SearchFavoritesEvent>(_onSearchFavorites);
  }

  Future<void> _onSearchFavorites(
      SearchFavoritesEvent event, Emitter<FavoriteState> emit) async {
    try {
      if (event.query.isEmpty) {
        add(FetchFavoritesEvent()); // Reset to all favorites if query is empty
        return;
      }

      emit(FavoriteLoadingState()); // Add loading state
      final searchResults = await _favoriteRepository.searchFavorites(
        event.query,
        event.products,
      );
      emit(FavoritesLoadedState(products: searchResults));
    } catch (e) {
      print('Error searching favorites: $e'); // Add error logging
      emit(FavoriteErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onCheckFavoriteStatus(
      CheckFavoriteStatusEvent event, Emitter<FavoriteState> emit) async {
    try {
      emit(FavoriteLoadingState());

      final isFavorite = await _favoriteRepository.checkFavoriteStatus(
        productId: event.productId,
        variantId: event.variantId,
        size: event.size,
      );

      emit(FavoriteStatusState(isFavorite: isFavorite));
    } catch (e) {
      print('Error checking favorite status: $e');
      emit(FavoriteErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
    try {
      emit(FavoriteLoadingState());

      final favorite = Favorite(
        productId: event.productId,
        variantId: event.variant.id,
        size: event.sizeStock.size,
        variant: event.variant,
        price: event.sizeStock.baseprice,
      );

      await _favoriteRepository.toggleFavorite(favorite: favorite);

      final isFavorite = await _favoriteRepository.checkFavoriteStatus(
        productId: event.productId,
        variantId: event.variant.id,
        size: event.sizeStock.size,
      );

      emit(FavoriteStatusState(isFavorite: isFavorite));
    } catch (e) {
      print('Favorite Toggle Error: $e');
      emit(FavoriteErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchFavorites(
      FetchFavoritesEvent event, Emitter<FavoriteState> emit) async {
    try {
      emit(FavoriteLoadingState());

      final favoriteProducts = await _favoriteRepository.fetchFavorites();

      emit(FavoritesLoadedState(products: favoriteProducts));
    } catch (e) {
      print('Error fetching favorites: $e');
      emit(FavoriteErrorState(errorMessage: e.toString()));
    }
  }
}
