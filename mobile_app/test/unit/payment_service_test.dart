import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/payments/payment_service.dart';

void main() {
  group('PaymentService', () {
    late PaymentService paymentService;

    setUp(() {
      paymentService = PaymentService();
      paymentService.init();
    });

    tearDown(() {
      paymentService.dispose();
    });

    test('startPayment does not throw', () {
      expect(
        () => paymentService.startPayment(
          amount: 499,
          name: 'Test',
          description: 'Monthly subscription',
          email: 'test@example.com',
          contact: '9999999999',
        ),
        returnsNormally,
      );
    });
  });
}
