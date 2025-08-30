import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/home/logic/home_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/base/dependency_injection.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart'
    show AppFontStyleGlobal;
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../data/models/funerial_model.dart';
import 'widgets/funeral_item.dart';

class AllFuneralsScreen extends StatefulWidget {
  const AllFuneralsScreen({super.key});
  static const String routeName = 'AllFuneralsScreen';

  @override
  State<AllFuneralsScreen> createState() => _AllFuneralsScreenState();
}

//

class _AllFuneralsScreenState extends State<AllFuneralsScreen> {
  final viewModel = sl<HomeViewModel>()..getAllFunerals(1);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Load next page when 200px near the bottom
        viewModel.loadNextPageFunerals();
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
          title: AppText(
            text: AppLocalizations.of(context)!.translate("funerals"),
            model: AppTextModel(
              style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                  .bodyMedium1
                  .copyWith(
                    color: AppColors.black,
                  ),
            ),
          ),
        ),
        body: BlocBuilder<GenericCubit<FuneralsResponse>,
            GenericCubitState<FuneralsResponse>>(
          bloc: viewModel.allFuneralsRes,
          builder: (context, funeralsState) {
            // if (donationState is GenericLoadingState) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            if (funeralsState is GenericErrorState) {
              return Center(
                  child: Text(funeralsState.responseError!.errorMessage));
            }

            final posts = funeralsState.data.posts;
            final hasMore = viewModel.hasMorePages;

            return Skeletonizer(
              enabled: funeralsState is GenericLoadingState,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final isLoading = funeralsState is GenericLoadingState;

                  // Fake placeholders when loading
                  if (isLoading) {
                    return FuneralItem(
                      post: FuneralPost(),
                      onTap: () {},
                    );
                  }

                  // Normal state
                  if (index == posts!.length) {
                    return hasMore
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();
                  }

                  final post = posts[index];
                  return FuneralItem(
                    post: post,
                    onTap: () {},
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemCount: (funeralsState is GenericLoadingState)
                    ? 5
                    : posts!.length + (hasMore ? 1 : 0),
              ),
            );
          },
        ),
      ),
    );
  }
}
