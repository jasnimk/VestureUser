import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String brandId;
  final String description;
  final List<String> imageUrls;
  final double price;
  final String productName;
  String? brandName; 

  Product({
    required this.id,
    required this.brandId,
    required this.description,
    required this.imageUrls,
    required this.price,
    required this.productName,
    this.brandName,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      brandId: data['brandId'] ?? '',
      description: data['description'] ?? '',
      imageUrls:
          (data['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      price: (data['price'] ?? 0.0).toDouble(),
      productName: data['productName'] ?? '',
    );
  }

  Future<void> fetchBrandName() async {
    try {
      final brandDoc = await FirebaseFirestore.instance
          .collection('brands')
          .doc(brandId)
          .get();

      if (brandDoc.exists) {
        brandName = brandDoc.data()?['brandName'];
      } else {
        brandName = 'Unknown Brand';
      }
    } catch (e) {
      print('Error fetching brand name: $e');
      brandName = 'Error fetching brand';
    }
  }
}
