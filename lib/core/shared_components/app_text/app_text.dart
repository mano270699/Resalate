import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'models/app_text_model.dart';

class AppText extends StatelessWidget {
  final String text;
  final AppTextModel model;
  const AppText({
    super.key,
    required this.text,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: model.style,
      textAlign: model.textAlign,
      overflow: model.overflow,
      maxLines: model.maxLines,
      textDirection: model.textDirection,
      softWrap: model.softWrap,
      // textHeightBehavior: model.textHeightBehavior,
    );
  }
}
