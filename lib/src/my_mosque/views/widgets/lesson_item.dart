import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/src/lessons/view/lesson_details_screen.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../data/models/masjed_details_model.dart';

class LessonItem extends StatelessWidget {
  const LessonItem({
    super.key,
    required this.lesson,
  });
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 10.w),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            LessonDetailsScreen.routeName,
            arguments: {
              "id": lesson.id,
            },
          );
        },
        child: Container(
          height: 200.h,
          // width: 180.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: AppColors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: SizedBox(
                      height: 100.h,
                      width: double.infinity,
                      child: Image.network(
                        lesson.image ?? "",
                        fit: BoxFit.cover,
                      ))),
              10.h.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: AppText(
                  text: lesson.title ?? "",
                  model: AppTextModel(
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
                  text: lesson.excerpt ?? "",
                  model: AppTextModel(
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
              AppText(
                text: lesson.date ?? "",
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
