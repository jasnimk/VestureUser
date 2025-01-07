import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vesture_firebase_user/models/brand_model.dart';
import '../models/category_model.dart';
import '../models/offer_model.dart';
import '../models/coupon_model.dart';
import '../models/product_model.dart';

class HomeRepository {
  final FirebaseFirestore _firestore;

  HomeRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<CategoryModel>> getParentCategories() {
    return _firestore
        .collection('categories')
        .where('parentCategoryId', isNull: true)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromFirestore(doc))
            .toList());
  }

  Future<List<ProductModel>> getRandomProductsForCategory(
      String categoryId) async {
    final productsSnapshot = await _firestore
        .collection('products')
        .where('parentCategoryId', isEqualTo: categoryId)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    List<ProductModel> products = [];

    for (var productDoc in productsSnapshot.docs) {
      final productData = productDoc.data();

      // Get variants with images
      final variantsSnapshot = await _firestore
          .collection('variants')
          .where('productId', isEqualTo: productDoc.id)
          .get();

      List<Variant> variants = [];
      for (var variantDoc in variantsSnapshot.docs) {
        final variantData = variantDoc.data();

        // Get size stocks for this variant
        final sizeStocksSnapshot = await _firestore
            .collection('sizes_and_stocks')
            .where('variantId', isEqualTo: variantDoc.id)
            .get();

        List<SizeStockModel> sizeStocks = sizeStocksSnapshot.docs
            .map((doc) => SizeStockModel.fromMap(doc.data(), doc.id))
            .toList();

        if (variantData['imageUrls'] != null) {
          variants.add(Variant.fromMap(variantData, variantDoc.id, sizeStocks));
        }
      }

      if (variants.isEmpty) continue;

      // Get brand name
      String? brandName;
      final brandId = productData['brandId'] as String?;
      if (brandId != null) {
        final brandDoc =
            await _firestore.collection('brands').doc(brandId).get();
        final brandData = brandDoc.data();
        if (brandData != null) {
          brandName = brandData['name'] as String?;
        }
      }

      // Calculate category offer
      double offer = await ProductModel.calculateCategoryOffer(
          _firestore,
          productData['parentCategoryId'] as String?,
          productData['subCategoryId'] as String?);

      products.add(
          ProductModel.fromFirestore(productDoc, variants, brandName, offer));
    }

    return products;
  }

  Future<ProductModel?> getRandomProductForOffer(OfferModel offer) async {
    QuerySnapshot querySnapshot;

    if (offer.productId != null) {
      querySnapshot = await _firestore
          .collection('products')
          .where(FieldPath.documentId, isEqualTo: offer.productId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();
    } else if (offer.subCategoryId != null) {
      querySnapshot = await _firestore
          .collection('products')
          .where('subCategoryId', isEqualTo: offer.subCategoryId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection('products')
          .where('parentCategoryId', isEqualTo: offer.parentCategoryId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();
    }

    if (querySnapshot.docs.isEmpty) return null;

    final productDoc = querySnapshot.docs.first;
    final productData = productDoc.data() as Map<String, dynamic>;

    // Get variants with images
    final variantsSnapshot = await _firestore
        .collection('variants')
        .where('productId', isEqualTo: productDoc.id)
        .get();

    List<Variant> variants = [];
    for (var variantDoc in variantsSnapshot.docs) {
      final variantData = variantDoc.data();

      final sizeStocksSnapshot = await _firestore
          .collection('sizes_and_stocks')
          .where('variantId', isEqualTo: variantDoc.id)
          .get();

      List<SizeStockModel> sizeStocks = sizeStocksSnapshot.docs
          .map((doc) => SizeStockModel.fromMap(doc.data(), doc.id))
          .toList();

      if (variantData['imageUrls'] != null) {
        variants.add(Variant.fromMap(variantData, variantDoc.id, sizeStocks));
      }
    }

    if (variants.isEmpty) return null;

    String? brandName;
    final brandId = productData['brandId'] as String?;
    if (brandId != null) {
      final brandDoc = await _firestore.collection('brands').doc(brandId).get();
      final brandData = brandDoc.data();
      if (brandData != null) {
        brandName = brandData['name'] as String?;
      }
    }

    return ProductModel.fromFirestore(
        productDoc, variants, brandName, offer.discount);
  }

  Stream<List<OfferModel>> getActiveOffers() {
    return _firestore
        .collection('offers')
        .where('isActive', isEqualTo: true)
        .where('validTo', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => OfferModel.fromFirestore(doc)).toList());
  }

  Stream<List<CouponModel>> getActiveCoupons() {
    return _firestore
        .collection('coupons')
        .where('isActive', isEqualTo: true)
        .where('validTo', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CouponModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<BrandModel>> getActiveBrands() {
    return _firestore
        .collection('brands')
        .orderBy('createdAt', descending: true) // Sort by creation date
        .snapshots()
        .map((snapshot) {
      print('Fetched ${snapshot.docs.length} brands'); // Debug log
      return snapshot.docs.map((doc) {
        final data = doc.data();
        print(
            'Brand data: ${doc.id} - ${data['brandName']} - ${data['brandIcon']?.length ?? 0} bytes'); // Debug log
        return BrandModel.fromFirestore(doc);
      }).toList();
    });
  }

  Future<Map<String, List<String>>> getCouponCategoryImages(
      String couponId) async {
    print('📸 Fetching images for coupon: $couponId');

    final couponDoc =
        await _firestore.collection('coupons').doc(couponId).get();
    final couponData = couponDoc.data();

    print('📄 Coupon data: $couponData');

    if (couponData == null) {
      print('⚠️ No coupon data found');
      return {};
    }

    // Get parent and sub category IDs
    final parentCategoryId = couponData['parentCategoryId'] as String?;
    final subCategoryId = couponData['subCategoryId'] as String?;

    print('🏷️ Parent Category ID: $parentCategoryId');
    print('🏷️ Sub Category ID: $subCategoryId');

    Map<String, List<String>> categoryImages = {};

    // If subCategoryId exists, only use that. Otherwise use parentCategoryId
    final categoryId = subCategoryId ?? parentCategoryId;
    if (categoryId == null) {
      print('⚠️ No valid category ID found');
      return {};
    }

    print('🔍 Searching products for category: $categoryId');

    // Query based on the appropriate category ID
    final productsQuery = subCategoryId != null
        ? _firestore
            .collection('products')
            .where('subCategoryId', isEqualTo: categoryId)
            .where('isActive', isEqualTo: true)
            .limit(1)
        : _firestore
            .collection('products')
            .where('parentCategoryId', isEqualTo: categoryId)
            .where('isActive', isEqualTo: true)
            .limit(1);

    final productsSnapshot = await productsQuery.get();
    print(
        '📦 Found ${productsSnapshot.docs.length} products for category $categoryId');

    for (var productDoc in productsSnapshot.docs) {
      print('🏷️ Processing product: ${productDoc.id}');

      final variantsSnapshot = await _firestore
          .collection('variants')
          .where('productId', isEqualTo: productDoc.id)
          .limit(1)
          .get();

      print(
          '🎨 Found ${variantsSnapshot.docs.length} variants for product ${productDoc.id}');

      for (var variantDoc in variantsSnapshot.docs) {
        final variantData = variantDoc.data();
        print('📄 Variant data: $variantData');

        if (variantData['imageUrls'] != null &&
            variantData['imageUrls'].isNotEmpty) {
          categoryImages[categoryId] =
              List<String>.from(variantData['imageUrls']);
          print(
              '✅ Found images for category $categoryId: ${categoryImages[categoryId]}');
          break;
        } else {
          print('⚠️ No images found in variant ${variantDoc.id}');
        }
      }

      if (categoryImages.containsKey(categoryId)) break;
    }

    print('🎉 Final category images map: $categoryImages');
    return categoryImages;
  }

  Future<List<CategoryModel>> getCouponCategories(String couponId) async {
    final couponDoc =
        await _firestore.collection('coupons').doc(couponId).get();
    final couponData = couponDoc.data();

    if (couponData == null) {
      return [];
    }

    final parentCategoryId = couponData['parentCategoryId'] as String?;
    final subCategoryId = couponData['subCategoryId'] as String?;

    if (subCategoryId != null) {
      // If subCategoryId exists, only get that category
      final categoryDoc =
          await _firestore.collection('categories').doc(subCategoryId).get();
      if (categoryDoc.exists) {
        return [CategoryModel.fromFirestore(categoryDoc)];
      }
    } else if (parentCategoryId != null) {
      // If only parentCategoryId exists, get that category
      final categoryDoc =
          await _firestore.collection('categories').doc(parentCategoryId).get();
      if (categoryDoc.exists) {
        return [CategoryModel.fromFirestore(categoryDoc)];
      }
    }

    return [];
  }
}
