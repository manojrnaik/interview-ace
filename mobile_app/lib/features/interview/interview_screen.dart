import 'dart:async';

import 'package:flutter/material.dart';
import '../../shared/services/api_service.dart';
import '../../shared/services/analytics_service.dart';
import '../voice/speech_to_text_service.dart';
import '../voice/text_to_speech_service.dart';

class InterviewScreen extends StatefulWidget {
  final String role;

  const InterviewScreen({super.key, required this.role});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final SpeechToTextService _sttService = SpeechToTextService();
  final TextToSpeechService _ttsService = TextToSpeechService();

  String? _question;
  String _answer = '';
  bool _isLoading = true;
  bool _isListening = false;
  bool _isSubmitting = false;
  String? _error;
  int _timeLeft = 120; // 2 min timer
  Timer? _timer;

  // Animation
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initVoice();
    _loadQuestion();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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
        _timeLeft = 120;
      });

      final question =
          await _apiService.getInterviewQuestion(widget.role);

      setState(() {
        _question = question;
        _isLoading = false;
      });

      await _ttsService.speak(question);
      await AnalyticsService.logInterviewStart(widget.role);

      _startTimer();
    } catch (e) {
      setState(() {
        _error = 'Failed to load question';
        _isLoading = false;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _submitAnswer();
      }
    });
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _sttService.stopListening();
      setState(() => _isListening = false);
      _animationController.reverse();
    } else {
      setState(() => _isListening = true);
      _animationController.forward();
      await _sttService.startListening(onResult: (text) {
        setState(() => _answer = text);
      });
    }
  }

  Future<void> _submitAnswer() async {
    if (_answer.isEmpty || _question == null) return;

    setState(() => _isSubmitting = true);

    try {
      final result = await _apiService.evaluateAnswer(
        role: widget.role,
        question: _question!,
        answer: _answer,
      );

      setState(() => _isSubmitting = false);
      _timer?.cancel();

      await AnalyticsService.logInterviewComplete(result['score']);

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
              ...List.from(result['strengths']).map((e) => Text('• $e')),
              const SizedBox(height: 12),
              const Text('Improvements',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...List.from(result['improvements']).map((e) => Text('• $e')),
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
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    _sttService.stopListening();
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.role),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question
                      Text(
                        _question ?? '',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 16),

                      // Timer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Time Left: $_timeLeft s',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          LinearProgressIndicator(
                            value: _timeLeft / 120,
                            minHeight: 6,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Answer box
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
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Spacer(),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _toggleListening,
                              child: ScaleTransition(
                                scale: Tween(begin: 1.0, end: 1.2)
                                    .animate(_animationController),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(_isListening
                                          ? Icons.stop
                                          : Icons.mic),
                                      const SizedBox(width: 8),
                                      Text(_isListening ? 'Stop' : 'Answer'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _submitAnswer,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: _isSubmitting
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
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


