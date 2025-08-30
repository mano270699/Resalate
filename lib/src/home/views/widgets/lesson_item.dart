import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/lessons_model.dart';

class LessonItem extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const LessonItem({
    super.key,
    required this.lesson,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Default text style to avoid repetition
    final TextStyle titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );

    final TextStyle excerptStyle = TextStyle(
      fontSize: 14,
      color: Colors.black54,
    );

    final TextStyle masjidStyle = TextStyle(
      fontSize: 10,
      color: Colors.black54,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 220.w,
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
            // Lesson Image
            if (lesson.image != null && lesson.image!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: lesson.image!,
                  height: 120,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (ctx, _) =>
                      Container(color: Colors.grey[300], height: 120),
                  errorWidget: (ctx, _, __) =>
                      Container(color: Colors.grey[300], height: 120),
                ),
              )
            else
              Container(color: Colors.grey[300], height: 120),

            // Text Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title ?? 'No Title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle,
                  ),
                  SizedBox(height: 4),
                  Text(
                    lesson.excerpt ?? 'No Excerpt Available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: excerptStyle,
                  ),
                  SizedBox(height: 6),
                  if (lesson.categories != null &&
                      lesson.categories!.isNotEmpty)
                    Text(
                      lesson.categories!.map((c) => c.name).join(", "),
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.grey[300]),

            // Masjid Info (Bottom Section)
            if (lesson.masjid != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Shrink-wrap the row
                  children: [
                    // Masjid Photo
                    if (lesson.masjid!.photo != null &&
                        lesson.masjid!.photo!.isNotEmpty)
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: lesson.masjid!.photo!,
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                          placeholder: (ctx, _) => Container(
                              color: Colors.grey[300], height: 20, width: 20),
                          errorWidget: (ctx, _, __) => Container(
                              color: Colors.grey[300], height: 20, width: 20),
                        ),
                      )
                    else
                      Container(
                        color: Colors.grey[300],
                        height: 20,
                        width: 20,
                      ),
                    SizedBox(width: 8),

                    // Masjid Name + Email using Flexible
                    Flexible(
                      fit: FlexFit.loose, // Allows content to take less space
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.masjid!.name ?? 'No Masjid Name',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle.copyWith(fontSize: 10),
                          ),
                          Text(
                            lesson.masjid!.email ?? 'No Email Available',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: masjidStyle,
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
    );
  }
}
