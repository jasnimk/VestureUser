import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_event.dart';
import 'package:vesture_firebase_user/bloc/address/bloc/adress_state.dart';
import 'package:vesture_firebase_user/repository/address_repo.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final String userId;
  final AddressRepository _addressRepository;

  AddressBloc(this.userId, this._addressRepository) : super(AddressInitial()) {
    on<AddAddressEvent>(_addAddressEvent);
    on<AddressLoadEvent>(_loadAddressEvent);
    on<UpdateAddressEvent>(_updateAddressEvent);
    on<DeleteAddressEvent>(_deleteAddressEvent);
  }

  Future<void> _addAddressEvent(
      AddAddressEvent event, Emitter<AddressState> emit) async {
    try {
      emit(AddressLoading());
      await _addressRepository.addAddress(userId, event.addressData);
      emit(AddressSubmitted());
      add(AddressLoadEvent());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _loadAddressEvent(
      AddressLoadEvent event, Emitter<AddressState> emit) async {
    try {
      emit(AddressLoading());
      // Make sure userId is not empty
      if (userId.isEmpty) {
        emit(AddressError('User ID is not valid'));
        return;
      }
      final addresses = await _addressRepository.loadAddresses(userId);
      if (addresses.isEmpty) {
        emit(AddressLoaded([])); // Emit empty list instead of error
      } else {
        emit(AddressLoaded(addresses));
      }
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _updateAddressEvent(
      UpdateAddressEvent event, Emitter<AddressState> emit) async {
    try {
      emit(AddressLoading());
      await _addressRepository.updateAddress(
          userId, event.addressId, event.addressData);
      add(AddressLoadEvent());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _deleteAddressEvent(
      DeleteAddressEvent event, Emitter<AddressState> emit) async {
    try {
      emit(AddressLoading());
      await _addressRepository.deleteAddress(userId, event.addressId);
      emit(AddressDeleted());
      add(AddressLoadEvent());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
}
