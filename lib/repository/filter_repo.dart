import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/models/product_filter.dart';

class FilterRepository {
  final FirebaseFirestore _firestore;

  FilterRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<FilterData> fetchFilterData() async {
    final productsSnapshot = await _firestore
        .collection('sizes_and_stocks')
        .orderBy('baseprice')
        .get();

    double minPrice = double.infinity;
    double maxPrice = 0;

    for (var doc in productsSnapshot.docs) {
      final price = (doc.data()['baseprice'] as num).toDouble();
      if (price < minPrice) minPrice = price;
      if (price > maxPrice) maxPrice = price;
    }

    final variantsSnapshot = await _firestore.collection('variants').get();
    final colors = variantsSnapshot.docs
        .map((doc) => doc.data()['color'] as String)
        .toSet()
        .toList();

    final sizesSnapshot = await _firestore.collection('sizes_and_stocks').get();
    final sizes = sizesSnapshot.docs
        .map((doc) => doc.data()['size'] as String)
        .toSet()
        .toList();

    final categoriesSnapshot = await _firestore
        .collection('categories')
        .where('isActive', isEqualTo: true)
        .get();
    final categories = ['All']..addAll(
        categoriesSnapshot.docs.map((doc) => doc.data()['name'] as String));

    final brandsSnapshot = await _firestore.collection('brands').get();
    final brands = brandsSnapshot.docs
        .map((doc) => doc.data()['brandName'] as String)
        .toList();

    return FilterData(
      priceRange: RangeValues(minPrice, maxPrice),
      colors: colors,
      sizes: sizes,
      categories: categories,
      brands: brands,
    );
  }
}
