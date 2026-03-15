import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.image,
    required this.title,
    required this.totalCourse,
    required this.color,
    required this.onTap,
    required this.width,
    this.height
  });
  final String image, title;
  final int totalCourse;
  final Color color;
  final VoidCallback onTap;
  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(12.h),
        margin: EdgeInsets.only(right: 12.h),
        decoration: BoxDecoration(
            borderRadius: AppComponents.defaultBorderRadiusLarge,
            color: color.withOpacity(.6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeInImage.assetNetwork(
              placeholder: 'assets/images/spinner.gif',
              image: image,
              height: 20.h,
              width: 20.w,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: context.color.primary);
              },
            ),
            8.ph,
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                fontSize: 12,
                  color: AppStaticColor.whiteColor,
                  fontWeight: FontWeight.w600),
            ),
            4.ph,
            Text(
              '$totalCourse ${S.of(context).course}',
              style: AppTextStyle(context)
                  .bodyTextSmall
                  .copyWith(color: AppStaticColor.whiteColor, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
