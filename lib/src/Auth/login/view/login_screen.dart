import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_component_style/component_style.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/common/app_icon_svg.dart';
import '../../../../core/shared_components/app_button/app_button.dart';
import '../../../../core/shared_components/app_button/models/app_button_model.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/shared_components/text_form_field/app_text_field.dart';
import '../../../../core/shared_components/text_form_field/models/app_text_field_model.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../../layout/screens/user_bottom_navigation_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = 'Login Screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SvgPicture.asset(
                AppLocalizations.of(context)!.locale.languageCode == "en"
                    ? AppIconSvg.splashLogo
                    : AppIconSvg.splashLogoAr,
                height: 200.h,
              ),
            ),
            // 10.h.verticalSpace,
            // AppText(
            //   text: "Resalty",
            //   model: AppTextModel(
            //       style:
            //           AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
            //               .heading1
            //               .copyWith(
            //                 color: AppColors.lightBlack,
            //               )),
            // ),

            20.h.verticalSpace,
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: AppTextField(
                model: AppTextFieldModel(
                  appTextModel: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .bodyRegular1
                          .copyWith(
                            color: AppColors.primaryColor,
                          )),
                  controller: TextEditingController(),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,

                  onChangeInput: (value) {
                    if (value.length <= 1) {
                      setState(() {});
                    }
                  },
                  // label: "Search..",
                  borderRadius: BorderRadius.circular(12.r),
                  decoration: ComponentStyle.inputDecoration(const Locale("en")
                          // AppLocalizations.of(context)!.locale,
                          )
                      .copyWith(
                    fillColor: AppColors.white,
                    contentPadding: EdgeInsetsDirectional.only(start: 10.w),
                    filled: true,

                    //   floatingLabelBehavior: viewModel.password.text.isEmpty
                    //       ? FloatingLabelBehavior.never
                    //       : FloatingLabelBehavior.always,
                    // labelText: "Search..",
                    //  viewModel.password.text.isEmpty
                    //     ? null
                    //     :
                    // AppLocalizations.of(context)!.translate('password'),
                    hintText:
                        AppLocalizations.of(context)!.translate('user_name'),
                  ),
                  errorText: "",

                  // validation.data.isNotEmpty
                  //     ? AppLocalizations.of(context)!.translate(validation.data)
                  //     : null,
                ),
              ),
            ),
            20.h.verticalSpace,
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: AppTextField(
                model: AppTextFieldModel(
                  appTextModel: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .bodyRegular1
                          .copyWith(
                            color: AppColors.primaryColor,
                          )),
                  controller: TextEditingController(),
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,

                  onChangeInput: (value) {
                    if (value.length <= 1) {
                      setState(() {});
                    }
                  },
                  // label: "Search..",
                  borderRadius: BorderRadius.circular(12.r),
                  decoration: ComponentStyle.inputDecoration(const Locale("en")
                          // AppLocalizations.of(context)!.locale,
                          )
                      .copyWith(
                    fillColor: AppColors.white,
                    contentPadding: EdgeInsetsDirectional.only(start: 10.w),
                    filled: true,

                    //   floatingLabelBehavior: viewModel.password.text.isEmpty
                    //       ? FloatingLabelBehavior.never
                    //       : FloatingLabelBehavior.always,
                    // labelText: "Search..",
                    //  viewModel.password.text.isEmpty
                    //     ? null
                    //     :
                    // AppLocalizations.of(context)!.translate('password'),
                    hintText:
                        AppLocalizations.of(context)!.translate('password'),
                  ),
                  errorText: "",

                  // validation.data.isNotEmpty
                  //     ? AppLocalizations.of(context)!.translate(validation.data)
                  //     : null,
                ),
              ),
            ),
            20.h.verticalSpace,
            AppText(
              text: "Forget Password?",
              model: AppTextModel(
                  style:
                      AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                          .bodyMedium1
                          .copyWith(
                            color: AppColors.lightBlack,
                          )),
            ),

            20.h.verticalSpace,
            // SizedBox(
            //   height: 24,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       AppText(
            //         text: AppLocalizations.of(context)!
            //             .translate('do_not_have_account'),
            //         model: AppTextModel(
            //           style: AppFontStyleGlobal(
            //                   AppLocalizations.of(context)!.locale)
            //               .bodyRegular1
            //               .copyWith(
            //                 color: AppColors.hint,
            //               ),
            //         ),
            //       ),
            //       SizedBox(width: 5.w),
            //       InkWell(
            //         onTap: () => Navigator.pushNamed(
            //           context,
            //           SignupScreen.routeName,
            //         ),
            //         child: AppText(
            //           text: AppLocalizations.of(context)!
            //               .translate('register_now'),
            //           model: AppTextModel(
            //             style: AppFontStyleGlobal(
            //                     AppLocalizations.of(context)!.locale)
            //                 .bodyRegular1
            //                 .copyWith(
            //                   color: AppColors.primaryColor,
            //                 ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            Padding(
              padding: EdgeInsetsDirectional.only(
                  bottom: 14, start: 16.w, end: 16.w),
              child: AppButton(
                model: AppButtonModel(
                  child: AppText(
                    text: AppLocalizations.of(context)!.translate('login'),
                    model: AppTextModel(
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .label
                            .copyWith(color: AppColors.white)),
                  ),
                  decoration: ComponentStyle.buttonDecoration,
                  buttonStyle: ComponentStyle.buttonStyle,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    MainBottomNavigationScreen.routeName,
                  );
                },
                // onPressed: () => viewModel.login(context: context),
              ),
            ),

            10.h.verticalSpace,
            SizedBox(
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: AppLocalizations.of(context)!
                        .translate('do_not_have_account'),
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .bodyRegular1
                          .copyWith(
                            color: AppColors.gray,
                          ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      RegesterScreen.routeName,
                    ),
                    child: AppText(
                      text: AppLocalizations.of(context)!
                          .translate('register_now'),
                      model: AppTextModel(
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .bodyRegular1
                            .copyWith(
                              color: AppColors.primaryColor,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
