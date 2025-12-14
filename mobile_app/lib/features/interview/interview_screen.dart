import 'package:flutter/material.dart';
import '../../shared/services/api_service.dart';

class InterviewScreen extends StatefulWidget {
  final String role;

  const InterviewScreen({
    super.key,
    required this.role,
  });

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final ApiService _apiService = ApiService();

  String? _question;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  Future<void> _loadQuestion() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final question =
          await _apiService.getInterviewQuestion(widget.role);

      setState(() {
        _question = question;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load interview question';
        _isLoading = false;
      });
    }
  }

  void _nextQuestion() {
    _loadQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.role),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _nextQuestion,
            tooltip: 'Next Question',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadQuestion,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Interview Question',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _question ?? '',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _nextQuestion,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next Question'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
