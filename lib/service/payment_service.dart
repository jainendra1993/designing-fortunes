import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  void Function(PurchaseDetails)? onSuccess;
  void Function(String error)? onError;
  void Function()? onCancelled;

  void initialize() {
    if (!Platform.isIOS) return;
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (error) => onError?.call(error.toString()),
    );
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<ProductDetails?> fetchProduct(String productId) async {
    final bool available = await _iap.isAvailable();
    if (!available) return null;

    final response = await _iap.queryProductDetails({productId});
    if (response.productDetails.isEmpty) return null;
    return response.productDetails.first;
  }

  Future<bool> purchaseProduct({
    required String productId,
    required void Function(PurchaseDetails) onSuccess,
    required void Function(String) onError,
    required void Function() onCancelled,
  }) async {
    this.onSuccess = onSuccess;
    this.onError = onError;
    this.onCancelled = onCancelled;

    final product = await fetchProduct(productId);
    if (product == null) {
      onError('Product not found. Please try again later.');
      return false;
    }

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      return true;
    } catch (e) {
      onError(e.toString());
      return false;
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _iap.completePurchase(purchase);
          onSuccess?.call(purchase);
          break;
        case PurchaseStatus.error:
          _iap.completePurchase(purchase);
          onError?.call(purchase.error?.message ?? 'Purchase failed');
          break;
        case PurchaseStatus.canceled:
          onCancelled?.call();
          break;
        case PurchaseStatus.pending:
          break;
      }
    }
  }
}

String appleProductId(int courseId) =>
    'com.designingfortunes.designingfortunes.course_$courseId';