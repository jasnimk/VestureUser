import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  final String id;
  final String brandName; // Changed from 'name' to 'brandName'
  final String? brandIcon;
  final DateTime createdAt;

  BrandModel({
    required this.id,
    required this.brandName,
    this.brandIcon,
    required this.createdAt,
  });

  factory BrandModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BrandModel(
      id: doc.id,
      brandName: data['brandName'] ?? '', // Changed from 'name' to 'brandName'
      brandIcon: data['brandIcon'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
