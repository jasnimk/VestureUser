import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/categories_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/categories_state.dart';
import 'package:vesture_firebase_user/models/category_model.dart';

import 'package:vesture_firebase_user/repository/category_repo.dart'; // Add this import

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
    print('CategoryBloc Transition: $transition');
    super.onTransition(transition);
  }

  Future<void> _onFetchCategories(
      FetchCategoriesEvent event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoadingState());

      _allCategories = await _categoryRepository.fetchCategories();

      print('Loaded Categories Count: ${_allCategories.length}');
      _allCategories.forEach((category) {
        print('Category Name: ${category.name}, ID: ${category.id}');
      });

      emit(CategoryLoadedState(categories: _allCategories));
    } catch (e) {
      print('Error Fetching Categories: $e');
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
      print('Debug: Search Query Received - "$query"');
      print('Debug: Total Categories Before Search - ${_allCategories.length}');

      final searchResults = await _categoryRepository.searchCategories(query);

      print('Debug: Search Results Count - ${searchResults.length}');

      if (searchResults.isEmpty) {
        emit(CategoryLoadedState(categories: _allCategories));
      } else {
        emit(CategorySearchState(searchResults: searchResults));
      }
    } catch (e) {
      print('Search Error: $e');
      emit(CategoryErrorState(errorMessage: e.toString()));
    }
  }
}
