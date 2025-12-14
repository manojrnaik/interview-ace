import 'package:flutter/material.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../core/router/app_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
             text: 'Login',
             onPressed: () async {
              await ref.read(authControllerProvider)
               .login(email, password);

            Navigator.pushReplacementNamed(
             context,
             AppRouter.home,
    );
  },
),

          ],
        ),
      ),
    );
  }
}
