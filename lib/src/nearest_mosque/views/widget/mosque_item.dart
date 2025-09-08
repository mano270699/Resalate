import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';

class MosqueItem extends StatelessWidget {
  const MosqueItem(
      {super.key,
      required this.image,
      required this.title,
      required this.address,
      required this.distance,
      required this.lat,
      required this.long});
  final String image;
  final String title;
  final String address;
  final String distance;
  final String lat;
  final String long;

  Future<void> openMapDirections({
    required double lat,
    required double lng,
  }) async {
    String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";
    String appleMapsUrl = "http://maps.apple.com/?daddr=$lat,$lng";

    if (Platform.isIOS) {
      // Try Apple Maps first
      if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
        await launchUrl(Uri.parse(appleMapsUrl),
            mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch maps';
      }
    } else {
      // Android → Google Maps
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch maps';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300.h,
      width: MediaQuery.of(context).size.width - 32.w,
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
                    height: 120.h,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      image,
                      fit: BoxFit.contain,
                    ))),
            5.h.verticalSpace,
            AppText(
              text: title,
              model: AppTextModel(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                          .headingMedium2
                          .copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          )),
            ),
            AppText(
              text: address,
              model: AppTextModel(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                          .subTitle1
                          .copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray,
                          )),
            ),
            10.h.verticalSpace,
            AppText(
              text: distance,
              model: AppTextModel(
                  style:
                      AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                          .subTitle1
                          .copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.scondaryColor,
                          )),
            ),
            10.h.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                GestureDetector(
                  onTap: () {
                    openMapDirections(
                        lat: double.parse(lat), lng: double.parse(long));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                        color: AppColors.scondaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    height: 35.h,
                    // width: 100.w,
                    child: Center(
                      child: AppText(
                        text: AppLocalizations.of(context)!
                            .translate('direction'),
                        model: AppTextModel(
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .subTitle2
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white,
                                )),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
