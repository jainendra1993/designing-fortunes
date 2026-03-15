import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/features/subscriptions/controller/subscription_controller.dart';
import 'package:ready_lms/features/subscriptions/data/subscription_repo_imp.dart';
import 'package:ready_lms/features/subscriptions/model/enrolled_plan_model.dart';
import 'package:ready_lms/features/subscriptions/model/subscription_model.dart';

final subscriptionRepoImpProvider = Provider((ref) => SubscriptionRepoImp(ref));
final subscriptionControllerProvider = StateNotifierProvider<
    SubscriptionController,
    AsyncValue<SubscriptionPlanModel>>((ref) => SubscriptionController(ref));

final selectedCoursesProvider =
    StateNotifierProvider<SelectedCoursesNotifier, List<Course>>((ref) {
  return SelectedCoursesNotifier();
});

final subscriptionPaymentProvider =
    StateNotifierProvider<SubscriptionPayment, bool>(
        (ref) => SubscriptionPayment(ref));

final enrolledPlanControllerProvider = StateNotifierProvider<
        EnrolledSubscriptionPlanController, AsyncValue<EnrolledPlanModel>>(
    (ref) => EnrolledSubscriptionPlanController(ref));
