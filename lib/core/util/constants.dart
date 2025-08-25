import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Constants {
  static const appBarSize = Size.fromHeight(65);
  static const token = "token";
  static const fcmToken = "fcmToken";
  static const userId = "userId";

  static Future<void> launcherUrl({required String uri}) async {
    final Uri url = Uri.parse(uri);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
