import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/live_feed/data/models/live_feed_details.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/common/models/failure.dart';
import '../data/repository/live_feed_repository.dart';

class LiveFeedViewModel {
  final LiveFeedRepositoryImpl _liveFeedRepositoryImpl;

  LiveFeedViewModel(this._liveFeedRepositoryImpl);

  GenericCubit<LiveFeedDetailsModel> liveDetailsRes =
      GenericCubit(LiveFeedDetailsModel());
  GenericCubit<YoutubePlayerController?> youtubeController = GenericCubit(null);
  Future<void> getLiveFeedDetails({required int id}) async {
    liveDetailsRes.onLoadingState();
    try {
      Either<String, LiveFeedDetailsModel> response =
          await _liveFeedRepositoryImpl.getLiveFeedDetails(id: id);

      response.fold(
        (failure) {
          liveDetailsRes.onErrorState(Failure(failure));
        },
        (res) async {
          if (res.post!.iframe != null && res.post!.iframe!.isNotEmpty) {
            final videoId =
                YoutubePlayer.convertUrlToId(res.post!.iframe ?? "");
            if (videoId != null) {
              youtubeController.onUpdateData(YoutubePlayerController(
                initialVideoId: videoId,
                flags: const YoutubePlayerFlags(autoPlay: false, isLive: true),
              ));
            }
          }
          liveDetailsRes.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      liveDetailsRes.onErrorState(Failure('$e'));
    }
  }
}
