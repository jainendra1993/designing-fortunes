import 'package:dio/dio.dart';

abstract class PaymentHistoryRepository{
  Future<Response> getHistory();
}