import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'models/app_bottom_sheet_model.dart';

class AppBottomSheet extends StatelessWidget {
  final AppBottomSheetModel model;
  const AppBottomSheet({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: model.imageFilter,
      child: Container(
        decoration: model.uperContanerDecoration,
        child: Container(
          decoration: model.belowContanerDecoration,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 4.h,
                    width: 67.w,
                    margin: const EdgeInsets.only(top: 8.0),
                    decoration: model.deviderDecoration,
                  ),
                  model.child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
