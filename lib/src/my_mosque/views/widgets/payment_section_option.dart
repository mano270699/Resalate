import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/common/app_colors/app_colors.dart';
import 'package:resalate/core/util/localization/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/masjed_details_model.dart';

class PaymentOptionsSection extends StatelessWidget {
  final PaymentInfo paymentInfo;

  const PaymentOptionsSection({super.key, required this.paymentInfo});

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        backgroundColor: AppColors.scondaryColor,
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              "${AppLocalizations.of(context)!.translate("Copied")} $text",
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paypalUser = paymentInfo.paypalUser ?? "";
    final switchInfo = paymentInfo.switchData;
    final bankInfo = paymentInfo.bankAccount;

    final sections = <Widget>[];

    // PayPal Section
    if (paypalUser.isNotEmpty) {
      sections.add(
        _PaymentCard(
          icon: Icons.account_balance_wallet_rounded,
          iconColor: const Color(0xFF003087),
          title: AppLocalizations.of(context)!.translate("paypal"),
          children: [
            _InfoRow(
              icon: Icons.person_outline_rounded,
              label: AppLocalizations.of(context)!.translate("user"),
              value: paypalUser,
              onCopy: () => _copyToClipboard(context, paypalUser),
            ),
          ],
        ),
      );
    }

    // Switch Section
    if (switchInfo != null) {
      sections.add(
        _PaymentCard(
          icon: Icons.swap_horiz_rounded,
          iconColor: AppColors.primaryColor,
          title: AppLocalizations.of(context)!.translate("switch"),
          children: [
            if ((switchInfo.number ?? "").isNotEmpty)
              _InfoRow(
                icon: Icons.tag_rounded,
                label: AppLocalizations.of(context)!.translate("switch_number"),
                value: switchInfo.number!,
                onCopy: () => _copyToClipboard(context, switchInfo.number!),
              ),
            if (switchInfo.url != null && switchInfo.url!.isNotEmpty)
              _LinkRow(
                icon: Icons.link_rounded,
                label: AppLocalizations.of(context)!.translate("link"),
                url: switchInfo.url!,
                onTap: () => _launchUrl(switchInfo.url!),
                onCopy: () => _copyToClipboard(context, switchInfo.url!),
              ),
            if (switchInfo.qrCode?.url != null &&
                switchInfo.qrCode!.url!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        switchInfo.qrCode!.url!,
                        width: 200.w,
                        height: 200.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => SizedBox(
                          width: 140.w,
                          height: 140.w,
                          child: Icon(
                            Icons.qr_code_rounded,
                            size: 60.sp,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Bank Account Section
    if (bankInfo != null) {
      sections.add(
        _PaymentCard(
          icon: Icons.account_balance_rounded,
          iconColor: AppColors.scondaryColor,
          title: AppLocalizations.of(context)!.translate("bank_account"),
          children: [
            if ((bankInfo.name ?? "").isNotEmpty)
              _InfoRow(
                icon: Icons.person_outline_rounded,
                label: AppLocalizations.of(context)!.translate("Name"),
                value: bankInfo.name!,
                onCopy: () => _copyToClipboard(context, bankInfo.name!),
              ),
            if ((bankInfo.accountNumber ?? "").isNotEmpty)
              _InfoRow(
                icon: Icons.confirmation_number_outlined,
                label: AppLocalizations.of(context)!.translate("Account_No"),
                value: bankInfo.accountNumber!,
                onCopy: () =>
                    _copyToClipboard(context, bankInfo.accountNumber!),
              ),
            if ((bankInfo.iban ?? "").isNotEmpty)
              _InfoRow(
                icon: Icons.credit_card_rounded,
                label: AppLocalizations.of(context)!.translate("IBAN"),
                value: bankInfo.iban!,
                onCopy: () => _copyToClipboard(context, bankInfo.iban!),
              ),
            if ((bankInfo.swiftCode ?? "").isNotEmpty)
              _InfoRow(
                icon: Icons.sync_alt_rounded,
                label: AppLocalizations.of(context)!.translate("Swift_Code"),
                value: bankInfo.swiftCode!,
                onCopy: () => _copyToClipboard(context, bankInfo.swiftCode!),
              ),
          ],
        ),
      );
    }

    if (sections.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < sections.length; i++) ...[
          sections[i],
          if (i < sections.length - 1) SizedBox(height: 12.h),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Payment Card
// ---------------------------------------------------------------------------
class _PaymentCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<Widget> children;

  const _PaymentCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                topRight: Radius.circular(14.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, color: iconColor, size: 18.sp),
                ),
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.scondaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Content rows
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1 && children[i] is _InfoRow ||
                      children[i] is _LinkRow)
                    Divider(
                      height: 16.h,
                      thickness: 0.5,
                      color: Colors.grey.shade200,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info Row (label + value + copy)
// ---------------------------------------------------------------------------
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onCopy;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightBlack,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onCopy,
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.copy_rounded,
                  size: 16.sp,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Link Row (clickable URL + copy)
// ---------------------------------------------------------------------------
class _LinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  final VoidCallback onTap;
  final VoidCallback onCopy;

  const _LinkRow({
    required this.icon,
    required this.label,
    required this.url,
    required this.onTap,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    url,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onCopy,
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.copy_rounded,
                  size: 16.sp,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
