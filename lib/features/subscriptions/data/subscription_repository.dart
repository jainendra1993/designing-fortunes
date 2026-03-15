import 'package:dio/dio.dart';

abstract class SubscriptionRepository{

  Future<Response> getPlanList();
  Future<Response> planEnroll(Map<String, dynamic> data);
  Future<Response> getEnrolledPlan();

}