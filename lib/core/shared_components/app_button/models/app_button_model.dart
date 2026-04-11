import 'package:flutter/material.dart';

class AppButtonModel {
  ButtonStyle? buttonStyle;
  EdgeInsets? padding;
  Widget child;
  Decoration? decoration;
  OutlinedBorder? shape;
  double? width;
  AppButtonModel({
    this.buttonStyle,
    required this.child,
    this.padding,
    this.decoration,
    this.shape,
    this.width = double.infinity,
  });
}
