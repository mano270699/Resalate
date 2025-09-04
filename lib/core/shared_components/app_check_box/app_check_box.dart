import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/app_colors/app_colors.dart';
import '../gradiant_icon.dart';
import 'models/app_check_box_model.dart';

class AppCheckBox extends StatelessWidget {
  final AppCheckBoxModel appCheckBoxModel;
  const AppCheckBox({super.key, required this.appCheckBoxModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            appCheckBoxModel.onChanged();
          },
          child: Card(
            elevation: 5,
            child: Container(
              width: 20.w,
              height: 20.h,
              decoration: appCheckBoxModel.decoration,
              child: appCheckBoxModel.isChecked
                  ? GradientIcon(
                      icon: Icons.check,
                      size: 18.sp,
                      gradient: AppColors.checkBoxGradient,
                    )
                  : null,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: appCheckBoxModel.text,
                style: appCheckBoxModel.textModel,
              ),
              TextSpan(
                text: appCheckBoxModel.buttonText,
                style: appCheckBoxModel.buttonModel,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    appCheckBoxModel.onPressedTermsAndConditions();
                  },
              ),
            ],
          ),
        )
        // AppText(
        //   text: appCheckBoxModel.text,
        //   model: AppTextModel(
        //     style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
        //         .bodyMedium2
        //         .copyWith(color: DarkColors.primaryColorLight),
        //   ),
        // ),
        // AppButton(
        //   onPressed: () {
        //     appCheckBoxModel.onPressedTermsAndConditions();
        //   },
        //   model: appCheckBoxModel.buttonModel,
        // ),
      ],
    );
  }
}
