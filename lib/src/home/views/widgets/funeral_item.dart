import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../data/models/funerial_model.dart';

class FuneralItem extends StatelessWidget {
  final FuneralPost post;
  final VoidCallback onTap;
  final double? width;
  final EdgeInsetsGeometry margin;

  const FuneralItem({
    super.key,
    required this.post,
    required this.onTap,
    this.width,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final isLtr = AppLocalizations.of(context)!.locale.languageCode == 'en' ||
        AppLocalizations.of(context)!.locale.languageCode == 'sv';
    final textDirection = isLtr ? TextDirection.ltr : TextDirection.rtl;
    final hasDate = (post.date ?? '').trim().isNotEmpty;

    return Padding(
      padding: margin,
      child: SizedBox(
        width: width,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final hasBoundedHeight = constraints.maxHeight.isFinite;
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
            final imageHeight =
                (availableWidth * 0.56).clamp(112.0, 180.0).toDouble();
            final isCompactHomeCard =
                hasBoundedHeight && constraints.maxHeight <= imageHeight + 192;
            final borderRadius = BorderRadius.circular(18.r);
            final titleLines = isCompactHomeCard ? 1 : 2;
            final excerptLines = isCompactHomeCard ? 1 : 2;
            final contentSpacing = isCompactHomeCard ? 5.h : 6.h;
            final dateSpacing = isCompactHomeCard ? 6.h : 8.h;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: borderRadius,
                child: Container(
                  height: hasBoundedHeight ? constraints.maxHeight : null,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: AppColors.primaryColor.withAlpha(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withAlpha(20),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(18.r),
                            ),
                            child: (post.image ?? '').isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: post.image!,
                                    height: imageHeight,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (ctx, _) => Container(
                                      height: imageHeight,
                                      color: Colors.grey[300],
                                    ),
                                    errorWidget: (ctx, _, __) => Container(
                                      height: imageHeight,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: imageHeight,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFF223858),
                                          Color(0xFF111A2C),
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.volunteer_activism_rounded,
                                        color: AppColors.white,
                                        size: 34.sp,
                                      ),
                                    ),
                                  ),
                          ),
                          if (hasDate)
                            PositionedDirectional(
                              top: isCompactHomeCard ? 10.h : 12.h,
                              end: 12.w,
                              child: _FuneralBadge(label: post.date!.trim()),
                            ),
                        ],
                      ),
                      if (hasBoundedHeight)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: isCompactHomeCard ? 7.h : 8.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.title?.trim().isNotEmpty == true
                                      ? post.title!.trim()
                                      : '---',
                                  maxLines: titleLines,
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: textDirection,
                                  style: TextStyle(
                                    fontSize:
                                        availableWidth >= 320 ? 16.sp : 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.lightBlack,
                                    height: 1.25,
                                  ),
                                ),
                                SizedBox(height: contentSpacing),
                                Text(
                                  post.excerpt?.trim().isNotEmpty == true
                                      ? post.excerpt!.trim()
                                      : '',
                                  maxLines: excerptLines,
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: textDirection,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black54,
                                    height: 1.45,
                                  ),
                                ),
                                if (hasDate) ...[
                                  const Spacer(),
                                  SizedBox(height: dateSpacing),
                                  _FuneralMetaRow(
                                    icon: Icons.event_note_rounded,
                                    label: post.date!.trim(),
                                    textDirection: textDirection,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title?.trim().isNotEmpty == true
                                    ? post.title!.trim()
                                    : '---',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textDirection: textDirection,
                                style: TextStyle(
                                  fontSize:
                                      availableWidth >= 320 ? 16.sp : 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.lightBlack,
                                  height: 1.25,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                post.excerpt?.trim().isNotEmpty == true
                                    ? post.excerpt!.trim()
                                    : '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textDirection: textDirection,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.black54,
                                  height: 1.45,
                                ),
                              ),
                              if (hasDate) ...[
                                SizedBox(height: 8.h),
                                _FuneralMetaRow(
                                  icon: Icons.event_note_rounded,
                                  label: post.date!.trim(),
                                  textDirection: textDirection,
                                ),
                              ],
                            ],
                          ),
                        ),
                      if (post.masjid != null)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: isCompactHomeCard ? 7.h : 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withAlpha(9),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(18.r),
                            ),
                            border: Border(
                              top: BorderSide(
                                color: AppColors.primaryColor.withAlpha(20),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              _FuneralMasjidAvatar(
                                imageUrl: post.masjid!.photo,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.masjid!.name?.trim().isNotEmpty ==
                                              true
                                          ? post.masjid!.name!.trim()
                                          : '---',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: textDirection,
                                      style: TextStyle(
                                        fontSize: 12.5.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.scondaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      post.masjid!.email?.trim().isNotEmpty ==
                                              true
                                          ? post.masjid!.email!.trim()
                                          : '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: textDirection,
                                      style: TextStyle(
                                        fontSize: 11.5.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FuneralBadge extends StatelessWidget {
  const _FuneralBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 160.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.white.withAlpha(235),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.scondaryColor,
        ),
      ),
    );
  }
}

class _FuneralMetaRow extends StatelessWidget {
  const _FuneralMetaRow({
    required this.icon,
    required this.label,
    required this.textDirection,
  });

  final IconData icon;
  final String label;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: AppColors.primaryColor),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textDirection: textDirection,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _FuneralMasjidAvatar extends StatelessWidget {
  const _FuneralMasjidAvatar({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = (imageUrl ?? '').isNotEmpty;

    return Container(
      height: 38.h,
      width: 38.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor.withAlpha(24),
      ),
      child: ClipOval(
        child: hasImage
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (ctx, _) => Container(color: Colors.grey[300]),
                errorWidget: (ctx, _, __) => Icon(
                  Icons.location_city_rounded,
                  color: AppColors.primaryColor,
                  size: 18.sp,
                ),
              )
            : Icon(
                Icons.location_city_rounded,
                color: AppColors.primaryColor,
                size: 18.sp,
              ),
      ),
    );
  }
}
