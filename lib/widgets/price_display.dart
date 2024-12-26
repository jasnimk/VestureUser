import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/models/product_model.dart';

class ProductPriceDisplay extends StatelessWidget {
  final ProductModel product;

  const ProductPriceDisplay({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final originalPrice = product.getDefaultPrice();
    final discountedPrice = product.effectivePrice;

    if (originalPrice <= 0 ||
        product.offer <= 0 ||
        originalPrice == discountedPrice) {
      return Text(
        '₹${originalPrice.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '₹${discountedPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '₹${originalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (product.offer > 0)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${product.offer.toStringAsFixed(0)}% OFF',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Save ₹${(originalPrice - discountedPrice).toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
