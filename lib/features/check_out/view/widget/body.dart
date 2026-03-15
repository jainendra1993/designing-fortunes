import 'package:ready_lms/features/check_out/view/widget/payment_scection.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'coupon.dart';
import 'course_Info.dart';
import 'order_summary_card.dart';

class Body extends ConsumerStatefulWidget {
  final bool? isSubscription;
  final double? subscriptionPrice;

  const Body({super.key, this.isSubscription = false, this.subscriptionPrice = 0.0});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          12.ph,
          CourseInfo(
            isSubscription: widget.isSubscription,
          ),
          8.ph,
            OrderSummaryCard(isSubscription: widget.isSubscription, subscriptionPrice: widget.subscriptionPrice,),
          8.ph,
          (widget.isSubscription == false) ?
          const CouponCard() :SizedBox.shrink(),
          8.ph,
          const PaymentSection(),
          8.ph,
        ],
      ),
    );
  }
}
