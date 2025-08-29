import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../data/models/masjed_details_model.dart';

class FuneralsItem extends StatelessWidget {
  const FuneralsItem({
    super.key,
    required this.postItem,
  });
  final PostItem postItem;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 10.w),
      child: Container(
        // height: 150.h,
        // width: 100.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: SizedBox(
                      height: 100.h,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        postItem.image ?? "",
                        fit: BoxFit.cover,
                      ))),
              10.h.verticalSpace,
              AppText(
                text: "${postItem.title}",
                model: AppTextModel(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .heading1
                            .copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            )),
              ),
              10.h.verticalSpace,
              AppText(
                text: "${postItem.excerpt}",
                model: AppTextModel(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .subTitle1
                            .copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray,
                            )),
              ),
              10.h.verticalSpace,
              AppText(
                text: postItem.date ?? "",
                model: AppTextModel(
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .smallTab
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.scondaryColor,
                            )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
