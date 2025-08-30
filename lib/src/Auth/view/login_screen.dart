import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resalate/src/Auth/view/forget_password_screen.dart';

import '../../../core/base/dependency_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_component_style/component_style.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/common/app_icon_svg.dart';
import '../../../core/common/assets.dart';
import '../../../core/shared_components/app_button/app_button.dart';
import '../../../core/shared_components/app_button/models/app_button_model.dart';
import '../../../core/shared_components/app_snack_bar/app_snack_bar.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/shared_components/social_login.dart';
import '../../../core/shared_components/text_form_field/app_text_field.dart';
import '../../../core/shared_components/text_form_field/models/app_text_field_model.dart';
import '../../../core/util/loading.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../layout/screens/user_bottom_navigation_screen.dart';
import '../data/models/login_model.dart';
import '../logic/auth_view_model.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = 'Login Screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var viewModel = sl<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        body: BlocListener<GenericCubit<LoginResponse>,
            GenericCubitState<LoginResponse>>(
          bloc: viewModel.loginResponse,
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
                  25.h.verticalSpace,
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.black,
                        size: 30,
                      )),
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
                        bloc: viewModel.userNameEmailValidation,
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
                              controller: viewModel.userNameEmail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              onChangeInput: (value) {},
                              borderRadius: BorderRadius.circular(12.r),
                              decoration: ComponentStyle.inputDecoration(
                                      AppLocalizations.of(context)!.locale)
                                  .copyWith(
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
                        bloc: viewModel.loginPasswordValidation,
                        builder: (context, validation) {
                          return AppTextField(
                            model: AppTextFieldModel(
                              obscureInputText: true,
                              appTextModel: AppTextModel(
                                  style: AppFontStyleGlobal(
                                          AppLocalizations.of(context)!.locale)
                                      .bodyRegular1
                                      .copyWith(
                                        color: AppColors.primaryColor,
                                      )),
                              controller: viewModel.loginPassword,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              onChangeInput: (value) {},
                              borderRadius: BorderRadius.circular(12.r),
                              maxLines: 1,
                              decoration: ComponentStyle.inputDecoration(
                                      AppLocalizations.of(context)!.locale)
                                  .copyWith(
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ForgetPasswordScreen.routeName,
                      );
                    },
                    child: AppText(
                      text: AppLocalizations.of(context)!
                          .translate("Forget_Password"),
                      model: AppTextModel(
                          style: AppFontStyleGlobal(
                                  AppLocalizations.of(context)!.locale)
                              .bodyMedium1
                              .copyWith(
                                  color: AppColors.scondaryColor,
                                  fontSize: 14.sp)),
                    ),
                  ),
                  20.h.verticalSpace,
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                        bottom: 14, start: 8.w, end: 8.w),
                    child: AppButton(
                      model: AppButtonModel(
                        child: AppText(
                          text:
                              AppLocalizations.of(context)!.translate('login'),
                          model: AppTextModel(
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .label
                                  .copyWith(color: AppColors.white)),
                        ),
                        decoration: ComponentStyle.buttonDecoration,
                        buttonStyle: ComponentStyle.buttonStyle,
                      ),
                      onPressed: () => viewModel.login(context: context),
                    ),
                  ),
                  10.h.verticalSpace,
                  Center(
                    child: AppText(
                      text:
                          "------------------- ${AppLocalizations.of(context)!.translate('or')} --------------------",
                      model: AppTextModel(
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .bodyRegular1
                            .copyWith(
                              color: AppColors.gray,
                            ),
                      ),
                    ),
                  ),
                  10.h.verticalSpace,
                  Center(
                    child: SocialLoginButton(
                      label: AppLocalizations.of(context)!
                          .translate('continue_with_google'),
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      iconPath: Assets.googleImage, // Add Google icon asset
                      onPressed: () {
                        viewModel.signInWithGoogle(context);
                      },
                    ),
                  ),
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
          ),
        ),
      ),
    );
  }
}
