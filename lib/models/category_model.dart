import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? id;
  String name;
  String? parentCategoryId;
  bool isActive;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  CategoryModel({
    this.id,
    required this.name,
    this.parentCategoryId,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      parentCategoryId: data['parentCategoryId'],
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'parentCategoryId': parentCategoryId,
      'isActive': isActive,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  toLowerCase() {}
}
