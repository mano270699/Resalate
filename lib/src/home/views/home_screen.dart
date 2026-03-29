import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/home/data/models/donation_model.dart';
import 'package:resalate/src/home/data/models/funerial_model.dart';
import 'package:resalate/src/home/data/models/lessons_model.dart';
import 'package:resalate/src/home/data/models/live_model.dart';
import 'package:resalate/src/home/data/models/partners_model.dart';
import 'package:resalate/src/home/logic/home_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:resalate/src/home/views/all_feed_screen.dart';
import 'package:resalate/src/home/views/all_funerals_screen.dart';
import 'package:resalate/src/home/views/all_lesson_screen.dart';
import 'package:resalate/src/home/views/widgets/funeral_item.dart';
import 'package:resalate/src/home/views/widgets/lesson_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/base/dependency_injection.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/common/app_icon_svg.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../../core/util/localization/cubit/localization_cubit.dart';
import '../../profile/views/widgets/language_dialog.dart';
import '../../donation/view/donation_details_screen.dart';
import '../../from_mosque_to_mosque/views/from_mosque_to_mosque_screen.dart';
import '../../funerals/view/funerals_details_screen.dart';
import '../../lessons/view/lesson_details_screen.dart';
import '../../nearest_mosque/views/nearest_mosque.dart';
import '../data/models/home_data_model.dart';
import 'widgets/banner.dart';
import 'widgets/donation_item.dart';
import 'widgets/live_feed_item.dart';
import 'widgets/partenar_section.dart';
import 'widgets/resalty_numbers_item.dart';
import '../../layout/screens/main_screen_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.homeViewModel});

  final MainScreenViewModel homeViewModel;
  static const String routeName = 'Home Screen';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final viewModel = sl<HomeViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.getHomeData();
    viewModel.getDonationsData();
    viewModel.getLiveFeedData();
    viewModel.getLessonsData();
    viewModel.getFuneralsData();
    viewModel.getPartnersData();
  }

  String _getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇬🇧';
      case 'ar':
        return '🇸🇦';
      case 'sv':
        return '🇸🇪';
      default:
        return '🌐';
    }
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
        appBar: AppBar(
          toolbarHeight: 70.h,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: SvgPicture.asset(
            AppLocalizations.of(context)!.locale.languageCode == 'en' ||
                    AppLocalizations.of(context)!.locale.languageCode == 'sv'
                ? AppIconSvg.rowLogo
                : AppIconSvg.rowLogoAr,
            height: 150.h,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, NearestMosque.routeName);
              },
              child: Icon(
                Icons.search,
                size: 28,
                color: AppColors.scondaryColor,
              ),
            ),
            SizedBox(width: 8.w),
            BlocBuilder<LocalizationCubit, LocalizationState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LanguageDialog(
                          currentLanguage:
                              AppLocalizations.of(context)!.locale.languageCode,
                          onLanguageSelected: (String languageCode) {
                            context
                                .read<LocalizationCubit>()
                                .changeLanguage(languageCode);
                            viewModel.getHomeData();
                            viewModel.getDonationsData();
                            viewModel.getLiveFeedData();
                            viewModel.getLessonsData();
                            viewModel.getFuneralsData();
                            viewModel.getPartnersData();
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 35.h,
                    width: 35.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                    ),
                    child: Center(
                      child: Text(
                        _getLanguageFlag(
                            AppLocalizations.of(context)!.locale.languageCode),
                        style: TextStyle(fontSize: 22.sp),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 16.w),
          ],
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<GenericCubit<HomeDataModel>,
              GenericCubitState<HomeDataModel>>(
            bloc: viewModel.homeResponse,
            builder: (context, state) {
              return Skeletonizer(
                enabled: state is GenericLoadingState,
                child: Column(
                  children: [
                    state is GenericLoadingState
                        ? Container(
                            height: 200.h,
                            color: Colors.grey[200], // Will shimmer
                          )
                        : CustomBannerSlider(
                            images: state.data.home?.gallery ?? []),
                    10.h.verticalSpace,
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Skeletonizer(
                          enabled: state is GenericLoadingState,
                          child: Text(
                            "${state.data.home?.ayah1}",
                            textAlign: TextAlign.center,
                            textDirection: AppLocalizations.of(context)!
                                            .locale
                                            .languageCode ==
                                        'en' ||
                                    AppLocalizations.of(context)!
                                            .locale
                                            .languageCode ==
                                        'sv'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            style: ArabicTextStyle(
                              color: AppColors.primaryColor,
                              arabicFont: ArabicFont.scheherazade,
                              fontSize: 28.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    10.h.verticalSpace,
                    Skeletonizer(
                      enabled: state is GenericLoadingState,
                      child: PartenerSection(
                        desc: state.data.home?.aboutSection!.description ?? "",
                        title: state.data.home?.aboutSection!.title ?? "",
                        url: state.data.home?.aboutSection!.link ?? "",
                      ),
                    ),
                    15.h.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  FromMosqueToMosqueScreen.routeName,
                                );
                              },
                              child: Container(
                                height: 100.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: AppColors.white),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AppIconSvg.fromMosque,
                                      height: 35.h,
                                    ),
                                    10.h.verticalSpace,
                                    AppText(
                                      text: AppLocalizations.of(context)!
                                          .translate('from_mosque_to_mosque'),
                                      model: AppTextModel(
                                          textAlign: TextAlign.center,
                                          style: AppFontStyleGlobal(
                                                  AppLocalizations.of(context)!
                                                      .locale)
                                              .subTitle1
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.sp,
                                                height: 1,
                                                color: AppColors.scondaryColor,
                                              )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          10.w.horizontalSpace,
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  NearestMosque.routeName,
                                );
                              },
                              child: Container(
                                height: 100.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: AppColors.white),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AppIconSvg.mosqueLocation,
                                      height: 35.h,
                                    ),
                                    5.h.verticalSpace,
                                    AppText(
                                      text: AppLocalizations.of(context)!
                                          .translate('nearest_mosques'),
                                      model: AppTextModel(
                                          textAlign: TextAlign.center,
                                          style: AppFontStyleGlobal(
                                                  AppLocalizations.of(context)!
                                                      .locale)
                                              .subTitle1
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.sp,
                                                height: 1,
                                                color: AppColors.scondaryColor,
                                              )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    15.h.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: AppLocalizations.of(context)!
                                .translate('donate'),
                            model: AppTextModel(
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .label
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                    color: AppColors.scondaryColor,
                                  ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.homeViewModel.screenIndexChanged(index: 1);
                            },
                            child: AppText(
                              text: AppLocalizations.of(context)!
                                  .translate('show_more'),
                              model: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .subTitle2
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryColor,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.h.verticalSpace,
                    BlocBuilder<GenericCubit<DonationsResponse>,
                        GenericCubitState<DonationsResponse>>(
                      bloc: viewModel.donationResponse,
                      builder: (context, donationState) {
                        return Skeletonizer(
                          enabled: donationState is GenericLoadingState,
                          child: SizedBox(
                            height: 400.h,
                            child: ListView.separated(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => DonationItem(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, DonationDetailsScreen.routeName,
                                      arguments: {
                                        "id":
                                            donationState.data.posts![index].id,
                                      });
                                },
                                percentage: donationState
                                        .data.posts![index].donation?.percent
                                        .toString() ??
                                    "",
                                title: donationState.data.posts?[index].title ??
                                    "",
                                image: donationState.data.posts?[index].image ??
                                    "",
                                desc:
                                    donationState.data.posts?[index].excerpt ??
                                        "",
                                total: donationState
                                        .data.posts![index].donation?.total
                                        .toString() ??
                                    "",
                                paid: donationState
                                        .data.posts![index].donation?.paid
                                        .toString() ??
                                    "",
                                currency: donationState
                                        .data.posts![index].donation?.currency
                                        .toString() ??
                                    "",
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                width: 5.w,
                              ),
                              itemCount: donationState.data.posts?.length ?? 0,
                            ),
                          ),
                        );
                      },
                    ),
                    20.h.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: AppLocalizations.of(context)!
                                .translate('live_feed'),
                            model: AppTextModel(
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .label
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                    color: AppColors.scondaryColor,
                                  ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AllFeedLiveScreen.routeName);
                            },
                            child: AppText(
                              text: AppLocalizations.of(context)!
                                  .translate('show_more'),
                              model: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .subTitle2
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryColor,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.h.verticalSpace,
                    BlocBuilder<GenericCubit<LiveFeedsResponse>,
                        GenericCubitState<LiveFeedsResponse>>(
                      bloc: viewModel.liveResponse,
                      builder: (context, liveState) {
                        return Skeletonizer(
                          enabled: liveState is GenericLoadingState,
                          child: SizedBox(
                            height: 200.h,
                            child: ListView.separated(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => LiveFeedItem(
                                id: liveState.data.posts?[index].id ?? 0,
                                title: liveState.data.posts?[index].title ?? "",
                                url: liveState.data.posts?[index].iframe ?? "",
                                desc:
                                    liveState.data.posts?[index].excerpt ?? "",
                                image:
                                    "https://st.depositphotos.com/1006472/1847/i/950/depositphotos_18478155-stock-photo-live-message.jpg",
                                date: liveState.data.posts?[index].date ?? "",
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                width: 5.w,
                              ),
                              itemCount: liveState.data.posts?.length ?? 0,
                            ),
                          ),
                        );
                      },
                    ),
                    20.h.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: AppLocalizations.of(context)!
                                .translate('lessons'),
                            model: AppTextModel(
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .label
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                    color: AppColors.scondaryColor,
                                  ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AllLessonsScreen.routeName);
                            },
                            child: AppText(
                              text: AppLocalizations.of(context)!
                                  .translate('show_more'),
                              model: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .subTitle2
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryColor,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.h.verticalSpace,
                    BlocBuilder<GenericCubit<LessonsResponse>,
                        GenericCubitState<LessonsResponse>>(
                      bloc: viewModel.lessonsResponse,
                      builder: (context, lessonState) {
                        return Skeletonizer(
                          enabled: lessonState is GenericLoadingState,
                          child: SizedBox(
                            height: AppLocalizations.of(context)!
                                            .locale
                                            .languageCode ==
                                        'sv' ||
                                    AppLocalizations.of(context)!
                                            .locale
                                            .languageCode ==
                                        'en'
                                ? 265.h
                                : 260.h,
                            child: ListView.separated(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => LessonItem(
                                lesson: lessonState.data.lessons?[index] ??
                                    Lesson(),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, LessonDetailsScreen.routeName,
                                      arguments: {
                                        "id":
                                            lessonState.data.lessons?[index].id
                                      });
                                },
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                width: 5.w,
                              ),
                              itemCount: lessonState.data.lessons?.length ?? 0,
                            ),
                          ),
                        );
                      },
                    ),
                    20.h.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: AppLocalizations.of(context)!
                                .translate('funerals'),
                            model: AppTextModel(
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .label
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                    color: AppColors.scondaryColor,
                                  ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AllFuneralsScreen.routeName);
                            },
                            child: AppText(
                              text: AppLocalizations.of(context)!
                                  .translate('show_more'),
                              model: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .subTitle2
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryColor,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.h.verticalSpace,
                    BlocBuilder<GenericCubit<FuneralsResponse>,
                        GenericCubitState<FuneralsResponse>>(
                      bloc: viewModel.funeralsResponse,
                      builder: (context, funeralsState) {
                        return Skeletonizer(
                          enabled: funeralsState is GenericLoadingState,
                          child: SizedBox(
                            height: AppLocalizations.of(context)!
                                            .locale
                                            .languageCode ==
                                        'sv' ||
                                    AppLocalizations.of(context)!
                                            .locale
                                            .languageCode ==
                                        'en'
                                ? 265.h
                                : 260.h,
                            child: ListView.separated(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => FuneralItem(
                                post: funeralsState.data.posts?[index] ??
                                    FuneralPost(),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, FuneralsDetailsScreen.routeName,
                                      arguments: {
                                        "id":
                                            funeralsState.data.posts?[index].id
                                      });
                                },
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                width: 5.w,
                              ),
                              itemCount: funeralsState.data.posts?.length ?? 0,
                            ),
                          ),
                        );
                      },
                    ),
                    10.h.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: AppLocalizations.of(context)!
                                .translate('sponsors'),
                            model: AppTextModel(
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .label
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                    color: AppColors.scondaryColor,
                                  ),
                            ),
                          ),
                          // AppText(
                          //   text: AppLocalizations.of(context)!
                          //       .translate('show_more'),
                          //   model: AppTextModel(
                          //     style: AppFontStyleGlobal(
                          //             AppLocalizations.of(context)!.locale)
                          //         .subTitle2
                          //         .copyWith(
                          //           fontWeight: FontWeight.w500,
                          //           color: AppColors.primaryColor,
                          //         ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    20.h.verticalSpace,
                    SizedBox(
                      height: 100.h,
                      child: _AutoScrollingSponsorList(
                        sponsors: state.data.home?.sponser ?? [],
                      ),
                    ),
                    20.h.verticalSpace,
                    // Partners Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          AppText(
                            text: AppLocalizations.of(context)!
                                .translate('partners'),
                            model: AppTextModel(
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .label
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                    color: AppColors.scondaryColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.h.verticalSpace,
                    BlocBuilder<GenericCubit<PartnersResponse>,
                        GenericCubitState<PartnersResponse>>(
                      bloc: viewModel.partnersResponse,
                      builder: (context, partnersState) {
                        return _AutoScrollingPartnerList(
                          partners: partnersState.data.partners ?? [],
                        );
                      },
                    ),
                    20.h.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: AppLocalizations.of(context)!
                                .translate('resalty_in_numbers'),
                            model: AppTextModel(
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .label
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                    color: AppColors.scondaryColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.h.verticalSpace,
                    ResaltyNumbersWidgets(
                      numbers: state.data.home?.numbers ?? Numbers(),
                    ),
                    30.h.verticalSpace,
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          "${state.data.home?.ayah2}",
                          textAlign: TextAlign.center,
                          textDirection: AppLocalizations.of(context)!
                                          .locale
                                          .languageCode ==
                                      'en' ||
                                  AppLocalizations.of(context)!
                                          .locale
                                          .languageCode ==
                                      'sv'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: ArabicTextStyle(
                            color: AppColors.primaryColor,
                            arabicFont: ArabicFont.scheherazade,
                            fontSize: 30.sp,
                          ),
                        ),
                      ),
                    ),
                    30.h.verticalSpace,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AutoScrollingSponsorList extends StatefulWidget {
  final List<dynamic> sponsors;

  const _AutoScrollingSponsorList({required this.sponsors});

  @override
  State<_AutoScrollingSponsorList> createState() =>
      _AutoScrollingSponsorListState();
}

class _AutoScrollingSponsorListState extends State<_AutoScrollingSponsorList> {
  late ScrollController _scrollController;
  bool _isScrolling = false;

  // We duplicate items to create a seamless loop
  static const int _multiplier = 100;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  @override
  void didUpdateWidget(covariant _AutoScrollingSponsorList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isScrolling && widget.sponsors.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
    }
  }

  void _startScrolling() {
    if (!mounted || widget.sponsors.isEmpty) return;
    _isScrolling = true;
    _scroll();
  }

  void _scroll() async {
    if (!mounted || !_isScrolling) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    final remaining = maxScroll - current;

    if (remaining <= 0) {
      // Jump back to the start seamlessly
      _scrollController.jumpTo(0);
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted && _isScrolling) _scroll();
      return;
    }

    // Speed: pixels per second
    const speed = 40.0;
    final duration = Duration(milliseconds: (remaining / speed * 1000).toInt());

    await _scrollController.animateTo(
      maxScroll,
      duration: duration,
      curve: Curves.linear,
    );

    if (mounted && _isScrolling) {
      _scrollController.jumpTo(0);
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted && _isScrolling) _scroll();
    }
  }

  @override
  void dispose() {
    _isScrolling = false;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sponsors.isEmpty) return const SizedBox.shrink();

    return ListView.separated(
      controller: _scrollController,
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.sponsors.length * _multiplier,
      separatorBuilder: (context, index) => SizedBox(width: 3.w),
      itemBuilder: (context, index) {
        final sponsor = widget.sponsors[index % widget.sponsors.length];
        final url = sponsor?.url ?? "";

        return Padding(
          padding: EdgeInsetsDirectional.only(start: 5.w, end: 5.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              height: 100.h,
              width: 100.w,
              child: url.toLowerCase().endsWith(".svg")
                  ? SvgPicture.network(
                      url,
                      fit: BoxFit.contain,
                      placeholderBuilder: (context) => Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Image.network(
                      url,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _AutoScrollingPartnerList extends StatefulWidget {
  final List<Partner> partners;

  const _AutoScrollingPartnerList({required this.partners});

  @override
  State<_AutoScrollingPartnerList> createState() =>
      _AutoScrollingPartnerListState();
}

class _AutoScrollingPartnerListState extends State<_AutoScrollingPartnerList> {
  late ScrollController _scrollController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;

    int newIndex;
    final maxScroll = _scrollController.position.maxScrollExtent;

    // If scrolled to the very edge, force the last index
    if (maxScroll > 0 && _scrollController.offset >= maxScroll - 10) {
      newIndex = widget.partners.length - 1;
    } else {
      newIndex = (_scrollController.offset / 208.w).round();
    }

    newIndex = newIndex.clamp(0, widget.partners.length - 1);

    if (newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;

    String finalUrl = url.trim();
    if (!finalUrl.startsWith('http')) {
      finalUrl = 'https://$finalUrl';
    }

    final Uri uri = Uri.parse(finalUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not launch $finalUrl");
      }
    } catch (e) {
      debugPrint("Launch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.partners.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 130.h,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            itemCount: widget.partners.length,
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final partner = widget.partners[index];
              final imageUrl = partner.image ?? "";
              final partnerUrl = partner.url ?? "";

              return ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _launchUrl(partnerUrl),
                    child: SizedBox(
                      height: 200.h,
                      width: 200.w,
                      child: _buildImage(imageUrl),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        10.h.verticalSpace,
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: widget.partners.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8.h,
            dotWidth: 8.w,
            activeDotColor: AppColors.primaryColor,
            dotColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.toLowerCase().endsWith(".svg")) {
      return SvgPicture.network(
        imageUrl,
        fit: BoxFit.fill,
        placeholderBuilder: (_) => _loader(),
      );
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.fill,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _loader();
      },
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  Widget _loader() => const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
}
