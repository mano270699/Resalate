import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/base/dependency_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_component_style/component_style.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/common/app_icon_svg.dart';
import '../../../core/shared_components/app_button/app_button.dart';
import '../../../core/shared_components/app_button/models/app_button_model.dart';
import '../../../core/shared_components/app_snack_bar/app_snack_bar.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/shared_components/text_form_field/app_text_field.dart';
import '../../../core/shared_components/text_form_field/models/app_text_field_model.dart';
import '../../../core/util/loading.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../layout/screens/user_bottom_navigation_screen.dart';
import '../data/models/register_model.dart';
import '../logic/auth_view_model.dart';
import 'login_screen.dart';

class RegesterScreen extends StatefulWidget {
  const RegesterScreen({super.key});
  static const String routeName = 'Regester Screen';

  @override
  State<RegesterScreen> createState() => _RegesterScreenState();
}

class _RegesterScreenState extends State<RegesterScreen> {
  var viewModel = sl<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<GenericCubit<RegisterModel>,
          GenericCubitState<RegisterModel>>(
        bloc: viewModel.registerResponse,
        listener: (context, state) {
          if (state is GenericLoadingState) {
            LoadingScreen.show(context);
          } else if (state is GenericUpdatedState) {
            // Navigator.of(context, rootNavigator: false).pop();
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainBottomNavigationScreen.routeName,
              arguments: {"index": 0},
              (route) => false,
            );
            showAppSnackBar(
              context: context,
              message: state.data.message,
              color: AppColors.success,
            );
          } else {
            Navigator.pop(context);
            if (state is GenericErrorState) {
              showAppSnackBar(
                context: context,
                message: state.responseError!.errorMessage,
                color: AppColors.error,
              );
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
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

                20.h.verticalSpace,
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: BlocBuilder<GenericCubit<String>,
                          GenericCubitState<String>>(
                      bloc: viewModel.nameValidation,
                      builder: (context, validation) {
                        return AppTextField(
                          model: AppTextFieldModel(
                            appTextModel: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .bodyRegular1
                                    .copyWith(
                                      color: AppColors.primaryColor,
                                    )),
                            controller: viewModel.name,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,

                            onChangeInput: (value) {},
                            // label: "Search..",
                            borderRadius: BorderRadius.circular(12.r),
                            decoration: ComponentStyle.inputDecoration(
                              AppLocalizations.of(context)!.locale,
                            ).copyWith(
                              fillColor: AppColors.white,
                              contentPadding:
                                  EdgeInsetsDirectional.only(start: 10.w),
                              filled: true,
                              hintText: AppLocalizations.of(context)!
                                  .translate('name'),
                            ),
                            errorText: validation.data.isNotEmpty
                                ? AppLocalizations.of(context)!
                                    .translate(validation.data)
                                : null,
                          ),
                        );
                      }),
                ),
                20.h.verticalSpace,

                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: BlocBuilder<GenericCubit<String>,
                          GenericCubitState<String>>(
                      bloc: viewModel.emailValidation,
                      builder: (context, validation) {
                        return AppTextField(
                          model: AppTextFieldModel(
                            appTextModel: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .bodyRegular1
                                    .copyWith(
                                      color: AppColors.primaryColor,
                                    )),
                            controller: viewModel.email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            onChangeInput: (value) {},
                            borderRadius: BorderRadius.circular(12.r),
                            decoration: ComponentStyle.inputDecoration(
                              AppLocalizations.of(context)!.locale,
                            ).copyWith(
                              fillColor: AppColors.white,
                              contentPadding:
                                  EdgeInsetsDirectional.only(start: 10.w),
                              filled: true,
                              hintText: AppLocalizations.of(context)!
                                  .translate('email'),
                            ),
                            errorText: validation.data.isNotEmpty
                                ? AppLocalizations.of(context)!
                                    .translate(validation.data)
                                : null,
                          ),
                        );
                      }),
                ),
                20.h.verticalSpace,

                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: BlocBuilder<GenericCubit<String>,
                          GenericCubitState<String>>(
                      bloc: viewModel.phoneNumberValidation,
                      builder: (context, validation) {
                        return AppTextField(
                          model: AppTextFieldModel(
                            appTextModel: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .bodyRegular1
                                    .copyWith(
                                      color: AppColors.primaryColor,
                                    )),
                            controller: viewModel.phone,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            onChangeInput: (value) {},
                            borderRadius: BorderRadius.circular(12.r),
                            decoration: ComponentStyle.inputDecoration(
                              AppLocalizations.of(context)!.locale,
                            ).copyWith(
                              fillColor: AppColors.white,
                              contentPadding:
                                  EdgeInsetsDirectional.only(start: 10.w),
                              filled: true,
                              hintText: AppLocalizations.of(context)!
                                  .translate('phone'),
                            ),
                            errorText: validation.data.isNotEmpty
                                ? AppLocalizations.of(context)!
                                    .translate(validation.data)
                                : null,
                          ),
                        );
                      }),
                ),
                20.h.verticalSpace,

                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: BlocBuilder<GenericCubit<String>,
                          GenericCubitState<String>>(
                      bloc: viewModel.passwordValidation,
                      builder: (context, validation) {
                        return AppTextField(
                          model: AppTextFieldModel(
                            appTextModel: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .bodyRegular1
                                    .copyWith(
                                      color: AppColors.primaryColor,
                                    )),
                            controller: viewModel.password,
                            obscureInputText: true,
                            maxLines: 1,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            onChangeInput: (value) {},
                            borderRadius: BorderRadius.circular(12.r),
                            decoration: ComponentStyle.inputDecoration(
                              AppLocalizations.of(context)!.locale,
                            ).copyWith(
                              fillColor: AppColors.white,
                              contentPadding:
                                  EdgeInsetsDirectional.only(start: 10.w),
                              filled: true,
                              hintText: AppLocalizations.of(context)!
                                  .translate('password'),
                            ),
                            errorText: validation.data.isNotEmpty
                                ? AppLocalizations.of(context)!
                                    .translate(validation.data)
                                : null,
                          ),
                        );
                      }),
                ),

                20.h.verticalSpace,
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: BlocBuilder<GenericCubit<String>,
                          GenericCubitState<String>>(
                      bloc: viewModel.confirmValidation,
                      builder: (context, validation) {
                        return AppTextField(
                          model: AppTextFieldModel(
                            appTextModel: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .bodyRegular1
                                    .copyWith(
                                      color: AppColors.primaryColor,
                                    )),
                            controller: viewModel.confirmPassword,
                            keyboardType: TextInputType.visiblePassword,
                            obscureInputText: true,
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                            onChangeInput: (value) {},
                            borderRadius: BorderRadius.circular(12.r),
                            decoration: ComponentStyle.inputDecoration(
                              AppLocalizations.of(context)!.locale,
                            ).copyWith(
                              fillColor: AppColors.white,
                              contentPadding:
                                  EdgeInsetsDirectional.only(start: 10.w),
                              filled: true,
                              hintText: AppLocalizations.of(context)!
                                  .translate('confirm_password'),
                            ),
                            errorText: validation.data.isNotEmpty
                                ? AppLocalizations.of(context)!
                                    .translate(validation.data)
                                : null,
                          ),
                        );
                      }),
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
                      bottom: 14, start: 8.w, end: 8.w),
                  child: AppButton(
                    model: AppButtonModel(
                      child: AppText(
                        text: AppLocalizations.of(context)!
                            .translate('register_now'),
                        model: AppTextModel(
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .label
                                .copyWith(color: AppColors.white)),
                      ),
                      decoration: ComponentStyle.buttonDecoration,
                      buttonStyle: ComponentStyle.buttonStyle,
                    ),
                    onPressed: () => viewModel.register(context: context),
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
                            .translate('already_have_account'),
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
                          LoginScreen.routeName,
                        ),
                        child: AppText(
                          text:
                              AppLocalizations.of(context)!.translate('login'),
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
        ),
      ),
    );
  }
}
