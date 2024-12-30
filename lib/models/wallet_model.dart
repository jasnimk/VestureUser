// import 'package:cloud_firestore/cloud_firestore.dart';

// class WalletModel {
//   final String id;
//   final String userId;
//   final double balance;
//   final List<WalletTransaction> transactions;

//   WalletModel({
//     required this.id,
//     required this.userId,
//     required this.balance,
//     required this.transactions,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'balance': balance,
//       'transactions': transactions.map((tx) => tx.toMap()).toList(),
//     };
//   }

//   factory WalletModel.fromMap(Map<String, dynamic> map, String id) {
//     return WalletModel(
//       id: id,
//       userId: map['userId'] ?? '',
//       balance: (map['balance'] as num).toDouble(),
//       transactions: (map['transactions'] as List<dynamic>?)
//               ?.map((tx) => WalletTransaction.fromMap(tx))
//               .toList() ??
//           [],
//     );
//   }
// }

// class WalletTransaction {
//   final String id;
//   final double amount;
//   final String type; // 'credit' or 'debit'
//   final String description;
//   final DateTime timestamp;
//   final String? orderId;

//   WalletTransaction({
//     required this.id,
//     required this.amount,
//     required this.type,
//     required this.description,
//     required this.timestamp,
//     this.orderId,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'amount': amount,
//       'type': type,
//       'description': description,
//       'timestamp': Timestamp.fromDate(timestamp),
//       'orderId': orderId,
//     };
//   }

//   factory WalletTransaction.fromMap(Map<String, dynamic> map) {
//     return WalletTransaction(
//       id: map['id'] ?? '',
//       amount: (map['amount'] as num).toDouble(),
//       type: map['type'] ?? '',
//       description: map['description'] ?? '',
//       timestamp: (map['timestamp'] as Timestamp).toDate(),
//       orderId: map['orderId'],
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  final String id;
  final String userId;
  final double balance;
  final List<WalletTransaction> transactions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    this.transactions = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory WalletModel.fromMap(Map<String, dynamic> map, String documentId) {
    return WalletModel(
      id: documentId,
      userId: map['userId'] as String? ?? '',
      balance: (map['balance'] as num?)?.toDouble() ?? 0.0,
      transactions: [], // Transactions are loaded separately
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'balance': balance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class WalletTransaction {
  final String id;
  final double amount;
  final String type; // 'credit' or 'debit'
  final String description;
  final DateTime timestamp;
  final String? orderId;

  WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.timestamp,
    this.orderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
      'orderId': orderId,
    };
  }

  factory WalletTransaction.fromMap(Map<String, dynamic> map) {
    return WalletTransaction(
      id: map['id'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      orderId: map['orderId'],
    );
  }
}
