import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_text/models/app_text_model.dart';

class AppTextFieldModel {
  final void Function(String)? onChangeInput;

  String? Function(String?)? validator;

  final String? initialValue;
  final String? label;
  final int? maxLines;
  final int minLines;
  final bool readOnly;
  final TextInputType keyboardType;
  final bool obscureInputText;
  final InputDecoration decoration;
  final Widget? suffixIcon;
  final AppTextModel? appTextModel;
  final TextStyle? style;
  List<TextInputFormatter> inputFormatter;
  final AppTextModel? helperTextModel;
  final String? helperText;
  final void Function()? onTap;
  final void Function(String value)? onFieldSubmitted;

  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final BorderRadiusGeometry? borderRadius;
  final String? errorText;

  AppTextFieldModel({
    this.onFieldSubmitted,
    required this.keyboardType,
    this.maxLines,
    this.minLines = 1,
    this.obscureInputText = false,
    this.onChangeInput,
    this.readOnly = false,
    required this.decoration,
    this.suffixIcon,
    this.appTextModel,
    this.style,
    this.helperTextModel,
    this.helperText,
    this.inputFormatter = const [],
    this.initialValue,
    this.onTap,
    this.controller,
    this.textInputAction,
    this.label,
    this.borderRadius,
    this.validator,
    this.errorText,
  });
}
