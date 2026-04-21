import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/my_mosque/logic/masjed_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/base/dependency_injection.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/shared_components/app_snack_bar/app_snack_bar.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/loading.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../data/models/follow_masjed_model.dart';
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
import '../data/models/announcement_model.dart';
import 'widgets/announcement_item.dart';
import 'announcement_details_screen.dart';

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
  double? _distanceKm;

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

  Future<void> _calculateDistance(double? lat, double? lng) async {
    if (lat == null || lng == null) return;
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
      final distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        lat,
        lng,
      );
      if (mounted) {
        setState(() {
          _distanceKm = distanceInMeters / 1000;
        });
      }
    } catch (_) {}
  }

  String _formatDistance(double km) {
    if (km < 1) {
      return '${(km * 1000).toInt()} m';
    } else if (km < 10) {
      return '${km.toStringAsFixed(1)} km';
    } else {
      return '${km.toInt()} km';
    }
  }

  bool _isValidNetworkImage(String? value) {
    final imageUrl = value?.trim() ?? '';
    final uri = Uri.tryParse(imageUrl);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Widget _buildCoverImage(String? cover) {
    final coverUrl = cover?.trim();
    if (_isValidNetworkImage(coverUrl)) {
      return Image.network(
        coverUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildCoverFallback(),
      );
    }

    return _buildCoverFallback();
  }

  Widget _buildCoverFallback() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        'assets/icons/splash_logo.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildMasjidAvatar(String? image) {
    final imageUrl = image?.trim();
    final hasImage = _isValidNetworkImage(imageUrl);

    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.lightGray,
      foregroundImage: hasImage ? NetworkImage(imageUrl!) : null,
      onForegroundImageError: hasImage ? (_, __) {} : null,
      child: hasImage
          ? null
          : Icon(
              Icons.mosque_rounded,
              color: AppColors.scondaryColor,
              size: 20.sp,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          AppLocalizations.of(context)!.locale.languageCode == 'en' ||
                  AppLocalizations.of(context)!.locale.languageCode == 'sv'
              ? TextDirection.ltr
              : TextDirection.rtl,
      child: Scaffold(
        body: BlocListener<GenericCubit<FollowMasjedResponse>,
            GenericCubitState<FollowMasjedResponse>>(
          bloc: viewModel.followActionRes,
          listener: (context, state) {
            if (state is GenericLoadingState) {
              LoadingScreen.show(context);
            } else if (state is GenericUpdatedState) {
              Navigator.pop(context);

              showAppSnackBar(
                context: context,
                message: state.data.action,
                color: AppColors.success,
              );
            } else {
              Navigator.pop(context);
              if (state is GenericErrorState) {
                showAppSnackBar(
                  context: context,
                  message: state.responseError!.errorMessage,
                  color: AppColors.error,
                );
              }
            }
          },
          child: SizedBox(
            child: BlocBuilder<GenericCubit<MasjidDetailsResponse>,
                GenericCubitState<MasjidDetailsResponse>>(
              bloc: viewModel.masjedDetailsRes,
              builder: (context, state) {
                // Trigger distance calculation when data arrives
                if (state is GenericUpdatedState && _distanceKm == null) {
                  _calculateDistance(
                    state.data.masjid?.lat,
                    state.data.masjid?.lng,
                  );
                }
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
                                  // Image.network(
                                  // "${state.data.masjid?.cover}",
                                  //   fit: BoxFit.cover,
                                  // ),

                                  _buildCoverImage(state.data.masjid?.cover),

                                  FlexibleSpaceBar(
                                    collapseMode: CollapseMode.pin,
                                    title: collapsed
                                        ? AppText(
                                            text: state.data.masjid?.name ?? "",
                                            model: AppTextModel(
                                              style: AppFontStyleGlobal(
                                                      AppLocalizations.of(
                                                              context)!
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
                                  final collapsed = constraints.maxHeight <=
                                      kToolbarHeight + 50;
                                  return collapsed
                                      ? Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          _buildMasjidAvatar(
                                              state.data.masjid?.image),
                                          SizedBox(width: 8.w),
                                          Flexible(
                                            child: AppText(
                                              text:
                                                  "${state.data.masjid?.name}",
                                              model: AppTextModel(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppFontStyleGlobal(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .locale)
                                                    .headingMedium2
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors.black,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    BlocBuilder<GenericCubit<bool>,
                                        GenericCubitState<bool>>(
                                      bloc: viewModel.isUserFollowMasjed,
                                      builder: (context, isFollow) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (isFollow.data) {
                                              viewModel.unfollowMasjed(context,
                                                  masjedId:
                                                      state.data.masjid?.id ??
                                                          0);
                                            } else {
                                              viewModel.followMasjed(context,
                                                  masjedId:
                                                      state.data.masjid?.id ??
                                                          0);
                                            }
                                          },
                                          child: Container(
                                            height: 35.h,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.w),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16.r),
                                                color: AppColors.error),
                                            child: Center(
                                              child: AppText(
                                                text: isFollow.data
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .translate("unfollow")
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .translate("follow"),
                                                model: AppTextModel(
                                                  style: AppFontStyleGlobal(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .locale)
                                                      .subTitle2
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.white,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                                5.h.verticalSpace,
                                AppText(
                                  text:
                                      "${state.data.masjid?.city}, ${state.data.masjid?.province}, ${state.data.masjid?.country}",
                                  model: AppTextModel(
                                    style: AppFontStyleGlobal(
                                            AppLocalizations.of(context)!
                                                .locale)
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
                                socialMedia: state.data.masjid?.socialMedia ??
                                    SocialMedia(),
                              )),
                        ),

                        // Distance + Directions row
                        if (state.data.masjid?.lat != null &&
                            state.data.masjid?.lng != null)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              child: Row(
                                children: [
                                  // Distance badge
                                  if (_distanceKm != null)
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.scondaryColor
                                              .withValues(alpha: 0.08),
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          border: Border.all(
                                            color: AppColors.scondaryColor
                                                .withValues(alpha: 0.2),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.location_on_rounded,
                                              color: AppColors.scondaryColor,
                                              size: 20.sp,
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              _formatDistance(_distanceKm!),
                                              style: TextStyle(
                                                color: AppColors.scondaryColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (_distanceKm != null)
                                    SizedBox(width: 10.w),
                                  // Directions button
                                  Expanded(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () async {
                                          final url =
                                              'https://www.google.com/maps/dir/?api=1&destination=${state.data.masjid!.lat},${state.data.masjid!.lng}';
                                          final uri = Uri.parse(url);
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri,
                                                mode: LaunchMode
                                                    .externalApplication);
                                          }
                                        },
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            border: Border.all(
                                              color: AppColors.primaryColor
                                                  .withValues(alpha: 0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.directions_rounded,
                                                color: AppColors.primaryColor,
                                                size: 20.sp,
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .translate('direction'),
                                                style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        SliverToBoxAdapter(
                          child: BlocBuilder<
                              GenericCubit<AnnouncementsResponse>,
                              GenericCubitState<AnnouncementsResponse>>(
                            bloc: viewModel.announcementsRes,
                            builder: (context, announcementState) {
                              final announcements =
                                  announcementState.data.announcements ?? [];
                              // if (announcements.isEmpty) {
                              //   return const SizedBox.shrink();
                              // }
                              return announcements.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w),
                                          child: AppText(
                                            text: AppLocalizations.of(context)!
                                                .translate('annoncements'),
                                            model: AppTextModel(
                                              textDirection: AppLocalizations
                                                                  .of(context)!
                                                              .locale
                                                              .languageCode ==
                                                          'en' ||
                                                      AppLocalizations.of(
                                                                  context)!
                                                              .locale
                                                              .languageCode ==
                                                          'sv'
                                                  ? TextDirection.ltr
                                                  : TextDirection.rtl,
                                              style: AppFontStyleGlobal(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .locale)
                                                  .label
                                                  .copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 20.sp,
                                                    color:
                                                        AppColors.scondaryColor,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Skeletonizer(
                                          enabled: announcementState
                                              is GenericLoadingState,
                                          child: SizedBox(
                                            height: 300.h,
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              clipBehavior: Clip.none,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w),
                                              itemCount: announcementState
                                                      is GenericLoadingState
                                                  ? 3
                                                  : announcements.length,
                                              separatorBuilder: (_, __) =>
                                                  SizedBox(width: 10.w),
                                              itemBuilder: (context, index) {
                                                final item = announcementState
                                                        is GenericLoadingState
                                                    ? Announcement(
                                                        title:
                                                            'Loading announcement title',
                                                        excerpt:
                                                            'Loading excerpt text here',
                                                        date: '2026-01-01',
                                                      )
                                                    : announcements[index];
                                                return AnnouncementItem(
                                                  announcement: item,
                                                  onTap: () {
                                                    if (announcementState
                                                        is! GenericLoadingState) {
                                                      Navigator.pushNamed(
                                                        context,
                                                        AnnouncementDetailsScreen
                                                            .routeName,
                                                        arguments: {
                                                          "id": announcements[
                                                                  index]
                                                              .id,
                                                        },
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink();
                            },
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 10.h,
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
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final availableWidth = constraints.maxWidth;
                                final crossAxisCount = availableWidth >= 1050
                                    ? 3
                                    : availableWidth >= 560
                                        ? 2
                                        : 1;
                                final mainAxisExtent = availableWidth >= 900
                                    ? 112.0
                                    : availableWidth >= 560
                                        ? 104.0
                                        : 92.0;

                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      state.data.masjid?.services?.length ?? 0,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: 10.h,
                                    crossAxisSpacing: 10.w,
                                    mainAxisExtent: mainAxisExtent,
                                  ),
                                  itemBuilder: (context, index) {
                                    final service =
                                        state.data.masjid?.services?[index];
                                    return _buildInfoCard(
                                      service?.label?.trim() ?? "",
                                    );
                                  },
                                );
                              },
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
                                paymentInfo: state.data.masjid?.paymentInfo ??
                                    PaymentInfo(),
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
                              child: BlocBuilder<
                                  GenericCubit<WebViewController>,
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
                        /// Donation cases tab
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final donations = state.data.posts?.donations ?? [];

                            if (donations.isEmpty) {
                              return _buildTabEmptyState(
                                icon: Icons.volunteer_activism_outlined,
                                messageKey: 'no_donation_cases_found',
                              );
                            }

                            final w = constraints.maxWidth;
                            final crossAxisCount = w >= 1100
                                ? 4
                                : w >= 800
                                    ? 3
                                    : 2;
                            const spacing = 10.0;
                            final cardWidth =
                                (w - 24 - ((crossAxisCount - 1) * spacing)) /
                                    crossAxisCount;
                            // Donation cards: image(70h) + progress(15h) + text + button ≈ ratio
                            final cardHeight = cardWidth * 1.28;

                            return GridView.builder(
                              padding: EdgeInsets.all(12.w),
                              itemCount: donations.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: cardWidth / cardHeight,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing,
                              ),
                              itemBuilder: (_, index) => DonationItem(
                                donation: donations[index],
                              ),
                            );
                          },
                        ),

                        /// From Mosque To Mosque tab
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final masjidToMasjid =
                                state.data.posts?.masjidToMasjid ?? [];

                            if (masjidToMasjid.isEmpty) {
                              return _buildTabEmptyState(
                                icon: Icons.mosque_outlined,
                                messageKey:
                                    'no_from_mosque_to_mosque_posts_found',
                              );
                            }

                            final w = constraints.maxWidth;
                            final crossAxisCount = w >= 1100
                                ? 4
                                : w >= 800
                                    ? 3
                                    : 2;
                            const spacing = 10.0;
                            final cardWidth =
                                (w - 24 - ((crossAxisCount - 1) * spacing)) /
                                    crossAxisCount;
                            final cardHeight = cardWidth * 1.52;

                            return GridView.builder(
                              padding: EdgeInsets.all(12.w),
                              itemCount: masjidToMasjid.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: cardWidth / cardHeight,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing,
                              ),
                              itemBuilder: (_, index) => FromMasjedToMasjed(
                                postItem: masjidToMasjid[index],
                                whatsAppLink: state.data.masjid?.socialMedia
                                        ?.whatsappUrl ??
                                    "",
                              ),
                            );
                          },
                        ),

                        /// Funerals tab
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final funerals = state.data.posts?.funerals ?? [];

                            if (funerals.isEmpty) {
                              return _buildTabEmptyState(
                                icon: Icons.article_outlined,
                                messageKey: 'no_funerals_found',
                              );
                            }

                            final w = constraints.maxWidth;
                            final crossAxisCount = w >= 1100
                                ? 4
                                : w >= 800
                                    ? 3
                                    : 2;
                            const spacing = 10.0;
                            final cardWidth =
                                (w - 24 - ((crossAxisCount - 1) * spacing)) /
                                    crossAxisCount;
                            final cardHeight = cardWidth * 1.45;

                            return GridView.builder(
                              padding: EdgeInsets.all(12.w),
                              itemCount: funerals.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: cardWidth / cardHeight,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing,
                              ),
                              itemBuilder: (_, index) => FuneralsItem(
                                postItem: funerals[index],
                              ),
                            );
                          },
                        ),

                        /// Live feed tab
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final liveFeed = state.data.posts?.liveFeed ?? [];

                            if (liveFeed.isEmpty) {
                              return _buildTabEmptyState(
                                icon: Icons.live_tv_outlined,
                                messageKey: 'no_live_feed_found',
                              );
                            }

                            final w = constraints.maxWidth;
                            final crossAxisCount = w >= 1100
                                ? 3
                                : w >= 700
                                    ? 2
                                    : 1;

                            if (crossAxisCount == 1) {
                              return ListView.separated(
                                padding: EdgeInsets.all(12.w),
                                itemCount: liveFeed.length,
                                itemBuilder: (_, index) => LiveFeedItem(
                                  postItem: liveFeed[index],
                                ),
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 10.h),
                              );
                            }

                            const spacing = 10.0;
                            final cardWidth =
                                (w - 24 - ((crossAxisCount - 1) * spacing)) /
                                    crossAxisCount;
                            // Live feed: image(120h) + title + desc ≈ ratio
                            final cardHeight = cardWidth * 0.7;

                            return GridView.builder(
                              padding: EdgeInsets.all(12.w),
                              itemCount: liveFeed.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: cardWidth / cardHeight,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing,
                              ),
                              itemBuilder: (_, index) => LiveFeedItem(
                                postItem: liveFeed[index],
                              ),
                            );
                          },
                        ),

                        /// Lessons tab
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final lessons = state.data.posts?.lessons ?? [];

                            if (lessons.isEmpty) {
                              return _buildTabEmptyState(
                                icon: Icons.menu_book_outlined,
                                messageKey: 'no_lessons_found',
                              );
                            }

                            final w = constraints.maxWidth;
                            final crossAxisCount = w >= 1100
                                ? 3
                                : w >= 700
                                    ? 2
                                    : 1;

                            if (crossAxisCount == 1) {
                              return ListView.separated(
                                padding: EdgeInsets.all(12.w),
                                itemCount: lessons.length,
                                itemBuilder: (_, index) => LessonItem(
                                  lesson: lessons[index],
                                ),
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 10.h),
                              );
                            }

                            const spacing = 10.0;
                            final cardWidth =
                                (w - 24 - ((crossAxisCount - 1) * spacing)) /
                                    crossAxisCount;
                            // Lessons: image(100h) + title + desc + date ≈ ratio
                            final cardHeight = cardWidth * 0.75;

                            return GridView.builder(
                              padding: EdgeInsets.all(12.w),
                              itemCount: lessons.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: cardWidth / cardHeight,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing,
                              ),
                              itemBuilder: (_, index) => LessonItem(
                                lesson: lessons[index],
                              ),
                            );
                          },
                        ),
                      ],
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

  Widget _buildTabEmptyState({
    required IconData icon,
    required String messageKey,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64.sp,
              color: AppColors.gray.withValues(alpha: 0.75),
            ),
            SizedBox(height: 12.h),
            AppText(
              text: AppLocalizations.of(context)!.translate(messageKey),
              model: AppTextModel(
                textAlign: TextAlign.center,
                style: AppFontStyleGlobal(
                  AppLocalizations.of(context)!.locale,
                ).bodyMedium1.copyWith(
                      color: Colors.grey,
                      fontSize: 16.sp,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label) {
    final isLtr = AppLocalizations.of(context)!.locale.languageCode == 'en' ||
        AppLocalizations.of(context)!.locale.languageCode == 'sv';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Center(
          child: AppText(
            text: label,
            model: AppTextModel(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
              style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                  .subTitle1
                  .copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
            ),
          ),
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
