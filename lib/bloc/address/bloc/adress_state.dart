abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressSubmitting extends AddressState {}

class AddressSubmitted extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<Map<String, dynamic>> addresses;

  AddressLoaded(this.addresses);
}

class AddressError extends AddressState {
  final String message;

  AddressError(this.message);
}

class AddressUpdating extends AddressState {}

class AddressUpdated extends AddressState {
  final List<Map<String, dynamic>> addresses;

  AddressUpdated(this.addresses);
}

class AddressDeleting extends AddressState {}

class AddressDeleted extends AddressState {}
