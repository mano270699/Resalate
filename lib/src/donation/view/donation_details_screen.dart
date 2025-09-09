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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
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
            text: AppLocalizations.of(context)!.translate("Donation_details"),
            model: AppTextModel(
              style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                  .headingMedium2
                  .copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                    text: AppLocalizations.of(context)!
                        .translate("no_donation_details_found"),
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .bodyMedium1
                          .copyWith(
                            color: AppColors.gray,
                          ),
                    ),
                  ),
                );
              }

              return Skeletonizer(
                enabled: state is GenericLoadingState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Post Image
                    if ((data?.image ?? "").isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          data!.image!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),

                    const SizedBox(height: 12),

                    /// Title
                    AppText(
                      text: data?.title ?? "",
                      model: AppTextModel(
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .headingMedium2
                            .copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    AppText(
                      text: "📅 ${data?.date ?? ''}",
                      model: AppTextModel(
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .bodyMedium1
                            .copyWith(color: AppColors.gray, fontSize: 12.sp),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Content
                    AppText(
                      text: data?.content?.replaceAll(RegExp(r"<[^>]*>"), "") ??
                          "",
                      model: AppTextModel(
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .bodyMedium1
                            .copyWith(
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Donation Progress
                    if (data?.donation != null)
                      _buildDonationSection(data?.donation ?? Donation()),

                    // const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppText(
                                text: AppLocalizations.of(context)!
                                    .translate('total'),
                                model: AppTextModel(
                                    textDirection: AppLocalizations.of(context)!
                                                .locale
                                                .languageCode ==
                                            'en'
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                    style: AppFontStyleGlobal(
                                            AppLocalizations.of(context)!
                                                .locale)
                                        .subTitle1
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryColor,
                                        )),
                              ),
                              AppText(
                                text:
                                    " ${data?.donation?.total.toString()} ${data?.donation?.currency}",
                                model: AppTextModel(
                                    style: AppFontStyleGlobal(
                                            AppLocalizations.of(context)!
                                                .locale)
                                        .smallTab
                                        .copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.scondaryColor,
                                        )),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppText(
                                text: AppLocalizations.of(context)!
                                    .translate('paid'),
                                model: AppTextModel(
                                    textDirection: AppLocalizations.of(context)!
                                                .locale
                                                .languageCode ==
                                            'en'
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                    style: AppFontStyleGlobal(
                                            AppLocalizations.of(context)!
                                                .locale)
                                        .subTitle1
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryColor,
                                        )),
                              ),
                              AppText(
                                text:
                                    " ${data?.donation?.paid.toString()} ${data?.donation?.currency}",
                                model: AppTextModel(
                                    style: AppFontStyleGlobal(
                                            AppLocalizations.of(context)!
                                                .locale)
                                        .smallTab
                                        .copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.scondaryColor,
                                        )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    10.h.verticalSpace,
                    const SizedBox(height: 24),

                    /// Masjid Info
                    if (data?.masjid != null)
                      _buildMasjidSection(data?.masjid ?? Masjid()),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDonationSection(
    Donation donation,
  ) {
    final progress = (donation.percent ?? 0) / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: AppLocalizations.of(context)!.translate("donation_progress"),
          model: AppTextModel(
            style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                .headingMedium2
                .copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
          ),
        ),
        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearPercentIndicator(
            barRadius: const Radius.circular(8),
            fillColor: AppColors.primaryColor.withValues(alpha: 0.5),
            lineHeight: 30.h,

            padding: EdgeInsets.zero,
            percent: progress,
            // 50% progress
            center: AppText(
              text: "${donation.percent}%",
              model: AppTextModel(
                  style:
                      AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                          .label
                          .copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          )),
            ),

            progressColor: AppColors.primaryColor,
          ),
        ),
        // LinearProgressIndicator(
        //   value: progress,
        //   minHeight: 30.h,
        //   borderRadius: BorderRadius.circular(8),
        //   backgroundColor: Colors.grey[300],

        //   valueColor:
        //       const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        // ),
        const SizedBox(height: 8),
        // AppText(
        //   text:
        //       "${donation.paid}/${donation.total} ${donation.currency} (${donation.percent}%)",
        //   model: AppTextModel(
        //     style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
        //         .bodyMedium1
        //         .copyWith(
        //           fontWeight: FontWeight.w600,
        //           color: AppColors.black,
        //         ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildMasjidSection(
    Masjid masjid,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: AppLocalizations.of(context)!.translate("masjid_info"),
          model: AppTextModel(
            style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                .headingMedium2
                .copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(masjid.photo ?? ""),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: masjid.name ?? "",
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .headingMedium2
                          .copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                    ),
                  ),
                  AppText(
                    text: masjid.email ?? "",
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .bodyMedium1
                          .copyWith(
                            color: AppColors.gray,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (masjid.paymentInfo != null)
          CustomExpansionTile(
            content: PaymentOptionsSection(
              paymentInfo: masjid.paymentInfo!,
            ),
            title: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: AppText(
                text:
                    AppLocalizations.of(context)!.translate("payment_options"),
                model: AppTextModel(
                  style:
                      AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
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
          ),
      ],
    );
  }
}
