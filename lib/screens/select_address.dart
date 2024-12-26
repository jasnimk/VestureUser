import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_bloc.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_state.dart';
import 'package:vesture_firebase_user/widgets/details_widgets.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class AddressSelectionPage extends StatefulWidget {
  final String? selectedAddressId;

  const AddressSelectionPage({super.key, this.selectedAddressId});

  @override
  State<AddressSelectionPage> createState() => _AddressSelectionPageState();
}

class _AddressSelectionPageState extends State<AddressSelectionPage> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedAddressId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Address'),
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressLoaded) {
            if (state.addresses.isEmpty) {
              buildEmptyStateWidget(message: 'No ADRESSES ADDED!');
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.addresses.length,
              itemBuilder: (context, index) {
                final address = state.addresses[index];
                final name = address['name'] ?? 'Unknown';
                final houseName = address['houseName'] ?? '';
                final locality = address['locality'] ?? '';
                final district = address['district'] ?? '';
                final city = address['city'] ?? '';
                final stateName = address['state'] ?? '';
                final pincode = address['pincode'] ?? '';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: RadioListTile<String>(
                    title: Text(
                      name,
                      style: headerStyling(),
                    ),
                    subtitle: Text(
                      '$houseName\n$locality\n$district, $city\n$stateName - $pincode',
                      style: styling(height: 1.5),
                    ),
                    value: address['id'] as String,
                    groupValue: _selectedId,
                    onChanged: (value) {
                      setState(() {
                        _selectedId = value;
                      });
                      Navigator.pop(context, value);
                    },
                  ),
                );
              },
            );
          } else if (state is AddressLoading) {
            return buildLoadingIndicator(context: context);
          } else if (state is AddressError) {
            return Center(
              child: Text('Failed to load addresses: ${state.message}'),
            );
          }

          return const Center(
            child: Text('Unexpected state.'),
          );
        },
      ),
    );
  }
}
