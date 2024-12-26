import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vesture_firebase_user/models/favorite_model.dart';
import 'package:vesture_firebase_user/models/product_model.dart';

class FavoriteRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FavoriteRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<bool> checkFavoriteStatus({
    required String productId,
    required String variantId,
    required String size,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final favoriteDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .where('productId', isEqualTo: productId)
        .where('variantId', isEqualTo: variantId)
        .where('size', isEqualTo: size)
        .get();

    return favoriteDoc.docs.isNotEmpty;
  }

  Future<void> toggleFavorite({
    required Favorite favorite,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favoriteCollection =
        _firestore.collection('users').doc(user.uid).collection('favorites');

    final favoriteQuery = await favoriteCollection
        .where('productId', isEqualTo: favorite.productId)
        .where('variantId', isEqualTo: favorite.variantId)
        .where('size', isEqualTo: favorite.size)
        .get();

    if (favoriteQuery.docs.isNotEmpty) {
      await favoriteQuery.docs.first.reference.delete();
    } else {
      await favoriteCollection.add(favorite.toFirestore());
    }
  }

  Future<List<ProductModel>> fetchFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final favoritesQuery = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    final favorites =
        favoritesQuery.docs.map((doc) => Favorite.fromFirestore(doc)).toList();

    final uniqueProductIds = favorites.map((f) => f.productId).toSet();

    List<ProductModel> favoriteProducts = [];

    for (final productId in uniqueProductIds) {
      try {
        final productDoc =
            await _firestore.collection('products').doc(productId).get();

        if (!productDoc.exists) {
          continue;
        }

        final productData = productDoc.data()!;

        final categoryOffer = await ProductModel.calculateCategoryOffer(
          _firestore,
          productData['parentCategoryId'] as String?,
          productData['subCategoryId'] as String?,
        );

        final variantsSnapshot = await _firestore
            .collection('variants')
            .where('productId', isEqualTo: productId)
            .get();

        List<Variant> variants = [];
        for (var variantDoc in variantsSnapshot.docs) {
          final sizeStocksSnapshot = await _firestore
              .collection('sizes_and_stocks')
              .where('variantId', isEqualTo: variantDoc.id)
              .get();

          final sizeStocks = sizeStocksSnapshot.docs
              .map((doc) => SizeStockModel.fromMap(doc.data(), doc.id))
              .toList();

          variants.add(
              Variant.fromMap(variantDoc.data(), variantDoc.id, sizeStocks));
        }

        String? brandName;
        final brandDoc = await _firestore
            .collection('brands')
            .doc(productDoc.data()?['brandId'])
            .get();

        brandName = brandDoc.data()?['name'] ??
            brandDoc.data()?['brandName'] ??
            brandDoc.data()?['title'] ??
            'Unknown Brand';

        final product = ProductModel.fromFirestore(
          productDoc,
          variants,
          brandName,
          categoryOffer,
        );
        favoriteProducts.add(product);
      } catch (productFetchError) {
        rethrow;
      }
    }

    return favoriteProducts;
  }

  Future<List<ProductModel>> searchFavorites(
      String query, List<ProductModel> products) async {
    if (query.isEmpty) return products;

    final searchQuery = query.toLowerCase().trim();
    return products.where((product) {
      final productName = product.productName.toLowerCase();
      final brandName = (product.brandName ?? '').toLowerCase();
      final description = (product.description).toLowerCase();

      return productName.contains(searchQuery) ||
          brandName.contains(searchQuery) ||
          description.contains(searchQuery);
    }).toList();
  }
}
