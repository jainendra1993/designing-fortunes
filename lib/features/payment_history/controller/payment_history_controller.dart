import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/features/other/controller/others.dart';
import 'package:ready_lms/features/payment_history/model/payment_history_model.dart';

import '../data/payment_history_service.dart';

class PaymentHistoryController extends StateNotifier<AsyncValue<PaymentHistoryModel>>  {
  final Ref ref;

  PaymentHistoryController(this.ref) : super(const AsyncValue.loading());

  Future<PaymentHistoryModel?> getPaymentHistory() async {
    state = const AsyncValue.loading();;
    PaymentHistoryModel paymentHistoryModel = PaymentHistoryModel();
    try {
      state = const AsyncValue.loading();

      final response = await ref.read(paymentHistoryServiceProvider).getHistory();

      if (response.statusCode == 200) {
        final paymentHistoryModel = PaymentHistoryModel.fromJson(response.data);
        state = AsyncValue.data(paymentHistoryModel);
      } else {
        state = AsyncValue.error(
          "Failed with status: ${response.statusCode}",
          StackTrace.current,
        );
      }
    } catch (e, s) {
      throw s;
    }
  }


}

final paymentHistoryControllerProvider =StateNotifierProvider<
    PaymentHistoryController, AsyncValue<PaymentHistoryModel>>(
      (ref) => PaymentHistoryController(ref),);