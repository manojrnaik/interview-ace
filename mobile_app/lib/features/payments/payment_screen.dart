import 'package:flutter/material.dart';
import 'payment_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  double _amount = 499; // Example: ₹499 subscription

  @override
  void initState() {
    super.initState();
    _paymentService.init();
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium Subscription')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Get Premium Access for ₹$_amount/month',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _payNow,
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  void _payNow() {
    _paymentService.startPayment(
      amount: _amount,
      name: 'AI Interviewer Premium',
      description: 'Monthly subscription',
      email: 'user@example.com', // fetch from login
      contact: '9999999999', // fetch from user profile
    );
  }
}
