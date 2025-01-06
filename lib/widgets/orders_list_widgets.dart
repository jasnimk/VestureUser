import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/bloc/orders_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/bloc/orders_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/bloc/orders_state.dart';
import 'package:vesture_firebase_user/models/order_model.dart';
import 'package:vesture_firebase_user/repository/orders_repo.dart';
import 'package:vesture_firebase_user/screens/add_review.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class EmptyOrdersView extends StatelessWidget {
  const EmptyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No orders yet',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  final List<OrderModel> orders;

  const OrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) => OrderCard(order: orders[index]),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});
  bool _canBeCancelled() {
    final orderStatus = order.orderStatus.toLowerCase();

    // Check if order is delivered
    if (orderStatus != 'delivered') {
      return false;
    }

    // Check if deliveredAt is available
    if (order.deliveredAt == null) {
      return false;
    }

    // Check if within 3 days of delivery
    final daysSinceDelivery =
        DateTime.now().difference(order.deliveredAt!).inDays;
    return daysSinceDelivery <= 3;
  }

  Widget build(BuildContext context) {
    // Debug prints for troubleshooting
    print('DEBUG: Building OrderCard');
    print('DEBUG: Order Status: ${order.orderStatus}');
    print('DEBUG: Delivered At: ${order.deliveredAt}');

    final bool canBeCancelled = _canBeCancelled();

    print('DEBUG: Can Be Cancelled: $canBeCancelled');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderHeader(order: order),
            OrderItemsList(
              items: order.items,
              showReviewButton: order.orderStatus.toLowerCase() == 'delivered',
            ),
            OrderSummary(order: order),
            if (canBeCancelled) ...[
              const SizedBox(height: 16),
              BlocConsumer<OrdersBloc, OrdersState>(
                listener: (context, state) {
                  if (state is OrderCancellationSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is OrderCancellationFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is OrderCancellationInProgress) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<OrdersBloc>().add(
                              CancelOrder(
                                orderId: order.id,
                                amount: order.totalAmount,
                              ),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Return Order'),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class OrderItemsList extends StatelessWidget {
  final List<OrderItem> items;
  final bool showReviewButton;

  const OrderItemsList({
    super.key,
    required this.items,
    required this.showReviewButton,
  });

  @override
  Widget build(BuildContext context) {
    print('DEBUG: OrderItemsList - Show Review Button: $showReviewButton');
    print('DEBUG: OrderItemsList - Number of items: ${items.length}');

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        print('DEBUG: Building item at index $index');
        return OrderItemCard(
          item: items[index],
          showReviewButton: showReviewButton,
        );
      },
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final OrderItem item;
  final bool showReviewButton;

  const OrderItemCard({
    super.key,
    required this.item,
    required this.showReviewButton,
  });

  void _navigateToReviewScreen(BuildContext context) {
    // Navigate to review screen implementation
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: OrderItemCard - Show Review Button: $showReviewButton');
    print('DEBUG: OrderItemCard - Product Name: ${item.productName}');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImage(imageUrl: item.imageUrl),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        item.productName,
                        style: styling(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.color} | ${item.size}',
                        style: styling(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                  if (showReviewButton)
                    IconButton(
                      icon: Icon(
                        Icons.rate_review_outlined,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AddReviewDialog(
                              productId: item.productId,
                              productName: item.productName,
                            );
                          },
                        );

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => AddReviewScreen(
                        //           productId: item.productId,
                        //           productName: item.productName)),
                        // );
                      },
                      // onPressed: () => _navigateToReviewScreen(context),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${item.originalPrice}',
                    style: styling(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Qty: ${item.quantity}',
                    style: styling(color: Colors.grey),
                  ),
                ],
              ),
              if (item.categoryOffer > 0) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${item.categoryOffer}% off',
                      style: styling(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '₹${item.discountAmount}',
                      style: styling(),
                    )
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class OrderHeader extends StatelessWidget {
  final OrderModel order;

  const OrderHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order #${order.id.substring(0, 8)}', style: headerStyling()),
            StatusChip(status: order.orderStatus),
          ],
        ),
        Text(
          'Placed on ${DateFormatter.format(order.createdAt)}',
          style: styling(color: Colors.grey),
        ),
        if (order.paymentId != null) ...[
          const SizedBox(height: 4),
          Text(
            'Payment ID: ${order.paymentId}',
            style: styling(fontSize: 12),
          ),
        ],
      ],
    );
  }
}

class ProductImage extends StatelessWidget {
  final String imageUrl;

  const ProductImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(
        base64Decode(imageUrl),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 80,
          height: 80,
          color: Colors.grey[200],
          child: const Icon(Icons.image_not_supported),
        ),
      ),
    );
  }
}

class ProductDetails extends StatelessWidget {
  final OrderItem item;

  const ProductDetails({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.productName,
          style: styling(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          '${item.color} | ${item.size}',
          style: styling(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${item.originalPrice}',
              style: styling(fontWeight: FontWeight.bold),
            ),
            Text(
              'Qty: ${item.quantity}',
              style: styling(color: Colors.grey),
            ),
          ],
        ),
        if (item.categoryOffer > 0) ...[
          const SizedBox(height: 4),
          Row(
            spacing: 10,
            children: [
              Text(
                '${item.categoryOffer}% off',
                style: styling(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '₹${item.discountAmount}',
                style: styling(),
              )
            ],
          ),
        ],
      ],
    );
  }
}

class OrderSummary extends StatelessWidget {
  final OrderModel order;

  const OrderSummary({super.key, required this.order});

  double _calculateItemsTotal() {
    return order.items
        .fold(0, (sum, item) => sum + (item.originalPrice * item.quantity));
  }

  double _calculateDiscount() {
    double totalDiscount = order.items.fold(
        0.0,
        (sum, item) =>
            sum + (item.originalPrice - item.discountAmount) * item.quantity);
    return totalDiscount;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        SummaryRow(label: 'Items Total', value: '₹${_calculateItemsTotal()}'),
        SummaryRow(
          label: 'Total Discount',
          value: '-₹${_calculateDiscount()}',
          isDiscount: true,
        ),
        SummaryRow(label: 'Shipping Charge', value: '₹${order.shippingCharge}'),
        SummaryRow(
          label: 'Total Amount',
          value: '₹${order.totalAmount}',
          isTotal: true,
        ),
        const SizedBox(height: 12),
        PaymentInfo(
          method: order.paymentMethod,
          status: order.paymentStatus,
        ),
      ],
    );
  }
}

class PaymentInfo extends StatelessWidget {
  final String method;
  final String status;

  const PaymentInfo({
    super.key,
    required this.method,
    required this.status,
  });

  IconData get _paymentIcon => switch (method.toLowerCase()) {
        'cod' => Icons.money,
        'razorpay' => Icons.payment,
        _ => Icons.payment,
      };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(_paymentIcon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '${method.toUpperCase()} - $status',
          style: styling(color: Colors.grey[600], fontSize: 13),
        ),
      ],
    );
  }
}

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  Color get backgroundColor => switch (status.toLowerCase()) {
        'pending' => Colors.orange[100]!,
        'processing' => Colors.blue[100]!,
        'shipped' => Colors.purple[100]!,
        'delivered' => Colors.green[100]!,
        'cancelled' => Colors.red[100]!,
        _ => Colors.grey[100]!,
      };

  Color get textColor => switch (status.toLowerCase()) {
        'pending' => Colors.orange[900]!,
        'processing' => Colors.blue[900]!,
        'shipped' => Colors.purple[900]!,
        'delivered' => Colors.green[900]!,
        'cancelled' => Colors.red[900]!,
        _ => Colors.grey[900]!,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(status.toUpperCase(), style: styling(color: textColor)),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final bool isDiscount;

  const SummaryRow(
      {super.key,
      required this.label,
      required this.value,
      this.isTotal = false,
      this.isDiscount = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: styling(
            color: isTotal ? Colors.black : Colors.grey[600],
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: styling(
            color: isTotal
                ? Colors.black
                : isDiscount
                    ? Colors.green
                    : Colors.grey,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class DateFormatter {
  static final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  static String format(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }
}
