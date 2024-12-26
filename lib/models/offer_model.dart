import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  String? id;
  String offerType;
  String? parentCategoryId;
  String? subCategoryId;
  String? productId;
  double discount;
  DateTime validFrom;
  DateTime validTo;
  bool isActive;

  OfferModel({
    this.id,
    required this.offerType,
    this.parentCategoryId,
    this.subCategoryId,
    this.productId,
    required this.discount,
    required this.validFrom,
    required this.validTo,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'offerType': offerType,
      'parentCategoryId': parentCategoryId,
      'subCategoryId': subCategoryId,
      'productId': productId,
      'discount': discount,
      'validFrom': Timestamp.fromDate(validFrom),
      'validTo': Timestamp.fromDate(validTo),
      'isActive': isActive,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory OfferModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OfferModel(
      id: doc.id,
      offerType: data['offerType'] ?? '',
      parentCategoryId: data['parentCategoryId'],
      subCategoryId: data['subCategoryId'],
      productId: data['productId'],
      discount: (data['discount'] ?? 0.0).toDouble(),
      validFrom: (data['validFrom'] as Timestamp).toDate(),
      validTo: (data['validTo'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
    );
  }
}
