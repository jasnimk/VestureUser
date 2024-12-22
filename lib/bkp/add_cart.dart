
  // // In ProductDetailsBloc
  // Future<void> _onAddToCart(
  //     AddToCartEvent event, Emitter<ProductDetailsState> emit) async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       emit(AddToCartErrorState(
  //           errorMessage: 'Please login to add items to cart'));
  //       return;
  //     }

  //     // Start a transaction to handle stock updates atomically
  //     await _firestore.runTransaction((transaction) async {
  //       // Get the current stock level
  //       final sizeStockDoc = await transaction.get(_firestore
  //           .collection('sizes_and_stocks')
  //           .doc(event.selectedSize.id));

  //       if (!sizeStockDoc.exists) {
  //         throw Exception('Size not found');
  //       }

  //       final currentStock = sizeStockDoc.data()?['stock'] ?? 0;

  //       // Check cart for existing items
  //       final cartSnapshot = await _firestore
  //           .collection('users')
  //           .doc(user.uid)
  //           .collection('cart')
  //           .where('productId', isEqualTo: event.product.id)
  //           .where('variantId', isEqualTo: event.selectedVariant.id)
  //           .where('sizeId', isEqualTo: event.selectedSize.id)
  //           .get();

  //       int totalRequestedQuantity = event.quantity;
  //       if (cartSnapshot.docs.isNotEmpty) {
  //         final existingQuantity =
  //             cartSnapshot.docs.first.data()['quantity'] as int;
  //         totalRequestedQuantity += existingQuantity;
  //       }

  //       // Verify stock availability
  //       if (currentStock < totalRequestedQuantity) {
  //         throw Exception('Not enough stock available');
  //       }

  //       // Update stock
  //       final newStock = currentStock - event.quantity;
  //       transaction.update(
  //           _firestore
  //               .collection('sizes_and_stocks')
  //               .doc(event.selectedSize.id),
  //           {'stock': newStock});

  //       // Update or create cart item
  //       if (cartSnapshot.docs.isNotEmpty) {
  //         transaction.update(cartSnapshot.docs.first.reference,
  //             {'quantity': totalRequestedQuantity});
  //       } else {
  //         final cartRef = _firestore
  //             .collection('users')
  //             .doc(user.uid)
  //             .collection('cart')
  //             .doc();

  //         transaction.set(cartRef, {
  //           'productId': event.product.id,
  //           'variantId': event.selectedVariant.id,
  //           'sizeId': event.selectedSize.id,
  //           'quantity': event.quantity,
  //           'price': event.selectedSize.baseprice,
  //           'productName': event.product.productName,
  //           'color': event.selectedVariant.color,
  //           'size': event.selectedSize.size,
  //           'imageUrl': event.selectedVariant.imageUrls.first,
  //           'percentDiscount': event.selectedSize.percentDiscount,
  //           'addedAt': FieldValue.serverTimestamp(),
  //         });
  //       }
  //     });

  //     emit(AddToCartSuccessState(message: 'Item added to cart successfully'));

  //     // Refresh product details to show updated stock
  //     add(FetchProductDetailsEvent(productId: event.product.id!));
  //   } catch (e) {
  //     emit(AddToCartErrorState(errorMessage: e.toString()));
  //   }
  // }