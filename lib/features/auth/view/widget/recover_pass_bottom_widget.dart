
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/components/bottom_widget_header.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/auth.dart';
import 'otp_bottom_widget.dart';

class RecoverPassBottomWidget extends StatefulWidget {
  const RecoverPassBottomWidget({
    super.key,
    this.senderText = '',
  });
  final String? senderText;
  @override
  State<RecoverPassBottomWidget> createState() =>
      _RecoverPassBottomWidgetState();
}

class _RecoverPassBottomWidgetState extends State<RecoverPassBottomWidget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  bool showPass = false;

  @override
  void initState() {
    super.initState();
    idController.text = widget.senderText!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      /// ✅ Keyboard-safe animation
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),

        /// ✅ Prevents white screen
        child: Material(
          color: context.color.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,

          /// ✅ Handles system insets
          child: SafeArea(
            top: false,

            /// ✅ Prevents freeze when keyboard opens
              child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding:
                          EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 24.h),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BottomBarHeader(
                                  onTap: () => context.nav.pop(),
                                  title: S
                                      .of(context)
                                      .recoverPassword,
                                  body: S
                                      .of(context)
                                      .passRecoverDes,
                                ),

                                32.ph,

                                CustomFormWidget(
                                  label: S
                                      .of(context)
                                      .email,
                                  controller: idController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) =>
                                      validatorWithMessage(
                                        message:
                                        '${S
                                            .of(context)
                                            .email} ${S
                                            .of(context)
                                            .isRequired}',
                                        value: val,
                                      ),
                                ),

                                24.ph,

                                Consumer(
                                  builder: (context, ref, _) {
                                    return AppButton(
                                      title: S
                                          .of(context)
                                          .proceedNext,
                                      textPaddingVertical: 16.h,
                                      titleColor: context.color.surface,
                                      showLoading: ref.watch(authController),
                                      onTap: () async {
                                        if (formKey.currentState!.validate()) {
                                          final res = await ref
                                              .read(authController.notifier)
                                              .resetPassRequest(
                                            id: idController.text,
                                          );

                                          if (res.isSuccess) {
                                            context.nav.pop();
                                            ApGlobalFunctions.showBottomSheet(
                                              context: context,
                                              widget: OTPBottomWidget(
                                                senderText: idController.text,
                                                isFromResetPass: true,
                                              ),
                                            );
                                          } else {
                                            EasyLoading.showError(res.message);
                                          }
                                        }
                                      },
                                    );
                                  },
                                ),

                                SizedBox(height: 16.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
          ),
        ),
      ),
      ),
    );
  }
}
