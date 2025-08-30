import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/core/util/token_util.dart';
import 'package:resalate/src/my_mosque/logic/masjed_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/base/dependency_injection.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../data/models/masjed_details_model.dart';
import 'widgets/custom_expantion_tile.dart';
import 'widgets/donation_item.dart';
import 'widgets/from_masjed_to_masjed.dart';
import 'widgets/funerals_item.dart';
import 'widgets/lesson_item.dart';
import 'widgets/live_feed.dart';
import 'widgets/memorization_date.dart';
import 'widgets/payment_section_option.dart';
import 'widgets/social_media_item.dart';

class MyMosqueScreen extends StatefulWidget {
  const MyMosqueScreen({super.key, required this.id});
  final int id;
  static const String routeName = 'MyMosqueScreen';

  @override
  State<MyMosqueScreen> createState() => _MyMosqueScreenState();
}

class _MyMosqueScreenState extends State<MyMosqueScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final viewModel = sl<MasjedViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.getMasjedsDetails(id: widget.id);
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        body: BlocBuilder<GenericCubit<MasjidDetailsResponse>,
            GenericCubitState<MasjidDetailsResponse>>(
          bloc: viewModel.masjedDetailsRes,
          builder: (context, state) {
            return Skeletonizer(
              enabled: state is GenericLoadingState,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: 250,
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          final collapsed =
                              constraints.maxHeight <= kToolbarHeight + 50;

                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              // Background image
                              Image.network(
                                "${state.data.masjid?.cover}",
                                fit: BoxFit.cover,
                              ),

                              FlexibleSpaceBar(
                                collapseMode: CollapseMode.pin,
                                title: collapsed
                                    ? AppText(
                                        text: "${state.data.masjid?.name}",
                                        model: AppTextModel(
                                          style: AppFontStyleGlobal(
                                                  AppLocalizations.of(context)!
                                                      .locale)
                                              .headingMedium2
                                              .copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.white,
                                              ),
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          );
                        },
                      ),
                      // Default back button (only visible when collapsed)

                      leadingWidth: 40.w,
                      leading: Builder(
                        builder: (context) {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final collapsed =
                                  constraints.maxHeight <= kToolbarHeight + 50;
                              return collapsed
                                  ? Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 5),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 15,
                                        child: IconButton(
                                          color: AppColors.white,
                                          icon: const Icon(Icons.arrow_back,
                                              color: Colors.black),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            },
                          );
                        },
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          "${state.data.masjid?.image}"),
                                    ),
                                    SizedBox(width: 8.w),
                                    AppText(
                                      text: "${state.data.masjid?.name}",
                                      model: AppTextModel(
                                        style: AppFontStyleGlobal(
                                                AppLocalizations.of(context)!
                                                    .locale)
                                            .headingMedium2
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.black,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                FutureBuilder(
                                    future: UserIdUtil.getUserIdFromMemory(),
                                    builder: (context, asyncSnapshot) {
                                      final isUser = asyncSnapshot.data;
                                      return isUser?.isNotEmpty ?? false
                                          ? BlocBuilder<GenericCubit<bool>,
                                              GenericCubitState<bool>>(
                                              bloc:
                                                  viewModel.isUserFollowMasjed,
                                              builder: (context, isFollow) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    if (isFollow.data) {
                                                      viewModel.unfollowMasjed(
                                                          masjedId: state.data
                                                                  .masjid?.id ??
                                                              0);
                                                    } else {
                                                      viewModel.followMasjed(
                                                          masjedId: state.data
                                                                  .masjid?.id ??
                                                              0);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 35.h,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16.w),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.r),
                                                        color: AppColors.error),
                                                    child: Center(
                                                      child: AppText(
                                                        text: isFollow.data
                                                            ? AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .translate(
                                                                    "unfollow")
                                                            : AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .translate(
                                                                    "follow"),
                                                        model: AppTextModel(
                                                          style: AppFontStyleGlobal(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .locale)
                                                              .subTitle2
                                                              .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColors
                                                                    .white,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : SizedBox();
                                    })
                              ],
                            ),
                            5.h.verticalSpace,
                            AppText(
                              text:
                                  "${state.data.masjid?.city}, ${state.data.masjid?.province}, ${state.data.masjid?.country}",
                              model: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .subTitle2
                                    .copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.gray,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          child: SocialMediaItem(
                            socialMedia:
                                state.data.masjid?.socialMedia ?? SocialMedia(),
                          )),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20.h,
                      ),
                    ),

                    /// Services cards
                    SliverToBoxAdapter(
                        child: CustomExpansionTile(
                      content: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          child: MemorizationLessonDates(
                            memorizationDates:
                                state.data.masjid?.memorizationDates ?? [],
                          )),
                      title: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: AppText(
                          text: AppLocalizations.of(context)!
                              .translate("Memorization_Lesson_Dates"),
                          model: AppTextModel(
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .subTitle2
                                .copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.scondaryColor,
                                ),
                          ),
                        ),
                      ),
                      animationDuration: Duration(milliseconds: 200),
                      initiallyExpanded: false,
                    )),
                    SliverToBoxAdapter(
                        child: CustomExpansionTile(
                      content: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics:
                              NeverScrollableScrollPhysics(), // let parent scroll
                          crossAxisCount: 2, // 2 per row
                          mainAxisSpacing: 10.h,
                          crossAxisSpacing: 10.w,
                          childAspectRatio: 3, // adjust height/width
                          children: state.data.masjid?.services
                                  ?.map((service) => _buildInfoCard(
                                        " ${service.label}",
                                        "",
                                      ))
                                  .toList() ??
                              [],
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: AppText(
                          text: AppLocalizations.of(context)!
                              .translate("services"),
                          model: AppTextModel(
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .subTitle2
                                .copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.scondaryColor,
                                ),
                          ),
                        ),
                      ),
                      animationDuration: Duration(milliseconds: 200),
                      initiallyExpanded: false,
                    )),
                    SliverToBoxAdapter(
                        child: CustomExpansionTile(
                      content: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          child: PaymentOptionsSection(
                            paymentInfo:
                                state.data.masjid?.paymentInfo ?? PaymentInfo(),
                          )),
                      title: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: AppText(
                          text: AppLocalizations.of(context)!
                              .translate("Payment_Information"),
                          model: AppTextModel(
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .subTitle2
                                .copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.scondaryColor,
                                ),
                          ),
                        ),
                      ),
                      animationDuration: Duration(milliseconds: 200),
                      initiallyExpanded: false,
                    )),

                    SliverToBoxAdapter(
                        child: CustomExpansionTile(
                      content: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        child: SizedBox(
                          height: 200.h,
                          child: BlocBuilder<GenericCubit<WebViewController>,
                              GenericCubitState<WebViewController>>(
                            bloc: viewModel.controllerCubit,
                            builder: (context, state) {
                              return WebViewWidget(controller: state.data);
                            },
                          ),
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: AppText(
                          text: AppLocalizations.of(context)!
                              .translate("location"),
                          model: AppTextModel(
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .subTitle2
                                .copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.scondaryColor,
                                ),
                          ),
                        ),
                      ),
                      animationDuration: Duration(milliseconds: 200),
                      initiallyExpanded: false,
                    )),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverTabBarDelegate(
                        TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          indicatorColor: AppColors.primaryColor,
                          labelColor: AppColors.primaryColor,
                          unselectedLabelColor: Colors.grey,
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabAlignment: TabAlignment.center,
                          labelStyle: AppFontStyleGlobal(
                                  AppLocalizations.of(context)!.locale)
                              .subTitle1
                              .copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: AppColors.scondaryColor,
                              ),
                          tabs: [
                            Tab(
                                text: AppLocalizations.of(context)!
                                    .translate("Donation_cases")),
                            Tab(
                                text: AppLocalizations.of(context)!
                                    .translate("From_Mosque_To_Mosque")),
                            Tab(
                                text: AppLocalizations.of(context)!
                                    .translate("funerals")),
                            Tab(
                                text: AppLocalizations.of(context)!
                                    .translate("live_feed")),
                            Tab(
                                text: AppLocalizations.of(context)!
                                    .translate("lessons")),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    GridView.builder(
                      padding: EdgeInsets.all(12.w),
                      itemCount: state.data.posts?.donations?.length ?? 0,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.95,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (_, index) => DonationItem(
                        donation:
                            state.data.posts?.donations?[index] ?? Donation(),
                      ),
                    ),
                    GridView.builder(
                      padding: EdgeInsets.all(5.w),
                      itemCount: state.data.posts?.masjidToMasjid?.length ?? 0,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (_, index) => FromMasjedToMasjed(
                        postItem: state.data.posts?.masjidToMasjid?[index] ??
                            PostItem(),
                        whatsAppLink:
                            state.data.masjid?.socialMedia?.whatsappUrl ?? "",
                      ),
                    ),

                    /// Funerals
                    GridView.builder(
                      padding: EdgeInsets.all(12.w),
                      itemCount: state.data.posts?.funerals?.length ?? 0,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.70,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (_, index) => FuneralsItem(
                        postItem:
                            state.data.posts?.funerals?[index] ?? PostItem(),
                      ),
                    ),

                    /// Live feed
                    ListView.separated(
                      padding: EdgeInsets.all(12.w),
                      itemCount: state.data.posts?.liveFeed?.length ?? 0,
                      itemBuilder: (_, index) => LiveFeedItem(
                        postItem:
                            state.data.posts?.liveFeed?[index] ?? PostItem(),
                      ),
                      separatorBuilder: (_, __) => 20.h.verticalSpace,
                    ),
                    ListView.separated(
                      padding: EdgeInsets.all(12.w),
                      itemCount: state.data.posts?.lessons?.length ?? 0,
                      itemBuilder: (_, index) => LessonItem(
                        lesson: state.data.posts?.lessons?[index] ?? Lesson(),
                      ),
                      separatorBuilder: (_, __) => 20.h.verticalSpace,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.white,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150.w,
              child: AppText(
                text: label,
                model: AppTextModel(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                          .subTitle1
                          .copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                ),
              ),
            ),
            AppText(
              text: value,
              model: AppTextModel(
                style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                    .subTitle1
                    .copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate old) => false;
}
