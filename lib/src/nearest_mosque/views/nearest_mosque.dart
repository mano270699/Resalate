import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/nearest_mosque/data/models/nearby_masjids_model.dart';
import 'package:resalate/src/nearest_mosque/logic/nearby_masjeds_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/base/dependency_injection.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_component_style/component_style.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/shared_components/text_form_field/app_text_field.dart';
import '../../../core/shared_components/text_form_field/models/app_text_field_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import 'widget/mosque_item.dart';

class NearestMosque extends StatefulWidget {
  const NearestMosque({super.key});
  static const String routeName = 'Nearest Mosque Screen';

  @override
  State<NearestMosque> createState() => _NearestMosqueState();
}

class _NearestMosqueState extends State<NearestMosque> {
  final viewModel = sl<NearbyMasjedsViewModel>();
  int showItem = 1;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.getNearbyMasjedsList(context);
    // Reset list when search cleared
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        viewModel.resetMasjidsList(); // 👈 show default list again
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.translate("nearest_mosques"),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: AppTextField(
                          model: AppTextFieldModel(
                            appTextModel: AppTextModel(
                              style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale,
                              ).bodyRegular1.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                            ),
                            controller: TextEditingController(),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            onChangeInput: (value) {
                              if (value.length <= 1) {
                                viewModel.filterMasjeds(value);
                              }
                            },
                            borderRadius: BorderRadius.circular(12.r),
                            decoration: ComponentStyle.inputDecoration(
                              AppLocalizations.of(context)!.locale,
                            ).copyWith(
                              fillColor: AppColors.white,
                              contentPadding: EdgeInsetsDirectional.only(
                                start: 10.w,
                              ),
                              filled: true,
                              hintText: AppLocalizations.of(context)!
                                  .translate('search'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    10.w.horizontalSpace,
                    GestureDetector(
                      onTap: () => showRadiusFilterDialog(context),
                      child: Container(
                        height: 47.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.filter_alt_sharp,
                            color: AppColors.scondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showItem = 1;
                        });
                      },
                      child: Icon(
                        Icons.all_inbox,
                        color: showItem == 1
                            ? AppColors.scondaryColor
                            : AppColors.gray,
                      ),
                    ),
                    10.w.horizontalSpace,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showItem = 2;
                        });
                      },
                      child: Icon(
                        Icons.window,
                        color: showItem == 2
                            ? AppColors.scondaryColor
                            : AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<GenericCubit<List<Masjids>>,
                  GenericCubitState<List<Masjids>>>(
                bloc: viewModel.getNearbyMasjedsRes,
                builder: (context, state) {
                  // Show loading skeleton
                  if (state is GenericLoadingState) {
                    return Skeletonizer(
                        enabled: true,
                        child: Padding(
                          padding: EdgeInsets.only(top: 200.h),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.scondaryColor,
                            ),
                          ),
                        ));
                  }

                  // Handle error
                  if (state is GenericErrorState) {
                    return Padding(
                      padding: EdgeInsets.only(top: 200.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.responseError!.errorMessage,
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 10.h),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  AppColors.primaryColor),
                              foregroundColor:
                                  WidgetStateProperty.all(AppColors.white),
                            ),
                            onPressed: () {
                              Geolocator
                                  .openAppSettings(); // opens app settings
                            },
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate("Open_Settings"),
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Handle empty state
                  if (state.data.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: Column(
                        children: [
                          Icon(
                            Icons.mosque_outlined,
                            size: 80.sp,
                            color: AppColors.gray.withValues(alpha: 0.6),
                          ),
                          10.h.verticalSpace,
                          Text(
                            AppLocalizations.of(context)!
                                .translate("there_are_no_mosques_nearby"),
                            style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale,
                            ).bodyRegular1.copyWith(color: AppColors.gray),
                          ),
                        ],
                      ),
                    );
                  }

                  // Otherwise show the grid
                  return _buildMosquesGrid(state.data);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMosquesGrid(List<Masjids> mosques) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: mosques.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: showItem == 2 ? 0.57 : 1.25,
          crossAxisCount: showItem,
          crossAxisSpacing: 5.w,
          mainAxisSpacing: 5.h,
        ),
        itemBuilder: (BuildContext context, int index) {
          final masjid = mosques[index];
          return MosqueItem(
            distance: masjid.distance ?? "",
            address:
                "${masjid.country} ,${masjid.province} ,${masjid.city}", // Or masjid.address if you have it
            lat: masjid.lat.toString(),
            long: masjid.lng.toString(),
            image: masjid.image ?? "",
            title: masjid.name ?? "",
          );
        },
      ),
    );
  }

  showRadiusFilterDialog(BuildContext context) {
    final List<int> radiusOptions = [
      100,
      200,
      300,
      400,
      500,
      900,
      1000,
      3000,
      5000,
      10000,
      20000,
      30000,
      40000,
      50000,
      60000,
      60000,
      70000,
      80000,
      90000,
      100000,
      200000,
      300000,
      400000,
      500000,
      1000000,
      2000000,
      3000000,
      4000000,
      5000000,
    ]; // meters

    return showDialog<int>(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection:
              AppLocalizations.of(context)!.locale.languageCode == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
                AppLocalizations.of(context)!.translate("Filter_by_Radius")),
            content: BlocBuilder<GenericCubit<int>, GenericCubitState<int>>(
              bloc: viewModel.radiusFilter,
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: radiusOptions.map((r) {
                      final isSelected = state.data == r;
                      return GestureDetector(
                        onTap: () {
                          viewModel.changeRidusFilter(r, context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade400,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            r >= 1000
                                ? "${r ~/ 1000} ${AppLocalizations.of(context)!.translate("km")}"
                                : "$r ${AppLocalizations.of(context)!.translate("m")}",
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
