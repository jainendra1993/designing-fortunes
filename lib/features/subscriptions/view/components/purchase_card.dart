import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/features/subscriptions/model/subscription_model.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/global_function.dart';

class PricingCard extends StatelessWidget {
  PricingCard({
    super.key,
    this.isHighlighted = false,
    required this.planModel,
    required this.index,
  });

  final bool isHighlighted;
  final List<PlanData> planModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280.w,
        padding: const EdgeInsets.all(20),
        decoration: ShapeDecoration(
          color: const Color(0x145864FF),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isHighlighted ? Color(0xFF6873FF) : Colors.white24,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3D202135),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                planModel[index].title.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${AppConstants.currencySymbol}${planModel[index].price.toString()}",
                      style: const TextStyle(
                        color: Color(0xFF3F8CFF),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " / ${planModel[index].planType.toString()}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 1,
                color: Colors.white24,
              ),
              const SizedBox(height: 16),
              ...planModel[index].features!.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.70),
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                height: 1.80,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: 20),
          
              // Purchase button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.nav.pushNamed(Routes.selectCourseScreen, arguments: {
                      'title' : planModel[index].title.toString()
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5864FF),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    S.of(context).purchaseNow,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
