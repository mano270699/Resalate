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
import '../data/models/user_masjeds_model.dart';
import 'my_mosque_screen.dart';
import 'widgets/user_masjed_item.dart';

class UserMasjedListScreen extends StatefulWidget {
  const UserMasjedListScreen({super.key});
  static const String routeName = 'UserMyMosqueScreen';

  @override
  State<UserMasjedListScreen> createState() => _UserMasjedListScreenState();
}

class _UserMasjedListScreenState extends State<UserMasjedListScreen> {
  final viewModel = sl<MasjedViewModel>()..getUserMasjeds();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: AppText(
            text: AppLocalizations.of(context)!.translate("my_mosque"),
            model: AppTextModel(
              style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                  .bodyMedium1
                  .copyWith(
                    color: AppColors.black,
                  ),
            ),
          ),
        ),
        body: BlocBuilder<GenericCubit<UserMasjedsModel>,
            GenericCubitState<UserMasjedsModel>>(
          bloc: viewModel.userMasjidResponse,
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
                itemBuilder: (context, index) {
                  final isLoading = masjidState is GenericLoadingState;

                  // Fake placeholders when loading
                  if (isLoading) {
                    return UserMasjidItem(
                      onTap: () {},
                      masjid: Masjids(),
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
                  return UserMasjidItem(
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
}
