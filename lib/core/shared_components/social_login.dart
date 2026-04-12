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
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            minimumSize: Size(0, 52.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                height: 24,
                width: 24,
              ),
              SizedBox(width: 12.w),
              Flexible(
                child: AppText(
                  text: label,
                  model: AppTextModel(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .bodyRegular1
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize: 16.sp,
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
