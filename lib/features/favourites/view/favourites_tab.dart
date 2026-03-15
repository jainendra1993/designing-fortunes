import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_lms/components/busy_loader.dart';
import 'package:ready_lms/components/shimmer.dart';

import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/buttons/app_button.dart';
import '../../../routes.dart';
import '../../courses/model/course_list.dart';
import 'component/favorite_card.dart';
import '../controller/favourites_tab.dart';

class FavouriteTab extends ConsumerStatefulWidget {
  const FavouriteTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends ConsumerState<FavouriteTab> {
  ScrollController scrollController = ScrollController();
  bool hasMoreData = true;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init(isRefresh: true);
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (hasMoreData) init();
      }
    });
  }

  Future<void> init({bool isRefresh = false}) async {
    await ref
        .read(favouriteTabController.notifier)
        .getFavouriteList(isRefresh: isRefresh, currentPage: currentPage)
        .then(
      (value) {
        if (value.isSuccess) {
          if (value.response) {
            currentPage++;
          }
          hasMoreData = value.response;
          if (!hasMoreData) {
            setState(() {});
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(favouriteTabController).isLoading;
    List<CourseListModel> courseList =
        ref.watch(favouriteTabController).courseList;
    return Scaffold(
      appBar: ApGlobalFunctions.cAppBar(header: Text(S.of(context).favourites)),
      body: RefreshIndicator(
        onRefresh: () async {
          hasMoreData = true;
          currentPage = 1;
          init(isRefresh: true);
        },
        child: SafeArea(
            child: isLoading && currentPage == 1
                ? const ShimmerWidget()
                : !isLoading && courseList.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/svg/no_item_found.svg"),
                          ApGlobalFunctions.noItemFound(
                              context: context,
                              text: S.of(context).noItemsAreAddedInFavourites,
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
                      )
                    : SingleChildScrollView(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            16.ph,
                            ...List.generate(
                                courseList.length + 1,
                                (index) => index < courseList.length
                                    ? FavoriteCard(
                                        canEnroll:
                                            !courseList[index].isEnrolled,
                                        onTap: () {
                                          ref
                                              .read(favouriteTabController
                                                  .notifier)
                                              .favouriteUpdate(
                                                  id: courseList[index].id)
                                              .then((value) {
                                            if (value.isSuccess) {
                                              courseList.removeAt(index);
                                              setState(() {});
                                            }
                                          });
                                        },
                                        model: courseList[index],
                                      )
                                    : hasMoreData && courseList.length >= 6
                                        ? SizedBox(
                                            height: 80.h,
                                            child: const BusyLoader())
                                        : Container())
                          ],
                        ),
                      )),
      ),
    );
  }
}
