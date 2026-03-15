import 'dart:convert';

import 'package:dio/src/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/features/subscriptions/data/subscription_repository.dart';
import 'package:ready_lms/utils/api_client.dart';

class SubscriptionRepoImp extends SubscriptionRepository {
  final Ref ref;

  SubscriptionRepoImp(this.ref);

  @override
  Future<Response> getPlanList() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstants.getPlanList);
    return response;
  }

  @override
  Future<Response> planEnroll(Map<String, dynamic> data) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.planEnroll, data: data);
    return response;
  }

  @override
  Future<Response> getEnrolledPlan() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstants.enrolledPlan);
    return response;
  }
}
