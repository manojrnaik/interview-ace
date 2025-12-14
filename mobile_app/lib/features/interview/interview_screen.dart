import 'package:flutter/material.dart';

class InterviewScreen extends StatelessWidget {
  final String role;

  const InterviewScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(role)),
      body: const Center(
        child: Text(
          'Interview will start here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
