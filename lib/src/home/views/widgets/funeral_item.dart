import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/util/localization/app_localizations.dart';
import '../../data/models/funerial_model.dart';

class FuneralItem extends StatelessWidget {
  final FuneralPost post;
  final VoidCallback onTap;

  const FuneralItem({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 10.w),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 220.w,
          // margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Funeral Image (if available)
              if ((post.image ?? '').isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: post.image ?? '',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (ctx, _) =>
                        Container(color: Colors.grey[300], height: 120),
                    errorWidget: (ctx, _, __) =>
                        Container(color: Colors.grey[300], height: 120),
                  ),
                )
              else
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Icon(Icons.image_not_supported,
                      color: Colors.grey[600], size: 40),
                ),

              // Funeral Info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection:
                          AppLocalizations.of(context)!.locale.languageCode ==
                                      'en' ||
                                  AppLocalizations.of(context)!
                                          .locale
                                          .languageCode ==
                                      'sv'
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                      height: 35.h,
                      child: Text(
                        "${post.excerpt}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textDirection:
                            AppLocalizations.of(context)!.locale.languageCode ==
                                        'en' ||
                                    AppLocalizations.of(context)!
                                            .locale
                                            .languageCode ==
                                        'sv'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      post.date ?? '',
                      textDirection:
                          AppLocalizations.of(context)!.locale.languageCode ==
                                      'en' ||
                                  AppLocalizations.of(context)!
                                          .locale
                                          .languageCode ==
                                      'sv'
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: Colors.grey[300]),

              // Masjid Info (Bottom Section)
              if (post.masjid != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Masjid Photo
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: post.masjid!.photo ?? '',
                          height: 20.h,
                          width: 20.w,
                          fit: BoxFit.cover,
                          placeholder: (ctx, _) => Container(
                              color: Colors.grey[300], height: 20, width: 20),
                          errorWidget: (ctx, _, __) => Container(
                              color: Colors.grey[300], height: 20, width: 20),
                        ),
                      ),
                      SizedBox(width: 8),

                      // Masjid Name + Email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.masjid!.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            Text(
                              post.masjid!.email ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black54),
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
  }
}
