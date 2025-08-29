// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/core/common/app_icon_svg.dart';
import 'package:resalate/src/donation/logic/donations_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/base/dependency_injection.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/common/assets.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../my_mosque/views/widgets/custom_expantion_tile.dart';
import '../data/models/donation_details_model.dart';

class DonationDetailsScreen extends StatefulWidget {
  static const String routeName = 'DonationDetailsScreen';

  const DonationDetailsScreen({
    super.key,
    required this.donationId,
    required this.donationName,
  });
  final int donationId;
  final String donationName;

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
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: widget.donationName,
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
                  text: "No donation details found",
                  model: AppTextModel(
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
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

                  /// Date
                  AppText(
                    text: "📅 ${data?.date ?? ''}",
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .bodyMedium1
                          .copyWith(
                            color: AppColors.gray,
                          ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Content
                  AppText(
                    text:
                        data?.content?.replaceAll(RegExp(r"<[^>]*>"), "") ?? "",
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
          text: "Donation Progress",
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
        LinearProgressIndicator(
          value: progress,
          minHeight: 10,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.grey[300],
          valueColor:
              const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        ),
        const SizedBox(height: 8),
        AppText(
          text:
              "${donation.paid}/${donation.total} ${donation.currency} (${donation.percent}%)",
          model: AppTextModel(
            style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                .bodyMedium1
                .copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
          ),
        ),
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
          text: "Masjid Info",
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
            content: _buildPaymentInfo(masjid.paymentInfo!),
            title: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: AppText(
                text: "Payment Options",
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

  Widget _buildPaymentInfo(
    PaymentInfo info,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AppText(
        //   text: "Payment Options",
        //   model: AppTextModel(
        //     style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
        //         .headingMedium2
        //         .copyWith(
        //           fontSize: 16,
        //           fontWeight: FontWeight.bold,
        //           color: AppColors.black,
        //         ),
        //   ),
        // ),
        // const SizedBox(height: 12),

        /// Paypal
        if ((info.paypalUser ?? "").isNotEmpty)
          ListTile(
            leading:
                SvgPicture.asset(height: 20.h, width: 20.w, AppIconSvg.paypal),
            title: AppText(
              text: "Paypal: ${info.paypalUser}",
              model: AppTextModel(
                style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                    .bodyMedium1
                    .copyWith(
                      color: AppColors.black,
                    ),
              ),
            ),
          ),

        /// Switch
        if (info.switchPayment != null) ...[
          ListTile(
              leading: const Icon(Icons.payment,
                  color: Color.fromARGB(255, 2, 104, 188)),
              title: AppText(
                text: "Switch Number: ${info.switchPayment?.number ?? ''}",
                model: AppTextModel(
                  style:
                      AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                          .bodyMedium1
                          .copyWith(
                            color: AppColors.black,
                          ),
                ),
              ),
              subtitle: _buildContent(info.switchPayment?.url ?? "")
              // AppText(
              //   text: info.switchPayment?.url ?? "",
              //   model: AppTextModel(
              //     style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
              //         .bodyMedium1
              //         .copyWith(
              //           color: AppColors.gray,
              //         ),
              //   ),
              // ),
              ),
          if (info.switchPayment?.qrCode?.url != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Image.network(
                info.switchPayment!.qrCode!.url!,
                height: 150,
              ),
            ),
        ],

        /// Bank Account
        if (info.bankAccount != null)
          Card(
            margin: const EdgeInsets.only(top: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        Assets.bank,
                        height: 25.h,
                        width: 25.w,
                      ),
                      5.w.horizontalSpace,
                      AppText(
                        text: "Bank Account",
                        model: AppTextModel(
                          style: AppFontStyleGlobal(
                                  AppLocalizations.of(context)!.locale)
                              .headingMedium2
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    text: "Name: ${info.bankAccount?.name ?? ''}j",
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .bodyMedium1,
                    ),
                  ),
                  AppText(
                    text:
                        "Account No: ${info.bankAccount?.accountNumber ?? ''}",
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .bodyMedium1,
                    ),
                  ),
                  AppText(
                    text: "IBAN: ${info.bankAccount?.iban ?? ''}",
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .bodyMedium1,
                    ),
                  ),
                  AppText(
                    text: "Swift Code: ${info.bankAccount?.swiftCode ?? ''}",
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .bodyMedium1,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(String? content) {
    final cleanText = content?.replaceAll(RegExp(r"<[^>]*>"), "") ?? "";

    return Linkify(
      text: cleanText,
      // style: const TextStyle(fontSize: 16, color: Colors.black87),
      // linkStyle: const TextStyle(
      //     color: Colors.blue, decoration: TextDecoration.underline),
      onOpen: (link) async {
        final uri = Uri.parse(link.url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    );
  }
}
