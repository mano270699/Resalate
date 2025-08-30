import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/base/dependency_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_component_style/component_style.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/common/app_icon_svg.dart';
import '../../../core/common/models/error_model.dart';
import '../../../core/shared_components/app_button/app_button.dart';
import '../../../core/shared_components/app_button/models/app_button_model.dart';
import '../../../core/shared_components/app_pin_code_text_field/app_pin_code_text_field.dart';
import '../../../core/shared_components/app_pin_code_text_field/models/app_pin_code_model.dart';
import '../../../core/shared_components/app_snack_bar/app_snack_bar.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';

import '../../../core/util/loading.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../logic/auth_view_model.dart';
import 'reset_password_screen.dart';

class ForgetPasswordOTPScreen extends StatefulWidget {
  const ForgetPasswordOTPScreen({super.key, required this.email});
  final String email;
  static const String routeName = 'ForgetPasswordOTPScreen';

  @override
  State<ForgetPasswordOTPScreen> createState() =>
      _ForgetPasswordOTPScreenState();
}

class _ForgetPasswordOTPScreenState extends State<ForgetPasswordOTPScreen> {
  var viewModel = sl<AuthViewModel>();
  @override
  void initState() {
    viewModel.errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        body: BlocListener<GenericCubit<DefaultModel>,
            GenericCubitState<DefaultModel>>(
          bloc: viewModel.confirmOtpResponse,
          listener: (context, state) {
            if (state is GenericLoadingState) {
              LoadingScreen.show(context);
            } else if (state is GenericUpdatedState) {
              // Navigator.of(context, rootNavigator: false).pop();
              showAppSnackBar(
                context: context,
                message: state.data.message,
                color: AppColors.success,
              );
              Navigator.pushReplacementNamed(
                  context, ResetPasswordScreen.routeName, arguments: {
                "code": viewModel.controller.text,
                "email": widget.email
              });
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
          child: BlocListener<GenericCubit<DefaultModel>,
              GenericCubitState<DefaultModel>>(
            bloc: viewModel.resendOtpRes,
            listener: (context, state) {
              if (state is GenericLoadingState) {
                LoadingScreen.show(context);
              } else if (state is GenericUpdatedState) {
                // Navigator.of(context, rootNavigator: false).pop();
                Navigator.pop(context);

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
                    120.h.verticalSpace,
                    Center(
                      child: SvgPicture.asset(
                        AppLocalizations.of(context)!.locale.languageCode ==
                                "en"
                            ? AppIconSvg.splashLogo
                            : AppIconSvg.splashLogoAr,
                        height: 200.h,
                      ),
                    ),
                    20.h.verticalSpace,
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Center(
                        child: AppPinCodeTextField(
                          model: AppPinCodeModel(
                            controller: viewModel.controller,
                            key: viewModel.formKey,
                            boxHeight: 45.h,
                            boxWidth: 41.w,
                            borderRadius: 12.r,
                            errorTextSpace: 3.h,
                            length: 6,
                            obscureText: false,
                            selectedColor: AppColors.otpBorder,
                            activeColor: AppColors.otpBorder,
                            inactiveColor: AppColors.otpBorder,
                            errorBorderColor: AppColors.error,
                            errorDetailsTextModel: AppTextModel(
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .caption
                                  .copyWith(
                                    color: AppColors.error,
                                  ),
                            ),
                            textStyle: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .bodyMedium1
                                .copyWith(
                                  color: AppColors.darkBlack,
                                ),
                            onCompleted: (value) {},
                            onChanged: (value) {
                              debugPrint(value);
                            },
                            pinCodeSelectedFillColor: AppColors.white,
                            pinCodeInActiveFillColor: AppColors.white,
                            pinCodeActiveFillColor: AppColors.primaryColor,
                            cursorColor: AppColors.primaryColor,
                            // enableActiveFill: true,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false, signed: true),
                            errorController: viewModel.errorController,
                          ),
                        ),
                      ),
                    ),
                    80.h.verticalSpace,
                    // BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
                    //   bloc: viewModel.showTimer,
                    //   builder: (context, showTimerState) {
                    //     if (showTimerState.data) {
                    //       return SizedBox.shrink();
                    //     }
                    //     return GestureDetector(
                    //       onTap: () {
                    //         viewModel.startTimer();
                    //         viewModel.resendOtp(email: widget.email);
                    //       },
                    //       child: Center(
                    //         child: AppText(
                    //           text: AppLocalizations.of(context)!
                    //               .translate('resend_otp'),
                    //           model: AppTextModel(
                    //             style: AppFontStyleGlobal(
                    //                     AppLocalizations.of(context)!.locale)
                    //                 .bodyRegular1
                    //                 .copyWith(
                    //                   fontSize: 12.sp,
                    //                   fontWeight: FontWeight.bold,
                    //                   decoration: TextDecoration.underline,
                    //                   decorationColor: AppColors.scondaryColor,
                    //                   color: AppColors.scondaryColor,
                    //                 ),
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),

                    BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
                      bloc: viewModel.showTimer,
                      builder: (context, showTimerState) {
                        if (!showTimerState.data) {
                          return SizedBox.shrink();
                        }

                        return BlocBuilder<GenericCubit<String>,
                            GenericCubitState<String>>(
                          bloc: viewModel.timerCubit,
                          builder: (context, state) {
                            return Center(
                              child: AppText(
                                text: state.data,
                                model: AppTextModel(
                                  style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale,
                                  ).bodyRegular1.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryColor,
                                      ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
                      bloc: viewModel.showTimer,
                      builder: (context, showTimerState) {
                        if (showTimerState.data) {
                          return SizedBox.shrink();
                        }
                        return GestureDetector(
                          onTap: () {
                            viewModel.resendOtp(email: widget.email);
                          },

                          // viewModel.resendOtp(
                          //     context: context,
                          //     emailInput: widget.phone),
                          child: Center(
                            child: AppText(
                              text: AppLocalizations.of(context)!
                                  .translate('resend_otp'),
                              model: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .bodyRegular1
                                    .copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.scondaryColor,
                                      color: AppColors.scondaryColor,
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    20.h.verticalSpace,
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          bottom: 14, start: 8.w, end: 8.w),
                      child: AppButton(
                        model: AppButtonModel(
                          child: AppText(
                            text: AppLocalizations.of(context)!
                                .translate('verify'),
                            model: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .label
                                    .copyWith(color: AppColors.white)),
                          ),
                          decoration: ComponentStyle.buttonDecoration,
                          buttonStyle: ComponentStyle.buttonStyle,
                        ),
                        onPressed: () => viewModel.confirmOtp(
                          context: context,
                          email: widget.email,
                        ),
                      ),
                    ),
                    10.h.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
