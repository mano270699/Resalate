import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';

class LiveFeedItem extends StatelessWidget {
  const LiveFeedItem(
      {super.key,
      required this.image,
      required this.title,
      required this.desc});
  final String image;
  final String title;
  final String desc;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 10.w),
      child: Container(
        height: 200.h,
        width: 180.h,
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
                    width: 180.w,
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
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
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
                text: desc,
                model: AppTextModel(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
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
