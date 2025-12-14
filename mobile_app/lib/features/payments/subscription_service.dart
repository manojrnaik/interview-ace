import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService {
  final InAppPurchase _iap = InAppPurchase.instance;

  final String monthlyId = 'premium_monthly';
  final String yearlyId = 'premium_yearly';

  Future<List<ProductDetails>> loadProducts() async {
    final response = await _iap.queryProductDetails(
      {monthlyId, yearlyId},
    );

    return response.productDetails;
  }

  Future<void> buy(ProductDetails product) async {
    final purchaseParam = PurchaseParam(
      productDetails: product,
    );
    await _iap.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
  }
}
