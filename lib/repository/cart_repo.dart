import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vesture_firebase_user/models/cart_item.dart';
import 'package:vesture_firebase_user/models/product_model.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<List<CartItem>> fetchCartItems() async {
    if (currentUser == null) throw Exception('User not logged in');

    final cartSnapshot = await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('cart')
        .get();

    return cartSnapshot.docs
        .map((doc) => CartItem.fromMap(doc.data(), doc.id))
        .toList();
  }

  Stream<List<CartItem>> getCartStream() {
    if (currentUser == null) throw Exception('User not logged in');

    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('cart')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CartItem.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> updateCartItemQuantity(
      {required String cartItemId,
      required String sizeId,
      required int newQuantity}) async {
    if (currentUser == null) throw Exception('User not logged in');

    await _firestore.runTransaction((transaction) async {
      final cartDoc = await transaction.get(_firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('cart')
          .doc(cartItemId));

      if (!cartDoc.exists) throw Exception('Cart item not found');

      final currentQuantity = cartDoc.data()?['quantity'] as int;

      final sizeStockDoc = await transaction
          .get(_firestore.collection('sizes_and_stocks').doc(sizeId));

      if (!sizeStockDoc.exists) throw Exception('Size not found');

      final currentStock = sizeStockDoc.data()?['stock'] as int;
      final quantityDifference = newQuantity - currentQuantity;

      if (quantityDifference > 0 && currentStock < quantityDifference) {
        throw Exception('Not enough stock available');
      }

      transaction.update(_firestore.collection('sizes_and_stocks').doc(sizeId),
          {'stock': currentStock - quantityDifference});

      transaction.update(
          _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .collection('cart')
              .doc(cartItemId),
          {'quantity': newQuantity});
    });
  }

  Future<void> removeCartItem(
      {required String cartItemId, required String sizeId}) async {
    if (currentUser == null) throw Exception('User not logged in');

    await _firestore.runTransaction((transaction) async {
      final cartDoc = await transaction.get(_firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('cart')
          .doc(cartItemId));

      if (!cartDoc.exists) throw Exception('Cart item not found');

      final quantity = cartDoc.data()?['quantity'] as int;

      final sizeStockDoc = await transaction
          .get(_firestore.collection('sizes_and_stocks').doc(sizeId));

      if (!sizeStockDoc.exists) throw Exception('Size not found');

      final currentStock = sizeStockDoc.data()?['stock'] as int;

      transaction.update(_firestore.collection('sizes_and_stocks').doc(sizeId),
          {'stock': currentStock + quantity});

      transaction.delete(cartDoc.reference);
    });
  }

  Future<void> clearCart() async {
    if (currentUser == null) throw Exception('User not logged in');

    await _firestore.runTransaction((transaction) async {
      final cartSnapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('cart')
          .get();

      for (var doc in cartSnapshot.docs) {
        final quantity = doc.data()['quantity'] as int;
        final sizeId = doc.data()['sizeId'] as String;

        final sizeStockDoc = await transaction
            .get(_firestore.collection('sizes_and_stocks').doc(sizeId));

        if (sizeStockDoc.exists) {
          final currentStock = sizeStockDoc.data()?['stock'] as int;

          transaction.update(
              _firestore.collection('sizes_and_stocks').doc(sizeId),
              {'stock': currentStock + quantity});
        }

        transaction.delete(doc.reference);
      }
    });
  }

  Future<int> getAvailableStock(String sizeId) async {
    final sizeStockDoc =
        await _firestore.collection('sizes_and_stocks').doc(sizeId).get();
    if (!sizeStockDoc.exists) return 0;
    return sizeStockDoc.data()?['stock'] as int? ?? 0;
  }

  // Future<void> addToCart(ProductModel product, Variant selectedVariant,
  //     SizeStockModel selectedSize, int quantity) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     throw Exception('Please login to add items to cart');
  //   }

  //   try {
  //     await _firestore.runTransaction((transaction) async {
  //       // Get the current stock level
  //       final sizeStockDoc = await transaction.get(
  //           _firestore.collection('sizes_and_stocks').doc(selectedSize.id));

  //       if (!sizeStockDoc.exists) {
  //         throw Exception('Size not found');
  //       }

  //       final currentStock = sizeStockDoc.data()?['stock'] ?? 0;

  //       // Check cart for existing items
  //       final cartSnapshot = await _firestore
  //           .collection('users')
  //           .doc(user.uid)
  //           .collection('cart')
  //           .where('productId', isEqualTo: product.id)
  //           .where('variantId', isEqualTo: selectedVariant.id)
  //           .where('sizeId', isEqualTo: selectedSize.id)
  //           .get();

  //       if (cartSnapshot.docs.isNotEmpty) {
  //         // Update existing cart item
  //         final existingDoc = cartSnapshot.docs.first;
  //         final existingQuantity = existingDoc.data()['quantity'] as int;
  //         final newQuantity = existingQuantity + quantity;

  //         // Verify stock availability for the additional quantity only
  //         if (currentStock < quantity) {
  //           throw Exception('Not enough stock available');
  //         }

  //         // Update stock
  //         transaction.update(
  //             _firestore.collection('sizes_and_stocks').doc(selectedSize.id),
  //             {'stock': currentStock - quantity});

  //         // Update cart item quantity
  //         transaction.update(existingDoc.reference, {'quantity': newQuantity});
  //       } else {
  //         // Create new cart item if it doesn't exist
  //         if (currentStock < quantity) {
  //           throw Exception('Not enough stock available');
  //         }

  //         // Update stock
  //         transaction.update(
  //             _firestore.collection('sizes_and_stocks').doc(selectedSize.id),
  //             {'stock': currentStock - quantity});

  //         // Create new cart item
  //         final cartRef = _firestore
  //             .collection('users')
  //             .doc(user.uid)
  //             .collection('cart')
  //             .doc();

  //         transaction.set(cartRef, {
  //           'productId': product.id,
  //           'variantId': selectedVariant.id,
  //           'sizeId': selectedSize.id,
  //           'quantity': quantity,
  //           'price': selectedSize.baseprice,
  //           'productName': product.productName,
  //           'color': selectedVariant.color,
  //           'size': selectedSize.size,
  //           'imageUrl': selectedVariant.imageUrls.first,
  //           'addedAt': FieldValue.serverTimestamp(),
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     throw Exception('Error adding to cart: $e');
  //   }
  // }

  Future<void> addToCart(ProductModel product, Variant selectedVariant,
      SizeStockModel selectedSize, int quantity) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Please login to add items to cart');
    }

    try {
      await _firestore.runTransaction((transaction) async {
        // Get the current stock level
        final sizeStockDoc = await transaction.get(
            _firestore.collection('sizes_and_stocks').doc(selectedSize.id));

        if (!sizeStockDoc.exists) {
          throw Exception('Size not found');
        }

        final currentStock = sizeStockDoc.data()?['stock'] ?? 0;

        // Calculate category offer before adding to cart
        double categoryOffer = await CartItem.calculateCategoryOffer(
          _firestore,
          product.parentCategoryId,
          product.subCategoryId,
        );

        // Check cart for existing items
        final cartSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .where('productId', isEqualTo: product.id)
            .where('variantId', isEqualTo: selectedVariant.id)
            .where('sizeId', isEqualTo: selectedSize.id)
            .get();

        if (cartSnapshot.docs.isNotEmpty) {
          // Update existing cart item
          final existingDoc = cartSnapshot.docs.first;
          final existingQuantity = existingDoc.data()['quantity'] as int;
          final newQuantity = existingQuantity + quantity;

          if (currentStock < quantity) {
            throw Exception('Not enough stock available');
          }

          // Update stock
          transaction.update(
              _firestore.collection('sizes_and_stocks').doc(selectedSize.id),
              {'stock': currentStock - quantity});

          // Update cart item quantity and ensure discounts are saved
          transaction.update(existingDoc.reference, {
            'quantity': newQuantity,
            'categoryOffer': categoryOffer,
            'percentDiscount': selectedSize.percentDiscount,
            'parentCategoryId': product.parentCategoryId,
            'subCategoryId': product.subCategoryId,
          });
        } else {
          // Create new cart item
          if (currentStock < quantity) {
            throw Exception('Not enough stock available');
          }

          // Update stock
          transaction.update(
              _firestore.collection('sizes_and_stocks').doc(selectedSize.id),
              {'stock': currentStock - quantity});

          // Create new cart item with all discount information
          final cartRef = _firestore
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .doc();

          transaction.set(cartRef, {
            'productId': product.id,
            'variantId': selectedVariant.id,
            'sizeId': selectedSize.id,
            'quantity': quantity,
            'price': selectedSize.baseprice,
            'productName': product.productName,
            'color': selectedVariant.color,
            'size': selectedSize.size,
            'imageUrl': selectedVariant.imageUrls.isNotEmpty
                ? selectedVariant.imageUrls.first
                : '',
            'percentDiscount': selectedSize.percentDiscount,
            'categoryOffer': categoryOffer,
            'parentCategoryId': product.parentCategoryId,
            'subCategoryId': product.subCategoryId,
            'addedAt': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      throw Exception('Error adding to cart: $e');
    }
  }
}
