import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/donation/data/models/donation_model.dart';
import 'package:resalate/src/donation/logic/donations_view_model.dart';
import 'package:resalate/src/donation/view/donation_details_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/base/dependency_injection.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../home/views/widgets/donation_item.dart';

class DonationListScreen extends StatefulWidget {
  const DonationListScreen({super.key});

  @override
  State<DonationListScreen> createState() => _DonationListScreenState();
}

class _DonationListScreenState extends State<DonationListScreen> {
  final viewModel = sl<DonationsViewModel>()..getDonationsData(1);
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
            text: AppLocalizations.of(context)!.translate("donate"),
            model: AppTextModel(
              style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                  .bodyMedium1
                  .copyWith(
                    color: AppColors.black,
                  ),
            ),
          ),
        ),
        body: BlocBuilder<GenericCubit<DonationsResponse>,
            GenericCubitState<DonationsResponse>>(
          bloc: viewModel.donationResponse,
          builder: (context, donationState) {
            // if (donationState is GenericLoadingState) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            if (donationState is GenericErrorState) {
              return Center(
                  child: Text(donationState.responseError!.errorMessage));
            }

            final posts = donationState.data.posts;
            final hasMore = viewModel.hasMorePages;

            return Skeletonizer(
              enabled: donationState is GenericLoadingState,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final isLoading = donationState is GenericLoadingState;

                  // Fake placeholders when loading
                  if (isLoading) {
                    return DonationItem(
                      onTap: () {},
                      percentage: "0",
                      title: "Loading title",
                      image: "", // skeletonizes
                      desc: "Loading description",
                      total: "0",
                      remaining: "0",
                      currency: "USD",
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
                  return DonationItem(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        DonationDetailsScreen.routeName,
                        arguments: {
                          "id": post.id,
                        },
                      );
                    },
                    percentage: post.donation?.percent.toString() ?? "",
                    title: post.title ?? "",
                    image: post.image ?? "",
                    desc: post.excerpt ?? "",
                    total: post.donation?.total.toString() ?? "",
                    remaining: post.donation?.paid.toString() ?? "",
                    currency: post.donation?.currency.toString() ?? "",
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemCount: (donationState is GenericLoadingState)
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
