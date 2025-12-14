import 'package:flutter/material.dart';

class ManageQuestionsScreen extends StatefulWidget {
  const ManageQuestionsScreen({super.key});

  @override
  State<ManageQuestionsScreen> createState() => _ManageQuestionsScreenState();
}

class _ManageQuestionsScreenState extends State<ManageQuestionsScreen> {
  final Map<String, List<String>> _questions = {
    'Software Engineer': ['Explain OOP concepts', 'What is Flutter?'],
    'Data Scientist': ['Explain Linear Regression', 'What is overfitting?'],
  };

  String? _selectedRole;
  final TextEditingController _questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Questions')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: const Text('Select Role'),
              value: _selectedRole,
              items: _questions.keys
                  .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Add New Question',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addQuestion,
              child: const Text('Add Question'),
            ),
            const SizedBox(height: 24),
            _selectedRole != null
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _questions[_selectedRole!]!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_questions[_selectedRole!]![index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteQuestion(index),
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void _addQuestion() {
    if (_selectedRole == null || _questionController.text.isEmpty) return;
    setState(() {
      _questions[_selectedRole!]!.add(_questionController.text);
      _questionController.clear();
    });
  }

  void _deleteQuestion(int index) {
    if (_selectedRole == null) return;
    setState(() {
      _questions[_selectedRole!]!.removeAt(index);
    });
  }
}
