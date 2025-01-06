// lib/models/coupon_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  final String? id;
  final String couponCode;
  final String? parentCategoryId;
  final String? subCategoryId;
  final double discount;
  final DateTime validFrom;
  final DateTime validTo;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CouponModel({
    this.id,
    required this.couponCode,
    this.parentCategoryId,
    this.subCategoryId,
    required this.discount,
    required this.validFrom,
    required this.validTo,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'couponCode': couponCode,
      'parentCategoryId': parentCategoryId,
      'subCategoryId': subCategoryId,
      'discount': discount,
      'validFrom': Timestamp.fromDate(validFrom),
      'validTo': Timestamp.fromDate(validTo),
      'isActive': isActive,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory CouponModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CouponModel(
      id: doc.id,
      couponCode: data['couponCode'] ?? '',
      parentCategoryId: data['parentCategoryId'],
      subCategoryId: data['subCategoryId'],
      discount: (data['discount'] ?? 0.0).toDouble(),
      validFrom: (data['validFrom'] as Timestamp).toDate(),
      validTo: (data['validTo'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }
}
