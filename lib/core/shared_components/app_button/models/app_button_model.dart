import 'package:flutter/material.dart';

class AppButtonModel {
  ButtonStyle? buttonStyle;
  EdgeInsets? padding;
  Widget child;
  Decoration? decoration;
  OutlinedBorder? shape;
  AppButtonModel({
    this.buttonStyle,
    required this.child,
    this.padding,
    this.decoration,
    this.shape,
  });
}
