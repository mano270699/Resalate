import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../app_text/models/app_text_model.dart';

class AppPinCodeModel {
  Function(String) onCompleted;
  Function(String)? onChanged;
  bool enableActiveFill;
  bool enablePinAutofill;
  double errorTextSpace;
  int length;
  bool obscureText;
  Color pinCodeSelectedFillColor;
  GlobalKey<FormState> key;
  Color pinCodeActiveFillColor;
  Color pinCodeInActiveFillColor;
  double boxHeight;
  double boxWidth;
  double borderRadius;
  TextStyle textStyle;
  StreamController<ErrorAnimationType>? errorController;
  PinCodeFieldShape shape;
  List<BoxShadow>? activeBoxShadow;
  List<BoxShadow>? inActiveBoxShadow;
  Duration animationDuration;
  TextInputType keyboardType;
  TextEditingController? controller;
  FocusNode? focusNode;
  final String label;
  final String? errorText;
  final AppTextModel errorDetailsTextModel;
  Color? errorBorderColor;
  Color? selectedColor;
  Color? inactiveColor;
  Color? activeColor;
  Color? cursorColor;
  AppPinCodeModel({
    required this.controller,
    required this.boxHeight,
    required this.borderRadius,
    required this.boxWidth,
    required this.length,
    required this.onCompleted,
    required this.obscureText,
    required this.key,
    required this.pinCodeActiveFillColor,
    required this.pinCodeInActiveFillColor,
    required this.pinCodeSelectedFillColor,
    required this.errorController,
    required this.textStyle,
    this.label = '',
    this.onChanged,
    this.enableActiveFill = true,
    this.enablePinAutofill = true,
    this.errorTextSpace = 25,
    this.shape = PinCodeFieldShape.box,
    this.activeBoxShadow,
    this.inActiveBoxShadow,
    this.animationDuration = const Duration(milliseconds: 300),
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.focusNode,
    required this.errorDetailsTextModel,
    this.activeColor,
    this.errorBorderColor,
    this.inactiveColor,
    this.selectedColor,
    this.cursorColor,
  });
}
