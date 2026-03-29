import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/shared_components/app_text/app_text.dart';
import 'package:resalate/src/my_mosque/logic/masjed_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/base/dependency_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/shared_components/app_snack_bar/app_snack_bar.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/loading.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../data/models/countries_model.dart';
import '../data/models/follow_masjed_model.dart';
import '../data/models/province_model.dart';
import '../data/models/cities_model.dart';
import '../data/models/masjed_list_model.dart';
import 'my_mosque_screen.dart';
import 'widgets/masjed_item.dart';

class MasjedListScreen extends StatefulWidget {
  const MasjedListScreen({super.key});

  @override
  State<MasjedListScreen> createState() => _MasjedListScreenState();
}

class _MasjedListScreenState extends State<MasjedListScreen> {
  final viewModel = sl<MasjedViewModel>()
    ..getMasjedsData(1)
    ..getLocationsList()
    ..getCountries();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Load next page when 200px near the bottom
        viewModel.loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          AppLocalizations.of(context)!.locale.languageCode == 'en' ||
                  AppLocalizations.of(context)!.locale.languageCode == 'sv'
              ? TextDirection.ltr
              : TextDirection.rtl,
      child: BlocListener<GenericCubit<FollowMasjedResponse>,
          GenericCubitState<FollowMasjedResponse>>(
        bloc: viewModel.followActionRes,
        listener: (context, state) {
          if (state is GenericLoadingState) {
            LoadingScreen.show(context);
          } else if (state is GenericUpdatedState) {
            Navigator.pop(context);

            showAppSnackBar(
              context: context,
              message: state.data.action,
              color: AppColors.success,
            );
            viewModel.getMasjedsData(1);
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
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: AppText(
              text: AppLocalizations.of(context)!.translate("masajed"),
              model: AppTextModel(
                style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                    .bodyMedium1
                    .copyWith(
                      color: AppColors.black,
                    ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  _openFilterBottomSheet();
                },
              ),
            ],
          ),
          body: BlocBuilder<GenericCubit<MasjidListResponse>,
              GenericCubitState<MasjidListResponse>>(
            bloc: viewModel.masjidResponse,
            builder: (context, masjidState) {
              if (masjidState is GenericErrorState) {
                return Center(
                    child: Text(masjidState.responseError!.errorMessage));
              }

              final posts = masjidState.data.masjids ?? [];
              final hasMore = viewModel.hasMorePages;
              if (posts.isEmpty && masjidState is! GenericLoadingState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey),
                      SizedBox(height: 12.h),
                      Text(
                        AppLocalizations.of(context)!
                            .translate("no_masjeds_found"),
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return Skeletonizer(
                enabled: masjidState is GenericLoadingState,
                child: ListView.separated(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    final isLoading = masjidState is GenericLoadingState;

                    // Fake placeholders when loading
                    if (isLoading) {
                      return MasjidItem(
                        viewModel: viewModel,
                        onTap: () {},
                        masjid: Masjid(),
                      );
                    }

                    // Normal state
                    if (index == posts.length) {
                      return hasMore
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              )),
                            )
                          : const SizedBox.shrink();
                    }

                    final post = posts[index];
                    return MasjidItem(
                      viewModel: viewModel,
                      onTap: () {
                        Navigator.pushNamed(context, MyMosqueScreen.routeName,
                            arguments: {"id": post.id});
                      },
                      masjid: post,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                  itemCount: (masjidState is GenericLoadingState)
                      ? 5
                      : posts.length + (hasMore ? 1 : 0),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Directionality(
              textDirection:
                  AppLocalizations.of(context)!.locale.languageCode == 'en' ||
                          AppLocalizations.of(context)!.locale.languageCode ==
                              'sv'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: SizedBox(
                  height: 400.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.h.verticalSpace,
                      Center(
                        child: Container(
                          height: 4.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppColors.gray),
                        ),
                      ),
                      20.h.verticalSpace,
                      Text(
                        AppLocalizations.of(context)!
                            .translate("Select_Filtration"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            color: AppColors.scondaryColor),
                      ),
                      25.h.verticalSpace,
                      // Country dropdown
                      BlocBuilder<GenericCubit<CountriesResponseModel>,
                          GenericCubitState<CountriesResponseModel>>(
                        bloc: viewModel.countriesListRes,
                        builder: (context, countryState) {
                          if (countryState is GenericLoadingState) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ));
                          }
                          return _buildDropdown<CountryModel>(
                            key:
                                ValueKey('country_${viewModel.filterSheetKey}'),
                            hint: AppLocalizations.of(context)!
                                .translate("Select_Country"),
                            value: viewModel.selectedCountry,
                            items: countryState.data.countries ?? [],
                            labelBuilder: (c) => c.name,
                            onChanged: (val) {
                              viewModel.selectCountry(val);
                              setSheetState(() {});
                            },
                          );
                        },
                      ),
                      10.h.verticalSpace,

                      // Province dropdown
                      BlocBuilder<GenericCubit<ProvincesResponseModel>,
                          GenericCubitState<ProvincesResponseModel>>(
                        bloc: viewModel.provincesListRes,
                        builder: (context, provinceState) {
                          if (provinceState is GenericLoadingState) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ));
                          }
                          return _buildDropdown<ProvinceModel>(
                            key: ValueKey(
                                'province_${viewModel.selectedCountry?.name ?? 'none'}_${viewModel.filterSheetKey}'),
                            hint: AppLocalizations.of(context)!
                                .translate("Select_Province"),
                            value: viewModel.selectedProvince,
                            items: provinceState.data.provinces ?? [],
                            labelBuilder: (s) => s.name,
                            onChanged: (val) {
                              viewModel.selectProvince(val);
                              setSheetState(() {});
                            },
                          );
                        },
                      ),
                      20.h.verticalSpace,

                      // City dropdown
                      BlocBuilder<GenericCubit<CitiesResponseModel>,
                          GenericCubitState<CitiesResponseModel>>(
                        bloc: viewModel.citiesListRes,
                        builder: (context, cityState) {
                          if (cityState is GenericLoadingState) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ));
                          }
                          return _buildDropdown<CityModel>(
                            key: ValueKey(
                                'city_${viewModel.selectedProvince?.name ?? 'none'}_${viewModel.filterSheetKey}'),
                            hint: AppLocalizations.of(context)!
                                .translate("Select_City"),
                            value: viewModel.selectedCity,
                            items: cityState.data.cities ?? [],
                            labelBuilder: (c) => c.name,
                            onChanged: (val) {
                              viewModel.selectCity(val);
                              setSheetState(() {});
                            },
                          );
                        },
                      ),
                      const Spacer(),

                      // Reset & Apply buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              onPressed: () {
                                viewModel.resetSelection();
                                viewModel.applySelection();
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("reset"),
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.scondaryColor),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              onPressed: () {
                                viewModel.applySelection();
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("apply"),
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdown<T>({
    Key? key,
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      key: key,
      initialValue: value,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      isExpanded: true,
      items: items
          .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Text(labelBuilder(e)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
