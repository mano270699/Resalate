import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/shared_components/app_text/app_text.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/common/assets.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import 'widgets/avatar_custom_paint.dart';
import 'widgets/background_custom_paint.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: WaveBackgroundPainter(),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 120.h,
                ),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CustomPaint(
                        size: const Size(120, 120),
                        painter: AvatarBorderPainter(),
                      ),
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/150'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                const Text(
                  'John Doe',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.h),
                const Text(
                  'John@gmail.com',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.facebookImage,
                      height: 40,
                      width: 40,
                    ),
                    5.w.horizontalSpace,
                    Image.asset(
                      Assets.instaImage,
                      height: 35,
                      width: 35,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: <Widget>[
                      10.h.verticalSpace,
                      Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: "Edit Profile",
                                model: AppTextModel(
                                    style: AppFontStyleGlobal(
                                            AppLocalizations.of(context)!
                                                .locale)
                                        .bodyLight1
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        )),
                              ),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                color: AppColors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                      10.h.verticalSpace,
                      Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: "Sponsor Form",
                                model: AppTextModel(
                                    style: AppFontStyleGlobal(
                                            AppLocalizations.of(context)!
                                                .locale)
                                        .bodyLight1
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        )),
                              ),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                color: AppColors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                      10.h.verticalSpace,
                      Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: "Common Questions",
                                model: AppTextModel(
                                    style: AppFontStyleGlobal(
                                            AppLocalizations.of(context)!
                                                .locale)
                                        .bodyLight1
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        )),
                              ),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                color: AppColors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                      10.h.verticalSpace,
                      Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: "About Resalty",
                                model: AppTextModel(
                                    style: AppFontStyleGlobal(
                                            AppLocalizations.of(context)!
                                                .locale)
                                        .bodyLight1
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        )),
                              ),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                color: AppColors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                      10.h.verticalSpace,
                      Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: " Privcy Policy",
                                model: AppTextModel(
                                    style: AppFontStyleGlobal(
                                            AppLocalizations.of(context)!
                                                .locale)
                                        .bodyLight1
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        )),
                              ),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                color: AppColors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                      10.h.verticalSpace,
                      Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: "Terms & Conditions",
                                model: AppTextModel(
                                    style: AppFontStyleGlobal(
                                            AppLocalizations.of(context)!
                                                .locale)
                                        .bodyLight1
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        )),
                              ),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                color: AppColors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                      10.h.verticalSpace,
                      Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: "Logout",
                                model: AppTextModel(
                                    style: AppFontStyleGlobal(
                                            AppLocalizations.of(context)!
                                                .locale)
                                        .bodyLight1
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.error,
                                        )),
                              ),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                color: AppColors.error,
                              )
                            ],
                          ),
                        ),
                      ),
                      10.h.verticalSpace,
                      Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: "Delete Account",
                                model: AppTextModel(
                                    style: AppFontStyleGlobal(
                                            AppLocalizations.of(context)!
                                                .locale)
                                        .bodyLight1
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.error,
                                        )),
                              ),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                color: AppColors.error,
                              )
                            ],
                          ),
                        ),
                      ),
                      20.h.verticalSpace,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
