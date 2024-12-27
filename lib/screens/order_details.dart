// import 'package:flutter/material.dart';
// import 'package:vesture_firebase_user/models/order_model.dart';
// import 'package:vesture_firebase_user/widgets/orders_list_widgets.dart';

// class OrderDetailsScreen extends StatelessWidget {
//   final OrderModel order;

//   const OrderDetailsScreen({super.key, required this.order});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order #${order.id.substring(0, 8)}'),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               OrderStatusTimeline(status: order.orderStatus),
//               const SizedBox(height: 24),
//               const Text(
//                 'Order Details',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               OrderHeader(order: order),
//               const Divider(height: 32),
//               const Text(
//                 'Items',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               OrderItemsList(items: order.items),
//               const Divider(height: 32),
//               OrderSummary(order: order),
//               if (order.paymentId != null) ...[
//                 const Divider(height: 32),
//                 Text(
//                   'Payment ID: ${order.paymentId}',
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OrderStatusTimeline extends StatelessWidget {
//   final String status;

//   const OrderStatusTimeline({super.key, required this.status});

//   List<String> get _allStatuses => [
//         'pending',
//         'processing',
//         'shipped',
//         'delivered',
//       ];

//   int get _currentStatusIndex {
//     final index = _allStatuses.indexOf(status.toLowerCase());
//     return index == -1 ? 0 : index;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: List.generate(
//         _allStatuses.length,
//         (index) => Expanded(
//           child: Row(
//             children: [
//               _StatusDot(
//                 isActive: index <= _currentStatusIndex,
//                 isCompleted: index < _currentStatusIndex,
//               ),
//               if (index < _allStatuses.length - 1)
//                 Expanded(
//                   child: Container(
//                     height: 2,
//                     color: index < _currentStatusIndex
//                         ? Colors.green
//                         : Colors.grey[300],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _StatusDot extends StatelessWidget {
//   final bool isActive;
//   final bool isCompleted;

//   const _StatusDot({
//     required this.isActive,
//     required this.isCompleted,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 24,
//       height: 24,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: isCompleted
//             ? Colors.green
//             : isActive
//                 ? Colors.blue
//                 : Colors.grey[300],
//       ),
//       child: isCompleted
//           ? const Icon(Icons.check, size: 16, color: Colors.white)
//           : null,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/models/order_model.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/orders_list_widgets.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context: context,
        title: 'Order #${order.id.substring(0, 8)}',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderHeader(order: order),
              const SizedBox(height: 24),
              Text('Items', style: headerStyling()),
              const SizedBox(height: 16),
              OrderItemsList(items: order.items),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: headerStyling(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OrderSummary(order: order),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
