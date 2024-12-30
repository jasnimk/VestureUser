import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vesture_firebase_user/bloc/wallet/bloc/wallet_bloc.dart';
import 'package:vesture_firebase_user/bloc/wallet/bloc/wallet_event.dart';
import 'package:vesture_firebase_user/bloc/wallet/bloc/wallet_state.dart';
import 'package:vesture_firebase_user/models/wallet_model.dart';
import 'package:vesture_firebase_user/repository/wallet_repo.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc(
        // Pass a new instance directly instead of using context.read()
        walletRepository: WalletRepository(),
      )..add(LoadWallet()),
      child: const WalletView(),
    );
  }
}

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
        elevation: 0,
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state is WalletLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WalletError) {
            return Center(child: Text(state.message));
          }

          if (state is WalletLoaded) {
            return _WalletContent(wallet: state.wallet);
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}

class _WalletContent extends StatelessWidget {
  final WalletModel wallet;

  const _WalletContent({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<WalletBloc>().add(LoadWallet());
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _WalletBalanceCard(balance: wallet.balance),
          ),
          const SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Transaction History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (wallet.transactions.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text('No transactions yet'),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final transaction = wallet.transactions[index];
                  return _TransactionCard(transaction: transaction);
                },
                childCount: wallet.transactions.length,
              ),
            ),
        ],
      ),
    );
  }
}

class _WalletBalanceCard extends StatelessWidget {
  final double balance;

  const _WalletBalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.red, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Balance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type.toLowerCase() == 'credit';
    final amountColor = isCredit ? Colors.green : Colors.red;
    final amountPrefix = isCredit ? '+' : '-';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          transaction.description,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy hh:mm a').format(transaction.timestamp),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: Text(
          '$amountPrefix₹${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
