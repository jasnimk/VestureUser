// review_state.dart
import 'package:equatable/equatable.dart';
import 'package:vesture_firebase_user/models/review_model.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {}

class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}

class ReviewsLoaded extends ReviewState {
  final List<ReviewModel> reviews;
  final double averageRating;

  const ReviewsLoaded(this.reviews, this.averageRating);

  @override
  List<Object?> get props => [reviews, averageRating];
}
