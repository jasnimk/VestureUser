// review_event.dart
import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class AddReview extends ReviewEvent {
  final String productId;
  final String productName;
  final double rating;
  final String comment;

  const AddReview({
    required this.productId,
    required this.productName,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [productId, productName, rating, comment];
}

class LoadProductReviews extends ReviewEvent {
  final String productId;

  const LoadProductReviews(this.productId);

  @override
  List<Object?> get props => [productId];
}
