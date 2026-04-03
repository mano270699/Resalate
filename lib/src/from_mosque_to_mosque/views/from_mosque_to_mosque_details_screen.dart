import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/base/dependency_injection.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/push_notification/notification_helper.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../layout/screens/user_bottom_navigation_screen.dart';
import '../data/models/masjed_to_masjed_detais_model.dart';
import '../logic/masjed_to_masjed_view_model.dart';

class FromMosqueToMosqueDetailsScreen extends StatefulWidget {
  const FromMosqueToMosqueDetailsScreen({super.key, required this.id});
  final int id;
  static const String routeName = 'FromMosqueToMosqueDetailsScreen';

  @override
  State<FromMosqueToMosqueDetailsScreen> createState() =>
      _FromMosqueToMosqueDetailsScreenState();
}

class _FromMosqueToMosqueDetailsScreenState
    extends State<FromMosqueToMosqueDetailsScreen> {
  final viewModel = sl<MasjedToMasjedViewModel>();

  @override
  void initState() {
    viewModel.getMasjedToMasjedDetails(id: widget.id);
    super.initState();
  }

  // ── helpers ──────────────────────────────────────────────────────────────
  Locale get _locale => AppLocalizations.of(context)!.locale;
  String _tr(String key) => AppLocalizations.of(context)!.translate(key);

  void _openWhatsApp(String phoneNumber) async {
    final url = "https://wa.me/$phoneNumber";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          _locale.languageCode == 'en' || _locale.languageCode == 'sv'
              ? TextDirection.ltr
              : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                if (NotificationHelper.isFromNotifiction) {
                  Navigator.pushNamed(
                    context,
                    MainBottomNavigationScreen.routeName,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.black,
                size: 30,
              )),
          title: AppText(
            text: _tr("from_mosque_to_mosque_details"),
            model: AppTextModel(
              style: AppFontStyleGlobal(_locale).headingMedium2.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
            ),
          ),
        ),
        body: BlocBuilder<GenericCubit<MasjedToMasjedDetailsModel>,
                GenericCubitState<MasjedToMasjedDetailsModel>>(
            bloc: viewModel.masjedToMasjedDetailsRes,
            builder: (context, state) {
              final post = state.data.post;
              return Skeletonizer(
                enabled: state is GenericLoadingState,
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ── Post Image with gradient overlay ──
                      if ((post?.image ?? "").isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Stack(
                              children: [
                                Image.network(
                                  post!.image!,
                                  width: double.infinity,
                                  height: 220.h,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 80.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.45),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      SizedBox(height: 16.h),

                      /// ── Masjid Info Card ──
                      Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border:
                              Border.all(color: Colors.grey.shade100, width: 1),
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
                                backgroundImage: NetworkImage(
                                  post?.masjid?.photo ?? "",
                                ),
                                backgroundColor: Colors.grey.shade100,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: post?.masjid?.name ?? "",
                                    model: AppTextModel(
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
                                          post?.masjid?.email ?? "",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.gray,
                                          ),
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
                        text: post?.title ?? "",
                        model: AppTextModel(
                          style: AppFontStyleGlobal(_locale)
                              .headingMedium2
                              .copyWith(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      /// ── Date chip + Categories ──
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Date chip
                          if ((post?.date ?? '').isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calendar_today_rounded,
                                      size: 14.sp,
                                      color: AppColors.primaryColor),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "${_tr("Published")}${post!.date!}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Category chips
                          if (post?.categories?.isNotEmpty ?? false)
                            ...post!.categories!.map(
                              (cat) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.scondaryColor.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: AppColors.scondaryColor
                                        .withValues(alpha: 0.15),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.label_rounded,
                                        size: 13.sp,
                                        color: AppColors.scondaryColor),
                                    SizedBox(width: 4.w),
                                    Text(
                                      cat.name ?? "",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.scondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      /// ── Divider ──
                      Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Colors.grey.shade200),

                      SizedBox(height: 16.h),

                      /// ── Post Content (HTML) ──
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border:
                              Border.all(color: Colors.grey.shade100, width: 1),
                        ),
                        child: Html(
                          data: post?.content ?? "",
                          style: {
                            "body": Style(
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

                      /// ── WhatsApp Button ──
                      if ((post?.masjid?.whatsapp ?? "").isNotEmpty)
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  _openWhatsApp(post!.masjid!.whatsapp!),
                              borderRadius: BorderRadius.circular(14.r),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF25D366),
                                      Color(0xFF128C7E),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF25D366)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.chat_rounded,
                                        color: Colors.white, size: 22.sp),
                                    SizedBox(width: 10.w),
                                    AppText(
                                      text: _tr("whatsApp"),
                                      model: AppTextModel(
                                        style: AppFontStyleGlobal(_locale)
                                            .headingMedium2
                                            .copyWith(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
