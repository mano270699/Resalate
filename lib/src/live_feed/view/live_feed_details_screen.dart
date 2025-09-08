import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/base/dependency_injection.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/live_feed/data/models/live_feed_details.dart';
import 'package:resalate/src/live_feed/logic/live_feed_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/push_notification/notification_helper.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../layout/screens/user_bottom_navigation_screen.dart';

class LiveFeedDetailsScreen extends StatefulWidget {
  const LiveFeedDetailsScreen({super.key, required this.id});
  final int id;
  static const String routeName = 'LiveFeedDetailsScreen';

  @override
  State<LiveFeedDetailsScreen> createState() => _LiveFeedDetailsScreenState();
}

class _LiveFeedDetailsScreenState extends State<LiveFeedDetailsScreen> {
  final viewModel = sl<LiveFeedViewModel>();
  @override
  void initState() {
    viewModel.getLiveFeedDetails(id: widget.id);
    super.initState();
  }

  Future<void> openYouTube(String videoUrl) async {
    final Uri url = Uri.parse(videoUrl);

    // This forces YouTube app if installed, otherwise fallback to browser
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // open in YouTube app
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    viewModel.youtubeController.state.data!.dispose();
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
          leading: GestureDetector(
              onTap: () {
                if (NotificationHelper.isFromNotifiction) {
                  Navigator.pushNamed(
                    context,
                    MainBottomNavigationScreen.routeName,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.black,
                size: 30,
              )),
          title: Text(
            AppLocalizations.of(context)!.translate("Live_Details"),
          ),
        ),
        body: BlocBuilder<GenericCubit<LiveFeedDetailsModel>,
                GenericCubitState<LiveFeedDetailsModel>>(
            bloc: viewModel.liveDetailsRes,
            builder: (context, state) {
              return Skeletonizer(
                enabled: state is GenericLoadingState,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              state.data.post?.masjid?.photo ?? "",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.data.post?.masjid?.name ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text(state.data.post?.masjid?.email ?? "",
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Post Title
                      Text(
                        state.data.post?.title ?? "",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),

                      /// Post Content (HTML)

                      Html(
                        data: state.data.post?.content ??
                            "", // render HTML content
                        style: {
                          "body": Style(
                            fontSize: FontSize(14),
                            color: Colors.grey[700],
                          ),
                        },
                      ),
                      const SizedBox(height: 20),

                      BlocBuilder<GenericCubit<YoutubePlayerController?>,
                          GenericCubitState<YoutubePlayerController?>>(
                        bloc: viewModel.youtubeController,
                        builder: (context, state) {
                          if (state.data != null) {
                            return YoutubePlayer(
                              controller: state.data!,
                              showVideoProgressIndicator: true,
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      /// Date
                      Text(
                        "${AppLocalizations.of(context)!.translate("Published")} ${state.data.post?.date ?? ""}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      10.h.verticalSpace,
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red),
                          foregroundColor:
                              WidgetStateProperty.all(AppColors.white),
                        ),
                        onPressed: () {
                          openYouTube(state.data.post?.iframe ?? "");
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("open_youtube"),
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
