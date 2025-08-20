import 'package:flutter/material.dart';

import 'app_step.dart';
import 'models/app_steper_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSteperList extends StatelessWidget {
  final int length;
  final int activeIndex;
  final AppSteperModel appSteperModel;

  const AppSteperList({
    super.key,
    required this.length,
    required this.activeIndex,
    required this.appSteperModel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2.h,
      child: ListView.builder(
          itemCount: length,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          // shrinkWrap: true,
          itemBuilder: (context, index) {
            if (activeIndex == index) {
              return AppStep(
                isActive: index == activeIndex,
                decoration: appSteperModel.activeDecoration,
                width:
                    (MediaQuery.of(context).size.width - 20.h) / (length + 1),
              );
            } else {
              return AppStep(
                isActive: index == activeIndex,
                decoration: appSteperModel.inactiveDecoration,
                width:
                    (MediaQuery.of(context).size.width - 20.h) / (length + 1),
              );
            }
          }),
    );
  }
}
