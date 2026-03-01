// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/donation/logic/donations_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/base/dependency_injection.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/push_notification/notification_helper.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../layout/screens/user_bottom_navigation_screen.dart';
import '../../my_mosque/views/widgets/custom_expantion_tile.dart';
import '../data/models/donation_details_model.dart';
import 'widgets/payment_options.dart';

class DonationDetailsScreen extends StatefulWidget {
  static const String routeName = 'DonationDetailsScreen';

  const DonationDetailsScreen({
    super.key,
    required this.donationId,
  });
  final int donationId;

  @override
  State<DonationDetailsScreen> createState() => _DonationDetailsScreenState();
}

class _DonationDetailsScreenState extends State<DonationDetailsScreen> {
  final viewModel = sl<DonationsViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.getDonationsDetails(widget.donationId);
  }

  // ── helpers ──────────────────────────────────────────────────────────────
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
            text: _tr("Donation_details"),
            model: AppTextModel(
              style: AppFontStyleGlobal(_locale).headingMedium2.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: BlocBuilder<GenericCubit<DonationsDetailsResponse>,
              GenericCubitState<DonationsDetailsResponse>>(
            bloc: viewModel.donationDetailsResponse,
            builder: (context, state) {
              final data = state.data.post;

              if (state is GenericLoadingState) {
                return Padding(
                    padding: EdgeInsets.only(top: 150.h),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ));
              }

              if (data == null && state is GenericUpdatedState) {
                return Center(
                  child: AppText(
                    text: _tr("no_donation_details_found"),
                    model: AppTextModel(
                      style: AppFontStyleGlobal(_locale)
                          .bodyMedium1
                          .copyWith(color: AppColors.gray),
                    ),
                  ),
                );
              }

              return Skeletonizer(
                enabled: state is GenericLoadingState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ── Post Image with gradient overlay ──
                    if ((data?.image ?? "").isNotEmpty)
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
                                data!.image!,
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

                    /// ── Title ──
                    AppText(
                      text: data?.title ?? "",
                      model: AppTextModel(
                        style:
                            AppFontStyleGlobal(_locale).headingMedium2.copyWith(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    /// ── Date chip ──
                    if ((data?.date ?? '').isNotEmpty)
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
                                size: 14.sp, color: AppColors.primaryColor),
                            SizedBox(width: 6.w),
                            Text(
                              data!.date!,
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

                    /// ── Divider ──
                    Divider(
                        height: 1, thickness: 0.5, color: Colors.grey.shade200),

                    SizedBox(height: 16.h),

                    /// ── Content ──
                    AppText(
                      text: data?.content?.replaceAll(RegExp(r"<[^>]*>"), "") ??
                          "",
                      model: AppTextModel(
                        style: AppFontStyleGlobal(_locale).bodyMedium1.copyWith(
                              fontSize: 15.sp,
                              height: 1.6,
                              color: AppColors.lightBlack,
                            ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// ── Donation progress ──
                    if (data?.donation != null)
                      _buildDonationSection(data!.donation!),

                    SizedBox(height: 24.h),

                    /// ── Masjid Info ──
                    if (data?.masjid != null)
                      _buildMasjidSection(data!.masjid!),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Donation Progress Section
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildDonationSection(Donation donation) {
    final progress = (donation.percent ?? 0) / 100;
    final remaining = ((donation.total ?? 0) - (donation.paid ?? 0))
        .clamp(0, double.infinity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section header
        Row(
          children: [
            Container(
              width: 4.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 8.w),
            AppText(
              text: _tr("donation_progress"),
              model: AppTextModel(
                style: AppFontStyleGlobal(_locale).headingMedium2.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
              ),
            ),
          ],
        ),

        SizedBox(height: 14.h),

        /// Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearPercentIndicator(
            barRadius: Radius.circular(10.r),
            fillColor: AppColors.primaryColor.withValues(alpha: 0.12),
            lineHeight: 32.h,
            padding: EdgeInsets.zero,
            percent: progress.clamp(0.0, 1.0),
            center: AppText(
              text: "${donation.percent}%",
              model: AppTextModel(
                  style: AppFontStyleGlobal(_locale).label.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                        fontSize: 13.sp,
                      )),
            ),
            progressColor: AppColors.primaryColor,
          ),
        ),

        SizedBox(height: 16.h),

        /// Stat cards row
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.account_balance_wallet_rounded,
                iconColor: AppColors.primaryColor,
                label: _tr('total'),
                value: "${donation.total ?? 0} ${donation.currency ?? ''}",
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle_rounded,
                iconColor: const Color(0xFF4CAF50),
                label: _tr('paid'),
                value: "${donation.paid ?? 0} ${donation.currency ?? ''}",
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _StatCard(
                icon: Icons.hourglass_bottom_rounded,
                iconColor: const Color(0xFFF57C00),
                label: _tr('remaining'),
                value: "$remaining ${donation.currency ?? ''}",
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Masjid Section
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildMasjidSection(Masjid masjid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section header
        Row(
          children: [
            Container(
              width: 4.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: AppColors.scondaryColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 8.w),
            AppText(
              text: _tr("masjid_info"),
              model: AppTextModel(
                style: AppFontStyleGlobal(_locale).headingMedium2.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        /// Masjid card
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
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundImage: NetworkImage(masjid.photo ?? ""),
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: masjid.name ?? "",
                      model: AppTextModel(
                        style:
                            AppFontStyleGlobal(_locale).headingMedium2.copyWith(
                                  fontSize: 17.sp,
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
                            masjid.email ?? "",
                            style: TextStyle(
                              fontSize: 13.sp,
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

        SizedBox(height: 16.h),

        /// Payment info expansion tile
        if (masjid.paymentInfo != null)
          CustomExpansionTile(
            content: PaymentOptionsSection(
              paymentInfo: masjid.paymentInfo!,
            ),
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AppText(
                text: _tr("payment_options"),
                model: AppTextModel(
                  style: AppFontStyleGlobal(_locale).subTitle2.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.scondaryColor,
                      ),
                ),
              ),
            ),
            animationDuration: Duration(milliseconds: 200),
            initiallyExpanded: false,
          ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  Stat Card (Total / Paid / Remaining)
// ═════════════════════════════════════════════════════════════════════════════
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: iconColor.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: iconColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
