import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vesture_firebase_user/models/offer_model.dart';
import 'package:vesture_firebase_user/utilities/offer_calculator.dart';

class ProductModel {
  String? id;
  String productName;
  String? parentCategoryId;
  String? subCategoryId;
  String? brandId;
  String? brandName;
  String description;
  List<String> imageUrls;
  double price;
  List<Variant>? variants;
  final double offer;

  ProductModel({
    this.id,
    required this.productName,
    this.parentCategoryId,
    this.subCategoryId,
    this.brandId,
    this.brandName,
    required this.description,
    this.imageUrls = const [],
    this.price = 0.0,
    this.variants,
    required this.offer,
  });
  List<String> getDefaultImages() {
    if (variants != null && variants!.isNotEmpty) {
      return variants!.first.imageUrls;
    }
    return imageUrls;
  }

  double getDefaultPrice() {
    if (variants != null && variants!.isNotEmpty) {
      for (var variant in variants!) {
        if (variant.sizeStocks.isNotEmpty) {
          return variant.sizeStocks.first.baseprice;
        }
      }
    }
    return price;
  }

  double get effectivePrice {
    final basePrice = getDefaultPrice();
    if (basePrice <= 0) return basePrice;
    return OfferCalculator.calculateFinalPrice(basePrice, offer);
  }

  factory ProductModel.fromFirestore(
    DocumentSnapshot doc,
    List<Variant> productVariants,
    String? brandName,
    double offer,
  ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    double basePrice = productVariants.isNotEmpty &&
            productVariants.first.sizeStocks.isNotEmpty
        ? productVariants.first.sizeStocks.first.baseprice
        : 0.0;

    return ProductModel(
      id: doc.id,
      productName: data['productName'] ?? '',
      parentCategoryId: data['parentCategoryId'],
      subCategoryId: data['subCategoryId'],
      brandId: data['brandId'],
      brandName: brandName ?? 'Unknown Brand',
      description: data['description'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      variants: productVariants,
      price: basePrice,
      offer: offer,
    );
  }

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
      return 0.0;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'parentCategoryId': parentCategoryId,
      'subCategoryId': subCategoryId,
      'brandId': brandId,
      'description': description,
      'imageUrls': imageUrls,
      'offer': offer,
    };
  }
}

class Variant {
  String id;
  String color;
  String hexcode;
  List<String> imageUrls;
  String productId;
  List<SizeStockModel> sizeStocks;
  Variant({
    required this.id,
    required this.color,
    required this.hexcode,
    required this.imageUrls,
    required this.productId,
    this.sizeStocks = const [],
  });

  factory Variant.fromMap(Map<String, dynamic> map, String documentId,
      List<SizeStockModel> variantSizeStocks) {
    return Variant(
      id: documentId,
      color: map['color'],
      hexcode: map['hexcode'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      productId: map['productId'] ?? '',
      sizeStocks: variantSizeStocks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'color': color,
      'hexcode': hexcode,
      'imageUrls': imageUrls,
      'productId': productId,
    };
  }
}

class SizeStockModel {
  String id;
  String size;
  int stock;
  double baseprice;
  double percentDiscount;
  String variantId;

  double get discountedPrice {
    return baseprice * (1 - percentDiscount / 100);
  }

  SizeStockModel({
    required this.id,
    required this.size,
    required this.baseprice,
    required this.stock,
    required this.percentDiscount,
    required this.variantId,
  });

  factory SizeStockModel.fromMap(Map<String, dynamic> map, String docId) {
    return SizeStockModel(
      id: docId,
      size: map['size'] ?? '',
      baseprice: (map['baseprice'] as num?)?.toDouble() ?? 0.0,
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      percentDiscount: (map['percentdiscount'] as num?)?.toDouble() ?? 0.0,
      variantId: map['variantId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'size': size,
      'stock': stock,
      'baseprice': baseprice,
      'percentdiscount': percentDiscount,
      'variantId': variantId,
    };
  }

  bool get isAvailable => stock > 0;
}
