import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/features/home_tab/model/banner.dart';
import 'package:ready_lms/features/other/model/common_response_model.dart';
import 'package:ready_lms/features/other/model/featured_instructor_model.dart';
import 'package:ready_lms/features/profile/model/contact_support.dart';
import 'package:ready_lms/features/courses/model/course_detail.dart';
import 'package:ready_lms/features/other/data/more_tab.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/utils/global_function.dart';

import '../../profile/model/master.dart';

class OtherController extends StateNotifier<bool> {
  final Ref ref;

  OtherController(this.ref) : super(false);
  MasterModel? masterModel;

  Future<CommonResponse> makeReview(
      {required int id, required Map<String, dynamic> data}) async {
    state = true;
    bool isSuccess = false;
    try {
      final response =
          await ref.read(otherServiceProvider).makeReview(id: id, data: data);
      state = false;
      if (response.statusCode == 200) {
        isSuccess = true;
      }
      return CommonResponse(
          isSuccess: isSuccess,
          message: response.data['message'],
          response: isSuccess
              ? SubmittedReview.fromJson(response.data['data']['review'])
              : null);
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> contactSupport(
      {required ContactSupport contactSupport}) async {
    state = true;
    bool isSuccess = false;
    try {
      final response = await ref
          .read(otherServiceProvider)
          .contactSupport(contactSupport: contactSupport);
      state = false;
      if (response.statusCode == 201) {
        isSuccess = true;
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> deleteAccount() async {
    state = true;
    bool isSuccess = false;
    try {
      final response = await ref.read(otherServiceProvider).deleteAccount();
      state = false;
      if (response.statusCode == 200) {
        isSuccess = true;
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> getMasterData() async {
    state = true;
    bool isSuccess = false;
    try {
      final response = await ref.read(otherServiceProvider).masterCall();
      state = false;
      if (response.statusCode == 200) {
        isSuccess = true;
        masterModel = MasterModel.fromJson(response.data['data']['master']);
        AppConstants.currencySymbol = masterModel?.currencySymbol ?? '€';
        AppConstants.appName = masterModel!.name;
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error, stackTracer) {
      debugPrint(error.toString());
      debugPrint(stackTracer.toString());
      masterModel = null;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<BannerModel?> getBanner() async {
    state = true;
    bool isSuccess = false;
    BannerModel bannerModel = BannerModel();
    try {
      final response = await ref.read(otherServiceProvider).getBanner();
      if (response.statusCode == 200) {
        isSuccess = true;
        bannerModel = BannerModel.fromJson(response.data['data']);
        return bannerModel;
      }
      return bannerModel;
    } catch (error) {

    } finally {
      state = false;
    }
  }

  Future<FeaturedInstructorModel?> getFeaturedInstructor() async {
    state = true;
    bool isSuccess = false;
    FeaturedInstructorModel featuredInstructorModel = FeaturedInstructorModel();

    try{
      final response = await ref.read(otherServiceProvider).getFeaturedInstructor();
      if(response.statusCode == 200) {
        isSuccess = true;
        featuredInstructorModel =
            FeaturedInstructorModel.fromJson(response.data);
        return featuredInstructorModel;
      }
      return featuredInstructorModel;
    }
    catch (error) {

    } finally {
      state = false;
    }

  }







}

final othersController =
    StateNotifierProvider<OtherController, bool>((ref) => OtherController(ref));
