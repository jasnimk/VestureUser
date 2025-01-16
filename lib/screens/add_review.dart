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

/// A dialog to add a review for a product, including rating and comments.
class AddReviewDialog extends StatefulWidget {
  final String productId; // The ID of the product being reviewed
  final String productName; // The name of the product being reviewed

  const AddReviewDialog({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final _commentController =
      TextEditingController(); // Controller for the review comment text field
  double _rating = 0; // The rating value selected by the user

  @override
  void dispose() {
    _commentController
        .dispose(); // Dispose of the text controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      // Listens for state changes in the ReviewBloc
      listener: (context, state) {
        if (state is ReviewSuccess) {
          Navigator.pop(context); // Close the dialog on success
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
          buildLoadingIndicator(
              context:
                  context); // Show loading indicator while the review is being processed
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16), // Rounded corners for the dialog
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rate ${widget.productName}', // Title displaying the product name
                  style: headerStyling(),
                ),
                const SizedBox(height: 16),
                Center(
                  child: RatingBar.builder(
                    // Rating bar for the user to select a rating
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
                        _rating =
                            rating; // Update the rating when the user interacts with the rating bar
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller:
                      _commentController, // Text field for writing a review comment
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
                          // Validate if a rating is selected before submission
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
                      height: 50), // Submit button for the review
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
