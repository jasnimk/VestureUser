import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_state.dart';
import 'package:vesture_firebase_user/bloc/bloc/coupon/bloc/coupon_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/coupon/bloc/coupon_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/coupon/bloc/coupon_state.dart';
import 'package:vesture_firebase_user/models/cart_item.dart';
import 'package:vesture_firebase_user/repository/cart_repo.dart';
import 'package:vesture_firebase_user/repository/coupon_repo.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class EnhancedOrderSummary extends StatelessWidget {
  final double shippingCharge;

  const EnhancedOrderSummary({
    Key? key,
    required this.shippingCharge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return MultiBlocProvider(
    //   providers: [
    //     BlocProvider<CartBloc>(
    //       create: (context) =>
    //           CartBloc(cartRepository: CartRepository())..add(LoadCartEvent()),
    //     ),
    //     BlocProvider<CouponBloc>(
    //       create: (context) => CouponBloc(couponRepository: CouponRepository()),
    //     ),
    //   ],
    //   child: _buildContent(),
    // );
    return _buildContent();
  }

  Widget _buildContent() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        return BlocBuilder<CouponBloc, CouponState>(
          builder: (context, couponState) {
            if (cartState is CartLoadingState) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (cartState is CartErrorState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load cart',
                        style: styling(color: Colors.red),
                      ),
                      if (cartState.message != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          cartState.message!,
                          style: styling(fontSize: 14, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }

            if (cartState is CartLoadedState) {
              final prices = _calculatePrices(cartState.items, couponState);
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: headerStyling(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (cartState.items.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Your cart is empty',
                            style: styling(color: Colors.grey[600]),
                          ),
                        ),
                      )
                    else ...[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartState.items.length,
                        itemBuilder: (context, index) {
                          final item = cartState.items[index];
                          if (item.price <= 0 || item.quantity <= 0) {
                            return const SizedBox.shrink();
                          }
                          final basePrice = item.price * item.quantity;
                          final maxDiscountPercent =
                              _calculateMaxDiscount(item);
                          final effectivePrice =
                              basePrice * (1 - maxDiscountPercent / 100);

                          return _buildItemRow(
                            item,
                            basePrice,
                            effectivePrice,
                            maxDiscountPercent,
                          );
                        },
                      ),
                      const Divider(height: 24),
                      _buildPriceRow('Subtotal', prices.subtotal),
                      if (prices.totalDiscount > 0)
                        _buildPriceRow(
                          'Total Discount',
                          -prices.totalDiscount,
                          isDiscount: true,
                        ),
                      if (couponState is CouponLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
                        _buildCouponSection(
                            context, prices.subtotal, couponState),
                      if (couponState is CouponApplied)
                        _buildPriceRow(
                          'Coupon Discount (${couponState.coupon.couponCode})',
                          couponState.discountAmount,
                          isDiscount: true,
                        ),
                      _buildPriceRow('Shipping Charge', shippingCharge),
                      const Divider(height: 24),
                      _buildPriceRow(
                        'Total Amount',
                        prices.subtotal -
                            prices.totalDiscount -
                            (couponState is CouponApplied
                                ? couponState.discountAmount
                                : 0) +
                            shippingCharge,
                        isTotal: true,
                      ),
                    ],
                  ],
                ),
              );
            }

            return const Center(
              child: Text('Something went wrong'),
            );
          },
        );
      },
    );
  }

  Widget _buildCouponSection(
    BuildContext context,
    double subtotal,
    CouponState couponState,
  ) {
    print('🏷️ Building coupon section');
    print('Current coupon state: ${couponState.runtimeType}');

    if (couponState is CouponApplied) {
      print('✅ Coupon applied:');
      print('   - Code: ${couponState.coupon.couponCode}');
      print('   - Discount: ${couponState.coupon.discount}%');
      print('   - Amount: ${couponState.discountAmount}');
    }
    final TextEditingController couponController = TextEditingController();

    final cartState = context.watch<CartBloc>().state;
    final List<CartItem> cartItems =
        (cartState is CartLoadedState) ? cartState.items : [];

    if (couponState is CouponApplied) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coupon Applied (${couponState.coupon.couponCode})',
                      style: styling(),
                    ),
                    if (couponState.coupon.parentCategoryId != null ||
                        couponState.coupon.subCategoryId != null)
                      Text(
                        'Applies to specific categories only',
                        style: styling(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.red),
                onPressed: () =>
                    context.read<CouponBloc>().add(RemoveCouponEvent()),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: couponController,
            decoration: InputDecoration(
              hintText: 'Enter coupon code',
              suffixIcon: TextButton(
                onPressed: () {
                  if (couponController.text.isNotEmpty) {
                    context.read<CouponBloc>().add(
                          ApplyCouponEvent(
                            couponCode: couponController.text,
                            cartItems: cartItems,
                          ),
                        );
                  }
                },
                child: const Text('Apply'),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () => _showAvailableCoupons(context, cartItems),
          icon: const Icon(Icons.local_offer),
          label: const Text('View Available Coupons'),
        ),
        if (couponState is CouponError)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              couponState.message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  void _showAvailableCoupons(BuildContext context, List<CartItem> cartItems) {
    final couponBloc = context.read<CouponBloc>();
    couponBloc.add(LoadAvailableCouponsEvent());

    showModalBottomSheet(
      context: context,
      builder: (context) => BlocProvider.value(
        value: couponBloc,
        child: BlocBuilder<CouponBloc, CouponState>(
          builder: (context, state) {
            if (state is CouponLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AvailableCouponsLoaded) {
              if (state.coupons.isEmpty) {
                return const Center(child: Text('No coupons available'));
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: state.coupons.length,
                  itemBuilder: (context, index) {
                    final coupon = state.coupons[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: BeveledRectangleBorder(),
                        child: ListTile(
                          title: Text(
                            coupon.couponCode,
                            style: headerStyling(
                              color: const Color.fromARGB(255, 182, 38, 28),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${coupon.discount}% off',
                                style: styling(),
                              ),
                              if (coupon.parentCategoryId != null ||
                                  coupon.subCategoryId != null)
                                Text(
                                  'Category-specific discount',
                                  style: styling(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                          trailing: Text(
                            'Valid till: ${coupon.validTo.toString().split(' ')[0]}',
                            style: styling(),
                          ),
                          onTap: () {
                            context.read<CouponBloc>().add(
                                  ApplyCouponEvent(
                                    couponCode: coupon.couponCode,
                                    cartItems: cartItems,
                                  ),
                                );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const Center(child: Text('Failed to load coupons'));
          },
        ),
      ),
    );
  }

  Widget _buildItemRow(
    CartItem item,
    double basePrice,
    double effectivePrice,
    double discountPercent,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName, style: styling()),
                    Text(
                      'Size: ${item.size} | Color: ${item.color} | Qty: ${item.quantity}',
                      style: styling(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${basePrice.toStringAsFixed(2)}',
                    style: styling(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  Text('₹${effectivePrice.toStringAsFixed(2)}',
                      style: styling()),
                ],
              ),
            ],
          ),
          if (discountPercent > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${discountPercent.toStringAsFixed(0)}% OFF',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: styling(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            isDiscount
                ? '-₹${amount.abs().toStringAsFixed(2)}'
                : '₹${amount.toStringAsFixed(2)}',
            style: styling(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isDiscount ? Colors.green.shade700 : null,
            ),
          ),
        ],
      ),
    );
  }

  ({double subtotal, double totalDiscount}) _calculatePrices(
    List<CartItem> items,
    CouponState couponState,
  ) {
    double subtotal = 0;
    double totalDiscount = 0;

    for (var item in items) {
      if (item.price <= 0 || item.quantity <= 0) continue;

      final basePrice = item.price * item.quantity;
      subtotal += basePrice;

      final maxDiscountPercent = _calculateMaxDiscount(item);
      final itemDiscount = basePrice * (maxDiscountPercent / 100);
      totalDiscount += itemDiscount;
    }

    return (subtotal: subtotal, totalDiscount: totalDiscount);
  }

  double _calculateMaxDiscount(CartItem item) {
    return [
      item.percentDiscount,
      item.categoryOffer,
      item.product?.offer ?? 0.0
    ].reduce((a, b) => a > b ? a : b);
  }
}
