import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/src/profile/logic/profile_view_model.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/core/common/app_colors/app_colors.dart';
import 'package:resalate/core/common/app_component_style/component_style.dart';
import 'package:resalate/core/common/app_font_style/app_font_style_global.dart';
import 'package:resalate/core/common/models/error_model.dart';
import 'package:resalate/core/shared_components/app_button/app_button.dart';
import 'package:resalate/core/shared_components/app_button/models/app_button_model.dart';
import 'package:resalate/core/shared_components/app_text/app_text.dart';
import 'package:resalate/core/shared_components/app_text/models/app_text_model.dart';
import 'package:resalate/core/shared_components/text_form_field/app_text_field.dart';
import 'package:resalate/core/shared_components/text_form_field/models/app_text_field_model.dart';
import 'package:resalate/core/util/localization/app_localizations.dart';
import 'package:resalate/core/shared_components/app_snack_bar/app_snack_bar.dart';

class ChangePasswordDialog extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ChangePasswordDialog({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GenericCubit<DefaultModel>, GenericCubitState<DefaultModel>>(
      bloc: viewModel.changePasswordRes,
      listener: (context, state) {
        if (state is GenericUpdatedState) {
          showAppSnackBar(
            context: context,
            message: state.data.message ?? AppLocalizations.of(context)!.translate('success'),
            color: Colors.green,
          );
        } else if (state is GenericErrorState) {
          showAppSnackBar(
            context: context,
            message: state.responseError?.errorMessage ?? AppLocalizations.of(context)!.translate('error'),
            color: AppColors.error,
          );
        }
      },
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.lock_reset, size: 48.w, color: AppColors.primaryColor),
                  ),
                  20.h.verticalSpace,
                  AppText(
                    text: AppLocalizations.of(context)!.translate('change_password'),
                    model: AppTextModel(
                      style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale).heading4.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  30.h.verticalSpace,
                  BlocBuilder<GenericCubit<String>, GenericCubitState<String>>(
                    bloc: viewModel.oldPasswordValidation,
                    builder: (context, validation) {
                      return AppTextField(
                        model: AppTextFieldModel(
                          appTextModel: AppTextModel(
                            style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                                .bodyRegular1
                                .copyWith(color: AppColors.primaryColor),
                          ),
                          controller: viewModel.oldPassword,
                          keyboardType: TextInputType.visiblePassword,
                          obscureInputText: true,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          borderRadius: BorderRadius.circular(16.r),
                          decoration: ComponentStyle.inputDecoration(AppLocalizations.of(context)!.locale).copyWith(
                            fillColor: AppColors.scaffoldBackgroundColor,
                            contentPadding: EdgeInsetsDirectional.only(start: 16.w, top: 16.h, bottom: 16.h),
                            filled: true,
                            prefixIcon: Icon(Icons.lock_outline, color: AppColors.gray, size: 22.w),
                            hintText: AppLocalizations.of(context)!.translate('old_password'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(color: AppColors.gray.withValues(alpha: 0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(color: AppColors.gray.withValues(alpha: 0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: const BorderSide(color: AppColors.primaryColor),
                            ),
                          ),
                          errorText: validation.data.isNotEmpty ? AppLocalizations.of(context)!.translate(validation.data) : null,
                        ),
                      );
                    },
                  ),
                  16.h.verticalSpace,
                  BlocBuilder<GenericCubit<String>, GenericCubitState<String>>(
                    bloc: viewModel.newPasswordValidation,
                    builder: (context, validation) {
                      return AppTextField(
                        model: AppTextFieldModel(
                          appTextModel: AppTextModel(
                            style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                                .bodyRegular1
                                .copyWith(color: AppColors.primaryColor),
                          ),
                          controller: viewModel.newPassword,
                          keyboardType: TextInputType.visiblePassword,
                          obscureInputText: true,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          borderRadius: BorderRadius.circular(16.r),
                          decoration: ComponentStyle.inputDecoration(AppLocalizations.of(context)!.locale).copyWith(
                            fillColor: AppColors.scaffoldBackgroundColor,
                            contentPadding: EdgeInsetsDirectional.only(start: 16.w, top: 16.h, bottom: 16.h),
                            filled: true,
                            prefixIcon: Icon(Icons.lock_outline, color: AppColors.gray, size: 22.w),
                            hintText: AppLocalizations.of(context)!.translate('new_password'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(color: AppColors.gray.withValues(alpha: 0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(color: AppColors.gray.withValues(alpha: 0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: const BorderSide(color: AppColors.primaryColor),
                            ),
                          ),
                          errorText: validation.data.isNotEmpty ? AppLocalizations.of(context)!.translate(validation.data) : null,
                        ),
                      );
                    },
                  ),
                  16.h.verticalSpace,
                  BlocBuilder<GenericCubit<String>, GenericCubitState<String>>(
                    bloc: viewModel.confirmPasswordValidation,
                    builder: (context, validation) {
                      return AppTextField(
                        model: AppTextFieldModel(
                          appTextModel: AppTextModel(
                            style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                                .bodyRegular1
                                .copyWith(color: AppColors.primaryColor),
                          ),
                          controller: viewModel.confirmPassword,
                          keyboardType: TextInputType.visiblePassword,
                          obscureInputText: true,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          borderRadius: BorderRadius.circular(16.r),
                          decoration: ComponentStyle.inputDecoration(AppLocalizations.of(context)!.locale).copyWith(
                            fillColor: AppColors.scaffoldBackgroundColor,
                            contentPadding: EdgeInsetsDirectional.only(start: 16.w, top: 16.h, bottom: 16.h),
                            filled: true,
                            prefixIcon: Icon(Icons.lock_outline, color: AppColors.gray, size: 22.w),
                            hintText: AppLocalizations.of(context)!.translate('confirm_password'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(color: AppColors.gray.withValues(alpha: 0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(color: AppColors.gray.withValues(alpha: 0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: const BorderSide(color: AppColors.primaryColor),
                            ),
                          ),
                          errorText: validation.data.isNotEmpty ? AppLocalizations.of(context)!.translate(validation.data) : null,
                        ),
                      );
                    },
                  ),
                  32.h.verticalSpace,
                  BlocBuilder<GenericCubit<DefaultModel>, GenericCubitState<DefaultModel>>(
                    bloc: viewModel.changePasswordRes,
                    builder: (context, state) {
                      return AppButton(
                        model: AppButtonModel(
                          child: state is GenericLoadingState
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : AppText(
                                  text: AppLocalizations.of(context)!.translate('confirm'),
                                  model: AppTextModel(
                                    style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale).label.copyWith(
                                          color: AppColors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primaryColor, AppColors.scondaryColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          buttonStyle: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                        ),
                        onPressed: () {
                          viewModel.changePassword(context: context);
                        },
                      );
                    },
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
