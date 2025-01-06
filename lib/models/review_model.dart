import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String productId;
  final String productName;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final String? userImageUrl;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.productName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.userImageUrl,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      rating: (data['rating'] as num).toDouble(),
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      userImageUrl: data['userImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'productId': productId,
      'productName': productName,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
      'userImageUrl': userImageUrl,
    };
  }
}
