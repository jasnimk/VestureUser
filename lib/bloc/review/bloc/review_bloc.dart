// review_bloc.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/review/bloc/review_event.dart';
import 'package:vesture_firebase_user/bloc/review/bloc/review_state.dart';
import 'package:vesture_firebase_user/models/review_model.dart';
import 'package:vesture_firebase_user/repository/review_repo.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _reviewRepository;
  FirebaseAuth _auth = FirebaseAuth.instance;

  ReviewBloc({required ReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository,
        super(ReviewInitial()) {
    on<AddReview>(_onAddReview);
    on<LoadProductReviews>(_onLoadProductReviews);
  }

  Future<void> _onAddReview(AddReview event, Emitter<ReviewState> emit) async {
    try {
      emit(ReviewLoading());

      final review = ReviewModel(
        id: '',
        userId: _auth.currentUser!.uid,
        userName: _auth.currentUser!.displayName!,
        productId: event.productId,
        productName: event.productName,
        rating: event.rating,
        comment: event.comment,
        createdAt: DateTime.now(),
      );

      await _reviewRepository.addReview(review);
      emit(ReviewSuccess());
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onLoadProductReviews(
      LoadProductReviews event, Emitter<ReviewState> emit) async {
    try {
      emit(ReviewLoading());

      final averageRating =
          await _reviewRepository.getAverageRating(event.productId);

      await emit.forEach(
        _reviewRepository.getProductReviews(event.productId),
        onData: (List<ReviewModel> reviews) {
          return ReviewsLoaded(reviews, averageRating);
        },
      );
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
