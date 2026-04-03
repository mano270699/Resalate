import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/src/live_feed/view/live_feed_details_screen.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../data/models/masjed_details_model.dart';

class LiveFeedItem extends StatelessWidget {
  const LiveFeedItem({
    super.key,
    required this.postItem,
  });
  final PostItem postItem;

  @override
  Widget build(BuildContext context) {
    final textDir =
        AppLocalizations.of(context)!.locale.languageCode == 'en' ||
                AppLocalizations.of(context)!.locale.languageCode == 'sv'
            ? TextDirection.ltr
            : TextDirection.rtl;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          LiveFeedDetailsScreen.routeName,
          arguments: {
            "id": postItem.id,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: SizedBox(
                    height: 120.h,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: postItem.image ??
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/960px-Placeholder_view_vector.svg.png",
                      fit: BoxFit.cover,
                    ))),
            10.h.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: AppText(
                text: postItem.title ?? "",
                model: AppTextModel(
                    textDirection: textDir,
                    style: AppFontStyleGlobal(
                            AppLocalizations.of(context)!.locale)
                        .headingMedium2
                        .copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        )),
              ),
            ),
            10.h.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: AppText(
                text: postItem.excerpt ?? "",
                model: AppTextModel(
                    textDirection: textDir,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyleGlobal(
                            AppLocalizations.of(context)!.locale)
                        .subTitle2
                        .copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryColor,
                        )),
              ),
            ),
            10.h.verticalSpace,
          ],
        ),
      ),
    );
  }
}
