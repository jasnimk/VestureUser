import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vesture_firebase_user/models/category_model.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoryModel>> searchCategories(String query) async {
    try {
      final categories = await fetchCategories();

      if (query.isEmpty) return categories;

      final searchQuery = query.toLowerCase().trim();
      return categories.where((category) {
        final categoryName = category.name.toLowerCase();
        return categoryName.contains(searchQuery);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      final doc =
          await _firestore.collection('categories').doc(categoryId).get();

      if (doc.exists) {
        return CategoryModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoryModel>> getParentCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .where('parentCategoryId', isNull: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoryModel>> getSubcategoriesByParentId(
      String parentId) async {
    try {
      final querySnapshot = await _firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .where('parentCategoryId', isEqualTo: parentId)
          .get();

      return querySnapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
