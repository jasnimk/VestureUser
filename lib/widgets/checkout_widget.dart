import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_state.dart';
import 'package:vesture_firebase_user/models/cart_item.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class EnhancedOrderSummary extends StatelessWidget {
  final double shippingCharge;

  const EnhancedOrderSummary({
    Key? key,
    required this.shippingCharge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoadedState) {
          final prices = _calculatePrices(state.items);

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Summary',
                  style: headerStyling(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    final basePrice = item.price * item.quantity;
                    final maxDiscountPercent = _calculateMaxDiscount(item);
                    final effectivePrice =
                        basePrice * (1 - maxDiscountPercent / 100);

                    return _buildItemRow(
                        item, basePrice, effectivePrice, maxDiscountPercent);
                  },
                ),
                const Divider(height: 24),
                _buildPriceRow('Subtotal', prices.subtotal),
                if (prices.totalDiscount > 0)
                  _buildPriceRow('Total Discount', -prices.totalDiscount,
                      isDiscount: true),
                _buildPriceRow('Shipping Charge', shippingCharge),
                const Divider(height: 24),
                _buildPriceRow(
                  'Total Amount',
                  prices.subtotal - prices.totalDiscount + shippingCharge,
                  isTotal: true,
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  ({double subtotal, double totalDiscount}) _calculatePrices(
      List<CartItem> items) {
    double subtotal = 0;
    double totalDiscount = 0;

    for (var item in items) {
      if (item.price <= 0 || item.quantity <= 0) {
        continue;
      }

      final basePrice = item.price * item.quantity;
      subtotal += basePrice;

      final maxDiscountPercent = _calculateMaxDiscount(item);
      final itemDiscount = basePrice * (maxDiscountPercent / 100);
      totalDiscount += itemDiscount;
    }

    return (subtotal: subtotal, totalDiscount: totalDiscount);
  }

  double _calculateMaxDiscount(CartItem item) {
    return [
      item.percentDiscount,
      item.categoryOffer,
      item.product?.offer ?? 0.0
    ].reduce((a, b) => a > b ? a : b);
  }

  Widget _buildItemRow(CartItem item, double basePrice, double effectivePrice,
      double discountPercent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName, style: styling()),
                    Text(
                      'Size: ${item.size} | Color: ${item.color} | Qty: ${item.quantity}',
                      style: styling(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${basePrice.toStringAsFixed(2)}',
                    style: styling(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  Text('₹${effectivePrice.toStringAsFixed(2)}',
                      style: styling()),
                ],
              ),
            ],
          ),
          if (discountPercent > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${discountPercent.toStringAsFixed(0)}% OFF',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: styling(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            isDiscount
                ? '-₹${amount.abs().toStringAsFixed(2)}'
                : '₹${amount.toStringAsFixed(2)}',
            style: styling(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isDiscount ? Colors.green.shade700 : null,
            ),
          ),
        ],
      ),
    );
  }
}
