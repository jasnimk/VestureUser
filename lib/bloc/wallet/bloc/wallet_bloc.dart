import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/wallet/bloc/wallet_event.dart';
import 'package:vesture_firebase_user/bloc/wallet/bloc/wallet_state.dart';
import 'package:vesture_firebase_user/models/wallet_model.dart';
import 'package:vesture_firebase_user/repository/wallet_repo.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository _walletRepository;

  WalletBloc({required WalletRepository walletRepository})
      : _walletRepository = walletRepository,
        super(WalletInitial()) {
    on<LoadWallet>(_onLoadWallet);
    on<AddToWallet>(_onAddToWallet);
  }

  void _onLoadWallet(LoadWallet event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    await _walletRepository.createWallet();
    await emit.forEach(
      _walletRepository.getWallet(),
      onData: (WalletModel wallet) {
        print("Wallet Loaded: ${wallet.transactions}");
        return WalletLoaded(wallet);
      },
      onError: (error, stackTrace) => WalletError(error.toString()),
    );
  }

  void _onAddToWallet(AddToWallet event, Emitter<WalletState> emit) async {
    try {
      await _walletRepository.addToWallet(
        event.amount,
        event.description,
        event.orderId,
      );
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }
}
