import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final _analytics = FirebaseAnalytics.instance;

  static Future<void> logInterviewStart(String role) async {
    await _analytics.logEvent(
      name: 'interview_start',
      parameters: {'role': role},
    );
  }

  static Future<void> logInterviewComplete(int score) async {
    await _analytics.logEvent(
      name: 'interview_complete',
      parameters: {'score': score},
    );
  }

  static Future<void> logPremiumPrompt() async {
    await _analytics.logEvent(name: 'premium_prompt');
  }
}
