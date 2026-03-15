import 'package:dio/src/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/features/payment_history/data/payment_history_repository.dart';
import 'package:ready_lms/utils/api_client.dart';

import '../../other/data/more_tab.dart';

class PaymentHistoryService extends PaymentHistoryRepository{
  final Ref ref;
  PaymentHistoryService(this.ref);

  @override
  Future<Response> getHistory() async{
    final response = await  ref.read(apiClientProvider).get(AppConstants.getPaymentHistory);
    return response;
  }

}

final paymentHistoryServiceProvider = Provider((ref) => PaymentHistoryService(ref));