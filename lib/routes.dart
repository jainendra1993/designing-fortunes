import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ready_lms/features/blog/view/blog_details.dart';
import 'package:ready_lms/features/blog/view/blogs_screen.dart';
import 'package:ready_lms/features/courses/model/course_detail.dart';
import 'package:ready_lms/features/payment_history/view/payment_history_screen.dart';
import 'package:ready_lms/features/subscriptions/view/extend_screen.dart';
import 'package:ready_lms/features/subscriptions/view/subscription_screen.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'features/auth/view/auth_home_screen.dart';
import 'features/category/view/all_category_screen.dart';
import 'features/category/view/search_category_screen.dart';
import 'features/certificate/view/certificate_screen.dart';
import 'features/check_out/view/checkout_screen.dart';
import 'features/courses/view/all_courses/all_course_screen.dart';
import 'features/courses/view/my_course_details/my_course_details.dart';
import 'features/courses/view/new_course/course_new_screen.dart';
import 'features/dashboard/view/dashboard.dart';
import 'features/exam/view/exam_screen.dart';
import 'features/notification/view/notification_screen.dart';
import 'features/other/other_secreen.dart';
import 'features/other/support_secreen.dart';
import 'features/pdf/pdf_screen.dart';
import 'features/profile/view/profile_screen.dart';
import 'features/quiz/view/quiz_screen.dart';
import 'features/result_screen/result_screen.dart';
import 'features/search/view/search_course_screen.dart';
import 'features/subscriptions/view/select_course_screen.dart';
import 'splash_screen.dart';

class Routes {
  /*We are mapping all th eroutes here
  so that we can call any named route
  without making typing mistake
  */
  Routes._();

  //core
  static const splash = '/';
  static const onBoarding = '/onBoarding';
  static const login = '/login';
  static const signUp = '/signUp';
  static const passwordRecover = '/passwordRecover';
  static const verifyOTPScreen = '/verifyOTPScreen';
  static const changePasswordScreen = '/changePasswordScreen';
  static const dashboard = '/dashboard';
  static const courseNew = '/courseNew';
  static const myCourseDetails = '/myCourseDetails';
  static const authHomeScreen = '/authHomeScreen';
  static const checkOutScreen = '/checkOutScreen';
  static const profileScreen = '/profileScreen';
  static const allCourseScreen = '/allCourseScreen';
  static const allCategoryScreen = '/allCategoryScreen';
  static const courseSearchScreen = '/courseSearchScreen';
  static const categorySearchScreen = '/categorySearchScreen';
  static const otherScreen = '/otherScreen';
  static const pdfScreen = '/PDFScreen';
  static const supportScreen = '/supportScreen';
  static const certificateScreen = '/certificateScreen';
  static const examScreen = '/examScreen';
  static const quizScreen = '/quizScreen';
  static const resultScreen = '/resultScreen';
  static const notificationScreen = '/notificationScreen';
  static const blogsScreen = '/blogsScreen';
  static const blogDetailsScreen = '/blogDetailsScreen';
  static const paymentHistoryScreen = '/paymentHistoryScreen';
  static const subscriptionScreen = '/subscriptionScreen';
  static const selectCourseScreen = '/selectCourseScreen';
  static const planExtendScreen = '/planExtendScreen';
}

Route generatedRoutes(RouteSettings settings) {
  Widget child;

  switch (settings.name) {
    //core
    case Routes.splash:
      child = const SplashScreen();
      break;
    case Routes.authHomeScreen:
      child = const AuthHomeScreen();
      break;
    case Routes.dashboard:
      child = const DashboardScreen(); //change to DashboardScreen
      break;
    case Routes.courseNew:
      var data = settings.arguments as Map<String, dynamic>;
      child = CourseNewScreen(
        courseId: data['courseId'],
        isShowBottomNavigationBar: data['show'] ?? true,
      );
      break;
    case Routes.myCourseDetails:
      int courseID = settings.arguments as int;
      child = MyCourseDetails(
        courseId: courseID,
      );
      break;
    case Routes.checkOutScreen:
      var data = settings.arguments as Map<String, dynamic>;

      // int courseID = settings.arguments as int;

      child = CheckOutScreen(
        courseId: data['courseId'],
        isSubscription: data['isSubscription'] ?? false,
        selectedCourses: data['selectedCourse'] ?? [],
        planTitle: data['planTitle'] ?? '',
        planPrice: data['planPrice'] ?? "0",
        planId: data['planId'] ?? 0,
      );
      break;
    case Routes.profileScreen:
      child = const ProfileScreen();
      break;
    case Routes.allCourseScreen:
      var data = settings.arguments as Map<String, dynamic>?;

      child = AllCourseScreen(
        categoryModel: data?['model'],
        showMostPopular: data?['popular'] ?? false,
      );
      break;
    case Routes.allCategoryScreen:
      child = const AllCategoryScreen();
      break;
    case Routes.courseSearchScreen:
      child = const CourseSearchScreen();
      break;
    case Routes.pdfScreen:
      var data = settings.arguments as Map<String, dynamic>;
      child = PDFScreen(
        id: data['id'],
        title: data['title'],
      );
      break;
    case Routes.categorySearchScreen:
      child = const CategorySearchScreen();
      break;
    case Routes.examScreen:
      child = ExamScreen(exam: settings.arguments as Exam);
      break;
    case Routes.quizScreen:
      child = QuizScreen(
        quiz: settings.arguments as Quiz,
      );
      break;
    case Routes.resultScreen:
      final argumants = settings.arguments as Map<String, dynamic>;

      child = ResultScreen(
        isQuiz: argumants['isQuize'],
        quiz: argumants['quiz'],
        quizQuestionDetailsModel: argumants['quizDetails'],
        examResultModel: argumants['examResult'],
      );
      break;

    case Routes.supportScreen:
      child = const SupportScreen();
      break;

    case Routes.paymentHistoryScreen:
      child = PaymentHistoryScreen();
      break;
    case Routes.subscriptionScreen:
      child = SubscriptionScreen();
      break;
    case Routes.planExtendScreen:
      child = PlanExtendScreen();
      break;
    case Routes.selectCourseScreen:
      Map<String, dynamic> data = settings.arguments as Map<String, dynamic>;
      child = SelectCourseScreen(
        plan: data['title'],
      );
      break;
    case Routes.certificateScreen:
      child = const CertificateScreen();
      break;
    case Routes.otherScreen:
      Map<String, String> data = settings.arguments as Map<String, String>;
      child = OtherScreen(title: data['title']!, body: data['body']!);
      break;
    case Routes.notificationScreen:
      child = const NotificationScreen();
      break;
    case Routes.blogsScreen:
      child = BlogsScreen();
      break;
    case Routes.blogDetailsScreen:
      final int blogId = settings.arguments as int;
      child = BlogDetailsScreen(
        blogId: blogId,
      );
      break;
    default:
      throw Exception('Invalid route: ${settings.name}');
  }
  debugPrint('Route: ${settings.name}');

  return PageTransition(
    child: child,
    type: PageTransitionType.fade,
    settings: settings,
    duration: 300.miliSec,
    reverseDuration: 300.miliSec,
  );
}
