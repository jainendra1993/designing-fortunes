import 'package:ready_lms/features/profile/model/updateUser.dart';
import 'package:dio/dio.dart';

abstract class Profile {
  Future<Response> updateProfile({required UpdateUser user});
}
