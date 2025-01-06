import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:vesture_firebase_user/bloc/review/bloc/review_bloc.dart';
import 'package:vesture_firebase_user/bloc/review/bloc/review_event.dart';
import 'package:vesture_firebase_user/bloc/review/bloc/review_state.dart';
import 'package:vesture_firebase_user/screens/add_review.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class ProductReviewsSection extends StatefulWidget {
  final String productId;
  final String productName;

  const ProductReviewsSection({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  State<ProductReviewsSection> createState() => _ProductReviewsSectionState();
}

class _ProductReviewsSectionState extends State<ProductReviewsSection> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(LoadProductReviews(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        if (state is ReviewLoading && !isExpanded) {
          return ExpansionTile(
            title: Text(
              'Reviews',
              style: headerStyling(),
            ),
            children: [
              Center(child: CircularProgressIndicator()),
            ],
          );
        }

        if (state is ReviewsLoaded) {
          return ExpansionTile(
            title: Row(
              children: [
                Text(
                  'Reviews',
                  style: headerStyling(),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(width: 4),
                      Text(state.averageRating.toStringAsFixed(1),
                          style: styling()),
                      const SizedBox(width: 4),
                      Text('(${state.reviews.length})',
                          style: subHeaderStyling()),
                    ],
                  ),
                ),
              ],
            ),
            onExpansionChanged: (expanded) {
              setState(() {
                isExpanded = expanded;
              });
            },
            children: [
              if (state.reviews.isEmpty)
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                      child: Text(
                    'No reviews yet',
                    style: headerStyling(),
                  )),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.reviews.length,
                  itemBuilder: (context, index) {
                    final review = state.reviews[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: review.userImageUrl != null
                                    ? NetworkImage(review.userImageUrl!)
                                    : null,
                                child: review.userImageUrl == null
                                    ? Text(review.userName[0])
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                        DateFormat('MMM d, y')
                                            .format(review.createdAt),
                                        style: subHeaderStyling()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          RatingBarIndicator(
                            rating: review.rating,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 16.0,
                          ),
                          if (review.comment.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              review.comment,
                              style: styling(),
                            ),
                          ],
                          if (index != state.reviews.length - 1)
                            const Divider(height: 24),
                        ],
                      ),
                    );
                  },
                ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: customButton(
                      height: 50,
                      context: context,
                      text: 'Write a Review',
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AddReviewDialog(
                                productId: widget.productId,
                                productName: widget.productName,
                              );
                            });
                      })
                  // child: ElevatedButton(
                  //   onPressed: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return AddReviewDialog(
                  //           productId: widget.productId,
                  //           productName: widget.productName,
                  //         );
                  //       },
                  //     );

                  //     // Navigator.push(
                  //     //   context,
                  //     //   MaterialPageRoute(
                  //     //     builder: (context) => AddReviewScreen(
                  //     //       productId: widget.productId,
                  //     //       productName: widget.productName,
                  //     //     ),
                  //     //   ),
                  //     // );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     minimumSize: const Size(double.infinity, 45),
                  //   ),
                  //   child: const Text('Write a Review'),
                  // ),
                  ),
            ],
          );
        }

        if (state is ReviewError) {
          return ExpansionTile(
            title: const Text('Reviews'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text(state.message)),
              ),
            ],
          );
        }

        return const ExpansionTile(
          title: Text('Reviews'),
          children: [SizedBox()],
        );
      },
    );
  }
}
