import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:your_app/features/interview/interview_screen.dart';

void main() {
  testWidgets('Interview screen shows start button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: InterviewScreen()));

    expect(find.text('Start Interview'), findsOneWidget);
  });
}
