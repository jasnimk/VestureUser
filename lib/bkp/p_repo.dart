// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:vesture_firebase_user/models/product_model.dart';

// class ProductRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Fetch products
//   Future<List<ProductModel>> fetchProducts() async {
//     try {
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

//       final productsSnapshot = await _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .where('parentCategoryId',
//               whereIn: activeParentCategoryIds + activeSubCategoryIds)
//           .get();

//       List<ProductModel> products = [];

//       for (var productDoc in productsSnapshot.docs) {
//         final variants = await _fetchVariantsWithSizeStocks(productDoc.id);
//         final brandName = await _fetchBrandName(productDoc);

//         final product =
//             ProductModel.fromFirestore(productDoc, variants, brandName);
//         products.add(product);
//       }

//       return products;
//     } catch (e) {
//       print('Error Fetching Products: $e');
//       rethrow;
//     }
//   }

//   // Fetch products by category
//   Future<List<ProductModel>> fetchProductsByCategory(String categoryId) async {
//     try {
//       final querySnapshotParentCategory = await _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .where('parentCategoryId', isEqualTo: categoryId)
//           .get();

//       final querySnapshotSubCategory = await _firestore
//           .collection('products')
//           .where('isActive', isEqualTo: true)
//           .where('subCategoryId', isEqualTo: categoryId)
//           .get();

//       final combinedResults = [
//         ...querySnapshotParentCategory.docs,
//         ...querySnapshotSubCategory.docs,
//       ];

//       List<ProductModel> products = [];

//       for (var doc in combinedResults) {
//         final variants = await _fetchVariantsWithSizeStocks(doc.id);
//         final brandName = await _fetchBrandName(doc);

//         final product = ProductModel.fromFirestore(doc, variants, brandName);
//         products.add(product);
//       }

//       return products;
//     } catch (e) {
//       print('Error Fetching Products by Category: $e');
//       rethrow;
//     }
//   }

//   // Search products
//   Future<List<ProductModel>> searchProducts(String query) async {
//     try {
//       final lowerCaseSearchQuery = query.toLowerCase().trim();

//       var querySnapshot = await _firestore
//           .collection('products')
//           .where('searchKeywords', arrayContains: lowerCaseSearchQuery)
//           .where('isActive', isEqualTo: true)
//           .get();

//       if (querySnapshot.docs.isEmpty) {
//         querySnapshot = await _firestore
//             .collection('products')
//             .where('isActive', isEqualTo: true)
//             .get();

//         var filteredDocs = querySnapshot.docs.where((doc) {
//           final data = doc.data();
//           final searchKeywords = (data['searchKeywords'] as List?)
//                   ?.map((k) => k.toString().toLowerCase()) ??
//               [];

//           return searchKeywords
//                   .any((keyword) => keyword.contains(lowerCaseSearchQuery)) ||
//               (data['productName'] as String?)
//                       ?.toLowerCase()
//                       .contains(lowerCaseSearchQuery) ==
//                   true ||
//               (data['description'] as String?)
//                       ?.toLowerCase()
//                       .contains(lowerCaseSearchQuery) ==
//                   true;
//         }).toList();

//         List<ProductModel> products = [];
//         for (var doc in filteredDocs) {
//           final variants = await _fetchVariantsWithSizeStocks(doc.id);
//           final brandName = await _fetchBrandName(doc);

//           final product = ProductModel.fromFirestore(doc, variants, brandName);
//           products.add(product);
//         }

//         return products;
//       }

//       List<ProductModel> products = [];
//       for (var doc in querySnapshot.docs) {
//         final variants = await _fetchVariantsWithSizeStocks(doc.id);
//         final brandName = await _fetchBrandName(doc);

//         final product = ProductModel.fromFirestore(doc, variants, brandName);
//         products.add(product);
//       }

//       return products;
//     } catch (e) {
//       print('Search Products Error: $e');
//       rethrow;
//     }
//   }

//   Future<List<Variant>> _fetchVariantsWithSizeStocks(String productId) async {
//     try {
//       final variantsSnapshot = await _firestore
//           .collection('variants')
//           .where('productId', isEqualTo: productId)
//           .get();

//       List<Variant> variants = [];
//       for (var variantDoc in variantsSnapshot.docs) {
//         final sizeStocksSnapshot = await _firestore
//             .collection('sizes_and_stocks')
//             .where('variantId', isEqualTo: variantDoc.id)
//             .get();

//         List<SizeStockModel> sizeStocks = sizeStocksSnapshot.docs
//             .map((doc) => SizeStockModel.fromMap(doc.data(), doc.id))
//             .toList();

//         variants.add(
//           Variant.fromMap(
//             variantDoc.data(),
//             variantDoc.id,
//             sizeStocks,
//           ),
//         );
//       }
//       return variants;
//     } catch (e) {
//       print('Error Fetching Variants: $e');
//       rethrow;
//     }
//   }

//   // Fetch brand name for a product
//   Future<String?> _fetchBrandName(DocumentSnapshot doc) async {
//     try {
//       final docData = doc.data() as Map<String, dynamic>?;
//       if (docData?['brandId'] == null) return null;

//       final brandDoc =
//           await _firestore.collection('brands').doc(docData!['brandId']).get();

//       return brandDoc.data()?['name'] ??
//           brandDoc.data()?['brandName'] ??
//           'Unknown Brand';
//     } catch (e) {
//       print('Error Fetching Brand: $e');
//       return 'Unknown Brand';
//     }
//   }
// }