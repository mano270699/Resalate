import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../../my_mosque/views/my_mosque_screen.dart';

class MosqueItem extends StatelessWidget {
  const MosqueItem({
    super.key,
    required this.image,
    required this.title,
    required this.address,
    required this.distance,
    required this.lat,
    required this.long,
    required this.id,
  });

  final String image;
  final String title;
  final String address;
  final String distance;
  final String lat;
  final String long;
  final int id;

  Future<void> openMapDirections({
    required double lat,
    required double lng,
  }) async {
    String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";
    String appleMapsUrl = "http://maps.apple.com/?daddr=$lat,$lng";

    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
        await launchUrl(Uri.parse(appleMapsUrl),
            mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication);
      }
    } else {
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!.locale;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, MyMosqueScreen.routeName,
            arguments: {"id": id});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ── Image with distance badge ──
            SizedBox(
              height: 140.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade100,
                      child: Icon(Icons.mosque_rounded,
                          size: 40.sp, color: Colors.grey.shade300),
                    ),
                  ),
                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Distance badge
                  if (distance.isNotEmpty)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color:
                              AppColors.scondaryColor.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.white, size: 12.sp),
                            SizedBox(width: 3.w),
                            Text(
                              distance,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// ── Details section ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  AppText(
                    text: title,
                    model: AppTextModel(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyleGlobal(locale).headingMedium2.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightBlack,
                          ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Address row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Icon(Icons.place_outlined,
                            size: 13.sp, color: AppColors.gray),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.gray,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  // Distance + Directions row
                  Row(
                    children: [
                      // Distance chip
                      if (distance.isNotEmpty)
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColors.scondaryColor
                                  .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: AppColors.scondaryColor
                                    .withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on,
                                      color: AppColors.scondaryColor,
                                      size: 14.sp),
                                  SizedBox(width: 3.w),
                                  Text(
                                    distance,
                                    style: TextStyle(
                                      color: AppColors.scondaryColor,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (distance.isNotEmpty) SizedBox(width: 6.w),

                      // Directions button
                      Expanded(
                        flex: distance.isNotEmpty ? 1 : 2,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              final latParsed = double.tryParse(lat);
                              final lngParsed = double.tryParse(long);
                              if (latParsed != null && lngParsed != null) {
                                openMapDirections(
                                    lat: latParsed, lng: lngParsed);
                              }
                            },
                            borderRadius: BorderRadius.circular(10.r),
                            child: Ink(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: AppColors.primaryColor
                                      .withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.directions_rounded,
                                        color: AppColors.primaryColor,
                                        size: 14.sp),
                                    SizedBox(width: 4.w),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('direction'),
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
