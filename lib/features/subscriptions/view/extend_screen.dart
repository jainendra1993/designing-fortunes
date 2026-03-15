import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/features/subscriptions/provider/subscription_providers.dart';
import 'package:ready_lms/features/subscriptions/view/components/subscription_extend_card.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/global_function.dart';

class PlanExtendScreen extends ConsumerStatefulWidget {
  const PlanExtendScreen({super.key});

  @override
  ConsumerState<PlanExtendScreen> createState() => _PlanExtendScreenState();
}

class _PlanExtendScreenState extends ConsumerState<PlanExtendScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  init() {
    ref.read(enrolledPlanControllerProvider.notifier).getEnrolledPlan();
    ref.read(subscriptionControllerProvider.notifier).getSubscriptionPlan();
  }

  @override
  Widget build(BuildContext context) {
    final enrolledPlan = ref.watch(enrolledPlanControllerProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).planAndPayment,
          ),
          leading: IconButton(
              onPressed: () {
                context.nav.pop();
                // ref.read(homeTabControllerProvider.notifier).state = 3;
              },
              icon: SvgPicture.asset(
                'assets/svg/ic_arrow_left.svg',
                width: 24.h,
                height: 24.h,
                color: context.color.onSurface,
              )),
        ),
        body: enrolledPlan.when(
            data: (data) {
              final enrolledData = data.data ?? [];
              if (enrolledData.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/svg/no_item_found.svg"),
                    ApGlobalFunctions.noItemFound(
                        context: context,
                        text: S.of(context).noCoursePurchased,
                        size: 25),
                    Gap(10),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 80,
                        right: 80,
                      ),
                      child: AppButton(
                        title: S.of(context).subscriptionPackage,
                        titleColor: context.color.surface,
                        onTap: () {
                          context.nav.pushNamed(Routes.subscriptionScreen);
                        },
                      ),
                    )
                  ],
                );
              }
              return ListView.builder(
                  itemCount: enrolledData.length,

                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        child: SubscriptionExtendCard(
                            title: enrolledData[index].title.toString(),
                            date: enrolledData[index].subscribedAt.toString(),
                            amount: enrolledData[index].plan!.price.toString(),
                            transationId:
                                enrolledData[index].transactionId.toString(),
                            email: "example@gmail.com",
                            onTap: () {
                              context.nav.pushNamed(Routes.selectCourseScreen, arguments: {
                                'title' :  enrolledData[index].title.toString()
                              });

                              ref.read(selectedCoursesProvider.notifier).courseId = enrolledData[index].courseIds!;
                              print( ref.read(selectedCoursesProvider.notifier).courseId );
                            },
                            status: enrolledData[index].status ?? true,
                            billingType:
                                enrolledData[index].plan!.planType.toString(),
                            startDate: enrolledData[index].startsAt.toString(),
                            endDate: enrolledData[index].endsAt.toString()));
                  });
            },
            error: (e, _) => Center(child: Text("Error: $e")),
            loading: () => const Center(
                    child: CircularProgressIndicator(
                  color: AppStaticColor.primaryColor,
                ))));
  }
}
