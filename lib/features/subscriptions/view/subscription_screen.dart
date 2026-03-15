import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/features/subscriptions/provider/subscription_providers.dart';
import 'package:ready_lms/features/subscriptions/view/components/purchase_card.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  late final CarouselSliderController? _carouselSliderController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  init() {
    _carouselSliderController = CarouselSliderController();
    ref.read(subscriptionControllerProvider.notifier).getSubscriptionPlan();
  }

  @override
  Widget build(BuildContext context) {
    final subscriberPlan = ref.watch(subscriptionControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).subscriptionPackage,
        ),
        leading: IconButton(
            onPressed: () {
              context.nav.pop();
              //ref.read(homeTabControllerProvider.notifier).state = 3;
            },
            icon: SvgPicture.asset(
              'assets/svg/ic_arrow_left.svg',
              width: 24.w,
              height: 24.h,
              color: context.color.onSurface,
            )),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.51, 0.50),
            radius: 1.09,
            colors: [const Color(0xFF20245D), const Color(0xFF020206)],
          ),
        ),
        child: Column(
          children: [
            24.ph,
            Center(
                child: Image.asset(
              "assets/images/premium_img.png",
              height: 80.h,
              width: 80.w,
            )),
            Text(
              S.of(context).premiumPlan,
              textAlign: TextAlign.center,
              style: AppTextStyle(context).title.copyWith(
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                  ),
            ),
            2.ph,
            Text(
              S.of(context).getUnlimitedCoursesAndExclusiveFeatures,
              textAlign: TextAlign.center,
              style: AppTextStyle(context).hintText.copyWith(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.70),
                    fontWeight: FontWeight.w300,
                    height: 1.67,
                  ),
            ),
            14.ph,
            Divider(
              height: 1,
              color: Colors.white.withValues(alpha: 0.16),
            ),
            18.ph,
            subscriberPlan.when(
                data: (data) {
                  final plan = data.data ?? [];
                  if (plan.isNotEmpty) {
                    return CarouselSlider(
                      carouselController: _carouselSliderController,
                      items: List.generate(
                        plan.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PricingCard(
                            isHighlighted: index == _currentIndex,
                            planModel: plan,
                            index: index,
                          ),
                        ),
                      ),
                      options: CarouselOptions(
                        height: 400.h,
                        initialPage: 1,
                        enlargeCenterPage: true,
                        viewportFraction: 0.78,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    );
                  } else {
                    return Center(
                        child: Text(
                      "No subscription plan available",
                      style: const TextStyle(color: Colors.white),
                    ));
                  }
                },
                error: (e, _) => Center(
                        child: Text(
                      "Error: $e",
                      style: const TextStyle(color: Colors.white),
                    )),
                loading: () => const Center(
                        child: CircularProgressIndicator(
                      color: AppStaticColor.primaryColor,
                    ))),
          ],
        ),
      ),
    );
  }
}
