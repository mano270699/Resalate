import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/base/dependency_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../data/models/masjed_to_masjed_model.dart';
import '../logic/masjed_to_masjed_view_model.dart';
import 'widgets/masjed_to_masjed_item.dart';

class FromMosqueToMosqueScreen extends StatefulWidget {
  const FromMosqueToMosqueScreen({super.key});
  static const String routeName = 'FromMosqueToMosque Screen';

  @override
  State<FromMosqueToMosqueScreen> createState() =>
      _FromMosqueToMosqueScreenState();
}

class _FromMosqueToMosqueScreenState extends State<FromMosqueToMosqueScreen> {
  final viewModel = sl<MasjedToMasjedViewModel>()..getMasjedToMasjed(page: 1);
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
          title: const Text("From Mosque To Mosque"),
        ),
        body: BlocBuilder<GenericCubit<MasjedToMasjedModel>,
            GenericCubitState<MasjedToMasjedModel>>(
          bloc: viewModel.masjedToMasjedRes,
          builder: (context, masjedToMasjedState) {
            if (masjedToMasjedState is GenericErrorState) {
              return Center(
                  child: Text(masjedToMasjedState.responseError!.errorMessage));
            }

            final posts = masjedToMasjedState.data.posts;
            final hasMore = viewModel.hasMorePages;

            return Skeletonizer(
              enabled: masjedToMasjedState is GenericLoadingState,
              child: ListView.separated(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final isLoading = masjedToMasjedState is GenericLoadingState;

                  // Fake placeholders when loading
                  if (isLoading) {
                    return ItemMasjedToMasjed(
                      posts: Posts(),
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
                  return ItemMasjedToMasjed(
                    posts: post,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemCount: (masjedToMasjedState is GenericLoadingState)
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
