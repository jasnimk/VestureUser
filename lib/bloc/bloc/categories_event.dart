abstract class CategoryEvent {}

class FetchCategoriesEvent extends CategoryEvent {}

class SelectCategoryEvent extends CategoryEvent {
  final String categoryId;
  SelectCategoryEvent({required this.categoryId});
}

class SearchCategoriesEvent extends CategoryEvent {
  final String query;
  SearchCategoriesEvent({required this.query});
}
