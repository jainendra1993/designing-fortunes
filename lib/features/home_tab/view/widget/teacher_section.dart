import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_lms/features/other/model/featured_instructor_model.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class TeacherSection extends ConsumerStatefulWidget {
  TeacherSection({super.key, required this.instructor});

  List<Instructor> instructor = [];

  @override
  ConsumerState<TeacherSection> createState() => _TeacherSectionState();
}

class _TeacherSectionState extends ConsumerState<TeacherSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          16.pw,
          ...List.generate(
              widget.instructor.length,
              (index) => InkWell(
                    onTap: () {},
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(6).r,
                      width: 140.w,
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.only(right: 8.r),
                      decoration: BoxDecoration(
                        color: context.color.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white38,
                          width: 2,
                        ),
                      ),
                      child: IntrinsicWidth(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                    height: 80.r,
                                    width: 142.w,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    // child: Image.asset(
                                    //   "assets/pngs/image.png",
                                    //   fit: BoxFit.cover,
                                    // ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          widget.instructor[index]
                                                  .profilePicture ??
                                              '',
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Gap(0.w),
                                Image.asset("assets/images/Star.png",
                                    width: 14.r, height: 14.r),
                                Gap(1.w),
                                Text(
                                  (widget.instructor[index].averageRating ?? '')
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Gap(15.w),
                              ],
                            ),
                            Text(
                              widget.instructor[index].name ?? '',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.instructor[index].title ?? '',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff5D5D5D),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
        ],
      ),
    );
  }
}
