import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vesture_firebase_user/bloc/review/bloc/review_bloc.dart';
import 'package:vesture_firebase_user/bloc/review/bloc/review_event.dart';
import 'package:vesture_firebase_user/bloc/review/bloc/review_state.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/custom_snackbar.dart';
import 'package:vesture_firebase_user/widgets/details_widgets.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class AddReviewDialog extends StatefulWidget {
  final String productId;
  final String productName;

  const AddReviewDialog({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final _commentController = TextEditingController();
  double _rating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state is ReviewSuccess) {
          Navigator.pop(context);
          CustomSnackBar.show(
            context,
            message: 'Review added successfully!',
            textColor: Colors.white,
          );
        } else if (state is ReviewError) {
          CustomSnackBar.show(
            context,
            message: state.message,
            textColor: Colors.white,
          );
        } else if (state is ReviewLoading) {
          buildLoadingIndicator(context: context);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rate ${widget.productName}',
                  style: headerStyling(),
                ),
                const SizedBox(height: 16),
                Center(
                  child: RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 158, 122, 12),
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Write your review',
                    labelStyle: styling(),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: customButton(
                      context: context,
                      onPressed: () {
                        if (_rating == 0) {
                          CustomSnackBar.show(
                            context,
                            message: 'Please Select a rating...!',
                            textColor: Colors.white,
                          );

                          return;
                        }
                        context.read<ReviewBloc>().add(
                              AddReview(
                                productId: widget.productId,
                                productName: widget.productName,
                                rating: _rating,
                                comment: _commentController.text,
                              ),
                            );
                      },
                      text: 'Submit Review',
                      height: 50),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
