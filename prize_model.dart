import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum PrizeType {
  giftCard,
  mobileTopUp,
  cash,
}

class PrizeModel extends Equatable {
  const PrizeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.costInPoints,
    required this.imageUrl,
    required this.brand,
    this.countries = const [],
    this.denominations = const [],
    this.isActive = true,
    this.createdAt,
  });

  final String id;
  final String name;
  final String description;
  final PrizeType type;
  final int costInPoints;
  final String imageUrl;
  final String brand;
  final List<String> countries;
  final List<double> denominations;
  final bool isActive;
  final DateTime? createdAt;

  factory PrizeModel.fromMap(Map<String, dynamic> map) {
    return PrizeModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      type: PrizeType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => PrizeType.giftCard,
      ),
      costInPoints: (map['costInPoints'] as num?)?.toInt() ?? 0,
      imageUrl: map['imageUrl'] as String,
      brand: map['brand'] as String,
      countries: (map['countries'] as List?)?.map((e) => e as String).toList() ?? [],
      denominations: (map['denominations'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList() ?? [],
      isActive: map['isActive'] as bool? ?? true,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory PrizeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PrizeModel.fromMap({'id': doc.id, ...data});
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'type': type.name,
      'costInPoints': costInPoints,
      'imageUrl': imageUrl,
      'brand': brand,
      'countries': countries,
      'denominations': denominations,
      'isActive': isActive,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  @override
  List<Object?> get props => [
        id, name, description, type, costInPoints,
        imageUrl, brand, countries, denominations, isActive, createdAt,
      ];
}
