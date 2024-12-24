// // // import 'package:cloud_firestore/cloud_firestore.dart';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:vesture_firebase_user/models/product_model.dart';

// // class CartItem {
// //   final String id;
// //   final String productId;
// //   final String variantId;
// //   final String sizeId;
// //   final int quantity;
// //   final double price;
// //   final String productName;
// //   final String color;
// //   final String size;
// //   final String imageUrl;
// //   final double percentDiscount;
// //   final DateTime? addedAt;

// //   CartItem({
// //     required this.id,
// //     required this.productId,
// //     required this.variantId,
// //     required this.sizeId,
// //     required this.quantity,
// //     required this.price,
// //     required this.productName,
// //     required this.color,
// //     required this.size,
// //     required this.imageUrl,
// //     required this.percentDiscount,
// //     this.addedAt,
// //   });

// //   double get discountedPrice => price * (1 - percentDiscount / 100);
// //   double get totalPrice => discountedPrice * quantity;

// //   // Updated factory method to handle variant images
// //   static Future<CartItem> fromProduct({
// //     required String docId,
// //     required ProductModel product,
// //     required Variant variant,
// //     required SizeStockModel sizeStock,
// //     required int quantity,
// //   }) async {
// //     // Get the first image from the variant's images
// //     String variantImage = variant.imageUrls.isNotEmpty
// //         ? variant.imageUrls.first
// //         : (product.imageUrls.isNotEmpty ? product.imageUrls.first : '');

// //     return CartItem(
// //       id: docId,
// //       productId: product.id ?? '',
// //       variantId: variant.id,
// //       sizeId: sizeStock.id,
// //       quantity: quantity,
// //       price: sizeStock.baseprice,
// //       productName: product.productName,
// //       color: variant.color,
// //       size: sizeStock.size,
// //       imageUrl: variantImage,
// //       percentDiscount: sizeStock.percentDiscount,
// //       addedAt: DateTime.now(),
// //     );
// //   }

// //   factory CartItem.fromMap(Map<String, dynamic> map, String docId) {
// //     return CartItem(
// //       id: docId,
// //       productId: map['productId'] ?? '',
// //       variantId: map['variantId'] ?? '',
// //       sizeId: map['sizeId'] ?? '',
// //       quantity: map['quantity'] ?? 0,
// //       price: (map['price'] as num?)?.toDouble() ?? 0.0,
// //       productName: map['productName'] ?? '',
// //       color: map['color'] ?? '',
// //       size: map['size'] ?? '',
// //       imageUrl: map['imageUrl'] ?? '',
// //       percentDiscount: (map['percentDiscount'] as num?)?.toDouble() ?? 0.0,
// //       addedAt: map['addedAt'] != null
// //           ? (map['addedAt'] as Timestamp).toDate()
// //           : null,
// //     );
// //   }

// //   Map<String, dynamic> toMap() {
// //     return {
// //       'productId': productId,
// //       'variantId': variantId,
// //       'sizeId': sizeId,
// //       'quantity': quantity,
// //       'price': price,
// //       'productName': productName,
// //       'color': color,
// //       'size': size,
// //       'imageUrl': imageUrl,
// //       'percentDiscount': percentDiscount,
// //       'addedAt': addedAt != null ? Timestamp.fromDate(addedAt!) : null,
// //     };
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
// import 'package:vesture_firebase_user/models/product_model.dart';

// class CartItem extends Equatable {
//   final String id;
//   final String productId;
//   final String variantId;
//   final String sizeId;
//   final int quantity;
//   final double price;
//   final String productName;
//   final String color;
//   final String size;
//   final String imageUrl;
//   final double percentDiscount;
//   final DateTime? addedAt;
//   final ProductModel? product;

//   const CartItem({
//     required this.id,
//     required this.productId,
//     required this.variantId,
//     required this.sizeId,
//     required this.quantity,
//     required this.price,
//     required this.productName,
//     required this.color,
//     required this.size,
//     required this.imageUrl,
//     required this.percentDiscount,
//     this.addedAt,
//     this.product,
//   });

//   // Getters for calculated values
//   double get discountedPrice => price * (1 - percentDiscount / 100);
//   double get totalPrice => discountedPrice * quantity;

//   // Override props for proper equality comparison
//   @override
//   List<Object?> get props => [
//         id,
//         productId,
//         variantId,
//         sizeId,
//         quantity,
//         price,
//         productName,
//         color,
//         size,
//         imageUrl,
//         percentDiscount,
//         addedAt,
//       ];

//   // Factory method for creating from product
//   static Future<CartItem> fromProduct({
//     required String docId,
//     required ProductModel product,
//     required Variant variant,
//     required SizeStockModel sizeStock,
//     required int quantity,
//   }) async {
//     String variantImage = variant.imageUrls.isNotEmpty
//         ? variant.imageUrls.first
//         : (product.imageUrls.isNotEmpty ? product.imageUrls.first : '');

//     return CartItem(
//       id: docId,
//       productId: product.id ?? '',
//       variantId: variant.id,
//       sizeId: sizeStock.id,
//       quantity: quantity,
//       price: sizeStock.baseprice,
//       productName: product.productName,
//       color: variant.color,
//       size: sizeStock.size,
//       imageUrl: variantImage,
//       percentDiscount: sizeStock.percentDiscount,
//       addedAt: DateTime.now(),
//     );
//   }

//   // Factory method for creating from map
//   factory CartItem.fromMap(Map<String, dynamic> map, String docId) {
//     return CartItem(
//       id: docId,
//       productId: map['productId'] ?? '',
//       variantId: map['variantId'] ?? '',
//       sizeId: map['sizeId'] ?? '',
//       quantity: map['quantity'] ?? 0,
//       price: (map['price'] as num?)?.toDouble() ?? 0.0,
//       productName: map['productName'] ?? '',
//       color: map['color'] ?? '',
//       size: map['size'] ?? '',
//       imageUrl: map['imageUrl'] ?? '',
//       percentDiscount: (map['percentDiscount'] as num?)?.toDouble() ?? 0.0,
//       addedAt: map['addedAt'] != null
//           ? (map['addedAt'] as Timestamp).toDate()
//           : null,
//     );
//   }

//   // Convert to map for Firestore
//   Map<String, dynamic> toMap() {
//     return {
//       'productId': productId,
//       'variantId': variantId,
//       'sizeId': sizeId,
//       'quantity': quantity,
//       'price': price,
//       'productName': productName,
//       'color': color,
//       'size': size,
//       'imageUrl': imageUrl,
//       'percentDiscount': percentDiscount,
//       'addedAt': addedAt != null ? Timestamp.fromDate(addedAt!) : null,
//     };
//   }

//   // Helper method to create a copy with updated quantity
//   CartItem copyWith({
//     int? quantity,
//   }) {
//     return CartItem(
//       id: id,
//       productId: productId,
//       variantId: variantId,
//       sizeId: sizeId,
//       quantity: quantity ?? this.quantity,
//       price: price,
//       productName: productName,
//       color: color,
//       size: size,
//       imageUrl: imageUrl,
//       percentDiscount: percentDiscount,
//       addedAt: addedAt,
//     );
//   }
// }
// CartItem Model Updates
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:vesture_firebase_user/models/offer_model.dart';
import 'package:vesture_firebase_user/models/product_model.dart';
import 'package:vesture_firebase_user/utilities/offer_calculator.dart';

class CartItem extends Equatable {
  final String id;
  final String productId;
  final String variantId;
  final String sizeId;
  final int quantity;
  final double price;
  final String productName;
  final String color;
  final String size;
  final String imageUrl;
  final double percentDiscount;
  final DateTime? addedAt;
  final String? parentCategoryId;
  final String? subCategoryId;
  final double categoryOffer;
  final ProductModel? product;

  const CartItem({
    required this.id,
    required this.productId,
    required this.variantId,
    required this.sizeId,
    required this.quantity,
    required this.price,
    required this.productName,
    required this.color,
    required this.size,
    required this.imageUrl,
    required this.percentDiscount,
    this.addedAt,
    this.parentCategoryId,
    this.subCategoryId,
    required this.categoryOffer,
    this.product,
  });

  double get effectivePrice {
    double basePrice = price;
    if (basePrice <= 0) return basePrice;
    return OfferCalculator.calculateFinalPrice(basePrice, categoryOffer);
  }

  double get totalPrice => effectivePrice * quantity;

  // static Future<CartItem> fromProduct({
  //   required String docId,
  //   required ProductModel product,
  //   required Variant variant,
  //   required SizeStockModel sizeStock,
  //   required int quantity,
  // }) async {
  //   String variantImage = variant.imageUrls.isNotEmpty
  //       ? variant.imageUrls.first
  //       : (product.imageUrls.isNotEmpty ? product.imageUrls.first : '');

  //   double categoryOffer = await calculateCategoryOffer(
  //     FirebaseFirestore.instance,
  //     product.parentCategoryId,
  //     product.subCategoryId,
  //   );

  //   return CartItem(
  //     id: docId,
  //     productId: product.id ?? '',
  //     variantId: variant.id,
  //     sizeId: sizeStock.id,
  //     quantity: quantity,
  //     price: sizeStock.baseprice,
  //     productName: product.productName,
  //     color: variant.color,
  //     size: sizeStock.size,
  //     imageUrl: variantImage,
  //     percentDiscount: sizeStock.percentDiscount,
  //     addedAt: DateTime.now(),
  //     parentCategoryId: product.parentCategoryId,
  //     subCategoryId: product.subCategoryId,
  //     categoryOffer: product.offer,
  //     product: product,
  //   );
  // }

  factory CartItem.fromMap(Map<String, dynamic> map, String docId) {
    return CartItem(
      id: docId,
      productId: map['productId'] ?? '',
      variantId: map['variantId'] ?? '',
      sizeId: map['sizeId'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      productName: map['productName'] ?? '',
      color: map['color'] ?? '',
      size: map['size'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      percentDiscount: (map['percentDiscount'] as num?)?.toDouble() ?? 0.0,
      addedAt: map['addedAt'] != null
          ? (map['addedAt'] as Timestamp).toDate()
          : null,
      parentCategoryId: map['parentCategoryId'],
      subCategoryId: map['subCategoryId'],
      categoryOffer: (map['categoryOffer'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'variantId': variantId,
      'sizeId': sizeId,
      'quantity': quantity,
      'price': price,
      'productName': productName,
      'color': color,
      'size': size,
      'imageUrl': imageUrl,
      'percentDiscount': percentDiscount,
      'addedAt': addedAt != null ? Timestamp.fromDate(addedAt!) : null,
      'parentCategoryId': parentCategoryId,
      'subCategoryId': subCategoryId,
      'categoryOffer': categoryOffer,
    };
  }

  CartItem copyWith({
    int? quantity,
    ProductModel? product,
  }) {
    return CartItem(
      id: id,
      productId: productId,
      variantId: variantId,
      sizeId: sizeId,
      quantity: quantity ?? this.quantity,
      price: price,
      productName: productName,
      color: color,
      size: size,
      imageUrl: imageUrl,
      percentDiscount: percentDiscount,
      addedAt: addedAt,
      parentCategoryId: parentCategoryId,
      subCategoryId: subCategoryId,
      categoryOffer: categoryOffer,
      product: product ?? this.product,
    );
  }

  @override
  List<Object?> get props => throw UnimplementedError();

  static Future<double> calculateCategoryOffer(FirebaseFirestore firestore,
      String? parentCategoryId, String? subCategoryId) async {
    if (parentCategoryId == null && subCategoryId == null) return 0.0;

    try {
      final offerQuery = await firestore
          .collection('offers')
          .where('isActive', isEqualTo: true)
          .where('offerType', isEqualTo: 'Category')
          .get();

      double maxOffer = 0.0;
      final now = DateTime.now();

      for (var doc in offerQuery.docs) {
        final offer = OfferModel.fromFirestore(doc);

        bool isApplicable = false;

        if (subCategoryId != null && offer.subCategoryId == subCategoryId) {
          isApplicable = true;
        } else if (parentCategoryId != null &&
            offer.parentCategoryId == parentCategoryId &&
            offer.subCategoryId == null) {
          isApplicable = true;
        }

        if (isApplicable &&
            offer.validFrom.isBefore(now) &&
            offer.validTo.isAfter(now) &&
            offer.discount > maxOffer) {
          maxOffer = offer.discount;
        }
      }

      return maxOffer;
    } catch (e) {
      print('Error calculating category offer: $e');
      return 0.0;
    }
  }
}
