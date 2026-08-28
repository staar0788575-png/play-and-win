import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:play_and_win/core/widgets/buttons.dart';
import 'package:play_and_win/core/theme/app_colors.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('renders label and responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Test Button',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      await tester.tap(find.byType(PrimaryButton));
      expect(tapped, true);
    });

    testWidgets('shows loading indicator when isLoading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const PrimaryButton(
              label: 'Loading',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });
  });

  group('GradientButton', () {
    testWidgets('renders with gradient', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              label: 'Gradient',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Gradient'), findsOneWidget);
    });
  });
}
