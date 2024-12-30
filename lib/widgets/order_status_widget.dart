import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class OrderStatusTimeline extends StatelessWidget {
  final String orderStatus;

  const OrderStatusTimeline({Key? key, required this.orderStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> orderStatuses = [
      {
        'status': 'pending',
        'title': 'Order Placed',
        'subtitle': 'Your order has been placed',
        'icon': Icons.shopping_cart,
        'color': Colors.blue
      },
      {
        'status': 'processing',
        'title': 'Processing',
        'subtitle': 'Your order is being processed',
        'icon': Icons.sync,
        'color': Colors.orange
      },
      {
        'status': 'shipped',
        'title': 'Shipped',
        'subtitle': 'Your order is on the way',
        'icon': Icons.local_shipping,
        'color': Colors.green
      },
      {
        'status': 'delivered',
        'title': 'Delivered',
        'subtitle': 'Order has been delivered',
        'icon': Icons.check_circle,
        'color': Colors.blue
      },
    ];

    int currentStatusIndex =
        orderStatuses.indexWhere((status) => status['status'] == orderStatus);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status',
            style: headerStyling(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(orderStatuses.length, (index) {
            final status = orderStatuses[index];
            final isActive = index <= currentStatusIndex;

            return TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.2,
              isFirst: index == 0,
              isLast: index == orderStatuses.length - 1,
              indicatorStyle: IndicatorStyle(
                width: 30,
                height: 30,
                indicator: Container(
                  decoration: BoxDecoration(
                    color: isActive ? status['color'] : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    status['icon'],
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
              beforeLineStyle: LineStyle(
                color: isActive ? status['color'] : Colors.grey.shade300,
                thickness: 2,
              ),
              afterLineStyle: LineStyle(
                color: index < currentStatusIndex
                    ? status['color']
                    : Colors.grey.shade300,
                thickness: 2,
              ),
              endChild: Container(
                margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                padding: const EdgeInsets.only(top: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status['title'],
                      style: styling(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isActive ? status['color'] : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status['subtitle'],
                      style: styling(
                        fontSize: 12,
                        color: isActive ? Colors.black54 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
