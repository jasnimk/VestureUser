import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class CartItemPriceDisplay extends StatelessWidget {
  final double originalPrice;
  final double effectivePrice;
  final double discount;
  final bool showSavings;

  const CartItemPriceDisplay({
    Key? key,
    required this.originalPrice,
    required this.effectivePrice,
    required this.discount,
    this.showSavings = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (originalPrice <= 0 ||
        discount <= 0 ||
        originalPrice == effectivePrice) {
      return Text(
        '₹${originalPrice.toStringAsFixed(2)}',
        style: styling(
          fontSize: 16,
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
              '₹${effectivePrice.toStringAsFixed(2)}',
              style: styling(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '₹${originalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 12,
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        if (showSavings && discount > 0) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${discount.toStringAsFixed(0)}% OFF',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Save ₹${(originalPrice - effectivePrice).toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
