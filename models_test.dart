import 'package:flutter_test/flutter_test.dart';
import 'package:play_and_win/data/models/user_model.dart';
import 'package:play_and_win/data/models/tournament_model.dart';
import 'package:play_and_win/data/models/game_model.dart';
import 'package:play_and_win/data/models/transaction_model.dart';
import 'package:play_and_win/data/models/prize_model.dart';

void main() {
  group('UserModel', () {
    test('winRate calculates correctly', () {
      final user = const UserModel(
        id: '1',
        email: 'test@test.com',
        username: 'tester',
        matchesPlayed: 10,
        matchesWon: 7,
      );
      expect(user.winRate, 70.0);
    });

    test('winRate returns 0 when no matches played', () {
      final user = const UserModel(
        id: '1',
        email: 'test@test.com',
        username: 'tester',
      );
      expect(user.winRate, 0.0);
    });

    test('toMap and fromMap roundtrip', () {
      final user = UserModel(
        id: '123',
        email: 'user@test.com',
        username: 'user1',
        displayName: 'User One',
        totalPoints: 500,
        walletBalance: 25.50,
        createdAt: DateTime(2025, 1, 1),
      );
      final map = user.toMap();
      final restored = UserModel.fromMap({'id': '123', ...map});
      expect(restored.id, '123');
      expect(restored.email, 'user@test.com');
      expect(restored.username, 'user1');
      expect(restored.totalPoints, 500);
      expect(restored.walletBalance, 25.50);
    });
  });

  group('TournamentModel', () {
    final game = const GameModel(
      id: 'g1',
      name: 'Chess',
      category: 'Board',
      description: 'Classic chess',
      imageUrl: '',
      isActive: true,
    );

    test('prize distribution', () {
      final tournament = TournamentModel(
        id: 't1',
        gameId: 'g1',
        game: game,
        name: 'Test Cup',
        description: 'Test',
        status: TournamentStatus.registration,
        type: TournamentType.free,
        entryFee: 0,
        prizePool: 1000,
        maxPlayers: 50,
        registeredPlayers: 10,
        startsAt: DateTime(2025, 12, 1),
      );
      expect(tournament.firstPrize, 500.0);
      expect(tournament.secondPrize, 300.0);
      expect(tournament.thirdPrize, 200.0);
    });

    test('canRegister logic', () {
      final open = TournamentModel(
        id: 't1',
        gameId: 'g1',
        game: game,
        name: 'Open',
        description: '',
        status: TournamentStatus.registration,
        type: TournamentType.free,
        entryFee: 0,
        prizePool: 100,
        maxPlayers: 50,
        registeredPlayers: 10,
        startsAt: DateTime.now().add(const Duration(days: 1)),
      );
      expect(open.canRegister, true);

      final full = TournamentModel(
        id: 't2',
        gameId: 'g1',
        game: game,
        name: 'Full',
        description: '',
        status: TournamentStatus.registration,
        type: TournamentType.free,
        entryFee: 0,
        prizePool: 100,
        maxPlayers: 10,
        registeredPlayers: 10,
        startsAt: DateTime.now().add(const Duration(days: 1)),
      );
      expect(full.canRegister, false);
    });
  });

  group('TransactionModel', () {
    test('isCredit and isDebit', () {
      const prize = TransactionModel(
        id: 'tx1',
        userId: 'u1',
        type: TransactionType.tournamentPrize,
        status: TransactionStatus.completed,
        amount: 50,
        description: 'Prize',
        createdAt: null,
      );
      expect(prize.isCredit, true);
      expect(prize.isDebit, false);

      const entry = TransactionModel(
        id: 'tx2',
        userId: 'u1',
        type: TransactionType.tournamentEntry,
        status: TransactionStatus.completed,
        amount: 10,
        description: 'Entry',
        createdAt: null,
      );
      expect(entry.isCredit, false);
      expect(entry.isDebit, true);
    });
  });

  group('PrizeModel', () {
    test('type parsing', () {
      final map = {
        'id': 'p1',
        'name': 'Amazon Gift Card',
        'description': 'Amazon \$10',
        'type': 'giftCard',
        'costInPoints': 1000,
        'imageUrl': '',
        'brand': 'Amazon',
      };
      final prize = PrizeModel.fromMap(map);
      expect(prize.type, PrizeType.giftCard);
      expect(prize.costInPoints, 1000);
    });
  });
}
