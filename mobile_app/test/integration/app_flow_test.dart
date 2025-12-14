import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:your_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full app flow test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Onboarding next button
    final nextButton = find.text('Next');
    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    // Role selection (skip actual selection for test)
    // Check login screen appears after onboarding
    // Add more interactions as needed
  });
}
