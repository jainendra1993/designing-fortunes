import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/custom_header_appbar.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/features/courses/controller/course.dart';
import 'package:ready_lms/features/courses/view/new_course/widget/couse_details.dart';
import 'package:ready_lms/features/dashboard/controller/dashboard_nav.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/payment_service.dart';
import 'package:ready_lms/utils/context_less_nav.dart';

import 'package:ready_lms/features/courses/data/course.dart';


import 'widget/about_tab.dart';
import 'widget/lessons_tab.dart';
import 'widget/reviews_tab.dart';

class CourseNewScreen extends ConsumerStatefulWidget {
  const CourseNewScreen({
    super.key,
    required this.courseId,
    this.isShowBottomNavigationBar = true,
  });

  final int courseId;
  final bool isShowBottomNavigationBar;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CourseNewViewState();
}

class _CourseNewViewState extends ConsumerState<CourseNewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _iapLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(courseController.notifier)
          .getNewCourseDetails(widget.courseId);
    });
    _tabController = TabController(length: 3, vsync: this);
  }

  // ─── iOS IAP Purchase ─────────────────────────────────────────────────────
  Future<void> _handleIOSPurchase(int courseId) async {
    setState(() => _iapLoading = true);

    final productId = appleProductId(courseId);

    // Check if product exists on App Store first
    final product = await PaymentService().fetchProduct(productId);
    if (product == null) {
      setState(() => _iapLoading = false);
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: context.color.surface,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline,
                    size: 40, color: Colors.orange),
                const SizedBox(height: 12),
                const Text(
                  'Not Available Yet',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'This course is not yet available for purchase on iOS. Please check back in 1-2 days.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                )
              ],
            ),
          ),
        );
      }
      return;
    }

    await PaymentService().purchaseProduct(
      productId: productId,
      onSuccess: (PurchaseDetails purchase) async {
        final receipt =
            purchase.verificationData.serverVerificationData;
        await _verifyReceiptWithBackend(
          courseId: courseId,
          receipt: receipt,
          transactionId: purchase.purchaseID ?? '',
        );
      },
      onError: (error) {
        setState(() => _iapLoading = false);
        EasyLoading.showError(error);
      },
      onCancelled: () {
        setState(() => _iapLoading = false);
      },
    );
  }

  /// Send Apple receipt to Laravel for verification + enrollment
  Future<void> _verifyReceiptWithBackend({
    required int courseId,
    required String receipt,
    required String transactionId,
  }) async {
    try {
      // TODO: Replace with your actual API call once Laravel endpoint is ready
      // final response = await ref.read(courseServiceProvider).verifyAppleIAP({
      //   'course_id': courseId,
      //   'receipt': receipt,
      //   'transaction_id': transactionId,
      // });
      // if (response.statusCode == 200) {
      //   setState(() => _iapLoading = false);
      //   if (mounted) _showPaymentSuccessDialog(courseId);
      // } else {
      //   setState(() => _iapLoading = false);
      //   EasyLoading.showError('Verification failed. Contact support.');
      // }

        final response = await ref.read(courseServiceProvider).verifyAppleIAP({
            'course_id': courseId,
            'receipt': receipt,
            'transaction_id': transactionId,
          });
          if (response.statusCode == 200) {
            setState(() => _iapLoading = false);
            if (mounted) _showPaymentSuccessDialog(courseId);
          } else {
            setState(() => _iapLoading = false);
            EasyLoading.showError('Verification failed. Contact support.');
          }

      setState(() => _iapLoading = false);
      if (mounted) _showPaymentSuccessDialog(courseId);
    } catch (e) {
      setState(() => _iapLoading = false);
      EasyLoading.showError('Verification failed. Contact support.');
    }
  }

  // ─── Android → existing WebView checkout ──────────────────────────────────
  Future<void> _handleAndroidPurchase(int courseId) async {
    context.nav.pushNamed(
      Routes.checkOutScreen,
      arguments: {'courseId': courseId},
    );
  }

  // ─── Free Course Enroll ───────────────────────────────────────────────────
  Future<void> _handleFreeEnroll(int courseId) async {
    final response = await ref
        .read(freeCourseEnrollController.notifier)
        .freeCourseEnroll(courseId: courseId);
    if (response.isSuccess && mounted) {
      _showEnrollSuccessDialog();
    } else {
      EasyLoading.showError(response.message);
    }
  }

  // ─── Unified Buy Button Handler ───────────────────────────────────────────
  Future<void> _onEnrolTap(int courseId, bool isFree) async {
    if (isFree) {
      await _handleFreeEnroll(courseId);
    } else if (Platform.isIOS) {
      await _handleIOSPurchase(courseId);
    } else {
      await _handleAndroidPurchase(courseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(courseController).courseDetails;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: Column(
        children: [
          CustomHeaderAppBar(
            title: S.of(context).courseDetails,
            widget: SvgPicture.asset(
              ref.watch(courseController).isFavourite
                  ? 'assets/svg/ic_heart.svg'
                  : 'assets/svg/ic_inactive_heart.svg',
              width: 24.h,
              height: 24.h,
            ),
            onTap: () => context.nav.pop(),
          ),
          Expanded(
            child: ref.watch(courseController).isLoading || model == null
                ? const ShimmerWidget()
                : Column(
                    children: [
                      CourseDetails(model: model),
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: S.of(context).about),
                          Tab(text: S.of(context).lessons),
                          Tab(text: S.of(context).reviews),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            const AboutTab(),
                            const LessonsTab(),
                            ReviewsTab(model: model),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),

      // ─── Bottom Bar ────────────────────────────────────────────────────────
      bottomNavigationBar:
          !widget.isShowBottomNavigationBar || model == null
              ? null
              : model.course.isEnrolled
                  ? null // Already enrolled → no bottom bar
                  : SafeArea(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 16.h),
                        child: Row(
                          children: [
                            // Price
                            Expanded(
                              child: Text(
                                model.course.isFree == true
                                    ? S.of(context).free
                                    : '${AppConstants.currencySymbol}${model.course.price}',
                                style: AppTextStyle(context).subTitle,
                              ),
                            ),

                            // Buy / Enrol button
                            SizedBox(
                              height: 45.h,
                              child: AppButton(
                                title: model.course.isFree == true
                                    ? S.of(context).enrolNow
                                    : S.of(context).enrolNow,
                                titleColor: context.color.surface,
                                showLoading: _iapLoading ||
                                    ref.watch(freeCourseEnrollController),
                                onTap: () => _onEnrolTap(
                                  model.course.id,
                                  model.course.isFree == true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
    );
  }

  // ─── Dialogs ──────────────────────────────────────────────────────────────

  void _showEnrollSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.color.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 50),
            const SizedBox(height: 10),
            const Text(
              'Course Enrolled Successfully',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.nav.pushNamedAndRemoveUntil(
                      Routes.dashboard, (route) => false);
                  ref.read(homeTabControllerProvider.notifier).state = 1;
                },
                child: const Text('Start Learning'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showPaymentSuccessDialog(int courseId) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.color.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 50),
            const SizedBox(height: 10),
            Text(
              S.of(context).paymentSuccessful,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'You now have full access to this course.',
              textAlign: TextAlign.center,
              style: AppTextStyle(context).bodyTextSmall,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.myCourseDetails,
                    (route) => false,
                    arguments: courseId,
                  );
                },
                child: Text(S.of(context).startLearning),
              ),
            )
          ],
        ),
      ),
    );
  }
}