import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/features/check_out/model/hive_cart_model.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../courses/controller/my_course_details.dart';

class PDFScreen extends ConsumerWidget {
  const PDFScreen({super.key, required this.id, required this.title});
  final int id;
  final String title;
  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 1,
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
      /*body: FutureBuilder(
          future: ref
              .read(myCourseDetailsController.notifier)
              .getHiveContent(id: id),
          builder: (context, AsyncSnapshot<HiveCartModel?> s) {
            if (s.hasData) {
              return PDFView(
                pdfData: s.data!.data,
                // filePath: widget.pdfUrl,
                onViewCreated: (PDFViewController controller) {},
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),*/

        body: FutureBuilder<HiveCartModel?>(
          future: ref
              .read(myCourseDetailsController.notifier)
              .getHiveContent(id: id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data?.data == null) {
              return const Center(child: Text('No PDF found'));
            }

            final hiveData = snapshot.data!;
            return SfPdfViewer.memory(
              hiveData.data!, // since it's Uint8List
            );
          },
        )
    );
  }
}
