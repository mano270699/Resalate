import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          if (model.helperText != null &&
              model.helperTextModel != null &&
              model.decoration.errorText == null)
            AppText(
              text: model.helperText.toString(),
              model: model.helperTextModel ??
                  AppTextModel(
                    style: const TextStyle(),
                  ),
            ),
        ],
      ),
    );
  }
}
