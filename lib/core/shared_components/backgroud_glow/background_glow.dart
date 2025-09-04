import 'models/background_glow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackGroundGlow extends StatelessWidget {
  final BackGroundGlowModel? model;
  const BackGroundGlow({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        width: model?.width ?? 265.39.w,
        height: model?.height ?? 265.39.w,
        decoration: model?.decoration ??
            const BoxDecoration(
              shape: BoxShape.circle,
              backgroundBlendMode: BlendMode.screen,
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Color(0x4F4096D8),
                  blurRadius: 70,
                  offset: Offset(0, 10),
                ),
                BoxShadow(
                  color: Color(0x4F5934D7),
                  blurRadius: 70,
                  offset: Offset(0, 10),
                ),
                BoxShadow(
                  color: Color(0x4FA92787),
                  blurRadius: 70,
                  offset: Offset(0, 10),
                ),
              ],
            ),
      ),
    );
  }
}
