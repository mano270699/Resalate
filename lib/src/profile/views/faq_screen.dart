import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resalate/src/home/data/models/home_data_model.dart';
import 'package:resalate/src/home/logic/home_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/base/dependency_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import 'widgets/faq_expantion_tile.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});
  final viewModel = sl<HomeViewModel>()..getHomeData();

  static const String routeName = 'FaqScreen';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: AppText(
            text: AppLocalizations.of(context)!.translate("faq"),
            model: AppTextModel(
              style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                  .bodyMedium1
                  .copyWith(
                    color: AppColors.black,
                  ),
            ),
          ),
        ),
        body: BlocBuilder<GenericCubit<HomeDataModel>,
            GenericCubitState<HomeDataModel>>(
          bloc: viewModel.homeResponse,
          builder: (context, state) {
            if (state is GenericErrorState) {
              return Center(child: Text(state.responseError!.errorMessage));
            }

            return Skeletonizer(
              enabled: state is GenericLoadingState,
              child: ListView.builder(
                itemCount: state.data.faq.length,
                itemBuilder: (context, index) {
                  final faq = state.data.faq[index];
                  return FaqExpansionTile(
                    question: faq.question,
                    answer: faq.answer,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
