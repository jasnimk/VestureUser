// import 'package:flutter/material.dart';

// class MyOrdersPage extends StatelessWidget {
//   const MyOrdersPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('My Orders')),
//       body: const Center(child: Text('Order details here')),
//     );
//   }
// }
// lib/pages/my_orders_page.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/bloc/orders_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/bloc/orders_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/bloc/orders_state.dart';
import 'package:vesture_firebase_user/repository/orders_repo.dart';
import '../models/order_model.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersBloc(OrdersRepository())..add(LoadOrders()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          elevation: 0,
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrdersError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No orders yet',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  return _OrderCard(order: state.orders[index]);
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            const Divider(height: 24),
            _buildOrderItems(),
            const Divider(height: 24),
            _buildOrderSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order #${order.id.substring(0, 8)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            _StatusChip(status: order.orderStatus),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Placed on ${_formatDate(order.createdAt)}',
          style: const TextStyle(color: Colors.grey),
        ),
        if (order.paymentId != null) ...[
          const SizedBox(height: 4),
          Text(
            'Payment ID: ${order.paymentId}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildOrderItems() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order.items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = order.items[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                base64Decode(item.imageUrl),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.color} | ${item.size}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${item.price}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Qty: ${item.quantity}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  if (item.percentDiscount > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${item.percentDiscount}% off',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      children: [
        _SummaryRow(
          label: 'Items Total',
          value: '₹${_calculateItemsTotal()}',
        ),
        const SizedBox(height: 8),
        _SummaryRow(
          label: 'Shipping Charge',
          value: '₹${order.shippingCharge}',
        ),
        const SizedBox(height: 8),
        _SummaryRow(
          label: 'Total Amount',
          value: '₹${order.totalAmount}',
          isTotal: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              _getPaymentIcon(),
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              '${order.paymentMethod.toUpperCase()} - ${order.paymentStatus}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  double _calculateItemsTotal() {
    return order.items
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  IconData _getPaymentIcon() {
    switch (order.paymentMethod.toLowerCase()) {
      case 'cod':
        return Icons.money;
      case 'razorpay':
        return Icons.payment;
      default:
        return Icons.payment;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: _getStatusTextColor(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange[100]!;
      case 'processing':
        return Colors.blue[100]!;
      case 'shipped':
        return Colors.purple[100]!;
      case 'delivered':
        return Colors.green[100]!;
      case 'cancelled':
        return Colors.red[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getStatusTextColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange[900]!;
      case 'processing':
        return Colors.blue[900]!;
      case 'shipped':
        return Colors.purple[900]!;
      case 'delivered':
        return Colors.green[900]!;
      case 'cancelled':
        return Colors.red[900]!;
      default:
        return Colors.grey[900]!;
    }
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey[600],
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey[600],
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
