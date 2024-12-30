import 'package:vesture_firebase_user/models/wallet_model.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletModel wallet;

  WalletLoaded(this.wallet);
}

class WalletError extends WalletState {
  final String message;

  WalletError(this.message);
}
