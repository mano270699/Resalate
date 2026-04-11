import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../data/models/lessons_model.dart';

class LessonItem extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;
  final double? width;
  final EdgeInsetsGeometry margin;

  const LessonItem({
    super.key,
    required this.lesson,
    required this.onTap,
    this.width,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final isLtr = AppLocalizations.of(context)!.locale.languageCode == 'en' ||
        AppLocalizations.of(context)!.locale.languageCode == 'sv';
    final textDirection = isLtr ? TextDirection.ltr : TextDirection.rtl;
    final categoryNames = lesson.categories
            ?.map((category) => category.name?.trim() ?? '')
            .where((name) => name.isNotEmpty)
            .toList() ??
        <String>[];
    final categoryLabel = categoryNames.isEmpty
        ? ''
        : categoryNames.length == 1
            ? categoryNames.first
            : '${categoryNames.first} +${categoryNames.length - 1}';
    final hasDate = (lesson.date ?? '').trim().isNotEmpty;

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
            final contentPadding = EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: isCompactHomeCard ? 8.h : 10.h,
            );
            final borderRadius = BorderRadius.circular(18.r);
            final titleLines = isCompactHomeCard ? 1 : 2;
            final excerptLines = isCompactHomeCard ? 1 : 2;
            final contentSpacing = isCompactHomeCard ? 6.h : 8.h;
            final dateSpacing = isCompactHomeCard ? 8.h : 10.h;

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
                      color: AppColors.scondaryColor.withAlpha(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.scondaryColor.withAlpha(18),
                        blurRadius: 20,
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
                            child: (lesson.image ?? '').isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: lesson.image!,
                                    height: imageHeight,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
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
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppColors.primaryColor.withAlpha(180),
                                          AppColors.scondaryColor,
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.menu_book_rounded,
                                        size: 34.sp,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                          ),
                          if (categoryLabel.isNotEmpty)
                            PositionedDirectional(
                              top: isCompactHomeCard ? 10.h : 12.h,
                              end: 12.w,
                              child: _LessonBadge(label: categoryLabel),
                            ),
                        ],
                      ),
                      if (hasBoundedHeight)
                        Expanded(
                          child: Padding(
                            padding: contentPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lesson.title?.trim().isNotEmpty == true
                                      ? lesson.title!.trim()
                                      : '---',
                                  maxLines: titleLines,
                                  textDirection: textDirection,
                                  overflow: TextOverflow.ellipsis,
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
                                  lesson.excerpt?.trim().isNotEmpty == true
                                      ? lesson.excerpt!.trim()
                                      : '',
                                  maxLines: excerptLines,
                                  textDirection: textDirection,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black54,
                                    height: 1.45,
                                  ),
                                ),
                                if (hasDate) ...[
                                  const Spacer(),
                                  SizedBox(height: dateSpacing),
                                  _LessonMetaRow(
                                    icon: Icons.schedule_rounded,
                                    label: lesson.date!.trim(),
                                    textDirection: textDirection,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: contentPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lesson.title?.trim().isNotEmpty == true
                                    ? lesson.title!.trim()
                                    : '---',
                                maxLines: 2,
                                textDirection: textDirection,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize:
                                      availableWidth >= 320 ? 16.sp : 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.lightBlack,
                                  height: 1.25,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                lesson.excerpt?.trim().isNotEmpty == true
                                    ? lesson.excerpt!.trim()
                                    : '',
                                maxLines: 2,
                                textDirection: textDirection,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.black54,
                                  height: 1.45,
                                ),
                              ),
                              if (hasDate) ...[
                                SizedBox(height: 10.h),
                                _LessonMetaRow(
                                  icon: Icons.schedule_rounded,
                                  label: lesson.date!.trim(),
                                  textDirection: textDirection,
                                ),
                              ],
                            ],
                          ),
                        ),
                      if (lesson.masjid != null)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: isCompactHomeCard ? 8.h : 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.scondaryColor.withAlpha(8),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(18.r),
                            ),
                            border: Border(
                              top: BorderSide(
                                color: AppColors.scondaryColor.withAlpha(18),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              _LessonMasjidAvatar(
                                imageUrl: lesson.masjid!.photo,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lesson.masjid!.name?.trim().isNotEmpty ==
                                              true
                                          ? lesson.masjid!.name!.trim()
                                          : '---',
                                      maxLines: 1,
                                      textDirection: textDirection,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.5.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.scondaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      lesson.masjid!.email?.trim().isNotEmpty ==
                                              true
                                          ? lesson.masjid!.email!.trim()
                                          : '',
                                      maxLines: 1,
                                      textDirection: textDirection,
                                      overflow: TextOverflow.ellipsis,
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

class _LessonBadge extends StatelessWidget {
  const _LessonBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 140.w),
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

class _LessonMetaRow extends StatelessWidget {
  const _LessonMetaRow({
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
            textDirection: textDirection,
            overflow: TextOverflow.ellipsis,
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

class _LessonMasjidAvatar extends StatelessWidget {
  const _LessonMasjidAvatar({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = (imageUrl ?? '').isNotEmpty;

    return Container(
      height: 38.h,
      width: 38.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor.withAlpha(26),
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
