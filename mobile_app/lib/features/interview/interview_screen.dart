import 'package:flutter/material.dart';
import '../../shared/services/api_service.dart';
import '../voice/speech_to_text_service.dart';
import '../voice/text_to_speech_service.dart';

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
  final SpeechToTextService _sttService = SpeechToTextService();
  final TextToSpeechService _ttsService = TextToSpeechService();

  String? _question;
  String _answer = '';
  bool _isLoading = true;
  bool _isListening = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeVoice();
    _loadQuestion();
  }

  Future<void> _initializeVoice() async {
    await _ttsService.init();
    await _sttService.init();
  }

  Future<void> _loadQuestion() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
        _answer = '';
      });

      final question =
          await _apiService.getInterviewQuestion(widget.role);

      setState(() {
        _question = question;
        _isLoading = false;
      });

      await _ttsService.speak(question);
    } catch (e) {
      setState(() {
        _error = 'Failed to load interview question';
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _sttService.stopListening();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _sttService.startListening(
        onResult: (text) {
          setState(() {
            _answer = text;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    _sttService.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.role),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadQuestion,
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
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Interview Question',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(_question ?? ''),
        ),
        const SizedBox(height: 24),
        const Text(
          'Your Answer',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _answer.isEmpty ? 'Tap mic and speak...' : _answer,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(_isListening ? Icons.stop : Icons.mic),
                label: Text(_isListening ? 'Stop' : 'Answer'),
                onPressed: _toggleListening,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _loadQuestion,
                child: const Text('Next Question'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

