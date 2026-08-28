import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum TransactionType {
  deposit,
  withdrawal,
  tournamentEntry,
  tournamentPrize,
  prizeRedemption,
  referralBonus,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

class TransactionModel extends Equatable {
  const TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.amount,
    required this.description,
    required this.createdAt,
    this.reference,
    this.metadata,
  });

  final String id;
  final String userId;
  final TransactionType type;
  final TransactionStatus status;
  final double amount;
  final String description;
  final DateTime createdAt;
  final String? reference;
  final Map<String, dynamic>? metadata;

  bool get isCredit =>
      type == TransactionType.tournamentPrize ||
      type == TransactionType.deposit ||
      type == TransactionType.referralBonus;

  bool get isDebit =>
      type == TransactionType.withdrawal ||
      type == TransactionType.tournamentEntry ||
      type == TransactionType.prizeRedemption;

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.deposit,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TransactionStatus.pending,
      ),
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reference: map['reference'] as String?,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel.fromMap({'id': doc.id, ...data});
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type.name,
      'status': status.name,
      'amount': amount,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'reference': reference,
      'metadata': metadata,
    };
  }

  @override
  List<Object?> get props => [
        id, userId, type, status, amount,
        description, createdAt, reference, metadata,
      ];
}
