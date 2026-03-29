import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/common/app_colors/app_colors.dart';
import 'package:resalate/core/common/app_font_style/app_font_style_global.dart';
import 'package:resalate/core/shared_components/app_text/app_text.dart';
import 'package:resalate/core/shared_components/app_text/models/app_text_model.dart';

import '../../../../core/util/localization/app_localizations.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final Color confirmColor;
  final VoidCallback onConfirm;
  final IconData? icon;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.confirmColor,
    required this.onConfirm,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!.locale;
    final textDir = locale.languageCode == 'en' || locale.languageCode == 'sv'
        ? TextDirection.ltr
        : TextDirection.rtl;

    // Determine the icon to show based on context
    final displayIcon = icon ??
        (confirmColor == Colors.red || confirmColor == AppColors.error
            ? Icons.warning_amber_rounded
            : Icons.logout_rounded);

    return Directionality(
      textDirection: textDir,
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        elevation: 8,
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon circle
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: confirmColor.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Icon(
                    displayIcon,
                    color: confirmColor,
                    size: 36.sp,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              AppText(
                text: title,
                model: AppTextModel(
                  textAlign: TextAlign.center,
                  style: AppFontStyleGlobal(locale).headingMedium2.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                ),
              ),
              SizedBox(height: 10.h),

              // Message
              AppText(
                text: message,
                model: AppTextModel(
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  style: AppFontStyleGlobal(locale).subTitle2.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                ),
              ),
              SizedBox(height: 28.h),

              // Buttons
              Row(
                children: [
                  // Cancel button
                  SizedBox(
                    height: 48.h,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: AppText(
                        text: AppLocalizations.of(context)!.translate("cancel"),
                        model: AppTextModel(
                          style: AppFontStyleGlobal(locale).subTitle1.copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  // Confirm button
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: confirmColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // close dialog
                          onConfirm(); // callback
                        },
                        child: AppText(
                          text: confirmText,
                          model: AppTextModel(
                            style:
                                AppFontStyleGlobal(locale).subTitle1.copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
