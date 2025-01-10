import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vesture_firebase_user/utilities&Services/offer_calculator.dart';

class OrderModel {
  final String id;
  final String userId;
  final String addressId;
  final List<OrderItem> items;
  final double subTotal;
  final double totalDiscount;
  final double finalAmount;
  final double shippingCharge;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final DateTime createdAt;
  final String? paymentId;
  final DateTime? deliveredAt;
  final String? appliedCouponId;
  final double? couponDiscount;

  OrderModel({
    this.appliedCouponId,
    this.couponDiscount,
    required this.id,
    required this.userId,
    required this.addressId,
    required this.items,
    required this.subTotal,
    required this.totalDiscount,
    required this.finalAmount,
    required this.shippingCharge,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.createdAt,
    this.paymentId,
    this.deliveredAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'addressId': addressId,
      'items': items.map((item) => item.toMap()).toList(),
      'subTotal': subTotal,
      'totalDiscount': totalDiscount,
      'finalAmount': finalAmount,
      'shippingCharge': shippingCharge,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'createdAt': Timestamp.fromDate(createdAt),
      'paymentId': paymentId,
      'appliedCouponId': appliedCouponId,
      'couponDiscount': couponDiscount,
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
      subTotal: (map['subTotal'] as num).toDouble(),
      totalDiscount: (map['totalDiscount'] as num).toDouble(),
      finalAmount: (map['finalAmount'] as num).toDouble(),
      shippingCharge: (map['shippingCharge'] as num).toDouble(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      paymentMethod: map['paymentMethod'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',
      orderStatus: map['orderStatus'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      paymentId: map['paymentId'],
      deliveredAt: map['deliveredAt'] != null
          ? (map['deliveredAt'] as Timestamp).toDate()
          : null,
    );
  }
}

class OrderItem {
  final String productId;
  final String variantId;
  final String sizeId;
  final int quantity;
  final double originalPrice;
  final double percentDiscount;
  final double categoryOffer;
  final double discountAmount;
  final double finalPrice;
  final double totalAmount;
  final String productName;
  final String color;
  final String size;
  final String imageUrl;
  final String? parentCategoryId;
  final String? subCategoryId;
  final DateTime addedAt;

  OrderItem({
    required this.productId,
    required this.variantId,
    required this.sizeId,
    required this.quantity,
    required this.originalPrice,
    required this.percentDiscount,
    required this.categoryOffer,
    required this.productName,
    required this.color,
    required this.size,
    required this.imageUrl,
    this.parentCategoryId,
    this.subCategoryId,
    required this.addedAt,
  })  : discountAmount = _calculateDiscountAmount(
          originalPrice,
          percentDiscount,
          categoryOffer,
          quantity,
        ),
        finalPrice = _calculateFinalPrice(
          originalPrice,
          percentDiscount,
          categoryOffer,
        ),
        totalAmount = _calculateTotalAmount(
          originalPrice,
          percentDiscount,
          categoryOffer,
          quantity,
        );

  static double _calculateDiscountAmount(
    double originalPrice,
    double percentDiscount,
    double categoryOffer,
    int quantity,
  ) {
    double priceAfterDiscount = OfferCalculator.calculateFinalPrice(
      originalPrice,
      categoryOffer,
    );
    return (originalPrice - priceAfterDiscount) * quantity;
  }

  static double _calculateFinalPrice(
    double originalPrice,
    double percentDiscount,
    double categoryOffer,
  ) {
    return OfferCalculator.calculateFinalPrice(
      originalPrice,
      categoryOffer,
    );
  }

  static double _calculateTotalAmount(
    double originalPrice,
    double percentDiscount,
    double categoryOffer,
    int quantity,
  ) {
    double finalPrice = _calculateFinalPrice(
      originalPrice,
      percentDiscount,
      categoryOffer,
    );
    return finalPrice * quantity;
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'variantId': variantId,
      'sizeId': sizeId,
      'quantity': quantity,
      'originalPrice': originalPrice,
      'percentDiscount': percentDiscount,
      'categoryOffer': categoryOffer,
      'discountAmount': discountAmount,
      'finalPrice': finalPrice,
      'totalAmount': totalAmount,
      'productName': productName,
      'color': color,
      'size': size,
      'imageUrl': imageUrl,
      'parentCategoryId': parentCategoryId,
      'subCategoryId': subCategoryId,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      variantId: map['variantId'] ?? '',
      sizeId: map['sizeId'] ?? '',
      quantity: map['quantity'] ?? 0,
      originalPrice: (map['originalPrice'] as num).toDouble(),
      percentDiscount: (map['percentDiscount'] as num).toDouble(),
      categoryOffer: (map['categoryOffer'] as num?)?.toDouble() ?? 0.0,
      productName: map['productName'] ?? '',
      color: map['color'] ?? '',
      size: map['size'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      parentCategoryId: map['parentCategoryId'],
      subCategoryId: map['subCategoryId'],
      addedAt: (map['addedAt'] as Timestamp).toDate(),
    );
  }
}
