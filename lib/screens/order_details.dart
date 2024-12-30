// import 'package:flutter/material.dart';
// import 'package:vesture_firebase_user/models/order_model.dart';
// import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
// import 'package:vesture_firebase_user/widgets/order_status_widget.dart';
// import 'package:vesture_firebase_user/widgets/orders_list_widgets.dart';
// import 'package:vesture_firebase_user/widgets/textwidget.dart';

// class OrderDetailScreen extends StatelessWidget {
//   final OrderModel order;

//   const OrderDetailScreen({super.key, required this.order});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildCustomAppBar(
//         context: context,
//         title: 'Order #${order.id.substring(0, 8)}',
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               OrderHeader(order: order),
//               const SizedBox(height: 24),
//               Text('Items', style: headerStyling()),
//               const SizedBox(height: 16),
//               OrderItemsList(items: order.items),
//               const SizedBox(height: 24),
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     spacing: 10,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Order Summary',
//                         style: headerStyling(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       OrderSummary(order: order),
//                     ],
//                   ),
//                 ),
//               ),
//               Card(
//                 child: OrderStatusTimeline(orderStatus: order.orderStatus),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/models/order_model.dart';
import 'package:vesture_firebase_user/widgets/cancel_order.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/order_status_widget.dart';
import 'package:vesture_firebase_user/widgets/orders_list_widgets.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  bool _isWithinCancellationPeriod(DateTime orderDate) {
    final Duration difference = DateTime.now().difference(orderDate);
    return difference.inDays <= 3; // Changed to 3 days
  }

  @override
  Widget build(BuildContext context) {
    final bool canBeCancelled = _isWithinCancellationPeriod(order.createdAt);

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
              OrderCard(
                order: order,
              ),
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
                      OrderSummary(order: order),
                    ],
                  ),
                ),
              ),
              Card(
                child: OrderStatusTimeline(orderStatus: order.orderStatus),
              ),
              // if (canBeCancelled)
              //   Padding(
              //     padding: const EdgeInsets.only(top: 16),
              //     child: CancelOrderButton(orderId: order.id),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
