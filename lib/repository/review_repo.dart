// review_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vesture_firebase_user/models/review_model.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore;

  ReviewRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Future<void> addReview(ReviewModel review) async {
  //   await _firestore.collection('reviews').add(review.toMap());
  // }

  Future<void> addReview(ReviewModel review) async {
    try {
      // Check if a review from the same user for the same product already exists
      final querySnapshot = await _firestore
          .collection('reviews')
          .where('productId', isEqualTo: review.productId)
          .where('userId', isEqualTo: review.userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Review exists, update the existing review
        final docId = querySnapshot.docs.first.id;
        await _firestore
            .collection('reviews')
            .doc(docId)
            .update(review.toMap());
      } else {
        // No review found, add a new review
        await _firestore.collection('reviews').add(review.toMap());
      }
    } catch (e) {
      throw Exception('Error adding/updating review: $e');
    }
  }

  Stream<List<ReviewModel>> getProductReviews(String productId) {
    return _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReviewModel.fromFirestore(doc))
            .toList());
  }

  Future<double> getAverageRating(String productId) async {
    final querySnapshot = await _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .get();

    if (querySnapshot.docs.isEmpty) return 0.0;

    double totalRating = 0.0;
    for (var doc in querySnapshot.docs) {
      totalRating += (doc.data()['rating'] as num).toDouble();
    }

    return totalRating / querySnapshot.docs.length;
  }
}
