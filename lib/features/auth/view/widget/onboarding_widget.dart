import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/buttons/outline_button.dart';
import 'package:ready_lms/features/auth/view/widget/login_bottom_widget.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/config/app_constants.dart';

class OnboardingWidget extends ConsumerStatefulWidget {
  const OnboardingWidget({super.key});

  @override
  ConsumerState<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends ConsumerState<OnboardingWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToLast() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.surface,
      appBar: AppBar(
        title: (_currentPage < 2) ? null : Image.asset(
          ref.read(hiveStorageProvider).getTheme()
              ? 'assets/images/app_name_logo_dark.png'
              : 'assets/images/app_name_logo_light.png',
          height: 32.h,
          fit: BoxFit.contain,
        ),
        actions: _currentPage < 2
            ? [
          TextButton(
            onPressed: _skipToLast,
            child: Text(
              S.of(context).skip,
              style: AppTextStyle(context).buttonText?.copyWith(
                color: colors(context).primaryColor,
              ),
            ),
          ),
        ]
            : null,
      ),
      body: SafeArea(
        child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                // Screen 1: First onboarding
                _buildOnboardingScreen(
                  imagePath: 'assets/images/on_boarding_1.png',
                  title: 'Your Learning, Simplified',
                  description: 'Access courses, track progress, and achieve your goals in one place.',
                ),
                // Screen 2: Second onboarding
                _buildOnboardingScreen(
                  imagePath: 'assets/images/on_boarding_2.png',
                  title: 'Track, Practice,  Succeed',
                  description: 'Stay motivated with progress tracking, quizzes, and achievements.',
                ),
                // Screen 3: Auth home content
                _buildAuthHomeContent(),
              ],
            ),
          ),
          // Page indicators
          if (_currentPage < 2) _buildPageIndicators(),
        ],
      ),
      )
    );
  }

  Widget _buildOnboardingScreen({
    required String imagePath,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Text(
                  title,
                  style: AppTextStyle(context).title?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.color.onSurface,
                  ),

                ),
                16.ph,
                Text(
                  description,
                  style: AppTextStyle(context).subTitle?.copyWith(
                    fontSize: 12.sp,
                    color: context.color.onSurface.withOpacity(0.7),
                  ),

                ),
                const Spacer(),
                AppButton(
                  title: "Next",
                  titleColor: context.color.surface,
                  textPaddingVertical: 15.h,
                  onTap: _nextPage,
                  icon: SvgPicture.asset(
                    'assets/svg/ic_right_arrow.svg',
                    color: context.color.surface,
                    width: 24.h,
                    height: 24.h,
                  ),
                ),
                24.ph,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget
  _buildAuthHomeContent() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Image.asset(
              'assets/images/auth_welcome_avt.png',
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: '${S.of(context).authHomeDes} ',
                            style: AppTextStyle(context).title),
                        WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 2.h),
                                  child: Container(
                                    color: colors(context)
                                        .primaryColor!
                                        .withOpacity(.3),
                                    width: AppConstants.appName.length < 7
                                        ? (AppConstants.appName.length + 1) *
                                        16.w
                                        : (AppConstants.appName.length + 1) *
                                        17.w,
                                    height: 11.h,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: Text('${AppConstants.appName}.',
                                      style: AppTextStyle(context).title),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                  const Spacer(),
//                   AppButton(
//                     title: S.of(context).getStarted,
//                     titleColor: context.color.surface,
//                     textPaddingVertical: 15.h,
//                     onTap: () async {
//                       await ref
//                           .read(hiveStorageProvider)
//                           .setFirstOpenValue(value: false);
//                       if (context.mounted) {
//                         context.nav.pushNamedAndRemoveUntil(
//                             Routes.dashboard, (route) => false);
//                       }
//                     },
//                     icon: SvgPicture.asset(
//                       'assets/svg/ic_right_arrow.svg',
//                       color: context.color.surface,
//                       width: 24.h,
//                       height: 24.h,
//                     ),
//                   ),
//                   16.ph,
                  AppOutlineButton(
                    title: S.of(context).loginWithPassword,
                    borderRadius: 12.r,
                    onTap: () {
                      ApGlobalFunctions.showBottomSheet(
                          context: context,
                          widget: const LoginBottomWidget());
                    },
                  ),
                  24.ph
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
              (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: _currentPage == index ? 24.w : 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? colors(context).primaryColor
                  : colors(context).primaryColor!.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
      ),
    );
  }
}
