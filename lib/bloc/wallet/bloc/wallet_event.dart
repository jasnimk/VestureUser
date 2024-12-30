abstract class WalletEvent {}

class LoadWallet extends WalletEvent {}

class AddToWallet extends WalletEvent {
  final double amount;
  final String description;
  final String? orderId;

  AddToWallet({
    required this.amount,
    required this.description,
    this.orderId,
  });
}
