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
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../data/models/location_model.dart';
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
    ..getLocationsList();
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
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
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
            // ✅ Handle empty state
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
                      onTap: () {},
                      masjid: Masjid(),
                    );
                  }

                  // Normal state
                  if (index == posts.length) {
                    return hasMore
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();
                  }

                  final post = posts[index];
                  return MasjidItem(
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
    );
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: SizedBox(
            height: 360.h,
            child: BlocBuilder<GenericCubit<LocationsModels>,
                GenericCubitState<LocationsModels>>(
              bloc: viewModel.getLocationsListRes,
              builder: (context, state) {
                if (state is GenericLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is GenericErrorState) {
                  return Center(
                      child:
                          Text("Failed: ${state.responseError?.errorMessage}"));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    40.h.verticalSpace,
                    BlocBuilder<GenericCubit<List<Locations>>,
                        GenericCubitState<List<Locations>>>(
                      bloc: viewModel.countriesList,
                      builder: (context, state) {
                        return _buildDropdown<Locations>(
                          hint: AppLocalizations.of(context)!
                              .translate("Select_Country"),
                          value: viewModel.selectedCountry,
                          items: state.data,
                          labelBuilder: (c) => c.country ?? "",
                          onChanged: (val) => viewModel.selectCountry(val),
                        );
                      },
                    ),
                    10.h.verticalSpace,
                    BlocBuilder<GenericCubit<List<States>>,
                        GenericCubitState<List<States>>>(
                      bloc: viewModel.provincesList,
                      builder: (context, state) {
                        return _buildDropdown<States>(
                          hint: AppLocalizations.of(context)!
                              .translate("Select_Province"),
                          value: viewModel.selectedProvince,
                          items: state.data,
                          labelBuilder: (s) => s.state ?? "",
                          onChanged: (val) => viewModel.selectProvince(val),
                        );
                      },
                    ),
                    10.h.verticalSpace,
                    BlocBuilder<GenericCubit<List<Cities>>,
                        GenericCubitState<List<Cities>>>(
                      bloc: viewModel.citiesList,
                      builder: (context, state) {
                        return _buildDropdown<Cities>(
                          hint: AppLocalizations.of(context)!
                              .translate("Select_City"),
                          value: viewModel.selectedCity,
                          items: state.data,
                          labelBuilder: (c) => c.name ?? "",
                          onChanged: (val) => viewModel.selectCity(val),
                        );
                      },
                    ),
                    const Spacer(),
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
                              setState(() => viewModel.resetSelection());
                              viewModel.applySelection();
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.translate("reset"),
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
                              AppLocalizations.of(context)!.translate("apply"),
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
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
