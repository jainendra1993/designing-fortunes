import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ready_lms/components/busy_loader.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/features/certificate/view/component/certificate_card.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/api_client.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../components/buttons/app_button.dart';
import '../../../routes.dart';
import '../../courses/model/course_list.dart';

import '../controller/certificate.dart';

@pragma("vm:entry-point")
void downloadCallback(String id, int status, int progress) {
  final SendPort send =
      IsolateNameServer.lookupPortByName('downloader_send_port')!;
  send.send([id, status, progress]);
}

class CertificateScreen extends ConsumerStatefulWidget {
  const CertificateScreen({super.key});

  @override
  ConsumerState<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends ConsumerState<CertificateScreen> {
  ScrollController scrollController = ScrollController();
  bool hasMoreData = true;
  int currentPage = 1;

  static final isloading = StateProvider<bool>((ref) => false);
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    getPermission();
    _portListener();
    FlutterDownloader.registerCallback(downloadCallback);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init(isRefresh: true);
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent >=
          scrollController.position.pixels) {
        if (hasMoreData) init();
      }
    });
  }

  _portListener() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) async {
      int status = data[1];
      int process = data[2];
      if (status == DownloadTaskStatus.complete.index) {

        ref.read(isloading.notifier).state = false;

        String taskId = data[0];
        var tasks = await FlutterDownloader.loadTasksWithRawQuery(
            query: "SELECT * FROM task WHERE task_id='$taskId'");
        if (tasks != null && tasks.isNotEmpty) {
          String filePath = "${tasks.first.savedDir}/${tasks.first.filename}";

          if (context.mounted) {
            context.nav.push(MaterialPageRoute(
              builder: (_) => CertificateViewer(filePath: filePath),
            ));
          }
        }
      } else if (status == DownloadTaskStatus.failed.index) {
        debugPrint('Something Went Wrong');
      }
      if (process == 100) {
        ref.read(isloading.notifier).state = false;
      }
    });
  }

  // getPermission() async {
  //   var checkStatus = await Permission.storage.status;
  //
  //   if (checkStatus.isGranted) {
  //     return;
  //   } else {
  //     var androidInfo = await DeviceInfoPlugin().androidInfo;
  //     var sdkInt = androidInfo.version.sdkInt;
  //     if (Platform.isAndroid && sdkInt > 29) {
  //       await Permission.manageExternalStorage.request();
  //     } else {
  //       await Permission.storage.request();
  //     }
  //   }
  // }

  Future<void> getPermission() async {
    if (!Platform.isAndroid) return;

    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }


  Future<void> init({bool isRefresh = false}) async {
    await ref
        .read(certificateController.notifier)
        .getCertificateList(isRefresh: isRefresh, currentPage: currentPage)
        .then(
      (value) {
        if (value.isSuccess) {
          if (value.response) {
            currentPage++;
          }
          hasMoreData = value.response;
          print("hasMoreData: ${hasMoreData}");
          if (!hasMoreData) {
            setState(() {});
          }
        }
      },
    );
  }

  // Future<String?> _getDownloadDirectory() async {
  //   Directory? appDocDir;
  //
  //   if (Platform.isAndroid) {
  //     appDocDir = Directory('/storage/emulated/0/Download');
  //     if (!await appDocDir.exists()) {
  //       appDocDir = await getExternalStorageDirectory();
  //     }
  //   } else if (Platform.isIOS) {
  //     appDocDir = await getApplicationDocumentsDirectory();
  //   } else {
  //     throw UnsupportedError('Unsupported platform');
  //   }
  //   return appDocDir?.path;
  // }


  Future<String> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        throw Exception("External storage not available");
      }
      return dir.path;
    } else if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      return dir.path;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }


  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
    }
  }

  Future<void> _downloadCertificate(
      {required String certificateUrl, required int id}) async {
    await _requestPermission();

    final saveDir = await _getDownloadDirectory();
    final fileName = 'certificate--$id.pdf';
    ref.read(isloading.notifier).state = true;
    FlutterDownloader.enqueue(
      url: certificateUrl,
      savedDir: saveDir!,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(certificateController).isLoading;
    List<CourseListModel> certificateList =
        ref.watch(certificateController).courseList;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).certificates,
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
      body: isLoading && currentPage == 1
          ? const ShimmerWidget()
          : !isLoading && certificateList.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 15,
                  children: [
                    //  ApGlobalFunctions.noItemFound(context: context),
                    Text("No Certificates are Available"),
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
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      12.ph,
                      ...List.generate(
                          certificateList.length + 1,
                          (index) => index < certificateList.length
                              ? CertificateCard(
                                  model: certificateList[index],
                                  onTap: () {
                                    downloadFile(
                                            certificateList[index]
                                                .id
                                                .toString(),
                                            certificateList[index].title.trim())
                                        .then((value) {
                                      if (value != null) {
                                        if (value) context.nav.pop();
                                      }
                                    });
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              surfaceTintColor:
                                                  context.color.surface,
                                              shadowColor:
                                                  context.color.surface,
                                              backgroundColor:
                                                  context.color.surface,
                                              insetPadding: EdgeInsets.zero,
                                              contentPadding: EdgeInsets.zero,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              12.w))),
                                              content: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    30.h,
                                                padding: EdgeInsets.all(24.w),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      certificateList[index]
                                                          .title,
                                                      style:
                                                          AppTextStyle(context)
                                                              .bodyText,
                                                    ),
                                                    16.ph,
                                                    Row(
                                                      children: [
                                                        Text(
                                                          S
                                                              .of(context)
                                                              .download,
                                                          style: AppTextStyle(
                                                                  context)
                                                              .bodyTextSmall,
                                                        ),
                                                        const Spacer(),
                                                        SizedBox(
                                                          width: 18.h,
                                                          height: 18.h,
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                    Color>(colors(
                                                                        context)
                                                                    .primaryColor!),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ));
                                  },
                                )
                              : hasMoreData && certificateList.length >= 6
                                  ? /*SizedBox(
                                      height: 80.h, child: const BusyLoader())*/
                                  Container()
                                  : Container()),
                    ],
                  ),
                ),
    );
  }

  Future<bool?> downloadFile(String id, String name) async {
    String? appDocPath = await ApGlobalFunctions.getPath();
    String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    String filePath = '$appDocPath/$currentTime.pdf';
    Dio dio = Dio();

    try {
      Response response = await dio.get(
        AppConstants.showCertificate + id,
        options: Options(
            headers: ref.read(apiClientProvider).defaultHeaders,
            // responseType: ResponseType.,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      _downloadCertificate(
          certificateUrl: response.data['data']['url'], id: int.parse(id));
      EasyLoading.showSuccess(S.of(context).filedownloadsuccessfully);
      return true;
    } catch (e) {
      EasyLoading.showError(S.of(context).filedownloadsuccessfully);

      if (kDebugMode) {
        print('${S.of(context).errordownloadingfile} $e');
      }
      throw Exception('${S.of(context).errordownloadingfile} $e');
    }
  }
}

class CertificateViewer extends StatelessWidget {
  final String filePath;
  const CertificateViewer({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Certificate")),
      body: SfPdfViewer.file(File(filePath)),
    );
  }
}

