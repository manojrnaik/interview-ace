import 'package:flutter/material.dart';
import '../../interview/interview_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roles = [
      'Software Developer',
      'Data Analyst',
      'Product Manager',
      'Sales Executive',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Select Job Role')),
      body: ListView.builder(
        itemCount: roles.length,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(roles[index]),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InterviewScreen(role: roles[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
