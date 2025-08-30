import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resalate/src/Auth/view/login_screen.dart';

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
import '../data/models/reset_password_model.dart';
import '../logic/auth_view_model.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.email, required this.code});
  final String email;
  final String code;
  static const String routeName = 'ResetPasswordScreen';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var viewModel = sl<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        body: BlocListener<GenericCubit<ResetPasswordResponse>,
            GenericCubitState<ResetPasswordResponse>>(
          bloc: viewModel.resetPasswordRes,
          listener: (context, state) {
            if (state is GenericLoadingState) {
              LoadingScreen.show(context);
            } else if (state is GenericUpdatedState) {
              showAppSnackBar(
                context: context,
                message: state.data.message,
                color: AppColors.success,
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginScreen.routeName,
                (route) => false,
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
                  120.h.verticalSpace,
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
                        bloc: viewModel.resetPasswordValidation,
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
                              controller: viewModel.resetPassword,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              onChangeInput: (value) {},
                              borderRadius: BorderRadius.circular(12.r),
                              decoration: ComponentStyle.inputDecoration(
                                      const Locale("en"))
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: BlocBuilder<GenericCubit<String>,
                            GenericCubitState<String>>(
                        bloc: viewModel.confirmResetPasswordValidation,
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
                              controller: viewModel.confirmRestPassword,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              onChangeInput: (value) {},
                              borderRadius: BorderRadius.circular(12.r),
                              decoration: ComponentStyle.inputDecoration(
                                      const Locale("en"))
                                  .copyWith(
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
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                        bottom: 14, start: 8.w, end: 8.w),
                    child: AppButton(
                      model: AppButtonModel(
                        child: AppText(
                          text:
                              AppLocalizations.of(context)!.translate('change'),
                          model: AppTextModel(
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .label
                                  .copyWith(color: AppColors.white)),
                        ),
                        decoration: ComponentStyle.buttonDecoration,
                        buttonStyle: ComponentStyle.buttonStyle,
                      ),
                      onPressed: () => viewModel.resetUserPassword(
                          context: context,
                          code: widget.code,
                          email: widget.email),
                    ),
                  ),
                  10.h.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
