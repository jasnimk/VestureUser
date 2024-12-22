import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_bloc.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_event.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_state.dart';
import 'package:vesture_firebase_user/screens/add_address.dart';
import 'package:vesture_firebase_user/widgets/confirmation_dialog.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/custom_snackbar.dart';
import 'package:vesture_firebase_user/widgets/details_widgets.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class ShippingAddressesPage extends StatelessWidget {
  const ShippingAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Addresses'),
        elevation: 0,
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressError) {
            CustomSnackBar.show(
              context,
              message: state.message,
              textColor: Colors.white,
            );
          }
          if (state is AddressDeleted) {
            CustomSnackBar.show(
              context,
              message: 'Address Deleted Succesfully!',
              textColor: Colors.white,
            );
          }
        },
        builder: (context, state) {
          if (state is AddressInitial) {
            context.read<AddressBloc>().add(AddressLoadEvent());
            return buildLoadingIndicator(context: context);
          }

          if (state is AddressLoading) {
            return buildLoadingIndicator(context: context);
          }

          if (state is AddressLoaded || state is AddressUpdated) {
            final addresses = (state is AddressLoaded)
                ? state.addresses
                : (state as AddressUpdated).addresses;

            if (addresses.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No addresses found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final address = addresses[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  shadowColor: Color.fromRGBO(196, 28, 13, 0.829),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              address['name'] ?? '',
                              style: styling(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  fontFamily: 'Poppins-SemiBold'),
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: const Text('Edit'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddAddressForm(
                                          addressData: address,
                                          isEditing: true,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                PopupMenuItem(
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onTap: () {
                                    Future.delayed(
                                      const Duration(milliseconds: 200),
                                      () => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ConfirmationDialog(
                                          title: 'Delete Address',
                                          content:
                                              'Are you sure you want to delete this address?',
                                          onConfirm: () {
                                            context.read<AddressBloc>().add(
                                                  DeleteAddressEvent(
                                                      address['id']),
                                                );
                                          },
                                          onCancel: () {},
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(
                          '${address['houseName']}\n'
                          '${address['locality']}\n'
                          '${address['district']}, ${address['city']}\n'
                          '${address['state']} - ${address['pincode']}',
                          style: styling(height: 1.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Phone: ${address['phone']}',
                          style: styling(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Something went wrong'),
                  const SizedBox(height: 16),
                  customButton(
                      onPressed: () {
                        context.read<AddressBloc>().add(AddressLoadEvent());
                      },
                      context: context,
                      text: 'Retry',
                      height: 50),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddAddressForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/bloc/address/bloc/adress_bloc.dart';
// import 'package:vesture_firebase_user/bloc/address/bloc/adress_event.dart';
// import 'package:vesture_firebase_user/bloc/address/bloc/adress_state.dart';
// import 'package:vesture_firebase_user/screens/add_address.dart';
// import 'package:vesture_firebase_user/widgets/confirmation_dialog.dart';
// import 'package:vesture_firebase_user/widgets/custom_button.dart';
// import 'package:vesture_firebase_user/widgets/custom_snackbar.dart';
// import 'package:vesture_firebase_user/widgets/details_widgets.dart';
// import 'package:vesture_firebase_user/widgets/textwidget.dart';

// class ShippingAddressesPage extends StatefulWidget {
//   const ShippingAddressesPage({super.key});

//   @override
//   State<ShippingAddressesPage> createState() => _ShippingAddressesPageState();
// }

// class _ShippingAddressesPageState extends State<ShippingAddressesPage> {
//   String? selectedAddressId;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Shipping Addresses'),
//         elevation: 0,
//       ),
//       body: BlocConsumer<AddressBloc, AddressState>(
//         listener: (context, state) {
//           if (state is AddressError) {
//             CustomSnackBar.show(
//               context,
//               message: state.message,
//               textColor: Colors.white,
//             );
//           }
//           if (state is AddressDeleted) {
//             CustomSnackBar.show(
//               context,
//               message: 'Address Deleted Successfully!',
//               textColor: Colors.white,
//             );
//             // Since the address is deleted, we'll clear the selection
//             setState(() {
//               selectedAddressId = null;
//             });
//           }
//         },
//         builder: (context, state) {
//           if (state is AddressInitial) {
//             context.read<AddressBloc>().add(AddressLoadEvent());
//             return buildLoadingIndicator(context: context);
//           }

//           if (state is AddressLoading) {
//             return buildLoadingIndicator(context: context);
//           }

//           if (state is AddressLoaded || state is AddressUpdated) {
//             final addresses = (state is AddressLoaded)
//                 ? state.addresses
//                 : (state as AddressUpdated).addresses;

//             if (addresses.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.location_off_outlined,
//                       size: 64,
//                       color: Colors.grey[400],
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'No addresses found',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             return ListView.separated(
//               padding: const EdgeInsets.all(16),
//               itemCount: addresses.length,
//               separatorBuilder: (context, index) => const SizedBox(height: 12),
//               itemBuilder: (context, index) {
//                 final address = addresses[index];
//                 final isSelected = selectedAddressId == address['id'];

//                 return Card(
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(0),
//                   ),
//                   shadowColor: const Color.fromRGBO(196, 28, 13, 0.829),
//                   child: InkWell(
//                     onTap: () {
//                       setState(() {
//                         selectedAddressId = isSelected ? null : address['id'];
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Checkbox
//                           Padding(
//                             padding:
//                                 const EdgeInsets.only(right: 16.0, top: 4.0),
//                             child: Checkbox(
//                               value: isSelected,
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   selectedAddressId =
//                                       value! ? address['id'] : null;
//                                 });
//                               },
//                             ),
//                           ),
//                           // Address content
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       address['name'] ?? '',
//                                       style: styling(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 19,
//                                         fontFamily: 'Poppins-SemiBold',
//                                       ),
//                                     ),
//                                     PopupMenuButton(
//                                       itemBuilder: (context) => [
//                                         PopupMenuItem(
//                                           child: const Text('Edit'),
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (_) => AddAddressForm(
//                                                   addressData: address,
//                                                   isEditing: true,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                         PopupMenuItem(
//                                           child: const Text(
//                                             'Delete',
//                                             style: TextStyle(color: Colors.red),
//                                           ),
//                                           onTap: () {
//                                             Future.delayed(
//                                               const Duration(milliseconds: 200),
//                                               () => showDialog(
//                                                 context: context,
//                                                 builder: (context) =>
//                                                     ConfirmationDialog(
//                                                   title: 'Delete Address',
//                                                   content:
//                                                       'Are you sure you want to delete this address?',
//                                                   onConfirm: () {
//                                                     // Clear selection if deleting selected address
//                                                     if (selectedAddressId ==
//                                                         address['id']) {
//                                                       setState(() {
//                                                         selectedAddressId =
//                                                             null;
//                                                       });
//                                                     }
//                                                     context
//                                                         .read<AddressBloc>()
//                                                         .add(
//                                                           DeleteAddressEvent(
//                                                               address['id']),
//                                                         );
//                                                   },
//                                                   onCancel: () {},
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const Divider(height: 24),
//                                 Text(
//                                   '${address['houseName']}\n'
//                                   '${address['locality']}\n'
//                                   '${address['district']}, ${address['city']}\n'
//                                   '${address['state']} - ${address['pincode']}',
//                                   style: styling(height: 1.5),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Phone: ${address['phone']}',
//                                   style: styling(
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('Something went wrong'),
//                   const SizedBox(height: 16),
//                   customButton(
//                     onPressed: () {
//                       context.read<AddressBloc>().add(AddressLoadEvent());
//                     },
//                     context: context,
//                     text: 'Retry',
//                     height: 50,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const AddAddressForm(),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
