import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_state.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_bloc.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_state.dart';
import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_state.dart';
import 'package:vesture_firebase_user/models/cart_item.dart';
import 'package:vesture_firebase_user/repository/stripe_repo.dart';
import 'package:vesture_firebase_user/screens/select_address.dart';
import 'package:vesture_firebase_user/screens/success.dart';
import 'package:vesture_firebase_user/widgets/checkout_widget.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/details_widgets.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'cod';
  String? _selectedAddressId;
  final double _shippingCharge = 60.0;
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(AddressLoadEvent());
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context: context,
        title: 'Checkout',
      ),
      body: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            setState(() => _isPlacingOrder = false);
            context.read<CartBloc>().add(ClearCartEvent());
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => SuccessScreen()),
            );
          } else if (state is CheckoutError) {
            setState(() => _isPlacingOrder = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is CheckoutLoading) {
            setState(() => _isPlacingOrder = true);
          } else if (state is PaymentProcessing) {
            setState(() => _isPlacingOrder = true);
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddressSection(),
                    const SizedBox(height: 24),
                    _buildPaymentMethodSection(),
                    const SizedBox(height: 24),
                    _buildOrderSummary(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            if (_isPlacingOrder) buildLoadingIndicator(context: context)
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAddressSection() {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        if (state is AddressLoaded) {
          if (_selectedAddressId == null && state.addresses.isNotEmpty) {
            _selectedAddressId = state.addresses[0]['id'];
          }

          final selectedAddress = state.addresses.firstWhere(
            (addr) => addr['id'] == _selectedAddressId,
            orElse: () => state.addresses.isNotEmpty ? state.addresses[0] : {},
          );

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Address',
                      style: headerStyling(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final selectedAddr = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddressSelectionPage(
                              selectedAddressId: _selectedAddressId,
                            ),
                          ),
                        );
                        if (selectedAddr != null) {
                          setState(() {
                            _selectedAddressId = selectedAddr;
                          });
                        }
                      },
                      child: const Text('Change'),
                    ),
                  ],
                ),
                if (selectedAddress.isNotEmpty) ...[
                  Text(
                    selectedAddress['name'] ?? '',
                    style: styling(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${selectedAddress['houseName']}, ${selectedAddress['locality']}\n'
                    '${selectedAddress['district']}, ${selectedAddress['city']}\n'
                    '${selectedAddress['state']} - ${selectedAddress['pincode']}\n'
                    'Phone: ${selectedAddress['phone']}',
                    style: styling(color: Colors.grey),
                  ),
                ] else
                  Text(
                    'No address selected. Please add an address.',
                    style: subHeaderStyling(color: Colors.red),
                  ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Method', style: headerStyling()),
          const SizedBox(height: 16),
          RadioListTile(
            title: Text(
              'Cash on Delivery',
              style: styling(),
            ),
            value: 'cod',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text(
              'Pay Online',
              style: styling(),
            ),
            value: 'stripe',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value.toString();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: customButton(
        context: context,
        text: 'Place Order',
        onPressed: () {
          if (!_isPlacingOrder) {
            _handlePlaceOrder();
          }
        },
        height: 50,
      ),
    );
  }

  Widget _buildOrderSummary() {
    return EnhancedOrderSummary(shippingCharge: _shippingCharge);
  }

  void _handlePlaceOrder() async {
    if (_isPlacingOrder) return;

    if (_selectedAddressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    final cartState = context.read<CartBloc>().state;
    if (cartState is CartLoadedState) {
      double subtotal = 0;
      double totalDiscount = 0;

      for (var item in cartState.items) {
        if (item.price <= 0 || item.quantity <= 0) {
          continue;
        }

        final basePrice = item.price * item.quantity;
        subtotal += basePrice;

        final maxDiscountPercent = calculateMaxDiscount(item);
        final itemDiscount = basePrice * (maxDiscountPercent / 100);
        totalDiscount += itemDiscount;
      }

      final finalAmount = subtotal - totalDiscount + _shippingCharge;

      if (_selectedPaymentMethod == 'cod') {
        context.read<CheckoutBloc>().add(
              InitiateCheckoutEvent(
                addressId: _selectedAddressId!,
                items: cartState.items,
                totalAmount: finalAmount,
                paymentMethod: 'cod',
              ),
            );
      } else if (_selectedPaymentMethod == 'stripe') {
        context.read<CheckoutBloc>().add(InitiateCheckoutEvent(
              addressId: _selectedAddressId!,
              paymentMethod: 'stripe',
              items: cartState.items,
              totalAmount: finalAmount,
            ));

        await StripeService.instance
            .makePayment(amount: finalAmount, context: context);
      }
    }
  }

  double calculateMaxDiscount(CartItem item) {
    return [
      item.percentDiscount,
      item.categoryOffer,
      item.product?.offer ?? 0.0
    ].reduce((a, b) => a > b ? a : b);
  }
}
