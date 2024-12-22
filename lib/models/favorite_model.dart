import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vesture_firebase_user/models/product_model.dart';

class Favorite {
  String productId;
  String variantId;
  String size;
  Variant variant;
  double price;
  Timestamp? addedAt;

  Favorite({
    required this.productId,
    required this.variantId,
    required this.size,
    required this.variant,
    required this.price,
    this.addedAt,
  });

  factory Favorite.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Favorite(
      productId: data['productId'] ?? '',
      variantId: data['variantId'] ?? '',
      size: data['size'] ?? '',
      variant: Variant(
        id: data['variant']?['id'] ?? '',
        color: data['variant']?['color'] ?? '',
        hexcode: data['variant']?['hexcode'] ?? '',
        imageUrls: List<String>.from(data['variant']?['imageUrls'] ?? []),
        productId: data['variant']?['productId'] ?? '',
      ),
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      addedAt: data['addedAt'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'variantId': variantId,
      'size': size,
      'variant': variant.toMap(),
      'price': price,
      'addedAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Favorite &&
          productId == other.productId &&
          variantId == other.variantId &&
          size == other.size;

  @override
  int get hashCode => productId.hashCode ^ variantId.hashCode ^ size.hashCode;
}
