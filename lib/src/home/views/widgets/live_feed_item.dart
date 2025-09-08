import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../../live_feed/view/live_feed_details_screen.dart';

class LiveFeedItem extends StatelessWidget {
  const LiveFeedItem(
      {super.key,
      required this.image,
      required this.title,
      required this.desc,
      required this.url,
      required this.date,
      required this.id});
  final String image;
  final String url;
  final int id;
  final String title;
  final String desc;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 10.w),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, LiveFeedDetailsScreen.routeName,
              arguments: {"id": id});
          // openYouTube(url);
        },
        child: Container(
          height: 200.h,
          width: 190.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: AppColors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: SizedBox(
                      height: 100.h,
                      width: double.infinity,
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ))),
              10.h.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: AppText(
                  text: title,
                  model: AppTextModel(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .headingMedium2
                          .copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          )),
                ),
              ),
              5.h.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: AppText(
                  text: desc,
                  model: AppTextModel(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .subTitle2
                          .copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.scondaryColor,
                          )),
                ),
              ),
              5.h.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: AppText(
                  text: date,
                  model: AppTextModel(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .subTitle2
                          .copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.gray,
                          )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
