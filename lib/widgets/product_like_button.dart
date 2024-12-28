// like_button_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_bloc.dart';
import 'package:vesture_firebase_user/bloc/favorites/bloc/favorite_event.dart';
import 'package:vesture_firebase_user/models/product_model.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class ProductLikeButton extends StatelessWidget {
  final bool isFavorite;
  final String productId;
  final Variant selectedVariant;
  final SizeStockModel selectedSize;
  final double size;
  final EdgeInsetsGeometry padding;

  const ProductLikeButton({
    Key? key,
    required this.isFavorite,
    required this.productId,
    required this.selectedVariant,
    required this.selectedSize,
    this.size = 30,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Remove from Favorites', style: headerStyling()),
          content: Text(
            'Are you sure you want to remove this item from favorites?',
            style: styling(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: styling(color: Colors.grey)),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: Text('Confirm', style: styling(color: Colors.red)),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LikeButton(
        size: size,
        isLiked: isFavorite,
        onTap: (bool isLiked) async {
          final newFavoriteState = !isLiked;
          
          if (!newFavoriteState) {
            final shouldRemove = await _showConfirmationDialog(context);
            if (shouldRemove != true) {
              return isLiked;
            }
          }

          // Optimistically update UI
          context.read<FavoriteBloc>().add(ToggleFavoriteEvent(
            productId: productId,
            variant: selectedVariant,
            sizeStock: selectedSize,
            context: context,
          ));
          
          return newFavoriteState;
        },
        likeBuilder: (bool isLiked) {
          return Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: const Color.fromRGBO(196, 28, 13, 0.829),
            size: size,
          );
        },
        circleColor: const CircleColor(
          start: Colors.red,
          end: Colors.redAccent,
        ),
        bubblesColor: const BubblesColor(
          dotPrimaryColor: Colors.redAccent,
          dotSecondaryColor: Colors.red,
        ),
      ),
    );
  }
}