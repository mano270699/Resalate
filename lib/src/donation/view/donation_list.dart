import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/donation/data/models/donation_model.dart';
import 'package:resalate/src/donation/logic/donations_view_model.dart';
import 'package:resalate/src/donation/view/donation_details_screen.dart';

import '../../../core/base/dependency_injection.dart';
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Donation"),
      ),
      body: BlocBuilder<GenericCubit<DonationsResponse>,
          GenericCubitState<DonationsResponse>>(
        bloc: viewModel.donationResponse,
        builder: (context, donationState) {
          if (donationState is GenericLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (donationState is GenericErrorState) {
            return Center(
                child: Text(donationState.responseError!.errorMessage));
          }

          final posts = donationState.data.posts ?? [];
          final hasMore = viewModel.hasMorePages;

          return ListView.separated(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index == posts.length) {
                // Show loader ONLY if more pages exist
                return hasMore
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox.shrink(); // empty widget if no more pages
              }

              final post = posts[index];
              return DonationItem(
                onTap: () {
                  Navigator.pushNamed(context, DonationDetailsScreen.routeName,
                      arguments: {"id": post.id,"donation_name":post.title});
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
            itemCount:
                posts.length + (hasMore ? 1 : 0), // add loader only if has more
          );
        },
      ),
    );
  }
}
