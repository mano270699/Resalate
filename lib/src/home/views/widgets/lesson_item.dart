import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 220,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: lesson.image ?? '',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (ctx, _) =>
                    Container(color: Colors.grey[300], height: 120),
                errorWidget: (ctx, _, __) =>
                    Container(color: Colors.grey[300], height: 120),
              ),
            ),

            // Text Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  SizedBox(height: 4),
                  Text(
                    lesson.excerpt ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
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
                  children: [
                    // Masjid Photo
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: lesson.masjid!.photo ?? '',
                        height: 20,
                        width: 20,
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
                            lesson.masjid!.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          Text(
                            lesson.masjid!.email ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(fontSize: 10, color: Colors.black54),
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
