// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_bloc.dart';
// // import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_state.dart';
// // import 'package:vesture_firebase_user/bloc/address/bloc/adress_bloc.dart';
// // import 'package:vesture_firebase_user/bloc/address/bloc/adress_state.dart';
// // import 'package:vesture_firebase_user/screens/address_page.dart';
// // import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
// // import 'package:vesture_firebase_user/widgets/custom_button.dart';
// // import 'package:vesture_firebase_user/widgets/textwidget.dart';

// // class CheckoutScreen extends StatefulWidget {
// //   const CheckoutScreen({super.key});

// //   @override
// //   State<CheckoutScreen> createState() => _CheckoutScreenState();
// // }

// // class _CheckoutScreenState extends State<CheckoutScreen> {
// //   String _selectedPaymentMethod = 'cod';
// //   final double _shippingCharge = 60.0;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: buildCustomAppBar(
// //         context: context,
// //         title: 'Checkout',
// //       ),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _buildAddressSection(),
// //               const SizedBox(height: 24),
// //               _buildPaymentMethodSection(),
// //               const SizedBox(height: 24),
// //               _buildOrderSummary(),
// //             ],
// //           ),
// //         ),
// //       ),
// //       bottomNavigationBar: _buildBottomBar(),
// //     );
// //   }

// //   Widget _buildAddressSection() {
// //     return BlocBuilder<AddressBloc, AddressState>(
// //       builder: (context, state) {
// //         if (state is AddressLoaded) {
// //           final selectedAddress =
// //               state.addresses.isNotEmpty ? state.addresses[0] : null;

// //           return Container(
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               border: Border.all(color: Colors.grey.shade300),
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     const Text(
// //                       'Delivery Address',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     TextButton(
// //                       onPressed: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (_) => const ShippingAddressesPage(),
// //                           ),
// //                         );
// //                       },
// //                       child: const Text('Change'),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 8),
// //                 if (selectedAddress != null) ...[
// //                   Text(
// //                     selectedAddress['name'] ?? '',
// //                     style: const TextStyle(fontWeight: FontWeight.w500),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     '${selectedAddress['houseName']}, ${selectedAddress['locality']}\n'
// //                     '${selectedAddress['district']}, ${selectedAddress['city']}\n'
// //                     '${selectedAddress['state']} - ${selectedAddress['pincode']}\n'
// //                     'Phone: ${selectedAddress['phone']}',
// //                     style: const TextStyle(color: Colors.grey),
// //                   ),
// //                 ] else
// //                   const Text(
// //                     'No address selected. Please add an address.',
// //                     style: TextStyle(color: Colors.red),
// //                   ),
// //               ],
// //             ),
// //           );
// //         }
// //         return const Center(child: CircularProgressIndicator());
// //       },
// //     );
// //   }

// //   Widget _buildPaymentMethodSection() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         border: Border.all(color: Colors.grey.shade300),
// //         borderRadius: BorderRadius.circular(1),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text('Payment Method', style: headerStyling()),
// //           const SizedBox(height: 16),
// //           RadioListTile(
// //             title: Text(
// //               'Cash on Delivery',
// //               style: styling(),
// //             ),
// //             value: 'cod',
// //             groupValue: _selectedPaymentMethod,
// //             onChanged: (value) {
// //               setState(() {
// //                 _selectedPaymentMethod = value.toString();
// //               });
// //             },
// //           ),
// //           RadioListTile(
// //             title: Text(
// //               'Razorpay',
// //               style: styling(),
// //             ),
// //             value: 'razorpay',
// //             groupValue: _selectedPaymentMethod,
// //             onChanged: (value) {
// //               setState(() {
// //                 _selectedPaymentMethod = value.toString();
// //               });
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildOrderSummary() {
// //     return BlocBuilder<CartBloc, CartState>(
// //       builder: (context, state) {
// //         if (state is CartLoadedState) {
// //           final totalBasePrice = state.items.fold<double>(
// //             0,
// //             (sum, item) => sum + (item.price * item.quantity),
// //           );

// //           final totalDiscount = state.items.fold<double>(
// //             0,
// //             (sum, item) =>
// //                 sum +
// //                 ((item.price * item.percentDiscount / 100) * item.quantity),
// //           );

// //           final finalAmount = totalBasePrice - totalDiscount + _shippingCharge;

// //           return Container(
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               border: Border.all(color: Colors.grey.shade300),
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text(
// //                   'Order Summary',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 _buildSummaryRow(
// //                   'Items (${state.items.length})',
// //                   '₹${totalBasePrice.toStringAsFixed(2)}',
// //                 ),
// //                 if (totalDiscount > 0)
// //                   _buildSummaryRow(
// //                     'Discount',
// //                     '-₹${totalDiscount.toStringAsFixed(2)}',
// //                     valueColor: Colors.green,
// //                   ),
// //                 _buildSummaryRow(
// //                   'Shipping',
// //                   '₹${_shippingCharge.toStringAsFixed(2)}',
// //                 ),
// //                 const Divider(height: 24),
// //                 _buildSummaryRow(
// //                   'Total Amount',
// //                   '₹${finalAmount.toStringAsFixed(2)}',
// //                   isBold: true,
// //                 ),
// //               ],
// //             ),
// //           );
// //         }
// //         return const Center(child: CircularProgressIndicator());
// //       },
// //     );
// //   }

// // Widget _buildSummaryRow(
// //   String label,
// //   String value, {
// //   bool isBold = false,
// //   Color? valueColor,
// // }) {
// //   return Padding(
// //     padding: const EdgeInsets.symmetric(vertical: 4),
// //     child: Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(
// //           label,
// //           style: TextStyle(
// //             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
// //           ),
// //         ),
// //         Text(
// //           value,
// //           style: TextStyle(
// //             color: valueColor,
// //             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
// //           ),
// //         ),
// //       ],
// //     ),
// //   );
// // }

// //   Widget _buildBottomBar() {
// //     return Container(
// //         padding: EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.grey.withValues(),
// //               blurRadius: 10,
// //               offset: const Offset(0, -5),
// //             ),
// //           ],
// //         ),
// //         child: customButton(
// //             context: context,
// //             text: 'Place Order',
// //             onPressed: () {},
// //             height: 50));
// //   }

// //   void _handlePlaceOrder() {
// //     // TODO: Implement order placement logic
// //     // 1. Validate address is selected
// //     // 2. Handle payment based on selected method
// //     // 3. Create order in Firestore
// //     // 4. Clear cart
// //     // 5. Navigate to order confirmation
// //   }
// // }
// // Modified CheckoutScreen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/bloc/address/bloc/adress_event.dart';
// import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_bloc.dart';
// import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_state.dart';
// import 'package:vesture_firebase_user/bloc/address/bloc/adress_bloc.dart';
// import 'package:vesture_firebase_user/bloc/address/bloc/adress_state.dart';
// import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_bloc.dart';
// import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_event.dart';
// import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_state.dart';
// import 'package:vesture_firebase_user/screens/select_address.dart';
// import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
// import 'package:vesture_firebase_user/widgets/custom_button.dart';
// import 'package:vesture_firebase_user/widgets/textwidget.dart';

// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   String _selectedPaymentMethod = 'cod';
//   String? _selectedAddressId;
//   final double _shippingCharge = 60.0;

//   @override
//   void initState() {
//     super.initState();
//     // Load addresses when screen initializes
//     context.read<AddressBloc>().add(AddressLoadEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildCustomAppBar(
//         context: context,
//         title: 'Checkout',
//       ),
//       body: BlocListener<CheckoutBloc, CheckoutState>(
//         listener: (context, state) {
//           if (state is CheckoutSuccess) {
//             // Navigate to order success screen
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Order placed successfully!')),
//             );
//             // Clear cart and navigate
//             Navigator.of(context).pushReplacementNamed('/order-success');
//           } else if (state is CheckoutError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildAddressSection(),
//                 const SizedBox(height: 24),
//                 _buildPaymentMethodSection(),
//                 const SizedBox(height: 24),
//                 _buildOrderSummary(),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildBottomBar(),
//     );
//   }

//   Widget _buildSummaryRow(
//     String label,
//     String value, {
//     bool isBold = false,
//     Color? valueColor,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               color: valueColor,
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderSummary() {
//     return BlocBuilder<CartBloc, CartState>(
//       builder: (context, state) {
//         if (state is CartLoadedState) {
//           final totalBasePrice = state.items.fold<double>(
//             0,
//             (sum, item) => sum + (item.price * item.quantity),
//           );

//           final totalDiscount = state.items.fold<double>(
//             0,
//             (sum, item) =>
//                 sum +
//                 ((item.price * item.percentDiscount / 100) * item.quantity),
//           );

//           final finalAmount = totalBasePrice - totalDiscount + _shippingCharge;

//           return Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Order Summary',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 _buildSummaryRow(
//                   'Items (${state.items.length})',
//                   '₹${totalBasePrice.toStringAsFixed(2)}',
//                 ),
//                 if (totalDiscount > 0)
//                   _buildSummaryRow(
//                     'Discount',
//                     '-₹${totalDiscount.toStringAsFixed(2)}',
//                     valueColor: Colors.green,
//                   ),
//                 _buildSummaryRow(
//                   'Shipping',
//                   '₹${_shippingCharge.toStringAsFixed(2)}',
//                 ),
//                 const Divider(height: 24),
//                 _buildSummaryRow(
//                   'Total Amount',
//                   '₹${finalAmount.toStringAsFixed(2)}',
//                   isBold: true,
//                 ),
//               ],
//             ),
//           );
//         }
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//   }

//   Widget _buildAddressSection() {
//     return BlocBuilder<AddressBloc, AddressState>(
//       builder: (context, state) {
//         if (state is AddressLoaded) {
//           // Set default address if none selected
//           if (_selectedAddressId == null && state.addresses.isNotEmpty) {
//             _selectedAddressId = state.addresses[0]['id'];
//           }

//           final selectedAddress = state.addresses.firstWhere(
//             (addr) => addr['id'] == _selectedAddressId,
//             orElse: () => state.addresses.isNotEmpty ? state.addresses[0] : {},
//           );

//           return Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Delivery Address',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () async {
//                         final selectedAddr = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => AddressSelectionPage(
//                               selectedAddressId: _selectedAddressId,
//                             ),
//                           ),
//                         );
//                         if (selectedAddr != null) {
//                           setState(() {
//                             _selectedAddressId = selectedAddr;
//                           });
//                         }
//                       },
//                       child: const Text('Change'),
//                     ),
//                   ],
//                 ),
//                 if (selectedAddress.isNotEmpty) ...[
//                   Text(
//                     selectedAddress['name'] ?? '',
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${selectedAddress['houseName']}, ${selectedAddress['locality']}\n'
//                     '${selectedAddress['district']}, ${selectedAddress['city']}\n'
//                     '${selectedAddress['state']} - ${selectedAddress['pincode']}\n'
//                     'Phone: ${selectedAddress['phone']}',
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 ] else
//                   const Text(
//                     'No address selected. Please add an address.',
//                     style: TextStyle(color: Colors.red),
//                   ),
//               ],
//             ),
//           );
//         }
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//   }

//   Widget _buildPaymentMethodSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Payment Method', style: headerStyling()),
//           const SizedBox(height: 16),
//           RadioListTile(
//             title: Text(
//               'Cash on Delivery',
//               style: styling(),
//             ),
//             value: 'cod',
//             groupValue: _selectedPaymentMethod,
//             onChanged: (value) {
//               setState(() {
//                 _selectedPaymentMethod = value.toString();
//               });
//             },
//           ),
//           RadioListTile(
//             title: Text(
//               'Razorpay',
//               style: styling(),
//             ),
//             value: 'razorpay',
//             groupValue: _selectedPaymentMethod,
//             onChanged: (value) {
//               setState(() {
//                 _selectedPaymentMethod = value.toString();
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _handlePlaceOrder() {
//     final cartState = context.read<CartBloc>().state;
//     if (cartState is CartLoadedState && _selectedAddressId != null) {
//       final totalBasePrice = cartState.items.fold<double>(
//         0,
//         (sum, item) => sum + (item.price * item.quantity),
//       );

//       final totalDiscount = cartState.items.fold<double>(
//         0,
//         (sum, item) =>
//             sum + ((item.price * item.percentDiscount / 100) * item.quantity),
//       );

//       final finalAmount = totalBasePrice - totalDiscount + _shippingCharge;

//       context.read<CheckoutBloc>().add(
//             InitiateCheckoutEvent(
//               addressId: _selectedAddressId!,
//               items: cartState.items,
//               totalAmount: finalAmount,
//               paymentMethod: _selectedPaymentMethod,
//             ),
//           );
//     }
//   }

//   Widget _buildBottomBar() {
//     return Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withValues(),
//               blurRadius: 10,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         child: customButton(
//             context: context,
//             text: 'Place Order',
//             onPressed: () {},
//             height: 50));
//   }
// }
