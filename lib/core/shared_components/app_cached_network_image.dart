import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:resalate/core/common/assets.dart';
import '../common/app_colors/app_colors.dart';

class AppCachedNetworkImage extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final bool showLoader;
  final BoxFit? fit;

  const AppCachedNetworkImage({
    super.key,
    this.image,
    this.height,
    this.width,
    this.fit,
    this.showLoader = true,
  });

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return SizedBox(
        height: height ?? 70.h,
        width: width ?? MediaQuery.sizeOf(context).width,
      );
    }
    return CachedNetworkImage(
      imageUrl: image!,
      fit: fit,
      height: height,
      width: width,
      fadeInCurve: Curves.easeInBack,
      placeholder: (context, url) => showLoader
          ? Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: height ?? 100.h,
                width: width ?? MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            )
          : SizedBox(
              height: height ?? 70.h,
              width: width ?? MediaQuery.sizeOf(context).width,
            ),
      errorWidget: (context, url, error) {
        debugPrint("Error::$error");
        return Container(
          height: height ?? 70.h,
          width: width ?? MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
          alignment: Alignment.center,
          child: Image.asset(Assets.placeholderImage),
        );
      },
    );
  }
}
