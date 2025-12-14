import 'package:flutter/material.dart';
import '../../shared/localization/app_localizations.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  final List<String> roles = [
    'Software Engineer',
    'Data Scientist',
    'Product Manager',
    'Designer',
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            loc.translate('select_role'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          ...roles.map((role) => RadioListTile<String>(
                title: Text(role),
                value: role,
                groupValue: _selectedRole,
                onChanged: (value) {
                  setState(() => _selectedRole = value);
                },
              )),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _selectedRole == null
                ? null
                : () {
                    // Save role selection
                    // Navigate to login screen
                  },
            child: Text(loc.translate('get_started')),
          ),
        ],
      ),
    );
  }
}
