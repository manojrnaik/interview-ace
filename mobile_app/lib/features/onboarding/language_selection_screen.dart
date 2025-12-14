import 'package:flutter/material.dart';
import '../../shared/localization/app_localizations.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            loc.translate('select_language'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          ListTile(
            title: Text(loc.translate('english')),
            onTap: () {
              // Save language preference
              // For now, default to English
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Move to role selection page
            },
            child: Text(loc.translate('next')),
          ),
        ],
      ),
    );
  }
}
