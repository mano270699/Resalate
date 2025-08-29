import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/notification_model.dart';

class NotificationItem extends StatelessWidget {
  final Notifications notification;

  const NotificationItem({super.key, required this.notification});

  IconData _getIcon(String? type) {
    switch (type) {
      case "donations":
        return Icons.volunteer_activism;
      case "lessons":
        return Icons.menu_book;
      case "funerals":
        return Icons.airline_seat_flat;
      case "live-feed":
        return Icons.live_tv;
      case "masjid-to-masjid":
        return Icons.account_balance;
      default:
        return Icons.notifications;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat("yyyy-MM-dd hh:mm a").format(dt);
    } catch (e) {
      return dateStr;
    }
  }

  void _openUrl(String? url) async {
    if (url != null && url != "false" && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final seen = notification.seen ?? false;
    final title = notification.title ?? "";
    final postType = notification.postType;
    final url = notification.postUrl;
    final createdAt = notification.createdAt;

    return InkWell(
      onTap: () => _openUrl(url),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: seen ? Colors.white : Colors.blue.shade50, // highlight unseen
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.shade100,
              child: Icon(_getIcon(postType), color: Colors.blue, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight:
                              seen ? FontWeight.normal : FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(createdAt ?? ""),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (!seen)
              const Icon(Icons.circle,
                  color: Colors.red, size: 10), // unread dot
          ],
        ),
      ),
    );
  }
}
