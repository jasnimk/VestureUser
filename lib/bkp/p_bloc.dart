// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:vesture_firebase_user/models/category_model.dart';
// import 'package:vesture_firebase_user/models/product_model.dart';
// import 'product_event.dart';
// import 'product_state.dart';

// class ProductBloc extends Bloc<ProductEvent, ProductState> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   ProductBloc() : super(ProductInitialState()) {
//     on<FetchProductsEvent>(_onFetchProducts);
//     on<FetchProductsByCategoryEvent>(_onFetchProductsByCategory);
//     on<FetchCategoriesEvent>(_onFetchCategories);
//     on<SearchProductsEvent>(_onSearchProducts);
//   }

//   Future<void> _onFetchCategories(
//       FetchCategoriesEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(ProductLoadingState());

//       final categorySnapshot = await _firestore.collection('categories').get();
//       List<CategoryModel> categories = categorySnapshot.docs
//           .map((doc) => CategoryModel.fromFirestore(doc))
//           .toList();

//       emit(ProductCategoriesLoadedState(categories: categories));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onFetchProducts(
//       FetchProductsEvent event, Emitter<ProductState> emit) async {
//     try {
//       emit(ProductLoadingState());
//       final categoriesSnapshot = await _firestore
//           .collection('categories')
//           .where('isActive', isEqualTo: true)
//           .get();

//       // Get IDs of active categories
//       final activeParentCategoryIds = categoriesSnapshot.docs
//           .where((doc) => doc.data()['parentCategoryId'] == null)
//           .map((doc) => doc.id)
//           .toList();

//       final activeSubCategoryIds = categoriesSnapshot.docs
//           .where((doc) => doc.data()['parentCategoryId'] != null)
//           .map((doc) => doc.id)
//           .toList();

//       final productsStream = _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .where('parentCategoryId',
//               whereIn: activeParentCategoryIds + activeSubCategoryIds)
//           .snapshots();
//       await for (var snapshot in productsStream) {
//         List<ProductModel> products = [];

//         for (var productDoc in snapshot.docs) {
//           final variantsSnapshot = await _firestore
//               .collection('variants')
//               .where('productId', isEqualTo: productDoc.id)
//               .get();

//           List<Variant> variants = [];
//           for (var variantDoc in variantsSnapshot.docs) {
//             final sizeStocksSnapshot = await _firestore
//                 .collection('sizes_and_stocks')
//                 .where('variantId', isEqualTo: variantDoc.id)
//                 .get();

//             List<SizeStockModel> sizeStocks = sizeStocksSnapshot.docs
//                 .map((doc) => SizeStockModel.fromMap(doc.data(), doc.id))
//                 .toList();

//             variants.add(
//                 Variant.fromMap(variantDoc.data(), variantDoc.id, sizeStocks));
//           }

//           String? brandName;
//           final brandDoc = await _firestore
//               .collection('brands')
//               .doc(productDoc.data()['brandId'])
//               .get();

//           brandName = brandDoc.data()?['name'] ??
//               brandDoc.data()?['brandName'] ??
//               brandDoc.data()?['title'] ??
//               'Unknown Brand';

//           final product =
//               ProductModel.fromFirestore(productDoc, variants, brandName);

//           products.add(product);
//         }

//         emit(ProductLoadedState(products: products));
//       }
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onFetchProductsByCategory(
//     FetchProductsByCategoryEvent event,
//     Emitter<ProductState> emit,
//   ) async {
//     try {
//       emit(ProductLoadingState());

//       final querySnapshotParentCategory = await _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .where('parentCategoryId', isEqualTo: event.categoryId)
//           .get();

//       final querySnapshotSubCategory = await _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .where('subCategoryId', isEqualTo: event.categoryId)
//           .get();

//       final combinedResults = [
//         ...querySnapshotParentCategory.docs,
//         ...querySnapshotSubCategory.docs,
//       ];

//       print('Fetched products: ${combinedResults.length}');
//       print('Fetching products for category ID: ${event.categoryId}');

//       List<ProductModel> products = [];

//       for (var doc in combinedResults) {
//         final variantsSnapshot = await _firestore
//             .collection('variants')
//             .where('productId', isEqualTo: doc.id)
//             .get();

//         List<Variant> variants = [];
//         for (var variantDoc in variantsSnapshot.docs) {
//           final sizeStocksSnapshot = await _firestore
//               .collection('sizes_and_stocks')
//               .where('variantId', isEqualTo: variantDoc.id)
//               .get();

//           List<SizeStockModel> sizeStocks = sizeStocksSnapshot.docs
//               .map((doc) => SizeStockModel.fromMap(doc.data(), doc.id))
//               .toList();

//           variants.add(
//               Variant.fromMap(variantDoc.data(), variantDoc.id, sizeStocks));
//         }

//         String? brandName;
//         if (doc.data()['brandId'] != null) {
//           try {
//             final brandDoc = await _firestore
//                 .collection('brands')
//                 .doc(doc.data()['brandId'])
//                 .get();

//             brandName = brandDoc.data()?['name'] ?? 'Unknown Brand';
//           } catch (e) {
//             print('Error fetching brand: $e');
//             brandName = 'Unknown Brand';
//           }
//         }

//         final product = ProductModel.fromFirestore(doc, variants, brandName);
//         products.add(product);
//       }

//       emit(ProductLoadedState(products: products));
//     } catch (e) {
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> _onSearchProducts(
//       SearchProductsEvent event, Emitter emit) async {
//     try {
//       print('Search Event Received: ${event.query}');
//       emit(ProductLoadingState());
//       final searchQuery = event.query.toLowerCase().trim();
//       print('Normalized Search Query: $searchQuery');
//       String lowerCaseSearchQuery = searchQuery.toLowerCase();
//       // Initial search with exact match on searchKeywords
//       var querySnapshot = await FirebaseFirestore.instance
//           .collection('products')
//           .where('searchKeywords', arrayContains: lowerCaseSearchQuery)
//           .where('isActive', isEqualTo: true)
//           .get();

//       print('Query Snapshot Length: ${querySnapshot.docs.length}');
//       querySnapshot.docs.forEach((doc) {
//         print('Found product: ${doc.data()}');
//       });
//       if (querySnapshot.docs.isEmpty) {
//         print('No products found for the search query: $searchQuery');
//       }
//       // If no exact matches, perform a more comprehensive search
//       if (querySnapshot.docs.isEmpty) {
//         // Fetch all active products
//         querySnapshot = await _firestore
//             .collection('products')
//             .where('isActive', isEqualTo: true)
//             .get();

//         final filteredDocs = querySnapshot.docs.where((doc) {
//           final data = doc.data();

//           final searchKeywords = (data['searchKeywords'] as List?)
//                   ?.map((k) => k.toString().toLowerCase()) ??
//               [];
//           if (searchKeywords.any((keyword) => keyword.contains(searchQuery))) {
//             return true;
//           }

//           return (data['productName'] as String?)
//                       ?.toLowerCase()
//                       .contains(searchQuery) ==
//                   true ||
//               (data['description'] as String?)
//                       ?.toLowerCase()
//                       .contains(searchQuery) ==
//                   true;
//         }).toList();

//         List<ProductModel> products = [];
//         for (var doc in filteredDocs) {
//           final variantsSnapshot = await _firestore
//               .collection('variants')
//               .where('productId', isEqualTo: doc.id)
//               .get();

//           List<Variant> variants =
//               await _fetchVariantsWithSizeStocks(variantsSnapshot);
//           String? brandName = await _fetchBrandName(doc);
//           final product = ProductModel.fromFirestore(doc, variants, brandName);
//           products.add(product);
//         }

//         emit(ProductLoadedState(products: products));
//         return;
//       }

//       List<ProductModel> products = [];
//       for (var doc in querySnapshot.docs) {
//         final variantsSnapshot = await _firestore
//             .collection('variants')
//             .where('productId', isEqualTo: doc.id)
//             .get();

//         List<Variant> variants =
//             await _fetchVariantsWithSizeStocks(variantsSnapshot);
//         String? brandName = await _fetchBrandName(doc);
//         final product = ProductModel.fromFirestore(doc, variants, brandName);
//         products.add(product);
//       }

//       emit(ProductLoadedState(products: products));
//     } catch (e) {
//       print('Search Error: $e');
//       emit(ProductErrorState(errorMessage: e.toString()));
//     }
//   }

//   Future<List<Variant>> _fetchVariantsWithSizeStocks(
//       QuerySnapshot variantsSnapshot) async {
//     List<Variant> variants = [];
//     for (var variantDoc in variantsSnapshot.docs) {
//       final sizeStocksSnapshot = await _firestore
//           .collection('sizes_and_stocks')
//           .where('variantId', isEqualTo: variantDoc.id)
//           .get();

//       List<SizeStockModel> sizeStocks = sizeStocksSnapshot.docs
//           .map((doc) => SizeStockModel.fromMap(doc.data(), doc.id))
//           .toList();

//       variants.add(
//         Variant.fromMap(variantDoc.data() as Map<String, dynamic>,
//             variantDoc.id, sizeStocks),
//       );
//     }
//     return variants;
//   }

//   Future<String?> _fetchBrandName(DocumentSnapshot doc) async {
//     final docData = doc.data() as Map<String, dynamic>?;
//     String? brandName;

//     if (docData?['brandId'] != null) {
//       try {
//         final brandDoc = await _firestore
//             .collection('brands')
//             .doc(docData!['brandId'])
//             .get();

//         brandName = brandDoc.data()?['name'] ??
//             brandDoc.data()?['brandName'] ??
//             'Unknown Brand';
//       } catch (e) {
//         print('Error fetching brand: $e');
//         brandName = 'Unknown Brand';
//       }
//     }

//     return brandName;
//   }

//   Future<List<QueryDocumentSnapshot>> _performBroaderSearch(
//       String query) async {
//     final additionalSearchSnapshot = await _firestore
//         .collection('products')
//         .where('isActive', isEqualTo: true)
//         .get();

//     return additionalSearchSnapshot.docs.where((doc) {
//       final data = doc.data() as Map<String, dynamic>?;
//       return _matchesSearch(data, query);
//     }).toList();
//   }

//   bool _matchesSearch(Map<String, dynamic>? data, String query) {
//     if (data == null) return false;
//     return (data['productName'] as String?)?.toLowerCase().contains(query) ==
//             true ||
//         (data['description'] as String?)?.toLowerCase().contains(query) ==
//             true ||
//         (data['brandName'] as String?)?.toLowerCase().contains(query) == true;
//   }
// }
