import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_component_style/app_componet_style.dart';
import '../../../../core/shared_components/app_bottom_sheet/app_bottom_sheet.dart';

class ImagePickerBottomSheet {
  static Future<void> addAssetImage(
    BuildContext context, {
    void Function()? onTapCamera,
    void Function()? onTapGallery,
  }) async {
    await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (bottomSheetContext) {
        return AppBottomSheet(
          model: AppComponentStyle.getAppBottomSheetModel().copyWith(
            imageFilter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            uperContanerDecoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text("Camera"),
                  onTap: onTapCamera,
                ),
                Divider(color: Colors.grey.withValues(alpha: 0.3), height: 0),
                ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: const Text("Gallery"),
                  onTap: onTapGallery,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
