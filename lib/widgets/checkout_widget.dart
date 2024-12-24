import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_state.dart';

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
          double subtotal = 0;
          double totalDiscount = 0;

// Suggested fixed version:
          for (var item in state.items) {
            // Ensure price and quantity are non-null and greater than 0
            if (item.price <= 0 || item.quantity <= 0) {
              print(
                  'Warning: Invalid price or quantity for item: ${item.product?.id}');
              continue;
            }

            // Calculate base price for this item
            double itemBasePrice = item.price * item.quantity;
            print(
                'Item: ${item.product?.id}, Price: ${item.price}, Quantity: ${item.quantity}, Base Price: $itemBasePrice');

            // Add to subtotal
            subtotal += itemBasePrice;

            // Calculate discount if applicable
            double offerPercentage = item.product?.offer ?? 0;
            if (offerPercentage > 0) {
              double itemDiscount = (itemBasePrice * offerPercentage / 100);
              totalDiscount += itemDiscount;
              print('Applied discount: $itemDiscount (${offerPercentage}%)');
            }
          }

// Add debug print after calculations
          print('Final Subtotal: $subtotal');
          print('Total Discount: $totalDiscount');
          print('Shipping Charge: $shippingCharge');
          print('Final Amount: ${subtotal - totalDiscount + shippingCharge}');

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(
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
                    subtotal += basePrice;

                    final effectivePrice = item.effectivePrice * item.quantity;
                    final itemDiscount = basePrice - effectivePrice;
                    totalDiscount += itemDiscount;

                    double maxDiscountPercent = [
                      item.percentDiscount,
                      item.categoryOffer,
                      item.product?.offer ?? 0.0
                    ].reduce((a, b) => a > b ? a : b);

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
                                    Text(
                                      item.productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Size: ${item.size} | Color: ${item.color} | Qty: ${item.quantity}',
                                      style: TextStyle(
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
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '₹${effectivePrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (maxDiscountPercent > 0) ...[
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
                                '${maxDiscountPercent.toStringAsFixed(0)}% OFF',
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
                  },
                ),
                const Divider(height: 24),
                _buildPriceRow('Subtotal', subtotal),
                if (totalDiscount > 0)
                  _buildPriceRow('Total Discount', -totalDiscount,
                      isDiscount: true),
                _buildPriceRow('Shipping Charge', shippingCharge),
                const Divider(height: 24),
                _buildPriceRow(
                  'Total Amount',
                  subtotal + shippingCharge,
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
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            isDiscount
                ? '-₹${amount.abs().toStringAsFixed(2)}'
                : '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
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
