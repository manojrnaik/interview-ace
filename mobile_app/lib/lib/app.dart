import 'package:flutter/material.dart';

class InterviewAceApp extends StatelessWidget {
  const InterviewAceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InterviewAce AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'InterviewAce AI',
            style: TextStyle(fontSize: 26),
          ),
        ),
      ),
    );
  }
}
