import 'package:flutter_test/flutter_test.dart';
import 'package:play_and_win/core/utils/validators.dart';
import 'package:play_and_win/core/utils/formatters.dart';

void main() {
  group('Validators', () {
    test('email validation', () {
      expect(Validators.email(null), 'Email is required');
      expect(Validators.email(''), 'Email is required');
      expect(Validators.email('notanemail'), 'Enter a valid email address');
      expect(Validators.email('user@example.com'), null);
    });

    test('password validation', () {
      expect(Validators.password(null), 'Password is required');
      expect(Validators.password('123'), 'Password must be at least 6 characters');
      expect(Validators.password('123456'), null);
    });

    test('username validation', () {
      expect(Validators.username('ab'), 'Username must be at least 3 characters');
      expect(Validators.username('abc'), null);
      expect(Validators.username('user_name'), null);
      expect(Validators.username('user123'), null);
      expect(Validators.username('user@name'), 'Only letters, numbers, and underscores allowed');
    });

    test('confirmPassword', () {
      expect(Validators.confirmPassword('abc123', 'abc123'), null);
      expect(Validators.confirmPassword('abc123', 'xyz789'), 'Passwords do not match');
    });

    test('amount validation', () {
      expect(Validators.amount('10', min: 5), null);
      expect(Validators.amount('3', min: 5), 'Minimum amount is \$5.00');
      expect(Validators.amount('2000', max: 1000), 'Maximum amount is \$1000.00');
      expect(Validators.amount('abc'), 'Enter a valid amount');
    });
  });

  group('Formatters', () {
    test('currency', () {
      expect(Formatters.currency(10.5), '\$10.50');
      expect(Formatters.currency(0), '\$0.00');
    });

    test('percentage', () {
      expect(Formatters.percentage(70.0), '70.0%');
    });

    test('compactNumber', () {
      expect(Formatters.compactNumber(1000), '1K');
      expect(Formatters.compactNumber(1500), '1.5K');
    });

    test('countdown', () {
      expect(Formatters.countdown(const Duration(hours: 1, minutes: 30, seconds: 45)), '01:30:45');
    });

    test('tournamentId', () {
      final id = Formatters.tournamentId('abcdefgh');
      expect(id, 'T-ABCDEFGH');
    });
  });
}
