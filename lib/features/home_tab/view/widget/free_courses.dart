import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/buttons/outline_button.dart';
import 'package:ready_lms/components/course_card.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

import '../../../courses/model/course_list.dart';

class FreeCourses extends StatelessWidget {
  const FreeCourses({
    super.key,
    required this.courseList,
  });
  final List<CourseListModel> courseList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          16.pw,
          ...List.generate(
            courseList.length,
                (index) => (courseList[index].isFree == true) ? CourseCard(
              marginRight: 15,
              maxLineOfTitle: 1,
              model: courseList[index],
              // height: 160,
              onTap: () {
                if (courseList[index].isEnrolled) {
                  context.nav.pushNamed(Routes.myCourseDetails,
                      arguments: courseList[index].id);
                } else {
                  context.nav.pushNamed(Routes.courseNew,
                      arguments: {'courseId': courseList[index].id});
                }
              },
            ) : SizedBox.shrink(),
          ),
          /* Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: AppOutlineButton(
              title: S.of(context).viewAllCourses,
              icon: SvgPicture.asset(
                'assets/svg/ic_right_arrow.svg',
                color: context.color.primary,
                width: 24.h,
                height: 24.h,
              ),
              onTap: () {
                context.nav.pushNamed(Routes.allCourseScreen);
              },
            ),
          ),*/
          //  24.ph
        ],
      ),
    );
  }
}
