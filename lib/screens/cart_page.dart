import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_state.dart';
import 'package:vesture_firebase_user/models/cart_item.dart';
import 'package:vesture_firebase_user/repository/cart_repo.dart';
import 'package:vesture_firebase_user/screens/product_Details.dart';
import 'package:vesture_firebase_user/widgets/cart_item.dart';
import 'package:vesture_firebase_user/widgets/cart_summary.dart';
import 'package:vesture_firebase_user/widgets/confirmation_dialog.dart';
import 'package:vesture_firebase_user/widgets/details_widgets.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CartBloc(cartRepository: CartRepository())..add(LoadCartEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping Cart'),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoadingState) {
              return buildLoadingIndicator(context: context);
            }

            if (state is CartErrorState) {
              return buildErrorWidget(state.message);
            }

            if (state is CartLoadedState) {
              // List items = state.items;
              // print(items);
              if (state.items.isEmpty) {
                return buildEmptyStateWidget(
                    message: 'No products found!',
                    subMessage: 'Start Shopping now');
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailsPage(
                                        productId: item.productId)));
                          },
                          child: CartItemCard(
                            cartItem: item,
                            error: state.errorItemId == item.id
                                ? state.error
                                : null,
                            onQuantityChanged: (newQuantity) {
                              context.read<CartBloc>().add(
                                    UpdateCartItemQuantityEvent(
                                      cartItem: item,
                                      newQuantity: newQuantity,
                                    ),
                                  );
                            },
                            onRemove: () =>
                                _showRemoveConfirmationDialog(context, item),
                          ),
                        );
                      },
                    ),
                  ),
                  CartSummaryWidget(totalAmount: state.totalAmount),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showRemoveConfirmationDialog(BuildContext context, CartItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Remove Item',
          content: 'Are you sure you want to remove this item from the cart?',
          onConfirm: () {
            context.read<CartBloc>().add(RemoveFromCartEvent(cartItem: item));
          },
          onCancel: () {},
        );
      },
    );
  }
}
