import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/categories_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/categories_state.dart';
import 'package:vesture_firebase_user/models/category_model.dart';

import 'package:vesture_firebase_user/repository/category_repo.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  List<CategoryModel> _allCategories = [];

  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CategoryInitialState()) {
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<SearchCategoriesEvent>(_onSearchCategories);
  }

  @override
  void onTransition(Transition<CategoryEvent, CategoryState> transition) {
    super.onTransition(transition);
  }

  Future<void> _onFetchCategories(
      FetchCategoriesEvent event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoadingState());

      _allCategories = await _categoryRepository.fetchCategories();

      // _allCategories.forEach((category) {

      // });

      emit(CategoryLoadedState(categories: _allCategories));
    } catch (e) {
      emit(CategoryErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onSearchCategories(
      SearchCategoriesEvent event, Emitter<CategoryState> emit) async {
    try {
      if (_allCategories.isEmpty) {
        await _onFetchCategories(FetchCategoriesEvent(), emit);
      }

      final query = event.query.toLowerCase().trim();

      final searchResults = await _categoryRepository.searchCategories(query);

      if (searchResults.isEmpty) {
        emit(CategoryLoadedState(categories: _allCategories));
      } else {
        emit(CategorySearchState(searchResults: searchResults));
      }
    } catch (e) {
      emit(CategoryErrorState(errorMessage: e.toString()));
    }
  }
}
