import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/shared_components/app_cached_network_image.dart';
import 'package:resalate/src/funerals/view/funerals_details_screen.dart';

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
    final textDir = AppLocalizations.of(context)!.locale.languageCode == 'en' ||
            AppLocalizations.of(context)!.locale.languageCode == 'sv'
        ? TextDirection.ltr
        : TextDirection.rtl;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          FuneralsDetailsScreen.routeName,
          arguments: {
            "id": postItem.id,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: SizedBox(
                        width: double.infinity,
                        child: AppCachedNetworkImage(
                          image: postItem.image,
                          fit: BoxFit.cover,
                        ))),
              ),
              const SizedBox(height: 6),
              AppText(
                text: "${postItem.title}",
                model: AppTextModel(
                    textDirection: textDir,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .heading1
                            .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            )),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: AppText(
                  text: "${postItem.excerpt}",
                  model: AppTextModel(
                      textDirection: textDir,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .subTitle1
                          .copyWith(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray,
                          )),
                ),
              ),
              const SizedBox(height: 4),
              AppText(
                text: postItem.date ?? "",
                model: AppTextModel(
                    textDirection: textDir,
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
