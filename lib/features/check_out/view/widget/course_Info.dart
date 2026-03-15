import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/custom_dot.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/features/subscriptions/model/subscription_model.dart';
import 'package:ready_lms/features/subscriptions/provider/subscription_providers.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

import '../../../../utils/global_function.dart';
import '../../controller/checkout.dart';

class CourseInfo extends ConsumerWidget {
  const CourseInfo({super.key, this.isSubscription = false});

  final bool? isSubscription;

  @override
  Widget build(BuildContext context, ref) {
    String? image = ref
        .read(checkoutController)
        .courseDetails
        ?.course
        .instructor
        .profilePicture;
    return (isSubscription == false)
        ? viewCourseContent(context, ref, image, [], 0, false)
        : Container(
            height:
                (ref.read(selectedCoursesProvider).length > 1) ? 220.h : 98.h,
            child: ListView.builder(
                itemCount: ref.read(selectedCoursesProvider).length,
                itemBuilder: (context, itemCount) {
                  return viewCourseContent(context, ref, image,
                      ref.read(selectedCoursesProvider), itemCount, true);
                }),
          );
  }

  Container viewCourseContent(BuildContext context, WidgetRef ref,
      String? image, List<Course>? courses, int index, bool? isSubscription) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: 10.h),
      color: context.color.surface,
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.h),
                child: FadeInImage.assetNetwork(
                  placeholderFit: BoxFit.contain,
                  placeholder: 'assets/images/spinner.gif',
                  image: (isSubscription == false)
                      ? ref
                              .read(checkoutController)
                              .courseDetails
                              ?.course
                              .thumbnail ??
                          AppConstants.defaultAvatarImageUrl
                      : courses![index].thumbnail.toString(),
                  width: 84.h,
                  height: 42.h,
                  fit: BoxFit.cover,
                ),
              ),
              12.pw,
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (isSubscription == false)
                        ? ref
                                .read(checkoutController)
                                .courseDetails
                                ?.course
                                .title ??
                            'Demo'
                        : courses![index].title.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(context).bodyTextSmall,
                  ),
                  8.ph,
                  Row(
                    children: [
                      Container(
                        width: 16.h,
                        height: 16.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.h),
                          child: image == null
                              ? Center(
                                  child: Image.asset(
                                    'assets/images/im_demo_user_1.png',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/spinner.gif',
                                  image: (isSubscription == false)
                                      ? image
                                      : courses![index]
                                          .instructor!
                                          .user!
                                          .profilePicture
                                          .toString(),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      6.pw,
                      Expanded(
                        child: Text(
                          (isSubscription == false)
                              ? 'Rob Sutcliffe'
                              : courses![index]
                                  .instructor!
                                  .user!
                                  .name
                                  .toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle(context).bodyTextSmall.copyWith(
                              color: context.color.inverseSurface,
                              fontSize: 12.sp),
                        ),
                      ),
                    ],
                  )
                ],
              ))
            ],
          ),
          13.ph,
          Row(
            children: [
              const CustomDot(),
              8.pw,
              Text(
                ApGlobalFunctions.convertMinutesToHours(
                    ref
                            .read(checkoutController)
                            .courseDetails
                            ?.course
                            .totalDuration ??
                        0,
                    context),
                //'${(ref.watch(checkoutController).courseDetails!.course.totalDuration / 60).toStringAsFixed(0)} ${S.of(context).hours}',
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                    color: context.color.inverseSurface, fontSize: 10.sp),
              ),
              8.pw,
              const CustomDot(),
              8.pw,
              Text(
                '${ref.watch(checkoutController).courseDetails?.course.videoCount} ${S.of(context).video}',
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                    color: context.color.inverseSurface, fontSize: 10.sp),
              ),
              8.pw,
              const CustomDot(),
              8.pw,
              Text(
                S.of(context).lifetimeAccess,
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                    color: context.color.inverseSurface, fontSize: 10.sp),
              ),
            ],
          )
        ],
      ),
    );
  }
}
