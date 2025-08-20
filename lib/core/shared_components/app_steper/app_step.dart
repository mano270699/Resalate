import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_text/models/app_text_model.dart';

class AppStep extends StatelessWidget {
  final bool isActive;
  final BoxDecoration decoration;
  final AppTextModel? appTextModel;
  final double width;
  const AppStep({
    Key? key,
    required this.isActive,
    required this.decoration,
    this.appTextModel,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 4.h),
      child: Container(
        width: width,
        decoration: decoration,
      ),
    );
  }
}
