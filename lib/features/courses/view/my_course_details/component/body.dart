import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/instructor_card.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/features/courses/model/course_detail.dart';
import 'package:ready_lms/features/courses/view/my_course_details/component/quizzes.dart';
import 'package:ready_lms/features/courses/view/my_course_details/component/review.dart';
import 'package:ready_lms/features/courses/view/my_course_details/component/video.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/global_function.dart';

import '../../../controller/my_course_details.dart';
import '../../new_course/widget/iframe_card.dart';

import 'exams.dart';
import 'image_card.dart';
import 'lessons.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer(builder: (context, ref, _) {
          String? fileSystem =
              ref.watch(myCourseDetailsController).currentPlay?.fileSystem;
          Contents? contents =
              ref.watch(myCourseDetailsController).currentPlay?.contents;
          var viewContentProvider =
              ref.watch(myCourseDetailsController).currentPlay?.isViewContent;
          if (fileSystem == FileSystem.video.name) {
            return const Visibility(
              visible: true,
              child: VideoCard(),
            );
          }
          if (fileSystem == FileSystem.audio.name) {
            return const Visibility(
              visible: true,
              child: VideoCard(),
            );
          }
          if (fileSystem == FileSystem.iframe.name) {
            return IframeCard(
              iframeUrl:
                  ref.read(myCourseDetailsController).currentPlay!.fileLink!,
              model: contents,
              isViewContent: viewContentProvider,
            );
          }
          if (fileSystem == FileSystem.document.name) {}
          return ImageCard(
              image:
                  ref.read(myCourseDetailsController).currentPlay!.fileLink!);
        }),
        Consumer(builder: (context, ref, _) {
          bool? isExpired = ref
              .read(myCourseDetailsController)
              .courseDetails!
              .course
              .isExpired;
          dynamic planId =
              ref.read(myCourseDetailsController).courseDetails!.course.planId;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (planId != null && planId != 0 && isExpired == false) {
              ApGlobalFunctions.showCustomSnackbar(
                  message: "This course is a part of a subscription",
                  isSuccess: true);
            }
          });

          if (isExpired == false) {
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Lessons(),
                    const Quizzes(),
                    const Exams(),
                    Consumer(
                      builder: (context, ref, _) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          child: InstructorCard(
                            model: ref
                                .read(myCourseDetailsController)
                                .courseDetails!
                                .course
                                .instructor,
                          ),
                        );
                      },
                    ),
                    const ReviewWidgets(),
                  ],
                ),
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(20),
                SvgPicture.asset("assets/svg/no_item_found.svg"),
                ApGlobalFunctions.noItemFound(
                    context: context,
                    text: "Subscription date expired",
                    size: 25),
                Gap(10),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 80,
                    right: 80,
                  ),
                  child: AppButton(
                    title: "Renew Now",
                    titleColor: context.color.surface,
                    buttonColor: AppStaticColor.primaryColor,
                    onTap: () {
                      context.nav.pushNamed(Routes.planExtendScreen);
                    },
                  ),
                )
              ],
            );
          }
        }),
      ],
    );
  }
}
