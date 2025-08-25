import 'package:flutter/material.dart';

import '../../common/app_colors/app_colors.dart';
import '../../common/app_font_style/app_font_style_global.dart';
import '../../util/localization/app_localizations.dart';
import '../app_text/app_text.dart';
import '../app_text/models/app_text_model.dart';

showAppSnackBar({
  required BuildContext context,
  required message,
  color = AppColors.primaryColorLight,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 5),
      backgroundColor: color,
      content: AppText(
        text: message,
        model: AppTextModel(
          style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
              .subTitle2
              .copyWith(color: AppColors.white),
        ),
      ),
    ),
  );
}
