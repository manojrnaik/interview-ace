import 'package:flutter/material.dart';
import '../../shared/localization/app_localizations.dart';
import 'notification_service.dart';
import 'notification_model.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Interviews')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickTime,
              child: Text(_selectedTime == null
                  ? 'Pick Reminder Time'
                  : 'Selected: ${_selectedTime!.format(context)}'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _selectedTime == null ? null : _scheduleReminder,
              child: const Text('Schedule Daily Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _scheduleReminder() {
    if (_selectedTime == null) return;

    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final notification = InterviewNotification(
      id: DateTime.now().toString(),
      title: 'Time to practice!',
      body: 'Your daily AI interview is ready.',
      scheduledTime: scheduledTime,
    );

    NotificationService.scheduleNotification(notification);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Daily reminder scheduled successfully!')),
    );
  }
}
