import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  List<ProductDetails> products = [];

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  /// Purchase Success Callback
  Function(String productId)? onPurchaseSuccess;

  Future<void> init(List<String> productIds) async {
    final bool available = await _inAppPurchase.isAvailable();

    if (!available) {
      debugPrint("Store not available");
      return;
    }

    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(productIds.toSet());

    if (response.error != null) {
      debugPrint("Error fetching products: ${response.error}");
    }

    products = response.productDetails;

    /// Listen to purchase updates
    _subscription =
        _inAppPurchase.purchaseStream.listen(_listenToPurchaseUpdated);
  }

  /// Buy Product
  void buy(ProductDetails product) {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: product);

    _inAppPurchase.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
  }

  /// Restore Purchases
  void restore() {
    _inAppPurchase.restorePurchases();
  }

  /// Purchase Listener
  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) {

    for (var purchase in purchaseDetailsList) {

      /// Pending
      if (purchase.status == PurchaseStatus.pending) {
        debugPrint("Purchase Pending");
      }

      /// Success
      else if (purchase.status == PurchaseStatus.purchased) {
        debugPrint("Purchase Success ${purchase.productID}");

        /// Trigger Success Callback
        if (onPurchaseSuccess != null) {
          onPurchaseSuccess!(purchase.productID);
        }
      }

      /// Error
      else if (purchase.status == PurchaseStatus.error) {
        debugPrint("Purchase Error: ${purchase.error}");
      }

      /// Complete purchase
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
    }
  }

  /// Dispose
  void dispose() {
    _subscription.cancel();
  }
}