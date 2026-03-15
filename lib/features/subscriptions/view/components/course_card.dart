import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/features/subscriptions/model/subscription_model.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class CourseCard extends StatefulWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.isSelected,
    this.onChanged,
    required this.courseLimit,
    this.isDisable = false
  });

  final Course course;
  final bool isSelected;
  final ValueChanged<bool?>? onChanged;
  final int courseLimit;
  final bool? isDisable;

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (widget.isDisable == true) ? 0.4 : 1.0,
      child: Container(
        width: double.infinity,
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xFFEFEAEA)),
                borderRadius: BorderRadius.circular(8))),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.course.thumbnail.toString(),
                  width: 120.w,
                  height: 104.h,
                  fit: BoxFit.cover,
                ),
                6.pw,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150.w,
                          child: Text(
                            widget.course.title.toString(),
                            softWrap: true,
                            maxLines:  2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle(context).title.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.67,
                                ),
                          ),
                        ),
                        5.pw,
                        Checkbox(
                          value: widget.isSelected,
                          onChanged: widget.onChanged,
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.selected)) {
                              return AppStaticColor.primaryColor;
                            }
                            return Colors.transparent;
                          }),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                        )
                      ],
                    ),
                    Text(
                      widget.course.instructor!.user!.name.toString(),
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle(context).subTitle.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.67,
                          color: Color(0xFF1B5AFD)),
                    ),
                    Row(
                      spacing: 4,
                      children: [
                        Text(
                          '${AppConstants.currencySymbol}${(widget.course.price ?? widget.course.regularPrice).toString()}',
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle(context).title.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.67,
                              color: const Color(0xFF030712)),
                        ),
                        if (widget.course.price != null)
                          Text(
                            '${AppConstants.currencySymbol}${widget.course.regularPrice.toString()}',
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle(context).title.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.67,
                                decoration: TextDecoration.lineThrough,
                                color: const Color(0xFF9CA3AF)),
                          ),
                      ],
                    ),
                  ],
                )
              ],
            ),
         /*       Positioned(
              top: 5,
              left: 5,
              child: Container(
                width: 38.w,
                decoration: ShapeDecoration(
                    color: context.color.surface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8))),
                child: Row(
                  spacing: 4,
                  children: [
                    Image.asset("assets/images/Star.png"),
                    Text(
                      "4.5",
                      style: TextStyle(
                        color: const Color(0xFF030712),
                        fontSize: 10,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700,
                        height: 1.40,
                        letterSpacing: 0.20,
                      ),
                    )
                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
