// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:ready_lms/components/buttons/app_button.dart';
// import 'package:ready_lms/components/custom_header_appbar.dart';
// import 'package:ready_lms/components/shimmer.dart';
// import 'package:ready_lms/config/app_color.dart';
// import 'package:ready_lms/config/app_constants.dart';
// import 'package:ready_lms/config/app_text_style.dart';
// import 'package:ready_lms/config/theme.dart';
// import 'package:ready_lms/features/courses/controller/course.dart';
// import 'package:ready_lms/features/courses/controller/my_course_details.dart';
// import 'package:ready_lms/features/courses/view/new_course/widget/couse_details.dart';
// import 'package:ready_lms/features/dashboard/controller/dashboard_nav.dart';
// import 'package:ready_lms/features/favourites/controller/favourites_tab.dart';
// import 'package:ready_lms/generated/l10n.dart';
// import 'package:ready_lms/routes.dart'; // ✅ IMPORTANT
// import 'package:ready_lms/utils/context_less_nav.dart';
// import 'package:ready_lms/utils/entensions.dart';
//
// import 'widget/about_tab.dart';
// import 'widget/lessons_tab.dart';
// import 'widget/reviews_tab.dart';
//
// class CourseNewScreen extends ConsumerStatefulWidget {
//   const CourseNewScreen({
//     super.key,
//     required this.courseId,
//     this.isShowBottomNavigationBar = true,
//   });
//
//   final int courseId;
//   final bool isShowBottomNavigationBar;
//
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _CourseNewViewState();
// }
//
// class _CourseNewViewState extends ConsumerState<CourseNewScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref
//           .read(courseController.notifier)
//           .getNewCourseDetails(widget.courseId);
//     });
//
//     _tabController = TabController(length: 3, vsync: this);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final model = ref.watch(courseController).courseDetails;
//
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(0),
//         child: AppBar(),
//       ),
//
//       body: Column(
//         children: [
//           CustomHeaderAppBar(
//             title: S.of(context).courseDetails,
//             widget: SvgPicture.asset(
//               ref.watch(courseController).isFavourite
//                   ? 'assets/svg/ic_heart.svg'
//                   : 'assets/svg/ic_inactive_heart.svg',
//               width: 24.h,
//               height: 24.h,
//             ),
//             onTap: () => context.nav.pop(),
//           ),
//
//           Expanded(
//             child: ref.watch(courseController).isLoading || model == null
//                 ? const ShimmerWidget()
//                 : Column(
//                     children: [
//                       CourseDetails(model: model),
//
//                       TabBar(
//                         controller: _tabController,
//                         tabs: [
//                           Tab(text: S.of(context).about),
//                           Tab(text: S.of(context).lessons),
//                           Tab(text: S.of(context).reviews),
//                         ],
//                       ),
//
//                       Expanded(
//                         child: TabBarView(
//                           controller: _tabController,
//                           children: [
//                             const AboutTab(),
//                             const LessonsTab(),
//                             ReviewsTab(model: model),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ],
//       ),
//
//       /// ✅ FIXED BOTTOM BAR
//       bottomNavigationBar: !widget.isShowBottomNavigationBar
//           ? null
//           : SafeArea(
//               child: Container(
//                 padding:
//                     EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         model?.course.isFree == true
//                             ? S.of(context).free
//                             : '${AppConstants.currencySymbol}${model?.course.price}',
//                         style: AppTextStyle(context).subTitle,
//                       ),
//                     ),
//
//                     SizedBox(
//                       height: 45.h, // ✅ FIXED BUTTON HEIGHT
//                       child: AppButton(
//                         title: S.of(context).enrolNow,
//                         titleColor: context.color.surface,
//                         onTap: () {
//                           if (model == null) return;
//
//                           if (model.course.isFree == true) {
//                             ref
//                                 .read(
//                                     freeCourseEnrollController.notifier)
//                                 .freeCourseEnroll(
//                                     courseId: model.course.id)
//                                 .then((response) {
//                               if (response.isSuccess) {
//                                 courseEnrollSuccessDialog(
//                                   context: context,
//                                   ref: ref,
//                                 );
//                               }
//                             });
//                           } else {
//                             showPurchaseWebsiteDialog(context);
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
//
// /// ✅ KEEP OUTSIDE CLASS
// void courseEnrollSuccessDialog({
//   required BuildContext context,
//   required WidgetRef ref,
// }) {
//   showDialog(
//     context: context,
//     builder: (_) => AlertDialog(
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(Icons.check_circle, color: Colors.green, size: 50),
//           const SizedBox(height: 10),
//           const Text("Course Enrolled Successfully"),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.nav.pushNamedAndRemoveUntil(
//                   Routes.dashboard, (route) => false);
//               ref.read(homeTabControllerProvider.notifier).state = 1;
//             },
//             child: const Text("Start Learning"),
//           )
//         ],
//       ),
//     ),
//   );
// }
//
// void showPurchaseWebsiteDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (_) => Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: const [
//             Icon(Icons.language, size: 40, color: Colors.orange),
//             SizedBox(height: 10),
//             Text(
//               "Purchase on Website",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               "Please purchase this course on our website.\nThen access it inside the app.",
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/custom_header_appbar.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/features/courses/controller/course.dart';
import 'package:ready_lms/features/courses/view/new_course/widget/couse_details.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';

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
                      /// Course info (image, title, etc.)
                      CourseDetails(model: model),

                      /// Tabs
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: S.of(context).about),
                          Tab(text: S.of(context).lessons),
                          Tab(text: S.of(context).reviews),
                        ],
                      ),

                      /// Content / Locked UI
                      Expanded(
                        child: model.course.isEnrolled
                            ? TabBarView(
                                controller: _tabController,
                                children: [
                                  const AboutTab(),
                                  const LessonsTab(),
                                  ReviewsTab(model: model),
                                ],
                              )
                            : _buildLockedUI(context),
                      ),
                    ],
                  ),
          ),
        ],
      ),

      /// ❌ REMOVED BOTTOM BAR COMPLETELY
      bottomNavigationBar: null,
    );
  }

  /// 🔒 Locked UI (for non-enrolled users)
  Widget _buildLockedUI(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 40),
            const SizedBox(height: 10),
            Text(
              "This course is available to enrolled users",
              style: AppTextStyle(context).subTitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}