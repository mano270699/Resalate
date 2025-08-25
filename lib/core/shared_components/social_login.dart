import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/app_font_style/app_font_style_global.dart';
import '../util/localization/app_localizations.dart';
import 'app_text/app_text.dart';
import 'app_text/models/app_text_model.dart';

class SocialLoginButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final String iconPath;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Social Media Icon
              Image.asset(
                iconPath,
                height: 32,
                width: 32,
              ),
              SizedBox(width: 12.h),
              // Button Label

              AppText(
                text: label,
                model: AppTextModel(
                  style:
                      AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                          .bodyRegular1
                          .copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
