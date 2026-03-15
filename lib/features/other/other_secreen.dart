import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/utils/context_less_nav.dart';

import '../../generated/l10n.dart';

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key, required this.title, required this.body});
  final String title, body;

  bool get isTerms =>
      title.toLowerCase().contains('term');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTerms
              ? S.of(context).termsConditions
              : S.of(context).privacyPolicy,
        ),
        leading: IconButton(
            onPressed: () {
              context.nav.pop();
            },
            icon: SvgPicture.asset(
              'assets/svg/ic_arrow_left.svg',
              width: 24.h,
              height: 24.h,
              color: context.color.onSurface,
            )),
      ),
      /// ✅ Proper safe-area + scroll handling
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      16.w,
                      16.h,
                      16.w,
                      32.h + MediaQuery.of(context).padding.bottom,
                    ),
                    child: Html(
                      data: body,
                      style: {
                        "body": Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                      },
                    ),
                  ),

            );
          },
        ),

    );
  }
}
