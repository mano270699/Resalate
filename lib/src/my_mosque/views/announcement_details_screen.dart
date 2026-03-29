import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/base/dependency_injection.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/my_mosque/data/models/announcement_model.dart';
import 'package:resalate/src/my_mosque/logic/announcement_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';

class AnnouncementDetailsScreen extends StatefulWidget {
  const AnnouncementDetailsScreen({super.key, required this.id});
  final int id;
  static const String routeName = 'AnnouncementDetailsScreen';

  @override
  State<AnnouncementDetailsScreen> createState() =>
      _AnnouncementDetailsScreenState();
}

class _AnnouncementDetailsScreenState extends State<AnnouncementDetailsScreen> {
  final viewModel = sl<AnnouncementViewModel>();

  @override
  void initState() {
    viewModel.getAnnouncementDetails(id: widget.id);
    super.initState();
  }

  Locale get _locale => AppLocalizations.of(context)!.locale;
  String _tr(String key) => AppLocalizations.of(context)!.translate(key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          _locale.languageCode == 'en' || _locale.languageCode == 'sv'
              ? TextDirection.ltr
              : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<GenericCubit<AnnouncementDetailsResponse>,
                GenericCubitState<AnnouncementDetailsResponse>>(
            bloc: viewModel.announcementDetailsRes,
            builder: (context, state) {
              final announcement = state.data.announcement;
              return Skeletonizer(
                enabled: state is GenericLoadingState,
                child: CustomScrollView(
                  slivers: [
                    // ── Collapsing App Bar with hero image ──
                    SliverAppBar(
                      expandedHeight: 280.h,
                      pinned: true,
                      backgroundColor: AppColors.scondaryColor,
                      leading: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: AppColors.scondaryColor,
                              size: 18.sp,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Image
                            (announcement?.image ?? "").isNotEmpty
                                ? Image.network(
                                    announcement!.image!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _heroPlaceholder(),
                                  )
                                : _heroPlaceholder(),

                            // Gradient overlays
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.0, 0.3, 0.7, 1.0],
                                  colors: [
                                    Colors.black.withValues(alpha: 0.3),
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.6),
                                  ],
                                ),
                              ),
                            ),

                            // Badge
                            Positioned(
                              top: MediaQuery.of(context).padding.top + 50.h,
                              right: 16.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor
                                          .withValues(alpha: 0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.campaign_rounded,
                                        size: 16.sp, color: Colors.white),
                                    SizedBox(width: 4.w),
                                    Text(
                                      _tr('announcement'),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Title on image
                            Positioned(
                              bottom: 16.h,
                              left: 16.w,
                              right: 16.w,
                              child: Text(
                                announcement?.title ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.3,
                                  shadows: [
                                    Shadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.5),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Body Content ──
                    SliverToBoxAdapter(
                      child: Transform.translate(
                        offset: Offset(0, -20.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24.r)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                16.w, 24.h, 16.w, 20.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Date & Masjid row ──
                                Row(
                                  children: [
                                    // Date chip
                                    if ((announcement?.date ?? '').isNotEmpty)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 7.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withValues(alpha: 0.08),
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                          border: Border.all(
                                            color: AppColors.primaryColor
                                                .withValues(alpha: 0.15),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                                Icons
                                                    .calendar_today_rounded,
                                                size: 13.sp,
                                                color:
                                                    AppColors.primaryColor),
                                            SizedBox(width: 6.w),
                                            Text(
                                              announcement!.date!,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    AppColors.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),

                                SizedBox(height: 20.h),

                                // ── Masjid Info Card ──
                                Container(
                                  padding: EdgeInsets.all(14.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: AppColors.scondaryColor
                                          .withValues(alpha: 0.08),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.scondaryColor
                                            .withValues(alpha: 0.06),
                                        blurRadius: 16,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Avatar with border
                                      Container(
                                        padding: EdgeInsets.all(2.w),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primaryColor,
                                              AppColors.scondaryColor,
                                            ],
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 26.r,
                                          backgroundImage: NetworkImage(
                                            announcement?.masjid?.photo ??
                                                "",
                                          ),
                                          backgroundColor:
                                              Colors.grey.shade100,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text: announcement
                                                      ?.masjid?.name ??
                                                  "",
                                              model: AppTextModel(
                                                textDirection: _locale
                                                                .languageCode ==
                                                            'en' ||
                                                        _locale.languageCode ==
                                                            'sv'
                                                    ? TextDirection.ltr
                                                    : TextDirection.rtl,
                                                style: AppFontStyleGlobal(
                                                        _locale)
                                                    .headingMedium2
                                                    .copyWith(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors
                                                          .scondaryColor,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Row(
                                              children: [
                                                Icon(
                                                    Icons.email_outlined,
                                                    size: 13.sp,
                                                    color: AppColors.gray),
                                                SizedBox(width: 4.w),
                                                Expanded(
                                                  child: Text(
                                                    announcement?.masjid
                                                            ?.email ??
                                                        "",
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color:
                                                          AppColors.gray,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Arrow indicator
                                      Icon(
                                        Icons.mosque_rounded,
                                        size: 22.sp,
                                        color: AppColors.primaryColor
                                            .withValues(alpha: 0.5),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 24.h),

                                // ── Divider with label ──
                                Row(
                                  children: [
                                    Container(
                                      width: 4.w,
                                      height: 20.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(2.r),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    AppText(
                                      text: _tr('details'),
                                      model: AppTextModel(
                                        style: AppFontStyleGlobal(_locale)
                                            .headingMedium2
                                            .copyWith(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  AppColors.scondaryColor,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16.h),

                                // ── Content (HTML) ──
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGray
                                        .withValues(alpha: 0.5),
                                    borderRadius:
                                        BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Html(
                                    data: announcement?.content ?? "",
                                    style: {
                                      "body": Style(
                                        direction:
                                            _locale.languageCode == 'en' ||
                                                    _locale.languageCode ==
                                                        'sv'
                                                ? TextDirection.ltr
                                                : TextDirection.rtl,
                                        fontSize: FontSize(14.sp),
                                        color: AppColors.lightBlack,
                                        lineHeight: LineHeight(1.7),
                                        margin: Margins.zero,
                                        padding: HtmlPaddings.zero,
                                      ),
                                    },
                                  ),
                                ),

                                SizedBox(height: 30.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget _heroPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.scondaryColor,
            AppColors.primaryColor,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.campaign_rounded,
          size: 64.sp,
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
