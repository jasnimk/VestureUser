// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:vesture_firebase_user/models/wallet_model.dart';

// class WalletRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Create wallet if it doesn't exist
//   Future<void> createWallet() async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('User not logged in');

//     final walletRef = _firestore.collection('wallets').doc(user.uid);
//     final walletDoc = await walletRef.get();

//     if (!walletDoc.exists) {
//       await walletRef.set({
//         'userId': user.uid,
//         'balance': 0.0,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       // Create separate collection for transactions
//       final transactionsRef = _firestore
//           .collection('wallets')
//           .doc(user.uid)
//           .collection('transactions');

//       // Add initial transaction
//       await transactionsRef.add({
//         'amount': 0.0,
//         'type': 'initial',
//         'description': 'Wallet created',
//         'timestamp': FieldValue.serverTimestamp(),
//         'orderId': null,
//       });
//     }
//   }

//   // Add amount to wallet
//   Future<void> addToWallet(
//       double amount, String description, String? orderId) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('User not logged in');

//     final walletRef = _firestore.collection('wallets').doc(user.uid);
//     final transactionsRef = walletRef.collection('transactions');

//     return _firestore.runTransaction((transaction) async {
//       // Get current wallet document
//       final walletDoc = await transaction.get(walletRef);
//       if (!walletDoc.exists) {
//         throw Exception('Wallet not found');
//       }

//       // Calculate new balance
//       final currentBalance =
//           (walletDoc.data()?['balance'] as num?)?.toDouble() ?? 0.0;
//       final newBalance = currentBalance + amount;

//       // Update wallet balance
//       transaction.update(walletRef, {
//         'balance': newBalance,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       // Create new transaction document
//       final newTransactionRef = transactionsRef.doc();
//       transaction.set(newTransactionRef, {
//         'id': newTransactionRef.id,
//         'amount': amount,
//         'type': 'credit',
//         'description': description,
//         'timestamp': FieldValue.serverTimestamp(),
//         'orderId': orderId,
//         'previousBalance': currentBalance,
//         'newBalance': newBalance,
//       });
//     });
//   }

//   // Get wallet details
//   Stream<WalletModel> getWallet() {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('User not logged in');

//     return _firestore
//         .collection('wallets')
//         .doc(user.uid)
//         .snapshots()
//         .map((doc) {
//           if (!doc.exists) {
//             return WalletModel(
//               id: user.uid,
//               userId: user.uid,
//               balance: 0.0,
//               transactions: [],
//             );
//           }
//           return WalletModel.fromMap(doc.data() ?? {}, doc.id);
//         });
//   }

//   // Get wallet transactions
//   Stream<List<WalletTransaction>> getTransactions() {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('User not logged in');

//     return _firestore
//         .collection('wallets')
//         .doc(user.uid)
//         .collection('transactions')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => WalletTransaction.fromMap(doc.data()))
//             .toList());
//   }

//   // Get wallet balance
//   Future<double> getBalance() async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('User not logged in');

//     final walletDoc = await _firestore
//         .collection('wallets')
//         .doc(user.uid)
//         .get();

//     if (!walletDoc.exists) {
//       return 0.0;
//     }

//     return (walletDoc.data()?['balance'] as num?)?.toDouble() ?? 0.0;
//   }

//   // Deduct from wallet (for purchases)
//   Future<void> deductFromWallet(
//       double amount, String description, String? orderId) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('User not logged in');

//     final walletRef = _firestore.collection('wallets').doc(user.uid);
//     final transactionsRef = walletRef.collection('transactions');

//     return _firestore.runTransaction((transaction) async {
//       final walletDoc = await transaction.get(walletRef);
//       if (!walletDoc.exists) {
//         throw Exception('Wallet not found');
//       }

//       final currentBalance =
//           (walletDoc.data()?['balance'] as num?)?.toDouble() ?? 0.0;

//       if (currentBalance < amount) {
//         throw Exception('Insufficient wallet balance');
//       }

//       final newBalance = currentBalance - amount;

//       transaction.update(walletRef, {
//         'balance': newBalance,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       final newTransactionRef = transactionsRef.doc();
//       transaction.set(newTransactionRef, {
//         'id': newTransactionRef.id,
//         'amount': amount,
//         'type': 'debit',
//         'description': description,
//         'timestamp': FieldValue.serverTimestamp(),
//         'orderId': orderId,
//         'previousBalance': currentBalance,
//         'newBalance': newBalance,
//       });
//     });
//   }
// }import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vesture_firebase_user/models/wallet_model.dart';

class WalletRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper method to get wallet reference
  DocumentReference _getWalletRef(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('wallet')
        .doc('details');
  }

  // Helper method to get transactions reference
  CollectionReference _getTransactionsRef(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('wallet')
        .doc('details')
        .collection('transactions');
  }

  // Create wallet if it doesn't exist
  Future<void> createWallet() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final walletRef = _getWalletRef(user.uid);
    final walletDoc = await walletRef.get();

    if (!walletDoc.exists) {
      await walletRef.set({
        'userId': user.uid,
        'balance': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create initial transaction
      final transactionsRef = _getTransactionsRef(user.uid);
      await transactionsRef.add({
        'amount': 0.0,
        'type': 'initial',
        'description': 'Wallet created',
        'timestamp': FieldValue.serverTimestamp(),
        'orderId': null,
        'previousBalance': 0.0,
        'newBalance': 0.0,
      });
    }
  }

  // Add amount to wallet
  Future<void> addToWallet(
      double amount, String description, String? orderId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final walletRef = _getWalletRef(user.uid);
    final transactionsRef = _getTransactionsRef(user.uid);

    return _firestore.runTransaction((transaction) async {
      final walletDoc = await transaction.get(walletRef);
      if (!walletDoc.exists) {
        // Create wallet if it doesn't exist
        await createWallet();
        // Get the wallet document again
        final newWalletDoc = await transaction.get(walletRef);
        if (!newWalletDoc.exists) {
          throw Exception('Failed to create wallet');
        }
      }
      final currentBalance =
          (walletDoc.data() as Map<String, dynamic>)?['balance'] as num? ?? 0.0;
      // // Calculate new balance
      // final currentBalance =
      //     (walletDoc.data()?['balance'] as num?)?.toDouble() ?? 0.0;
      final newBalance = currentBalance + amount;

      // Update wallet balance
      transaction.update(walletRef, {
        'balance': newBalance,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create new transaction document
      final newTransactionRef = transactionsRef.doc();
      transaction.set(newTransactionRef, {
        'id': newTransactionRef.id,
        'amount': amount,
        'type': 'credit',
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
        'orderId': orderId,
        'previousBalance': currentBalance,
        'newBalance': newBalance,
      });
    });
  }

  // Get wallet details
  Stream<WalletModel> getWallet() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    return _getWalletRef(user.uid).snapshots().map((doc) {
      if (!doc.exists) {
        return WalletModel(
          id: user.uid,
          userId: user.uid,
          balance: 0.0,
          transactions: [],
        );
      }

      // Explicitly cast the data to Map<String, dynamic>
      final data = doc.data() as Map<String, dynamic>? ?? {};
      return WalletModel.fromMap(data, doc.id);
    });
  }

  // Get wallet transactions
  Stream<List<WalletTransaction>> getTransactions() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    return _getTransactionsRef(user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return WalletTransaction.fromMap(data);
            }).toList());
  }

  // Get wallet balance
  Future<double> getBalance() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final walletDoc = await _getWalletRef(user.uid).get();

    if (!walletDoc.exists) {
      await createWallet();
      return 0.0;
    }

    final data = walletDoc.data() as Map<String, dynamic>? ?? {};
    return (data['balance'] as num?)?.toDouble() ?? 0.0;
  }

  // Deduct from wallet (for purchases)
  Future<void> deductFromWallet(
      double amount, String description, String? orderId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final walletRef = _getWalletRef(user.uid);
    final transactionsRef = _getTransactionsRef(user.uid);

    return _firestore.runTransaction((transaction) async {
      final walletDoc = await transaction.get(walletRef);
      if (!walletDoc.exists) {
        throw Exception('Wallet not found');
      }

      final currentBalance =
          (walletDoc.data() as Map<String, dynamic>)?['balance'] as num? ?? 0.0;

      if (currentBalance < amount) {
        throw Exception('Insufficient wallet balance');
      }

      final newBalance = currentBalance - amount;

      // Update wallet balance
      transaction.update(walletRef, {
        'balance': newBalance,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create transaction record
      final newTransactionRef = transactionsRef.doc();
      transaction.set(newTransactionRef, {
        'id': newTransactionRef.id,
        'amount': amount,
        'type': 'debit',
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
        'orderId': orderId,
        'previousBalance': currentBalance,
        'newBalance': newBalance,
      });
    });
  }
}
