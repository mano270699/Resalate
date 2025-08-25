import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../app_text/app_text.dart';
import 'models/app_pin_code_model.dart';

class AppPinCodeTextField extends StatelessWidget {
  final AppPinCodeModel model;
  const AppPinCodeTextField({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: model.key,
          child: PinCodeTextField(
            cursorColor: model.cursorColor,
            autoDisposeControllers: false,
            obscuringCharacter: "-",
            focusNode: model.focusNode,
            controller: model.controller,
            enablePinAutofill: model.enablePinAutofill,
            enableActiveFill: model.enableActiveFill,
            useExternalAutoFillGroup: true,
            onAutoFillDisposeAction: AutofillContextAction.commit,
            length: model.length,
            obscureText: model.obscureText,
            animationType: AnimationType.fade,
            errorTextSpace: model.errorTextSpace,
            textStyle: model.textStyle,
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            // ],
            pinTheme: PinTheme(
              activeColor: model.activeColor,
              inactiveColor: model.inactiveColor,
              selectedColor: model.selectedColor,
              errorBorderColor: model.errorBorderColor,
              selectedFillColor: model.pinCodeSelectedFillColor,
              activeFillColor: model.pinCodeInActiveFillColor,
              inactiveFillColor: model.pinCodeInActiveFillColor,
              shape: model.shape,
              borderRadius: BorderRadius.circular(model.borderRadius),
              fieldHeight: model.boxHeight,
              fieldWidth: model.boxWidth,
              activeBoxShadow: model.activeBoxShadow,
              inActiveBoxShadow: model.inActiveBoxShadow,
            ),
            animationDuration: model.animationDuration,
            keyboardType: model.keyboardType,
            appContext: context,
            errorAnimationController: model.errorController,
            onCompleted: model.onCompleted,
            onChanged: model.onChanged,
          ),
        ),
        if (model.errorText != null) ...[
          SizedBox(
            height: 8.h,
          ),
          AppText(
            text: model.errorText.toString(),
            model: model.errorDetailsTextModel,
          )
        ],
      ],
    );
  }
}
