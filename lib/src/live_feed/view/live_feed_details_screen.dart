import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/base/dependency_injection.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/live_feed/data/models/live_feed_details.dart';
import 'package:resalate/src/live_feed/logic/live_feed_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/push_notification/notification_helper.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../layout/screens/user_bottom_navigation_screen.dart';

class LiveFeedDetailsScreen extends StatefulWidget {
  const LiveFeedDetailsScreen({super.key, required this.id});
  final int id;
  static const String routeName = 'LiveFeedDetailsScreen';

  @override
  State<LiveFeedDetailsScreen> createState() => _LiveFeedDetailsScreenState();
}

class _LiveFeedDetailsScreenState extends State<LiveFeedDetailsScreen> {
  final viewModel = sl<LiveFeedViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.getLiveFeedDetails(id: widget.id);
  }

  Locale get _locale => AppLocalizations.of(context)!.locale;
  String _tr(String key) => AppLocalizations.of(context)!.translate(key);

  bool _isValidNetworkImage(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Future<void> openYouTube(String videoUrl) async {
    final videoId = LiveFeedViewModel.extractVideoId(videoUrl);
    if (videoId == null) throw 'Could not parse YouTube URL';
    final url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    // ✅ FIXED: Safely dispose only if controller exists
    final controller = viewModel.youtubeController.state.data;
    if (controller != null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          _locale.languageCode == 'en' || _locale.languageCode == 'sv'
              ? TextDirection.ltr
              : TextDirection.rtl,
      child: BlocBuilder<GenericCubit<YoutubePlayerController?>,
          GenericCubitState<YoutubePlayerController?>>(
        bloc: viewModel.youtubeController,
        builder: (context, ytState) {
          // ✅ FIXED: Wrap entire Scaffold with YoutubePlayerBuilder
          // This is REQUIRED on iOS for fullscreen + proper lifecycle handling
          if (ytState.data != null) {
            return YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: ytState.data!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: AppColors.primaryColor,
                progressColors: ProgressBarColors(
                  playedColor: AppColors.primaryColor,
                  handleColor: AppColors.primaryColor,
                  bufferedColor: AppColors.primaryColor.withValues(alpha: 0.3),
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
              builder: (context, player) => _buildScaffold(context, player),
            );
          }
          return _buildScaffold(context, null);
        },
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, Widget? player) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            if (NotificationHelper.isFromNotifiction) {
              Navigator.pushNamed(
                  context, MainBottomNavigationScreen.routeName);
            } else {
              Navigator.pop(context);
            }
          },
          child: Icon(Icons.arrow_back_ios, color: AppColors.black, size: 30),
        ),
        title: AppText(
          text: _tr("Live_Details"),
          model: AppTextModel(
            style: AppFontStyleGlobal(_locale).headingMedium2.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
          ),
        ),
      ),
      body: BlocBuilder<GenericCubit<LiveFeedDetailsModel>,
          GenericCubitState<LiveFeedDetailsModel>>(
        bloc: viewModel.liveDetailsRes,
        builder: (context, state) {
          final masjidPhoto = state.data.post?.masjid?.photo;
          final hasMasjidPhoto = _isValidNetworkImage(masjidPhoto);

          return Skeletonizer(
            enabled: state is GenericLoadingState,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ── Masjid Info Card ──
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Colors.grey.shade100, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  AppColors.primaryColor.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 28.r,
                            backgroundImage: hasMasjidPhoto
                                ? NetworkImage(masjidPhoto!)
                                : null,
                            backgroundColor: Colors.grey.shade100,
                            child: hasMasjidPhoto
                                ? null
                                : Icon(Icons.mosque_outlined,
                                    color: AppColors.gray, size: 26.sp),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: state.data.post?.masjid?.name ?? "",
                                model: AppTextModel(
                                  textDirection: _locale.languageCode == 'en' ||
                                          _locale.languageCode == 'sv'
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  style: AppFontStyleGlobal(_locale)
                                      .headingMedium2
                                      .copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.lightBlack,
                                      ),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(Icons.email_outlined,
                                      size: 14.sp, color: AppColors.gray),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      state.data.post?.masjid?.email ?? "",
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.gray),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// ── Post Title ──
                  AppText(
                    text: state.data.post?.title ?? "",
                    model: AppTextModel(
                      textDirection: _locale.languageCode == 'en' ||
                              _locale.languageCode == 'sv'
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      style:
                          AppFontStyleGlobal(_locale).headingMedium2.copyWith(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  /// ── Date chip ──
                  if ((state.data.post?.date ?? '').isNotEmpty)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 14.sp, color: AppColors.primaryColor),
                          SizedBox(width: 6.w),
                          Text(
                            "${_tr("Published")}${state.data.post!.date!}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 16.h),

                  Divider(
                      height: 1, thickness: 0.5, color: Colors.grey.shade200),

                  SizedBox(height: 16.h),

                  /// ── Post Content (HTML) ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade100, width: 1),
                    ),
                    child: Html(
                      data: state.data.post?.content ?? "",
                      style: {
                        "body": Style(
                          direction: _locale.languageCode == 'en' ||
                                  _locale.languageCode == 'sv'
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          fontSize: FontSize(14.sp),
                          color: AppColors.lightBlack,
                          lineHeight: LineHeight(1.6),
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// ── YouTube Player ──
                  // ✅ FIXED: player is passed from YoutubePlayerBuilder above
                  if (player != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: player, // ✅ Use the builder's player widget
                      ),
                    ),

                  SizedBox(height: 24.h),

                  /// ── Open YouTube Button ──
                  GestureDetector(
                    onTap: () => openYouTube(state.data.post?.iframe ?? ""),
                    child: Container(
                      height: 48.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.scondaryColor,
                            AppColors.scondaryColor.withValues(alpha: 0.85),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.scondaryColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_circle_fill_rounded,
                              color: AppColors.white, size: 22.sp),
                          SizedBox(width: 8.w),
                          AppText(
                            text: _tr('open_youtube'),
                            model: AppTextModel(
                              style: AppFontStyleGlobal(_locale)
                                  .subTitle2
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                    fontSize: 15.sp,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 50.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
