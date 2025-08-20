import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/shared_components/app_text/app_text.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/common/assets.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';

class PartenerSection extends StatelessWidget {
  const PartenerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 150.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff008673),
                  Color(0xff04536e),
                ])),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text("Partener Organization",),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: "Partener Organization",
                    model: AppTextModel(
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .bodyMedium1
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            )),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: 200,
                    child: AppText(
                      text:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                      model: AppTextModel(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyleGlobal(
                                  AppLocalizations.of(context)!.locale)
                              .bodyLight1
                              .copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.white,
                              )),
                    ),
                  ),
                ],
              ),

              Stack(
                alignment: Alignment.center,
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 0),
                    child: Image.asset(
                      Assets.partenerImage,
                      height: 120.h,
                      width: 120.w,
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        height: 40.h,
                        child: Center(
                          child: AppText(
                            text: "learn more",
                            model: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .subTitle2
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryColor,
                                    )),
                          ),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
