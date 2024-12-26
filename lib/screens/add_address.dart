import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_bloc.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_event.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_state.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/details_widgets.dart';
import 'package:vesture_firebase_user/widgets/textform.dart';

class AddAddressForm extends StatefulWidget {
  final Map<String, dynamic>? addressData;
  final bool isEditing;

  const AddAddressForm({
    super.key,
    this.addressData,
    this.isEditing = false,
  });

  @override
  _AddAddressFormState createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.addressData != null) {
      _nameController.text = widget.addressData!['name'] ?? '';
      _contactController.text = widget.addressData!['phone'] ?? '';
      _pincodeController.text = widget.addressData!['pincode'] ?? '';
      _stateController.text = widget.addressData!['state'] ?? '';
      _cityController.text = widget.addressData!['city'] ?? '';
      _districtController.text = widget.addressData!['district'] ?? '';
      _addressController.text = widget.addressData!['houseName'] ?? '';
      _localityController.text = widget.addressData!['locality'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _pincodeController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    _localityController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return CustomTextFormField(
      controller: controller,
      labelText: labelText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressLoading) {
            return buildLoadingIndicator(context: context);
          } else if (state is AddressSubmitted) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Address saved successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AddressError) {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Add New Address')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextFormField(
                      controller: _nameController,
                      labelText: 'Name',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your name'
                          : null,
                    ),
                    _buildTextFormField(
                      controller: _contactController,
                      labelText: 'Mobile Number',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a contact number';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Please enter a valid 10-digit mobile number';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            controller: _pincodeController,
                            labelText: 'Pincode',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a pincode';
                              }
                              if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                                return 'Please enter a valid 6-digit pincode';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextFormField(
                            controller: _stateController,
                            labelText: 'State',
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter state'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            controller: _cityController,
                            labelText: 'City',
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter city'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: customButton(
                            context: context,
                            text: 'Use My Location',
                            onPressed: () {},
                            icon: FontAwesomeIcons.locationCrosshairs,
                            height: 50,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    _buildTextFormField(
                      controller: _districtController,
                      labelText: 'District',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter district'
                          : null,
                    ),
                    _buildTextFormField(
                      controller: _addressController,
                      labelText: 'House Name',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter house name'
                          : null,
                    ),
                    _buildTextFormField(
                      controller: _localityController,
                      labelText: 'Locality Name',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter locality name'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    customButton(
                      context: context,
                      text:
                          widget.isEditing ? 'Update Address' : 'Save Address',
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final addressData = {
                            'name': _nameController.text,
                            'phone': _contactController.text,
                            'pincode': _pincodeController.text,
                            'state': _stateController.text,
                            'city': _cityController.text,
                            'district': _districtController.text,
                            'houseName': _addressController.text,
                            'locality': _localityController.text,
                          };

                          if (widget.isEditing && widget.addressData != null) {
                            context.read<AddressBloc>().add(
                                  UpdateAddressEvent(
                                    widget.addressData!['id'],
                                    addressData,
                                  ),
                                );
                          } else {
                            context
                                .read<AddressBloc>()
                                .add(AddAddressEvent(addressData));
                          }
                          Navigator.pop(context);
                        }
                      },
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
