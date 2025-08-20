import 'package:flutter/material.dart';

class AppTextModel {
  final TextStyle style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;
  final double? height;

  final TextDirection textDirection;
  final bool softWrap;

  final TextHeightBehavior? textHeightBehavior;

  AppTextModel({
    required this.style,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.clip,
    this.maxLines,
    this.height,
    this.textDirection = TextDirection.ltr,
    this.softWrap = true,
    this.textHeightBehavior,
  });
}
