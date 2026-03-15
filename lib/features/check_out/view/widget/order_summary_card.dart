import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/features/subscriptions/provider/subscription_providers.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

import '../../controller/checkout.dart';

class OrderSummaryCard extends ConsumerWidget {
  const OrderSummaryCard(
      {super.key, this.isSubscription = false, this.subscriptionPrice = 0.0});

  final bool? isSubscription;
  final double? subscriptionPrice;

  @override
  Widget build(BuildContext context, ref) {
    print("total price");
    print("total price ${ref.watch(checkoutController).totalPrice})");
    return Container(
      padding: EdgeInsets.all(20.h),
      width: double.infinity,
      color: context.color.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).orderSummary,
            style: AppTextStyle(context)
                .bodyText
                .copyWith(fontWeight: FontWeight.w600),
          ),
          12.ph,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 20.h),
            decoration: BoxDecoration(
                color: colors(context).scaffoldBackgroundColor,
                borderRadius: AppComponents.defaultBorderRadiusSmall),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      (isSubscription == false)
                          ? S.of(context).coursePrice
                          : "Total price without plan",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                            color: context.color.inverseSurface,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      (isSubscription == false)
                          ? '${AppConstants.currencySymbol}${ref.watch(checkoutController).courseDetails?.course.regularPrice}'
                          : '${AppConstants.currencySymbol}${(ref.read(selectedCoursesProvider.notifier).totalPrice).toStringAsFixed(2)}',
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                            color: context.color.inverseSurface,
                          ),
                    ),
                  ],
                ),
                // Only show discount/coupon rows if isSubscription == false
                if (isSubscription == false) ...[
                  if (ref.watch(checkoutController).discountAmount != 0) 24.ph,
                  if (ref.watch(checkoutController).discountAmount != 0)
                    Row(
                      children: [
                        Text(
                          '${S.of(context).discount} (${ref.watch(checkoutController).discountPresent.toStringAsFixed(2)}%)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle(context).bodyTextSmall.copyWith(
                                color: AppStaticColor.redColor,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          '-${AppConstants.currencySymbol}${ref.watch(checkoutController).discountAmount.toStringAsFixed(2)}',
                          style: AppTextStyle(context).bodyTextSmall.copyWith(
                                color: AppStaticColor.redColor,
                              ),
                        ),
                      ],
                    ),
                  if (ref.watch(checkoutController).couponAmount != 0) 24.ph,
                  if (ref.watch(checkoutController).couponAmount != 0)
                    Row(
                      children: [
                        Text(
                          '${S.of(context).coupon} ${S.of(context).discount} ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle(context).bodyTextSmall.copyWith(
                                color: AppStaticColor.redColor,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          '-${AppConstants.currencySymbol}${ref.watch(checkoutController).couponAmount}',
                          style: AppTextStyle(context).bodyTextSmall.copyWith(
                                color: AppStaticColor.redColor,
                              ),
                        ),
                      ],
                    ),
                ],
                12.ph,
                Divider(
                  color: colors(context).hintTextColor!.withOpacity(.3),
                ),
                12.ph,
                Row(
                  children: [
                    Text(
                      (isSubscription == false)
                          ? S.of(context).subTotal
                          : "Subscription plan price",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                            color: context.color.inverseSurface,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      (isSubscription == false)
                          ? '${AppConstants.currencySymbol}${ref.watch(checkoutController).totalPrice - ref.watch(checkoutController).couponAmount}'
                          : '${AppConstants.currencySymbol}${subscriptionPrice!.toStringAsFixed(2).toString()}',
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                            color: context.color.inverseSurface,
                          ),
                    ),
                  ],
                ),
                ((isSubscription == true) && (ref.read(selectedCoursesProvider.notifier).totalPrice >
                    subscriptionPrice!)) ?  12.ph : 0.ph,
                (isSubscription == true)
                    ? (ref.read(selectedCoursesProvider.notifier).totalPrice >
                            subscriptionPrice!)
                        ? Text(
                            "You have saved ${AppConstants.currencySymbol}${(ref.read(selectedCoursesProvider.notifier).totalPrice - subscriptionPrice!).toStringAsFixed(2)}",
                            style:
                                TextStyle(color: AppStaticColor.primaryColor, fontWeight: FontWeight.w600),
                          )
                        : SizedBox.shrink()
                    : SizedBox.shrink()
              ],
            ),
          )
        ],
      ),
    );
  }
}
