import 'package:flutter/material.dart';
import '../../shared/localization/app_localizations.dart';
import 'role_selection_screen.dart';
import 'language_selection_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: PageView(
        children: [
          _buildPage(
            context,
            title: loc.translate('welcome_title'),
            description: loc.translate('welcome_desc'),
            image: 'assets/images/onboarding1.png',
          ),
          LanguageSelectionScreen(),
          RoleSelectionScreen(),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context,
      {required String title,
      required String description,
      required String image}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          const SizedBox(height: 32),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text(description, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Navigate to next page handled by PageView controller
            },
            child: Text(AppLocalizations.of(context)!.translate('next')),
          ),
        ],
      ),
    );
  }
}
