import 'package:flutter/material.dart';

class ManageRolesScreen extends StatefulWidget {
  const ManageRolesScreen({super.key});

  @override
  State<ManageRolesScreen> createState() => _ManageRolesScreenState();
}

class _ManageRolesScreenState extends State<ManageRolesScreen> {
  final List<String> _roles = ['Software Engineer', 'Data Scientist', 'Product Manager'];

  final TextEditingController _roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Roles')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _roleController,
              decoration: const InputDecoration(
                labelText: 'Add New Role',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addRole,
              child: const Text('Add Role'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _roles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_roles[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteRole(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addRole() {
    if (_roleController.text.isEmpty) return;
    setState(() {
      _roles.add(_roleController.text);
      _roleController.clear();
    });
  }

  void _deleteRole(int index) {
    setState(() {
      _roles.removeAt(index);
    });
  }
}
