import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/common/models/error_model.dart';
import 'package:resalate/src/profile/logic/profile_view_model.dart';

import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_component_style/component_style.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_button/app_button.dart';
import '../../../../core/shared_components/app_button/models/app_button_model.dart';
import '../../../../core/shared_components/app_snack_bar/app_snack_bar.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/shared_components/text_form_field/app_text_field.dart';
import '../../../../core/shared_components/text_form_field/models/app_text_field_model.dart';
import '../../../../core/util/loading.dart';
import '../../../../core/util/localization/app_localizations.dart';

class ContactForm extends StatefulWidget {
  final ProfileViewModel viewModel;
  final ScrollController scrollController;
  const ContactForm(
      {super.key, required this.viewModel, required this.scrollController});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<GenericCubit<DefaultModel>,
        GenericCubitState<DefaultModel>>(
      bloc: widget.viewModel.contactRes,
      listener: (context, state) {
        if (state is GenericLoadingState) {
          LoadingScreen.show(context);
        } else if (state is GenericUpdatedState) {
          Navigator.of(context, rootNavigator: false).pop();

          showAppSnackBar(
            context: context,
            message: state.data.message,
            color: AppColors.success,
          );
        } else {
          Navigator.of(context, rootNavigator: false).pop();
          if (state is GenericErrorState) {
            showAppSnackBar(
              context: context,
              message: state.responseError!.errorMessage,
              color: AppColors.error,
            );
          }
        }
      },
      child: Directionality(
        textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              AppText(
                text: "Contact Us",
                model: AppTextModel(
                  style:
                      AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                          .headingMedium2
                          .copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                ),
              ),

              20.h.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: BlocBuilder<GenericCubit<String>,
                        GenericCubitState<String>>(
                    bloc: widget.viewModel.contactNameValidation,
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
                          controller: widget.viewModel.contactName,
                          keyboardType: TextInputType.text,
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
                            hintText:
                                AppLocalizations.of(context)!.translate('name'),
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
                    bloc: widget.viewModel.contactEmailValidation,
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
                          controller: widget.viewModel.contactEmail,
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
                    bloc: widget.viewModel.contactPhoneValidation,
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
                          controller: widget.viewModel.contactPhone,
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
                    bloc: widget.viewModel.contactSubjectValidation,
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
                          controller: widget.viewModel.contactSubject,
                          keyboardType: TextInputType.text,
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
                                .translate('subject'),
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
                    bloc: widget.viewModel.contactMessageValidation,
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
                          controller: widget.viewModel.contactMessage,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          maxLines: 10,
                          minLines: 5,
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
                                .translate('message'),
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
                      text: "contact us",
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
                    widget.viewModel.contactUs(context: context);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
            ],
          ),
        ),
      ),
    );
  }
}
