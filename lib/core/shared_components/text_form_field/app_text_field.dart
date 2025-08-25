import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/app_colors/app_colors.dart';
import '../../common/app_font_style/app_font_style_global.dart';
import '../../util/localization/app_localizations.dart';
import '../app_text/app_text.dart';
import '../app_text/models/app_text_model.dart';
import 'models/app_text_field_model.dart';

class AppTextField extends StatelessWidget {
  final AppTextFieldModel model;

  const AppTextField({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          model.label != null ? EdgeInsets.only(top: 24.h) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.label != null) ...[
            AppText(
              text: model.label!,
              model: model.appTextModel!,
            ),
            SizedBox(
              height: 8.h,
            ),
          ],
          TextFormField(
            controller: model.controller,
            initialValue: model.initialValue,
            inputFormatters: model.inputFormatter,
            obscureText: model.obscureInputText,
            readOnly: model.readOnly,
            onChanged: model.onChangeInput,
            onTap: model.onTap,
            maxLines: model.maxLines,
            keyboardType: model.keyboardType,
            decoration: model.decoration,
            style: model.style,
          ),
          if (model.helperText != null || model.helperTextModel != null)
            SizedBox(
              height: 8.h,
            ),
          if (model.errorText != null) ...[
            if (model.errorText!.isNotEmpty) ...[
              Padding(
                padding: EdgeInsetsDirectional.only(start: 15.w, top: 5),
                child: AppText(
                  text: model.errorText.toString(),
                  model: AppTextModel(
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .smallTab
                            .copyWith(color: AppColors.error, fontSize: 12.sp),
                  ),
                ),
              ),
            ]
          ] else ...[
            if (model.helperText != null && model.helperText!.isNotEmpty) ...[
              Padding(
                padding: EdgeInsetsDirectional.only(start: 15.w, top: 5),
                child: AppText(
                  text: model.helperText.toString(),
                  model: AppTextModel(
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .smallTab
                            .copyWith(color: AppColors.gray, fontSize: 12.sp),
                  ),
                ),
              ),
            ]
          ]
        ],
      ),
    );
  }
}
