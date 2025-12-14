import 'package:flutter/material.dart';
import 'subscription_service.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final SubscriptionService _service = SubscriptionService();
  bool _loading = true;
  List products = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    products = await _service.loadProducts();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Go Premium')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: products
                  .map(
                    (p) => ListTile(
                      title: Text(p.title),
                      subtitle: Text(p.price),
                      trailing: ElevatedButton(
                        onPressed: () => _service.buy(p),
                        child: const Text('Buy'),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
