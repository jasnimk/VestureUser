import 'package:vesture_firebase_user/models/category_model.dart';

abstract class CategoryState {}

class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  final List<CategoryModel> categories;
  CategoryLoadedState({required this.categories});
}

class CategoryErrorState extends CategoryState {
  final String errorMessage;
  CategoryErrorState({required this.errorMessage});
}

class CategorySearchState extends CategoryState {
  final List<CategoryModel> searchResults;
  CategorySearchState({required this.searchResults});
}
