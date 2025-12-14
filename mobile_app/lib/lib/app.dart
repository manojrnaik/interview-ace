import 'package:flutter/material.dart';
import 'core/router/app_router.dart';

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
      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
