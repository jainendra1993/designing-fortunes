import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/features/other/model/common_response_model.dart';
import 'package:ready_lms/features/subscriptions/model/enrolled_plan_model.dart';
import 'package:ready_lms/features/subscriptions/model/subscription_model.dart';
import 'package:ready_lms/features/subscriptions/provider/subscription_providers.dart';

class SubscriptionController
    extends StateNotifier<AsyncValue<SubscriptionPlanModel>> {
  final Ref ref;

  SubscriptionController(this.ref) : super(AsyncValue.loading());

  Future<SubscriptionPlanModel?> getSubscriptionPlan() async {
    try {
      state = AsyncValue.loading();
      final response =
      await ref.read(subscriptionRepoImpProvider).getPlanList();
      if (response.statusCode == 200) {
        final subscriptionPlanModel =
        SubscriptionPlanModel.fromJson(response.data);
        state = AsyncValue.data(subscriptionPlanModel);
      } else {
        state = AsyncValue.error("Something Went Wrong", StackTrace.current);
      }
    } catch (e, s) {
      throw s;
    }
  }
}

class SubscriptionPayment extends StateNotifier<bool> {
  SubscriptionPayment(this.ref) : super(false);
  final Ref ref;

  Future<CommonResponse> enrollPlan(Map<String, dynamic> data) async {
    try {
      state = true;
      final response =
      await ref.read(subscriptionRepoImpProvider).planEnroll(data);
      final String message = response.data['message'];
      if (response.statusCode == 201) {
        final String paymentUrl = response.data['data']['payment_webview_url'];
        state = false;
        final commonResponse = CommonResponse(
            isSuccess: true, message: message, response: paymentUrl);
        return commonResponse;
      } else {
        state = false;
        final commonResponse =
        CommonResponse(isSuccess: true, message: message);
        return commonResponse;
      }
    } catch (e) {
      state = false;
      final commonResponse =
      CommonResponse(isSuccess: true, message: e.toString());
      return commonResponse;
    }
  }
}

class SelectedCoursesNotifier extends StateNotifier<List<Course>> {
  SelectedCoursesNotifier() : super([]);

  double _totalPrice = 0.0;
  List<int> courseId = [];

  double get totalPrice => _totalPrice;

  void addCourse(Course course) {
    state = [...state, course];
    _totalPrice += (course.price?.toDouble() == null)
        ? course.regularPrice!.toDouble()
        : course.price!.toDouble();
    courseId.add(course.id!);
    print("Total Price: $totalPrice");
    print("Course IDs: $courseId");
  }

  void removeCourse(Course course) {
    state = state.where((c) => c.id != course.id).toList();
    _totalPrice -= (course.price?.toDouble() == null)
        ? course.regularPrice!.toDouble()
        : course.price!.toDouble();
    if (_totalPrice < 0) _totalPrice = 0.0;
    courseId.remove(course.id);
    print("Total Price: $totalPrice");
    print("Course IDs: $courseId");
  }

  void resetTotalPrice() {
    _totalPrice = 0.0;
    courseId.clear();
  }

  void setInitialCourses(List<Course> courses) {
    state = courses;
    _totalPrice = courses.fold(0.0, (sum, course) => sum + ((course.price?.toDouble() == null)
        ? course.regularPrice!.toDouble()
        : course.price!.toDouble()));
    courseId = courses.map((c) => c.id!).toList();
  }


}

class EnrolledSubscriptionPlanController extends StateNotifier<AsyncValue<EnrolledPlanModel>>{
  EnrolledSubscriptionPlanController(this.ref) : super(AsyncValue.loading());
  final Ref ref;

  Future<EnrolledPlanModel> getEnrolledPlan()async{
    try{
      state = AsyncValue.loading();
      final response = await ref.read(subscriptionRepoImpProvider).getEnrolledPlan();
      if(response.statusCode == 200){
        final enrolledPlanModel = EnrolledPlanModel.fromJson(response.data);
        state = AsyncValue.data(enrolledPlanModel);
        return enrolledPlanModel;
      }else{
        state = AsyncValue.error("Something Went Wrong", StackTrace.current);
        throw Exception("Something Went Wrong");
      }
    }catch(e,s){
      state = AsyncValue.error(e, s);
      throw s;
    }
  }


}
