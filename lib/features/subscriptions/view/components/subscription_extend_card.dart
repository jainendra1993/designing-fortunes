import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';

class SubscriptionExtendCard extends StatelessWidget {
  const SubscriptionExtendCard(
      {super.key,
      required this.title,
      required this.date,
      required this.amount,
      required this.transationId,
      required this.email,
      required this.onTap,
      required this.billingType,
      required this.startDate,
      required this.endDate,
      required this.status});

  final String title;
  final String date;
  final String amount;
  final String transationId;
  final String email;
  final String billingType;
  final String startDate;
  final String endDate;
  final VoidCallback onTap;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: ShapeDecoration(
          color: context.color.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    title,
                    style: AppTextStyle(context).hintText.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: colors(context).titleTextColor,
                        height: 1.57),
                  ),
                  Row(
                    children: [
                      Text(
                        "${AppConstants.currencySymbol}$amount",
                        style: AppTextStyle(context).bodyText.copyWith(
                            fontSize: 16.sp,
                            color: Color(0xFF5864FF),
                            fontWeight: FontWeight.w600,
                            height: 1.50),
                      ),
                      Text(
                        '/$billingType',
                        style: TextStyle(
                          color: const Color(0xFF24262D),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.67,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 2,
                children: [
                  Text(
                    date,
                    style: AppTextStyle(context).bodyText.copyWith(
                        fontSize: 13.sp, color: Colors.black, height: 1.80),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        S.of(context).paid,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            height: 1,
            color: Color(0xFFF6F7F9),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    S.of(context).transactionId,
                    style: AppTextStyle(context).hintText.copyWith(
                        fontSize: 13.sp,
                        color: colors(context).hintTextColor,
                        height: 1.80),
                  ),
                  Text(
                    transationId,
                    style: AppTextStyle(context).bodyText.copyWith(
                        fontSize: 12.sp,
                        color: Color(0xFF5864FF),
                        height: 1.80),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 2,
                children: [
                  Text(
                    S.of(context).emailAddress,
                    style: AppTextStyle(context).hintText.copyWith(
                        fontSize: 13.sp,
                        color: colors(context).hintTextColor,
                        height: 1.80),
                  ),
                  Text(
                    email,
                    style: AppTextStyle(context).bodyText.copyWith(
                        fontSize: 13.sp, color: Colors.black, height: 1.80),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            height: 1,
            color: Color(0xFFF6F7F9),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    S.of(context).startdate,
                    style: AppTextStyle(context).hintText.copyWith(
                        fontSize: 13.sp,
                        color: colors(context).hintTextColor,
                        height: 1.80),
                  ),
                  Text(
                    startDate,
                    style: AppTextStyle(context).bodyText.copyWith(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        height: 1.50),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 2,
                children: [
                  Text(
                    S.of(context).endDate,
                    style: AppTextStyle(context).hintText.copyWith(
                        fontSize: 13.sp,
                        color: colors(context).hintTextColor,
                        height: 1.80),
                  ),
                  Text(
                    endDate,
                    style: AppTextStyle(context).bodyText.copyWith(

                        fontSize: 12.sp, color: Color(0xFFF04438), height: 1.50,fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 12, right: 12),
              height: 40,
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: ShapeDecoration(
                color:  (status == true) ? Color(0xFF8500FA) : Color(0xFFFF5858),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
              child: Center(
                child: Text(
                    (status == true) ? S.of(context).extendPlan : "Renew Plan",
                  style: AppTextStyle(context).buttonText.copyWith(
                      fontSize: 12.sp, color: Colors.white,   height: 1.80),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
