import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GameModel extends Equatable {
  const GameModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.isActive,
    this.minPlayers = 2,
    this.maxPlayers = 100,
    this.entryFee = 0.0,
    this.rating = 0.0,
    this.totalPlays = 0,
    this.rules,
    this.createdAt,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  final bool isActive;
  final int minPlayers;
  final int maxPlayers;
  final double entryFee;
  final double rating;
  final int totalPlays;
  final List<String>? rules;
  final DateTime? createdAt;

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      isActive: map['isActive'] as bool? ?? true,
      minPlayers: (map['minPlayers'] as num?)?.toInt() ?? 2,
      maxPlayers: (map['maxPlayers'] as num?)?.toInt() ?? 100,
      entryFee: (map['entryFee'] as num?)?.toDouble() ?? 0.0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      totalPlays: (map['totalPlays'] as num?)?.toInt() ?? 0,
      rules: (map['rules'] as List?)?.map((e) => e as String).toList(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory GameModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GameModel.fromMap({'id': doc.id, ...data});
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'minPlayers': minPlayers,
      'maxPlayers': maxPlayers,
      'entryFee': entryFee,
      'rating': rating,
      'totalPlays': totalPlays,
      'rules': rules,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  @override
  List<Object?> get props => [
        id, name, category, description, imageUrl, isActive,
        minPlayers, maxPlayers, entryFee, rating, totalPlays, rules, createdAt,
      ];
}
