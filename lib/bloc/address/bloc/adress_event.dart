abstract class AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final Map<String, dynamic> addressData;

  AddAddressEvent(this.addressData);
}

class AddressLoadEvent extends AddressEvent {}

class UpdateAddressEvent extends AddressEvent {
  final String addressId;
  final Map<String, dynamic> addressData;

  UpdateAddressEvent(this.addressId, this.addressData);
}

class DeleteAddressEvent extends AddressEvent {
  final String addressId;

  DeleteAddressEvent(this.addressId);
}
