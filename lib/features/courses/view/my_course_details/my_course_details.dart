import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/utils/context_less_nav.dart';

import '../../../../routes.dart';
import '../../../dashboard/controller/dashboard_nav.dart';
import '../../controller/my_course_details.dart';
import 'component/body.dart';

class MyCourseDetails extends ConsumerStatefulWidget {
  const MyCourseDetails({super.key, required this.courseId});

  final int courseId;

  @override
  ConsumerState<MyCourseDetails> createState() => _MyCourseDetailsState();
}

class _MyCourseDetailsState extends ConsumerState<MyCourseDetails> {
  @override
  void initState() {
    super.initState();
    // getPermission();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  getPermission() async {
    var checkStatus = await Permission.storage.status;

    if (checkStatus.isGranted) {
      return;
    } else {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        return;
      } else if (status.isDenied) {
        getPermission();
      } else {
        openAppSettings();
        EasyLoading.showError('Allow the storage permission');
      }
    }
  }

  Future<void> init() async {
    ref
        .read(myCourseDetailsController.notifier)
        .getMyCourseDetails(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(myCourseDetailsController).courseDetails;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        ref.read(myCourseDetailsController.notifier).disposeController();
        (ref.read(homeTabControllerProvider.notifier).state == 3) ? context.nav.pop() :
        context.nav.pushNamedAndRemoveUntil(
            Routes.dashboard, (route) => false);
        (ref.read(homeTabControllerProvider.notifier).state == 0)
            ? ref.read(homeTabControllerProvider.notifier).state = 0
            : ref.read(homeTabControllerProvider.notifier).state = 1;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            model?.course.title ?? '',
            maxLines: 1,
          ),
          leading: IconButton(
              onPressed: () {
                (ref.read(homeTabControllerProvider.notifier).state == 3) ? context.nav.pop() :
                context.nav.pushNamedAndRemoveUntil(
                    Routes.dashboard, (route) => false);
                (ref.read(homeTabControllerProvider.notifier).state == 0)
                    ? ref.read(homeTabControllerProvider.notifier).state = 0
                    : ref.read(homeTabControllerProvider.notifier).state = 1;
              },
              icon: SvgPicture.asset(
                'assets/svg/ic_arrow_left.svg',
                width: 24.h,
                height: 24.h,
                color: context.color.onSurface,
              )),
        ),
        body: ref.watch(myCourseDetailsController).isLoading || model == null
            ? const ShimmerWidget()
            : Scaffold(
                body: PopScope(
                    onPopInvokedWithResult: (e, s) {
                      ref
                          .read(myCourseDetailsController.notifier)
                          .disposeController();
                    },
                    child: const Body()),
              ),
      ),
    );
  }
}
