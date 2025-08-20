import 'dart:ui';

import 'package:flutter/material.dart';

class AppBottomSheetModel {
  final BoxDecoration uperContanerDecoration;
  final BoxDecoration belowContanerDecoration;
  final Widget child;
  final ImageFilter imageFilter;
  final BoxDecoration deviderDecoration;

  AppBottomSheetModel({
    required this.uperContanerDecoration,
    required this.belowContanerDecoration,
    required this.child,
    required this.imageFilter,
    required this.deviderDecoration,
  });

  AppBottomSheetModel copyWith({
    BoxDecoration? uperContanerDecoration,
    BoxDecoration? belowContanerDecoration,
    Widget? child,
    ImageFilter? imageFilter,
    BoxDecoration? deviderDecoration,
  }) {
    return AppBottomSheetModel(
      uperContanerDecoration:
          uperContanerDecoration ?? this.uperContanerDecoration,
      belowContanerDecoration:
          belowContanerDecoration ?? this.belowContanerDecoration,
      child: child ?? this.child,
      imageFilter: imageFilter ?? this.imageFilter,
      deviderDecoration: deviderDecoration ?? this.deviderDecoration,
    );
  }
}
