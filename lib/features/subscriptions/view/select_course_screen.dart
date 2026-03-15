import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/features/dashboard/controller/dashboard_nav.dart';
import 'package:ready_lms/features/subscriptions/model/subscription_model.dart';
import 'package:ready_lms/features/subscriptions/provider/subscription_providers.dart';
import 'package:ready_lms/features/subscriptions/view/components/course_card.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';

import '../../../routes.dart';

class SelectCourseScreen extends ConsumerStatefulWidget {
  const SelectCourseScreen({super.key, required this.plan});

  final String plan;

  @override
  ConsumerState<SelectCourseScreen> createState() => _SelectCourseScreenState();
}

class _SelectCourseScreenState extends ConsumerState<SelectCourseScreen> {
  PlanData? selectedPlan;

  @override
  Widget build(BuildContext context) {
    final planModel = ref.watch(subscriptionControllerProvider);
    return PopScope(
      onPopInvokedWithResult: (e,s){
        ref.read(selectedCoursesProvider.notifier).state = [];
        ref.read(selectedCoursesProvider.notifier).resetTotalPrice();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).selectCourse,
          ),
          leading: IconButton(
              onPressed: () {
                ref.read(selectedCoursesProvider.notifier).state = [];
                ref.read(selectedCoursesProvider.notifier).resetTotalPrice();
                context.nav.pop();
                //ref.read(homeTabControllerProvider.notifier).state = 3;
              },
              icon: SvgPicture.asset(
                'assets/svg/ic_arrow_left.svg',
                width: 24.w,
                height: 24.h,
                color: context.color.onSurface,
              )),
        ),
        body: Column(
          children: [
            10.ph,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(color: context.color.surface),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).selectSubscriptionPlan,
                    style: AppTextStyle(context).title.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.57,
                        ),
                  ),
                  16.ph,
                  //Dropdown Menu ------>
                  Container(
                    width: double.infinity,
                    height: 52,
                    padding: const EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF6F7F9),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFD7DAE0),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: planModel.when(
                        data: (subscriptionData) {
                          final plans = subscriptionData.data ?? [];
                          if (plans.isEmpty) {
                            return const Center(
                                child: Text("No plans available"));
                          }

                          // Find the initial plan.
                          final initialPlan = plans.firstWhere(
                            (p) => p.title == widget.plan,
                            orElse: () => plans.first,
                          );

                          // If selectedPlan is null, initialize it with the initialPlan.
                          // This ensures selectedPlan is set once the data is available.
                          if (selectedPlan == null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  selectedPlan = initialPlan;
                                });
                                final courseIds = ref.read(selectedCoursesProvider.notifier).courseId;
                                if (initialPlan.courses != null && courseIds.isNotEmpty) {
                                  final initialCourses = initialPlan.courses!
                                      .where((course) => courseIds.contains(course.id))
                                      .toList();
                                  ref.read(selectedCoursesProvider.notifier).setInitialCourses(initialCourses);
                                }
                              }
                            });
                          }

                          return DropdownButton<PlanData>(
                            value: selectedPlan,
                            // Now selectedPlan will be non-null after first build
                            hint: Text(
                              "Select a plan",
                              style: AppTextStyle(context).bodyText.copyWith(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                            ),
                            isExpanded: true,
                            items: plans.map((plan) {
                              return DropdownMenuItem(
                                value: plan,
                                child: Text(
                                  "${plan.title.toString()} (Maximum ${plan.courseLimit.toString()} courses)",
                                  style: AppTextStyle(context).bodyText.copyWith(
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                      ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPlan = value;
                                ref.read(selectedCoursesProvider.notifier).state =
                                    [];
                                ref
                                    .read(selectedCoursesProvider.notifier)
                                    .resetTotalPrice();
                              });
                            },
                          );
                        },
                        loading: () => const ShimmerWidget(),
                        error: (err, stack) => Center(child: Text('Error: $err')),
                      ),
                    ),
                  )
                ],
              ),
            ),
            10.ph,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(color: context.color.surface),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).selectCourse,
                    style: AppTextStyle(context).title.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.57,
                        ),
                  ),
                  16.ph,
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.55,
                    child: ListView.builder(
                        itemCount: selectedPlan?.courses?.length ?? 0,
                        itemBuilder: (context, index) {
                          final course = selectedPlan!.courses![index];
                          final selectedCourses =
                              ref.watch(selectedCoursesProvider);
                          final isSelected = selectedCourses.contains(course);
                          final courseLimit = int.parse(selectedPlan!.courseLimit.toString());

                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: CourseCard(
                              course: course,
                              isSelected: isSelected,
                              onChanged: (value) {
                                if (value == true) {
                                  (ref.read(selectedCoursesProvider).length !=
                                          int.parse(selectedPlan!.courseLimit
                                              .toString()))
                                      ? ref
                                          .read(selectedCoursesProvider.notifier)
                                          .addCourse(course)
                                      : ApGlobalFunctions.showCustomSnackbar(
                                          message:
                                              "You can select only ${int.parse(selectedPlan!.courseLimit.toString())} courses",
                                          isSuccess: false);
                                } else {
                                  ref
                                      .read(selectedCoursesProvider.notifier)
                                      .removeCourse(course);
                                }
                              },
                              courseLimit:
                                  int.parse(selectedPlan!.courseLimit.toString()),
                              isDisable: !selectedCourses.contains(course) && selectedCourses.length >= courseLimit
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.07,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(homeTabControllerProvider.notifier).state = 1;
                    (ref.read(selectedCoursesProvider).isNotEmpty)
                        ? context.nav
                            .pushNamed(Routes.checkOutScreen, arguments: {
                            'courseId':
                                ref.read(selectedCoursesProvider).first.id,
                            'isSubscription': true,
                            'selectedCourse': ref.read(selectedCoursesProvider),
                            'planTitle': selectedPlan?.title,
                            'planPrice': selectedPlan?.price,
                            'planId': selectedPlan?.id,
                          })
                        : ApGlobalFunctions.showCustomSnackbar(
                            message: "Please select at least one course",
                            isSuccess: false);


                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStaticColor.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    S.of(context).checkOut,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
