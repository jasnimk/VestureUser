// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:vesture_firebase_user/bloc/bloc/categories_event.dart';
// import 'package:vesture_firebase_user/bloc/bloc/categories_state.dart';
// import 'package:vesture_firebase_user/models/category_model.dart';

// class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<CategoryModel> _allCategories = [];

//   CategoryBloc() : super(CategoryInitialState()) {
//     on<FetchCategoriesEvent>(_onFetchCategories);
//     on<SelectCategoryEvent>(_onSelectCategory);
//     on<SearchCategoriesEvent>(_onSearchCategories);
//   }
//   Future _onSearchCategories(SearchCategoriesEvent event, Emitter emit) async {
//     try {
//       print('Searching for query: ${event.query}');
//       final query = event.query.toLowerCase().trim();

//       if (query.isEmpty) {
//         emit(CategoryLoadedState(categories: _allCategories));
//         return;
//       }

//       final searchResults = _allCategories.where((category) {
//         // More flexible search: check if query is contained anywhere in the name
//         bool matches = category.name.toLowerCase().contains(query);

//         // Optional: Add more search strategies
//         // For example, starts with the query
//         bool startsWithQuery = category.name.toLowerCase().startsWith(query);

//         print(
//             'Checking category: ${category.name}, Contains: $matches, Starts With: $startsWithQuery');

//         return matches || startsWithQuery;
//       }).toList();

//       print('Search results count: ${searchResults.length}');

//       if (searchResults.isEmpty) {
//         // Optionally, you could emit a specific state for no results
//         emit(CategorySearchState(searchResults: []));
//       } else {
//         emit(CategorySearchState(searchResults: searchResults));
//       }
//     } catch (e) {
//       print('Search error: $e');
//       emit(CategoryErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onFetchCategories(
//       FetchCategoriesEvent event, Emitter<CategoryState> emit) async {
//     try {
//       emit(CategoryLoadingState());

//       final querySnapshot = await _firestore
//           .collection('categories')
//           .where('isActive', isEqualTo: true)
//           .get();

//       List<CategoryModel> categories = querySnapshot.docs
//           .map((doc) => CategoryModel.fromFirestore(doc))
//           .toList();

//       emit(CategoryLoadedState(categories: categories));
//     } catch (e) {
//       emit(CategoryErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onSelectCategory(
//       SelectCategoryEvent event, Emitter<CategoryState> emit) async {
//     // Navigate to the product details page with the selected category
//     // Navigator.push(
//     //   event.context,
//     //   MaterialPageRoute(
//     //     builder: (context) => ProductDetailsPage(
//     //       categoryId: event.category.id,
//     //     ),
//     //   ),
//     // );
//   }
// // }
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:vesture_firebase_user/bloc/bloc/categories_event.dart';
// import 'package:vesture_firebase_user/bloc/bloc/categories_state.dart';
// import 'package:vesture_firebase_user/models/category_model.dart';

// class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<CategoryModel> _allCategories = [];

//   CategoryBloc() : super(CategoryInitialState()) {
//     // Register event handlers in the constructor
//     on<FetchCategoriesEvent>(_onFetchCategories);
//     on<SearchCategoriesEvent>(_onSearchCategories);
//   }

//   @override
//   void onTransition(Transition<CategoryEvent, CategoryState> transition) {
//     // Add logging for state transitions
//     print('CategoryBloc Transition: $transition');
//     super.onTransition(transition);
//   }

//   Future<void> _onFetchCategories(
//       FetchCategoriesEvent event, Emitter<CategoryState> emit) async {
//     try {
//       emit(CategoryLoadingState());

//       print('Fetching Categories from Firestore');

//       final querySnapshot = await _firestore
//           .collection('categories')
//           .where('isActive', isEqualTo: true)
//           .get();

//       print('Categories Query Snapshot Size: ${querySnapshot.docs.length}');

//       _allCategories = querySnapshot.docs
//           .map((doc) => CategoryModel.fromFirestore(doc))
//           .toList();

//       print('Loaded Categories Count: ${_allCategories.length}');
//       _allCategories.forEach((category) {
//         print('Category Name: ${category.name}, ID: ${category.id}');
//       });

//       emit(CategoryLoadedState(categories: _allCategories));
//     } catch (e) {
//       print('Error Fetching Categories: $e');
//       emit(CategoryErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onSearchCategories(
//       SearchCategoriesEvent event, Emitter<CategoryState> emit) async {
//     try {
//       // If no categories are loaded, first load them
//       if (_allCategories.isEmpty) {
//         await _onFetchCategories(FetchCategoriesEvent(), emit);
//       }

//       final query = event.query.toLowerCase().trim();
//       print('Debug: Search Query Received - "$query"');
//       print('Debug: Total Categories Before Search - ${_allCategories.length}');

//       if (query.isEmpty) {
//         emit(CategoryLoadedState(categories: _allCategories));
//         return;
//       }

//       final searchResults = _allCategories.where((category) {
//         if (category.name == null) return false;

//         final categoryName = category.name.toLowerCase();

//         return categoryName.contains(query);
//       }).toList();

//       print('Debug: Search Results Count - ${searchResults.length}');

//       if (searchResults.isEmpty) {
//         emit(CategoryLoadedState(categories: _allCategories));
//       } else {
//         emit(CategorySearchState(searchResults: searchResults));
//       }
//     } catch (e) {
//       print('Search Error: $e');
//       emit(CategoryErrorState(errorMessage: e.toString()));
//     }
//   }
// }
