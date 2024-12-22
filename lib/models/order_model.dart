import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String addressId;
  final List<OrderItem> items;
  final double totalAmount;
  final double shippingCharge;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final DateTime createdAt;
  final String? paymentId;

  OrderModel({
    required this.id,
    required this.userId,
    required this.addressId,
    required this.items,
    required this.totalAmount,
    required this.shippingCharge,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.createdAt,
    this.paymentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'addressId': addressId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'shippingCharge': shippingCharge,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'createdAt': Timestamp.fromDate(createdAt),
      'paymentId': paymentId,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      addressId: map['addressId'] ?? '',
      items: (map['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item))
          .toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      shippingCharge: (map['shippingCharge'] as num).toDouble(),
      paymentMethod: map['paymentMethod'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',
      orderStatus: map['orderStatus'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      paymentId: map['paymentId'],
    );
  }
}

class OrderItem {
  final String productId;
  final String variantId;
  final String sizeId;
  final int quantity;
  final double price;
  final double percentDiscount;
  final String productName;
  final String color;
  final String size;
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.variantId,
    required this.sizeId,
    required this.quantity,
    required this.price,
    required this.percentDiscount,
    required this.productName,
    required this.color,
    required this.size,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'variantId': variantId,
      'sizeId': sizeId,
      'quantity': quantity,
      'price': price,
      'percentDiscount': percentDiscount,
      'productName': productName,
      'color': color,
      'size': size,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      variantId: map['variantId'] ?? '',
      sizeId: map['sizeId'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] as num).toDouble(),
      percentDiscount: (map['percentDiscount'] as num).toDouble(),
      productName: map['productName'] ?? '',
      color: map['color'] ?? '',
      size: map['size'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
