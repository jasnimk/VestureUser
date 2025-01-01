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
      transactions: [],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  WalletModel copyWith({
    String? id,
    String? userId,
    double? balance,
    List<WalletTransaction>? transactions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
