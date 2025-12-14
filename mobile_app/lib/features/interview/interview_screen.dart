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
  bool _isSubmitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initVoice();
    _loadQuestion();
  }

  Future<void> _initVoice() async {
    await _ttsService.init();
    await _sttService.init();
  }

  Future<void> _loadQuestion() async {
    try {
      setState(() {
        _isLoading = true;
        _answer = '';
        _error = null;
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
        _error = 'Failed to load question';
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
          setState(() => _answer = text);
        },
      );
    }
  }

  Future<void> _submitAnswer() async {
    if (_answer.isEmpty || _question == null) return;

    setState(() => _isSubmitting = true);

    final result = await _apiService.evaluateAnswer(
      role: widget.role,
      question: _question!,
      answer: _answer,
    );

    setState(() => _isSubmitting = false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            Text(
              'Score: ${result['score']}/10',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text('Strengths',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...List.from(result['strengths'])
                .map((e) => Text('• $e')),
            const SizedBox(height: 12),
            const Text('Improvements',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...List.from(result['improvements'])
                .map((e) => Text('• $e')),
            const SizedBox(height: 12),
            Text(result['overallFeedback']),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _loadQuestion();
              },
              child: const Text('Next Question'),
            ),
          ],
        ),
      ),
    );
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
      appBar: AppBar(title: Text(widget.role)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_question ?? '',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _answer.isEmpty
                              ? 'Tap mic and answer...'
                              : _answer,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(_isListening
                                  ? Icons.stop
                                  : Icons.mic),
                              label: Text(
                                  _isListening ? 'Stop' : 'Answer'),
                              onPressed: _toggleListening,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  _isSubmitting ? null : _submitAnswer,
                              child: _isSubmitting
                                  ? const CircularProgressIndicator()
                                  : const Text('Submit'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}


