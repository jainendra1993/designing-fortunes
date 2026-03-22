import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/buttons/outline_button.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/hive_contants.dart';
import 'package:ready_lms/features/subscriptions/model/subscription_model.dart';
import 'package:ready_lms/features/subscriptions/provider/subscription_providers.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../auth/controller/auth.dart';
import '../../auth/view/widget/login_bottom_widget.dart';
import '../../auth/view/widget/otp_bottom_widget.dart';
import '../../dashboard/controller/dashboard_nav.dart';
import '../controller/checkout.dart';
import 'widget/body.dart';

class CheckOutScreen extends ConsumerStatefulWidget {
  CheckOutScreen(
      {super.key,
        required this.courseId,
        this.isSubscription = false,
        this.selectedCourses,
        this.planId,
        this.planTitle,
        this.planPrice});

  final int courseId;
  final bool? isSubscription;
  final List<Course>? selectedCourses;
  final String? planTitle;
  final String? planPrice;
  final int? planId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CheckOutScreenViewState();
}

class _CheckOutScreenViewState extends ConsumerState<CheckOutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /*if (widget.isSubscription == false) {
        init();
      }*/
      init();
    });
  }

  Future<void> init() async {
    ref.read(checkoutController.notifier).getNewCourseDetails(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(checkoutController).courseDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).checkOut,
        ),
        leading: IconButton(
            onPressed: () {
              context.nav.pop();
            },
            icon: SvgPicture.asset(
              'assets/svg/ic_arrow_left.svg',
              width: 24.h,
              height: 24.h,
              color: context.color.onSurface,
            )),
      ),
      body: Scaffold(
        body: ref.watch(checkoutController).isLoading || model == null
            ? const ShimmerWidget()
            : Body(
          isSubscription: widget.isSubscription,
          subscriptionPrice: double.tryParse(widget.planPrice ?? '0.0'),
        ),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child:Container(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
          width: double.infinity,
          color: context.color.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    S.of(context).payableAmount,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(context).bodyTextSmall.copyWith(),
                  ),
                  const Spacer(),
                  Text(
                    (widget.isSubscription == false)
                        ? '${AppConstants.currencySymbol}${ref.watch(checkoutController).totalPrice - ref.watch(checkoutController).couponAmount}'
                        : '${AppConstants.currencySymbol}${widget.planPrice}',
                    style: AppTextStyle(context).subTitle,
                  ),
                ],
              ),
              8.ph,
              AppButton(
                title: S.of(context).payNow,
                width: double.infinity,
                titleColor: context.color.surface,
                textPaddingVertical: 13.h,
                showLoading: ref.watch(checkoutController).isEnrollLoading,
                onTap: ref.watch(checkoutController).paymentMethod == ''
                    ? null
                    : () async {
                  if (model != null) {
                    if (ref.read(hiveStorageProvider).isGuest()) {
                      Hive.box(AppHSC.appSettingsBox)
                          .put(AppHSC.path, "checkout");
                      EasyLoading.showInfo(S.of(context).plzLoginDec);
                      ApGlobalFunctions.showBottomSheet(
                          context: context,
                          widget: const LoginBottomWidget());
                      return;
                    }
                    if (widget.isSubscription == true) {
                      var data = {
                        'plan_id': widget.planId,
                        'payment_gateway':
                        ref.watch(checkoutController).paymentMethod,
                        'total_amount':
                        double.tryParse(widget.planPrice ?? '0.0') ??
                            0.0,
                        'course_ids': ref
                            .read(selectedCoursesProvider.notifier)
                            .courseId
                      };
                      print("All data: $data");

                      var res = await ref
                          .read(subscriptionPaymentProvider.notifier)
                          .enrollPlan(data);
                      if (res.isSuccess) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) {
                              return PayWithWeb(
                                url: res.response,
                                courseID: ref
                                    .read(selectedCoursesProvider.notifier)
                                    .courseId
                                    .first,
                              );
                            }));
                      }
                    } else {
                      double totalAmount =
                          ref.watch(checkoutController).totalPrice -
                              ref.watch(checkoutController).couponAmount;
                      var res = await ref
                          .read(checkoutController.notifier)
                          .enrollCourseById(
                        id: model.course.id,
                        totalAmount: totalAmount,
                      );
                      if (res.isSuccess) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) {
                              return PayWithWeb(
                                url: res.response,
                                courseID: widget.courseId,
                              );
                            }));
                      } else {
                        if (res.message ==
                            'Account activation required') {
                          activeAccountDialog(context: context);
                        }
                      }
                    }
                  }
                },
              )
            ],
          ),
        ),
        )
      ),
    );
  }

  activeAccountDialog({
    required BuildContext context,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: context.color.surface,
        shadowColor: context.color.surface,
        backgroundColor: context.color.surface,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.w))),
        content: Container(
          width: MediaQuery.of(context).size.width - 30.h,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please Active Your Account",
                textAlign: TextAlign.center,
                style: AppTextStyle(context).bodyText.copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w500,
                    color: AppStaticColor.redColor),
              ),
              20.ph,
              SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                          child: AppOutlineButton(
                            title: S.of(context).cancel,
                            width: double.infinity,
                            buttonColor: context.color.surface,
                            titleColor: AppStaticColor.redColor,
                            textPaddingVertical: 16.h,
                            borderRadius: 12.r,
                            onTap: () => context.nav.pop(),
                          )),
                      12.pw,
                      Expanded(child: Consumer(builder: (context, ref, _) {
                        return AppButton(
                          title: "Active",
                          width: double.infinity,
                          showLoading: ref.watch(authController),
                          titleColor: context.color.surface,
                          textPaddingVertical: 16.h,
                          onTap: () async {
                            var res = await ref
                                .read(authController.notifier)
                                .activeAccountRequest();
                            if (res.isSuccess) {
                              context.nav.pop();
                              ApGlobalFunctions.showBottomSheet(
                                  context: context,
                                  widget: OTPBottomWidget(
                                    senderText: ref
                                        .read(hiveStorageProvider)
                                        .getUserInfo()
                                        ?.email ??
                                        "Demo",
                                  ));
                            } else {
                              EasyLoading.showError(res.message);
                            }
                          },
                        );
                      })),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class PayWithWeb extends StatefulWidget {
  final String url;
  final int courseID;

  const PayWithWeb({
    super.key,
    required this.url,
    required this.courseID,
  });

  @override
  State<PayWithWeb> createState() => _PayWithWebState();
}

class _PayWithWebState extends State<PayWithWeb> {
  late final WebViewController controller;

  bool _handled = false; // 🔥 prevent multiple calls

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          // 🔥 MAIN FIX (like old onLoadStart)
          onPageStarted: (url) {
            debugPrint("STARTED: $url");

            if (url.contains('payment/success')) {
              handleSuccess();
            }

            if (url.contains('payment/cancel')) {
              handleCancel();
            }
          },

          onPageFinished: (url) {
            debugPrint("FINISHED: $url");

            if (url.contains('payment/success')) {
              handleSuccess();
            }

            if (url.contains('payment/cancel')) {
              handleCancel();
            }
          },

          onNavigationRequest: (request) {
            debugPrint("NAV: ${request.url}");
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  // ✅ SUCCESS HANDLER
  void handleSuccess() {
    if (_handled) return;
    _handled = true;

    Navigator.pop(context); // close webview

    Future.delayed(const Duration(milliseconds: 200), () {
      paymentSuccessDialog(context: context, id: widget.courseID);
    });
  }

  // ❌ CANCEL HANDLER
  void handleCancel() {
    if (_handled) return;
    _handled = true;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment canceled")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: WebViewWidget(controller: controller),
    );
  }

  // 🎉 YOUR OLD SUCCESS UI (same as screenshot)
  void paymentSuccessDialog({
    required BuildContext context,
    required int id,
  }) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: context.color.surface,
        shadowColor: context.color.surface,
        backgroundColor: context.color.surface,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width - 30.h,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.h,
                height: 60.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStaticColor.greenColor,
                ),
                child: Center(
                  child: Icon(
                    Icons.done_rounded,
                    color: context.color.surface,
                    size: 32.h,
                  ),
                ),
              ),
              16.ph,
              Text(
                S.of(context).paymentSuccessful,
                textAlign: TextAlign.center,
                style: AppTextStyle(context).title.copyWith(
                  fontSize: 22.sp,
                ),
              ),
              16.ph,
              Text(
                '${S.of(context).paymentDes} ${AppConstants.appName}',
                textAlign: TextAlign.center,
                style: AppTextStyle(context).bodyTextSmall,
              ),
              20.ph,
              AppButton(
                title: S.of(context).startLearning,
                width: double.infinity,
                titleColor: context.color.surface,
                textPaddingVertical: 13.h,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.myCourseDetails,
                    (route) => false,
                    arguments: widget.courseID,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}