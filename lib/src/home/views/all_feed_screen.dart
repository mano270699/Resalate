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
import '../data/models/live_model.dart';
import 'widgets/live_feed_item.dart';

class AllFeedLiveScreen extends StatefulWidget {
  const AllFeedLiveScreen({super.key});
  static const String routeName = 'AllFeedLiveScreen';

  @override
  State<AllFeedLiveScreen> createState() => _AllFeedLiveScreenState();
}

//

class _AllFeedLiveScreenState extends State<AllFeedLiveScreen> {
  final viewModel = sl<HomeViewModel>()..getAllFeedLive(1);
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
          title: AppText(
            text: AppLocalizations.of(context)!.translate("live_feed"),
            model: AppTextModel(
              style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                  .bodyMedium1
                  .copyWith(
                    color: AppColors.black,
                  ),
            ),
          ),
        ),
        body: BlocBuilder<GenericCubit<LiveFeedsResponse>,
            GenericCubitState<LiveFeedsResponse>>(
          bloc: viewModel.allfeedLiveRes,
          builder: (context, liveFeedState) {
            // if (donationState is GenericLoadingState) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            if (liveFeedState is GenericErrorState) {
              return Center(
                  child: Text(liveFeedState.responseError!.errorMessage));
            }

            final posts = liveFeedState.data.posts;
            final hasMore = viewModel.hasMorePages;

            return Skeletonizer(
              enabled: liveFeedState is GenericLoadingState,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final isLoading = liveFeedState is GenericLoadingState;

                  // Fake placeholders when loading
                  if (isLoading) {
                    return LiveFeedItem(
                      date: "",
                      desc: "",
                      image: "",
                      title: "",
                      url: "",
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
                  return LiveFeedItem(
                      date: post.date ?? "",
                      desc: post.excerpt ?? "",
                      image:
                          "https://st.depositphotos.com/1006472/1847/i/950/depositphotos_18478155-stock-photo-live-message.jpg",
                      title: post.title ?? "",
                      url: post.iframe ?? "");
                },
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemCount: (liveFeedState is GenericLoadingState)
                    ? 5 // show 5 skeleton DonationItems
                    : posts!.length + (hasMore ? 1 : 0),
              ),
            );
          },
        ),
      ),
    );
  }
}
