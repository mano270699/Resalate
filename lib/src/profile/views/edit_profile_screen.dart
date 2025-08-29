import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resalate/src/profile/data/models/profile_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_component_style/component_style.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/shared_components/app_button/app_button.dart';
import '../../../core/shared_components/app_button/models/app_button_model.dart';
import '../../../core/shared_components/app_snack_bar/app_snack_bar.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/shared_components/text_form_field/app_text_field.dart';
import '../../../core/shared_components/text_form_field/models/app_text_field_model.dart';
import '../../../core/util/loading.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../data/models/update_user_data.dart';
import '../logic/profile_view_model.dart';
import 'widgets/image_pic_bootomsheet.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.viewModel});
  static const String routeName = 'Edit ProfileScreen';
  final ProfileViewModel viewModel;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    widget.viewModel.getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.translate('edit_profile')),
        ),
        body: BlocBuilder<GenericCubit<ProfileModelResponse>,
            GenericCubitState<ProfileModelResponse>>(
          bloc: widget.viewModel.profileRes,
          builder: (context, profileState) {
            return BlocListener<GenericCubit<UpdateUserResponse>,
                    GenericCubitState<UpdateUserResponse>>(
                bloc: widget.viewModel.updateProfileRes,
                listener: (context, state) {
                  if (state is GenericLoadingState) {
                    LoadingScreen.show(context);
                  } else if (state is GenericDimissLoadingState) {
                    Navigator.of(context, rootNavigator: true).pop();
                  } else if (state is GenericUpdatedState) {
                    Navigator.of(context, rootNavigator: true).pop();
                    showAppSnackBar(
                      context: context,
                      message: state.data.message,
                      color: Colors.green,
                    );
                  } else {
                    Navigator.of(context, rootNavigator: true).pop();
                    if (state is GenericErrorState) {
                      showAppSnackBar(
                        context: context,
                        message: state.responseError!.errorMessage,
                        color: AppColors.error,
                      );
                    }
                  }
                },
                child: SingleChildScrollView(
                  child: Skeletonizer(
                    enabled: profileState is GenericLoadingState,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          // -- IMAGE with ICON
                          Stack(
                            children: [
                              SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: BlocBuilder<GenericCubit<File>,
                                        GenericCubitState<File>>(
                                      bloc: widget.viewModel.imageFile,
                                      builder: (context, state) {
                                        return state.data.path.isNotEmpty
                                            ? Image.file(state.data)
                                            : CachedNetworkImage(
                                                imageUrl: profileState
                                                        .data.user?.image ??
                                                    "",
                                                // placeholder: (context, url) =>
                                                //     const Center(
                                                //         child:
                                                //             CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: 120.w,
                                                  height: 120.w,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              );
                                      },
                                    ),
                                  )),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () =>
                                      ImagePickerBottomSheet.addAssetImage(
                                    context,
                                    onTapCamera: () {
                                      Navigator.pop(context);
                                      widget.viewModel.pickImage(
                                        source: ImageSource.camera,
                                      );
                                    },
                                    onTapGallery: () {
                                      Navigator.pop(context);
                                      widget.viewModel.pickImage(
                                        source: ImageSource.gallery,
                                      );
                                    },
                                  ),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: AppColors.primaryColor),
                                    child: const Icon(Icons.camera_alt,
                                        color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),

                          Column(
                            children: [
                              20.h.verticalSpace,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: BlocBuilder<GenericCubit<String>,
                                    GenericCubitState<String>>(
                                  bloc: widget.viewModel.emailValidation,
                                  builder: (context, validation) {
                                    return AppTextField(
                                      model: AppTextFieldModel(
                                        appTextModel: AppTextModel(
                                            style: AppFontStyleGlobal(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .locale)
                                                .bodyRegular1
                                                .copyWith(
                                                  color: AppColors.primaryColor,
                                                )),
                                        controller: widget.viewModel.name,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        decoration:
                                            ComponentStyle.inputDecoration(
                                          AppLocalizations.of(context)!.locale,
                                        ).copyWith(
                                          fillColor: AppColors.white,
                                          contentPadding:
                                              EdgeInsetsDirectional.only(
                                                  start: 10.w),
                                          filled: true,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .translate('name'),
                                        ),
                                        errorText: validation.data.isNotEmpty
                                            ? AppLocalizations.of(context)!
                                                .translate(validation.data)
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              20.h.verticalSpace,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: BlocBuilder<GenericCubit<String>,
                                    GenericCubitState<String>>(
                                  bloc: widget.viewModel.phoneNumberValidation,
                                  builder: (context, validation) {
                                    return AppTextField(
                                      model: AppTextFieldModel(
                                        appTextModel: AppTextModel(
                                            style: AppFontStyleGlobal(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .locale)
                                                .bodyRegular1
                                                .copyWith(
                                                  color: AppColors.primaryColor,
                                                )),
                                        controller: widget.viewModel.phone,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        decoration:
                                            ComponentStyle.inputDecoration(
                                          AppLocalizations.of(context)!.locale,
                                        ).copyWith(
                                          fillColor: AppColors.white,
                                          contentPadding:
                                              EdgeInsetsDirectional.only(
                                                  start: 10.w),
                                          filled: true,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .translate('phone'),
                                        ),
                                        errorText: validation.data.isNotEmpty
                                            ? AppLocalizations.of(context)!
                                                .translate(validation.data)
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              20.h.verticalSpace,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: BlocBuilder<GenericCubit<String>,
                                    GenericCubitState<String>>(
                                  bloc: widget.viewModel.emailValidation,
                                  builder: (context, validation) {
                                    return AppTextField(
                                      model: AppTextFieldModel(
                                        appTextModel: AppTextModel(
                                            style: AppFontStyleGlobal(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .locale)
                                                .bodyRegular1
                                                .copyWith(
                                                  color: AppColors.primaryColor,
                                                )),
                                        controller: widget.viewModel.email,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        decoration:
                                            ComponentStyle.inputDecoration(
                                          AppLocalizations.of(context)!.locale,
                                        ).copyWith(
                                          fillColor: AppColors.white,
                                          contentPadding:
                                              EdgeInsetsDirectional.only(
                                                  start: 10.w),
                                          filled: true,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .translate('email'),
                                        ),
                                        errorText: validation.data.isNotEmpty
                                            ? AppLocalizations.of(context)!
                                                .translate(validation.data)
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              20.h.verticalSpace,
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    bottom: 14, start: 16.w, end: 16.w),
                                child: AppButton(
                                  model: AppButtonModel(
                                    child: AppText(
                                      text: AppLocalizations.of(context)!
                                          .translate('edit_profile'),
                                      model: AppTextModel(
                                          style: AppFontStyleGlobal(
                                                  AppLocalizations.of(context)!
                                                      .locale)
                                              .label
                                              .copyWith(
                                                  color: AppColors.white)),
                                    ),
                                    decoration: ComponentStyle.buttonDecoration,
                                    buttonStyle: ComponentStyle.buttonStyle,
                                  ),
                                  onPressed: () {
                                    widget.viewModel.updateProfile(context);
                                  },
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }
}
