import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // In production, fetch analytics from backend
    final dummyAnalytics = {
      'Total Users': 120,
      'Daily Active Users': 45,
      'Interviews Completed': 300,
      'Premium Users': 35,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: dummyAnalytics.entries
              .map((e) => Card(
                    child: ListTile(
                      title: Text(e.key),
                      trailing: Text(e.value.toString()),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
