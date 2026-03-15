import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/features/payment_history/controller/payment_history_controller.dart';
import 'package:ready_lms/features/payment_history/data/payment_history_service.dart';
import 'package:ready_lms/features/payment_history/model/payment_history_model.dart';
import 'package:ready_lms/features/payment_history/view/widgets/history_card.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/global_function.dart';

import '../../../routes.dart';
import '../../dashboard/controller/dashboard_nav.dart';

class PaymentHistoryScreen extends ConsumerStatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  ConsumerState<PaymentHistoryScreen> createState() =>
      _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends ConsumerState<PaymentHistoryScreen> {
 // final List<Transaction> transactionList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  init() {
    ref.read(paymentHistoryControllerProvider.notifier).getPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    final paymentHistory = ref.watch(paymentHistoryControllerProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).paymentHistory,
          ),
          leading: IconButton(
              onPressed: () {
                context.nav.pop();
                ref.read(homeTabControllerProvider.notifier).state = 3;
              },
              icon: SvgPicture.asset(
                'assets/svg/ic_arrow_left.svg',
                width: 24.h,
                height: 24.h,
                color: context.color.onSurface,
              )),
        ),
        body: paymentHistory.when(
          data: (data) {
            final transactions = data.data?.transactions ?? [];
            if (transactions.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/svg/no_item_found.svg"),
                  ApGlobalFunctions.noItemFound(
                      context: context,
                      text: S.of(context).noCoursePurchased,
                      size: 25),
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 100,
                      right: 100,
                    ),
                    child: AppButton(
                      title: S.of(context).allCourse,
                      titleColor: context.color.surface,
                      onTap: () {
                        context.nav.pushNamed(Routes.allCourseScreen,
                            arguments: {'popular': true});

                      },
                    ),
                  )
                ],
              );
            }
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: HistoryCard(
                    title: transaction.courseTitle,
                    date: transaction.paidAt.split(" ")[0],
                    amount: transaction.paymentAmount.toString(),
                    transationId: transaction.id.toString(),
                    email: transaction.email.toString(),
                    onTap: (){
                      context.nav.pushNamed(
                          Routes.myCourseDetails,
                          arguments: transaction.courseId, );
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppStaticColor.primaryColor,)),
          error: (e, _) => Center(child: Text("Error: $e")),
        ),
    );
  }
  }

