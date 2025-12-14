import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:your_app/shared/localization/app_localizations.dart';

void main() {
  testWidgets('Localization loads English strings', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [AppLocalizations.delegate],
        supportedLocales: [Locale('en')],
        home: Builder(
          builder: (context) {
            return Text(AppLocalizations.of(context)?.translate('welcome_title') ?? '');
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Welcome to AI Interviewer'), findsOneWidget);
  });
}
