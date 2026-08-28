import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'game_model.dart';

enum TournamentStatus {
  upcoming,
  registration,
  live,
  completed,
  cancelled,
}

enum TournamentType {
  free,
  paid,
  premium,
}

class TournamentModel extends Equatable {
  const TournamentModel({
    required this.id,
    required this.gameId,
    required this.game,
    required this.name,
    required this.description,
    required this.status,
    required this.type,
    required this.entryFee,
    required this.prizePool,
    required this.maxPlayers,
    required this.registeredPlayers,
    required this.startsAt,
    this.endsAt,
    this.bannerUrl,
    this.rules,
    this.winnerIds = const [],
    this.createdAt,
  });

  final String id;
  final String gameId;
  final GameModel game;
  final String name;
  final String description;
  final TournamentStatus status;
  final TournamentType type;
  final double entryFee;
  final double prizePool;
  final int maxPlayers;
  final int registeredPlayers;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String? bannerUrl;
  final List<String>? rules;
  final List<String> winnerIds;
  final DateTime? createdAt;

  bool get isFree => type == TournamentType.free;
  bool get isFull => registeredPlayers >= maxPlayers;
  bool get hasStarted => DateTime.now().isAfter(startsAt);
  bool get canRegister =>
      status == TournamentStatus.registration && !isFull && !hasStarted;
  double get firstPrize => prizePool * 0.5;
  double get secondPrize => prizePool * 0.3;
  double get thirdPrize => prizePool * 0.2;

  factory TournamentModel.fromMap(Map<String, dynamic> map) {
    return TournamentModel(
      id: map['id'] as String,
      gameId: map['gameId'] as String,
      game: GameModel.fromMap(map['game'] as Map<String, dynamic>),
      name: map['name'] as String,
      description: map['description'] as String,
      status: TournamentStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TournamentStatus.upcoming,
      ),
      type: TournamentType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TournamentType.free,
      ),
      entryFee: (map['entryFee'] as num?)?.toDouble() ?? 0.0,
      prizePool: (map['prizePool'] as num?)?.toDouble() ?? 0.0,
      maxPlayers: (map['maxPlayers'] as num?)?.toInt() ?? 100,
      registeredPlayers: (map['registeredPlayers'] as num?)?.toInt() ?? 0,
      startsAt: (map['startsAt'] as Timestamp).toDate(),
      endsAt: (map['endsAt'] as Timestamp?)?.toDate(),
      bannerUrl: map['bannerUrl'] as String?,
      rules: (map['rules'] as List?)?.map((e) => e as String).toList(),
      winnerIds: (map['winnerIds'] as List?)?.map((e) => e as String).toList() ?? [],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory TournamentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TournamentModel.fromMap({'id': doc.id, ...data});
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'game': game.toMap(),
      'name': name,
      'description': description,
      'status': status.name,
      'type': type.name,
      'entryFee': entryFee,
      'prizePool': prizePool,
      'maxPlayers': maxPlayers,
      'registeredPlayers': registeredPlayers,
      'startsAt': Timestamp.fromDate(startsAt),
      'endsAt': endsAt != null ? Timestamp.fromDate(endsAt!) : null,
      'bannerUrl': bannerUrl,
      'rules': rules,
      'winnerIds': winnerIds,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  @override
  List<Object?> get props => [
        id, gameId, game, name, description, status, type,
        entryFee, prizePool, maxPlayers, registeredPlayers,
        startsAt, endsAt, bannerUrl, rules, winnerIds, createdAt,
      ];
}
