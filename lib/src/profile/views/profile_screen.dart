import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/core/common/models/error_model.dart';
import 'package:resalate/core/shared_components/app_text/app_text.dart';
import 'package:resalate/src/Auth/view/login_screen.dart';
import 'package:resalate/src/home/data/models/home_data_model.dart';
import 'package:resalate/src/profile/data/models/profile_model.dart';
import 'package:resalate/src/profile/views/faq_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/base/dependency_injection.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/common/app_icon_svg.dart';
import '../../../core/shared_components/app_snack_bar/app_snack_bar.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/loading.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../../core/util/localization/cubit/localization_cubit.dart';
import '../../notification/view/notification_screen.dart';
import '../logic/profile_view_model.dart';
import 'edit_profile_screen.dart';
import 'web_view_page.dart';
import 'widgets/avatar_custom_paint.dart';
import 'widgets/background_custom_paint.dart';
import 'widgets/confirm_dialog.dart';
import 'widgets/contact_form.dart';
import 'widgets/sponser_form.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final viewModel = sl<ProfileViewModel>();

  @override
  void initState() {
    viewModel.getAppOption();
    viewModel.checkLogin();

    super.initState();
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
          bloc: viewModel.profileAction,
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight, // fill screen at least
                  ),
                  child: Stack(
                    children: [
                      // Background
                      SizedBox(
                        width: double.infinity,
                        height: constraints.maxHeight,
                        child: CustomPaint(
                          painter: WaveBackgroundPainter(),
                        ),
                      ),
                      BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
                        bloc: viewModel.isUserLoggedin,
                        builder: (context, state) {
                          return state.data
                              ? Positioned(
                                  left: 10.w,
                                  top: 30.h,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          NotificationScreen.routeName);
                                    },
                                    child: SizedBox(
                                      child: SvgPicture.asset(
                                        AppIconSvg.notification,
                                        colorFilter: ColorFilter.mode(
                                            AppColors.white, BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink();
                        },
                      ),
                      Positioned(
                        right: 10.w,
                        top: 30.h,
                        child:
                            BlocBuilder<LocalizationCubit, LocalizationState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () {
                                if (AppLocalizations.of(context)!
                                        .locale
                                        .languageCode ==
                                    "en") {
                                  context
                                      .read<LocalizationCubit>()
                                      .changeLanguage('ar');
                                } else {
                                  context
                                      .read<LocalizationCubit>()
                                      .changeLanguage('en');
                                }
                              },
                              child: Container(
                                height: 35.h,
                                width: 35.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.white),
                                child: Center(
                                  child: AppText(
                                    text: AppLocalizations.of(context)!
                                                .locale
                                                .languageCode ==
                                            "en"
                                        ? "أ"
                                        : "A",
                                    model: AppTextModel(
                                      style: AppFontStyleGlobal(
                                              AppLocalizations.of(context)!
                                                  .locale)
                                          .bodyMedium1
                                          .copyWith(
                                              color: AppColors.black,
                                              fontSize: 20.h),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          BlocBuilder<GenericCubit<bool>,
                              GenericCubitState<bool>>(
                            bloc: viewModel.isUserLoggedin,
                            builder: (context, state) {
                              return state.data
                                  ? SizedBox(height: 120.h)
                                  : SizedBox(height: 155.h);
                            },
                          ),
                          BlocBuilder<GenericCubit<bool>,
                              GenericCubitState<bool>>(
                            bloc: viewModel.isUserLoggedin,
                            builder: (context, state) {
                              return state.data
                                  ? BlocBuilder<
                                      GenericCubit<ProfileModelResponse>,
                                      GenericCubitState<ProfileModelResponse>>(
                                      bloc: viewModel.profileRes,
                                      builder: (context, profileState) {
                                        return Skeletonizer(
                                          enabled: profileState
                                              is GenericLoadingState,
                                          child: Center(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                CustomPaint(
                                                  size: const Size(120, 120),
                                                  painter:
                                                      AvatarBorderPainter(),
                                                ),
                                                CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: NetworkImage(
                                                      '${profileState.data.user?.image}'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, LoginScreen.routeName);
                                        },
                                        child: Container(
                                          height: 40.h,
                                          width: 150.w,
                                          decoration: BoxDecoration(
                                              color: AppColors.scondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(20.w)),
                                          child: Center(
                                            child: AppText(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .translate("login"),
                                              model: AppTextModel(
                                                  style: AppFontStyleGlobal(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .locale)
                                                      .bodyLight1
                                                      .copyWith(
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors.white,
                                                      )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                            },
                          )

                          // ,
                          ,
                          BlocBuilder<GenericCubit<bool>,
                              GenericCubitState<bool>>(
                            bloc: viewModel.isUserLoggedin,
                            builder: (context, state) {
                              return state.data
                                  ? BlocBuilder<
                                      GenericCubit<ProfileModelResponse>,
                                      GenericCubitState<ProfileModelResponse>>(
                                      bloc: viewModel.profileRes,
                                      builder: (context, profileState) {
                                        return Skeletonizer(
                                          enabled: state is GenericLoadingState,
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10.h),
                                              AppText(
                                                text: profileState
                                                        .data.user?.name ??
                                                    "loading...",
                                                model: AppTextModel(
                                                    style: AppFontStyleGlobal(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .locale)
                                                        .bodyLight1
                                                        .copyWith(
                                                          fontSize: 24.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              AppColors.black,
                                                        )),
                                              ),
                                              SizedBox(height: 5.h),
                                              AppText(
                                                text: profileState
                                                        .data.user?.email ??
                                                    "loading...",
                                                model: AppTextModel(
                                                    style: AppFontStyleGlobal(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .locale)
                                                        .bodyLight1
                                                        .copyWith(
                                                          fontSize: 16.sp,
                                                          color: AppColors.gray,
                                                        )),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox(
                                      height: 60.h,
                                    );
                            },
                          ),
                          Column(
                            children: [
                              10.h.verticalSpace,
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Image.asset(
                              //       Assets.facebookImage,
                              //       height: 40,
                              //       width: 40,
                              //     ),
                              //     5.w.horizontalSpace,
                              //     Image.asset(
                              //       Assets.instaImage,
                              //       height: 35,
                              //       width: 35,
                              //     ),
                              //   ],
                              // ),

                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Column(children: <Widget>[
                                    BlocBuilder<GenericCubit<bool>,
                                        GenericCubitState<bool>>(
                                      bloc: viewModel.isUserLoggedin,
                                      builder: (context, state) {
                                        return state.data
                                            ? Column(
                                                children: [
                                                  10.h.verticalSpace,
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          EditProfileScreen
                                                              .routeName,
                                                          arguments: {
                                                            "viewModel":
                                                                viewModel
                                                          }).then(
                                                        (value) {
                                                          viewModel
                                                              .getProfileData();
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 50.h,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                        color: AppColors.white,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.w),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            AppText(
                                                              text: AppLocalizations
                                                                      .of(
                                                                          context)!
                                                                  .translate(
                                                                      "edit_profile"),
                                                              model:
                                                                  AppTextModel(
                                                                      style: AppFontStyleGlobal(
                                                                              AppLocalizations.of(context)!.locale)
                                                                          .bodyLight1
                                                                          .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                AppColors.black,
                                                                          )),
                                                            ),
                                                            const Icon(
                                                              Icons
                                                                  .arrow_forward_outlined,
                                                              color: AppColors
                                                                  .black,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : SizedBox.shrink();
                                      },
                                    ),
                                    Column(
                                      children: [
                                        10.h.verticalSpace,
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled:
                                                  true, // full height when keyboard opens
                                              backgroundColor: Colors
                                                  .transparent, // rounded corners effect
                                              builder: (context) {
                                                return DraggableScrollableSheet(
                                                  expand: false,
                                                  initialChildSize: 0.8,
                                                  maxChildSize: 0.9,
                                                  minChildSize: 0.4,
                                                  builder: (context,
                                                      scrollController) {
                                                    return Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20)),
                                                      ),
                                                      child: SponsorForm(
                                                          viewModel: viewModel,
                                                          scrollController:
                                                              scrollController),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: AppColors.white,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .translate(
                                                            "Sponsor_Form"),
                                                    model: AppTextModel(
                                                        style: AppFontStyleGlobal(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .locale)
                                                            .bodyLight1
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColors
                                                                  .black,
                                                            )),
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .arrow_forward_outlined,
                                                    color: AppColors.black,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        10.h.verticalSpace,
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled:
                                                  true, // full height when keyboard opens
                                              backgroundColor: Colors
                                                  .transparent, // rounded corners effect
                                              builder: (context) {
                                                return DraggableScrollableSheet(
                                                  expand: false,
                                                  initialChildSize: 0.85,
                                                  maxChildSize: 0.95,
                                                  minChildSize: 0.4,
                                                  builder: (context,
                                                      scrollController) {
                                                    return Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20)),
                                                      ),
                                                      child: ContactForm(
                                                          viewModel: viewModel,
                                                          scrollController:
                                                              scrollController),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: AppColors.white,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .translate(
                                                            "Contact_Form"),
                                                    model: AppTextModel(
                                                        style: AppFontStyleGlobal(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .locale)
                                                            .bodyLight1
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColors
                                                                  .black,
                                                            )),
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .arrow_forward_outlined,
                                                    color: AppColors.black,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    10.h.verticalSpace,
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, FaqScreen.routeName);
                                      },
                                      child: Container(
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          color: AppColors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AppText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .translate(
                                                        "Common_Questions"),
                                                model: AppTextModel(
                                                    style: AppFontStyleGlobal(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .locale)
                                                        .bodyLight1
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              AppColors.black,
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
                                    ),
                                    10.h.verticalSpace,
                                    BlocBuilder<GenericCubit<HomeDataModel>,
                                        GenericCubitState<HomeDataModel>>(
                                      bloc: viewModel.appOptionRes,
                                      builder: (context, state) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, WebViewPage.routeName,
                                                arguments: {
                                                  "title": AppLocalizations.of(
                                                          context)!
                                                      .translate(
                                                          "About_Resalty"),
                                                  "url": state
                                                      .data.aboutMobilePage?.url
                                                });
                                          },
                                          child: Container(
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: AppColors.white,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .translate(
                                                            "About_Resalty"),
                                                    model: AppTextModel(
                                                        style: AppFontStyleGlobal(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .locale)
                                                            .bodyLight1
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColors
                                                                  .black,
                                                            )),
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .arrow_forward_outlined,
                                                    color: AppColors.black,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    10.h.verticalSpace,
                                    BlocBuilder<GenericCubit<HomeDataModel>,
                                        GenericCubitState<HomeDataModel>>(
                                      bloc: viewModel.appOptionRes,
                                      builder: (context, state) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, WebViewPage.routeName,
                                                arguments: {
                                                  "title": AppLocalizations.of(
                                                          context)!
                                                      .translate(
                                                          "Privcy_Policy"),
                                                  "url": state
                                                      .data.privacyPolicy?.url
                                                });
                                          },
                                          child: Container(
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: AppColors.white,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .translate(
                                                            "Privcy_Policy"),
                                                    model: AppTextModel(
                                                        style: AppFontStyleGlobal(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .locale)
                                                            .bodyLight1
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColors
                                                                  .black,
                                                            )),
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .arrow_forward_outlined,
                                                    color: AppColors.black,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    10.h.verticalSpace,
                                    BlocBuilder<GenericCubit<HomeDataModel>,
                                        GenericCubitState<HomeDataModel>>(
                                      bloc: viewModel.appOptionRes,
                                      builder: (context, state) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, WebViewPage.routeName,
                                                arguments: {
                                                  "title": AppLocalizations.of(
                                                          context)!
                                                      .translate(
                                                          "Terms_Conditions"),
                                                  "url": state.data.terms?.url
                                                });
                                          },
                                          child: Container(
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: AppColors.white,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .translate(
                                                            "Terms_Conditions"),
                                                    model: AppTextModel(
                                                        style: AppFontStyleGlobal(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .locale)
                                                            .bodyLight1
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColors
                                                                  .black,
                                                            )),
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .arrow_forward_outlined,
                                                    color: AppColors.black,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    10.h.verticalSpace,
                                    BlocBuilder<GenericCubit<bool>,
                                        GenericCubitState<bool>>(
                                      bloc: viewModel.isUserLoggedin,
                                      builder: (context, state) {
                                        return state.data
                                            ? GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        ConfirmDialog(
                                                      title: AppLocalizations
                                                              .of(context)!
                                                          .translate("logout"),
                                                      message: AppLocalizations
                                                              .of(context)!
                                                          .translate(
                                                              "logout_alrt"),
                                                      confirmText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .translate(
                                                                  "logout"),
                                                      confirmColor: AppColors
                                                          .primaryColor,
                                                      onConfirm: () {
                                                        viewModel.logout();
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  height: 50.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    color: AppColors.white,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        AppText(
                                                          text: AppLocalizations
                                                                  .of(context)!
                                                              .translate(
                                                                  "logout"),
                                                          model: AppTextModel(
                                                              style: AppFontStyleGlobal(
                                                                      AppLocalizations.of(
                                                                              context)!
                                                                          .locale)
                                                                  .bodyLight1
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppColors
                                                                        .error,
                                                                  )),
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_outlined,
                                                          color:
                                                              AppColors.error,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox.shrink();
                                      },
                                    ),
                                    10.h.verticalSpace,
                                    BlocBuilder<GenericCubit<bool>,
                                        GenericCubitState<bool>>(
                                      bloc: viewModel.isUserLoggedin,
                                      builder: (context, state) {
                                        return state.data
                                            ? GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        ConfirmDialog(
                                                      title: AppLocalizations
                                                              .of(context)!
                                                          .translate(
                                                              "Delete_Account"),
                                                      message: AppLocalizations
                                                              .of(context)!
                                                          .translate(
                                                              "Delete_Account_alart"),
                                                      confirmText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .translate(
                                                                  "delete"),
                                                      confirmColor: Colors.red,
                                                      onConfirm: () {
                                                        viewModel
                                                            .deleteAccount();
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  height: 50.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    color: AppColors.white,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        AppText(
                                                          text: AppLocalizations
                                                                  .of(context)!
                                                              .translate(
                                                                  "Delete_Account"),
                                                          model: AppTextModel(
                                                              style: AppFontStyleGlobal(
                                                                      AppLocalizations.of(
                                                                              context)!
                                                                          .locale)
                                                                  .bodyLight1
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppColors
                                                                        .error,
                                                                  )),
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_outlined,
                                                          color:
                                                              AppColors.error,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox.shrink();
                                      },
                                    ),
                                    20.h.verticalSpace
                                  ]))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
