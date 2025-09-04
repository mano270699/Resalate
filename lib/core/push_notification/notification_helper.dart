import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../common/config.dart'; // Ensure this path is correct
// import '../util/environment/environment.dart'; // Ensure this path is correct
import '../util/token_util.dart';
import 'model/notification_body.dart';

class NotificationHelper {
  // --- Call this function from your main screen's initState or similar ---
  // --- It handles the case where the app is opened from a terminated state ---
  // --- by tapping a notification. ---

  static bool isFromNotifiction = false;

  static void handleInitialMessage() async {
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint(
          "🟢 [getInitialMessage] App launched via terminated notification.");
      _handleNotificationTap(initialMessage.data); // Use a common handler
    } else {
      debugPrint("🟡 [getInitialMessage] No initial message found.");
    }
  }

  // --- Common handler for navigating/acting based on notification data ---
  // --- Used by getInitialMessage, onMessageOpenedApp, onDidReceiveNotificationResponse ---
  static void _handleNotificationTap(Map<String, dynamic> data) {
    debugPrint("➡️ Handling Notification Tap Data: $data");
    // NotificationBody notificationBody = convertNotification(data);
    // debugPrint("➡️ Converted Notification Body: ${notificationBody.toJson()}");

    // Ensure the navigator is ready before pushing routes
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (Environment.navigatorKey.currentState != null) {
    //     if (notificationBody.courseId != null) {
    //       isFromNotifiction = true;
    //       debugPrint(
    //           "➡️ Navigating to CourseDetailsScreen with ID: ${notificationBody.courseId}");
    //       // Environment.navigatorKey.currentState!.pushNamed(
    //       //     CourseDetailsScreen.routeName, // Make sure this route is defined
    //       //     arguments: {"id": notificationBody.courseId});
    //     } else if (notificationBody.url != null &&
    //         notificationBody.url!.isNotEmpty) {
    //       // isFromNotifiction = true;
    //       debugPrint("➡️ Launching URL: ${notificationBody.url}");
    //       _launchUrl(notificationBody.url!);
    //     } else {
    //       debugPrint(
    //           "➡️ Notification tap data lacks actionable 'course_id' or 'url'. Data: $data");
    //       // Optional: Navigate to a default screen like notifications list
    //     }
    //   } else {
    //     debugPrint(
    //         "❌ Navigator state is null when handling tap. Cannot navigate.");
    //     // Optionally queue the action if this happens frequently
    //   }
    // });
  }

  static void whenTerminated(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {
        _handleNotificationTap(initialMessage.data);
      } else {
        isFromNotifiction = false;
      }
    });
  }

  // static Future<void> _launchUrl(String urlString) async {
  //   final Uri? url = Uri.tryParse(urlString); // Use tryParse for safety
  //   if (url != null) {
  //     try {
  //       bool launched =
  //           await launchUrl(url, mode: LaunchMode.externalApplication);
  //       if (!launched) {
  //         debugPrint('❌ Could not launch $urlString');
  //       } else {
  //         debugPrint('✅ Launched URL: $urlString');
  //       }
  //     } catch (e) {
  //       debugPrint('❌ Error launching URL $urlString: $e');
  //     }
  //   } else {
  //     debugPrint('❌ Invalid URL format for launch: $urlString');
  //   }
  // }
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    // --- Local Notifications Initialization ---
    const androidInit = AndroidInitializationSettings('notification_icon');
    const iOSInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings =
        InitializationSettings(android: androidInit, iOS: iOSInit);

    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (response) async {
      if (response.payload != null && response.payload!.isNotEmpty) {
        final data = jsonDecode(response.payload!);
        _handleNotificationTap(data);
      }
    });

    // --- iOS permission ---
    if (Platform.isIOS) {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint(
          "📲 iOS Notification Permission: ${settings.authorizationStatus}");
    }

    // --- Wait for APNs token ---
    if (Platform.isIOS) {
      String? apnsToken;
      int attempts = 0;
      while (apnsToken == null && attempts < 20) {
        // wait up to ~10s
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
      }

      if (apnsToken == null) {
        debugPrint("❌ Still no APNs token after waiting.");
        return; // 🔴 Stop here, don’t call getToken()
      } else {
        debugPrint("✅ Got APNs token: $apnsToken");
      }
    }

    // --- Now safe to fetch FCM token ---
    try {
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint("🔥 FCM Token: $token");
      if (token != null) {
        FCMTokenUtil.saveFCMToken(token);
      }

      // Subscribe only when token exists
      await FirebaseMessaging.instance.subscribeToTopic("general");
    } catch (e, s) {
      debugPrint("❌ Error getting FCM token: $e");
      FirebaseCrashlytics.instance.recordError(e, s);
    }

    // --- FCM Listeners ---
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🟢 Foreground message: ${message.data}');
      showNotification(message, flutterLocalNotificationsPlugin, false);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🟡 Message clicked!');
      _handleNotificationTap(message.data);
    });
  }

  // --- Function to display the local notification ---
  static Future<void> showNotification(RemoteMessage message,
      FlutterLocalNotificationsPlugin fln, bool isBackgroundData) async {
    // --- Prioritize data payload for content consistency ---
    Map<String, dynamic> dataPayload = message.data;
    RemoteNotification? notificationPayload = message.notification;

    String? title = dataPayload['title'] ?? notificationPayload?.title;
    String? body = dataPayload['body'] ?? notificationPayload?.body;
    String? imageUrl =
        dataPayload['image']; // Get image URL primarily from data

    // Construct full image URL if necessary (adjust logic as needed)
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        !imageUrl.startsWith('http')) {
      imageUrl =
          '${Config.baseUrl}/storage/app/public/notification/$imageUrl'; // Ensure Config.baseUrl is correct
    }

    // If image wasn't in data, try getting it from platform-specific notification payload
    if ((imageUrl == null || imageUrl.isEmpty) && notificationPayload != null) {
      String? platformImageUrl;
      if (Platform.isAndroid && notificationPayload.android?.imageUrl != null) {
        platformImageUrl = notificationPayload.android!.imageUrl;
      } else if (Platform.isIOS &&
          notificationPayload.apple?.imageUrl != null) {
        platformImageUrl = notificationPayload.apple!.imageUrl;
      }

      if (platformImageUrl != null && platformImageUrl.isNotEmpty) {
        imageUrl = platformImageUrl.startsWith('http')
            ? platformImageUrl
            : '${Config.baseUrl}/storage/app/public/notification/$platformImageUrl';
      }
    }

    // We need title and body to show anything
    if (title == null || body == null) {
      debugPrint("❌ Cannot show notification: Title or Body is missing.");
      debugPrint("   Data: $dataPayload");
      debugPrint("   Notification: ${notificationPayload?.toMap()}");
      return;
    }

    // Use the data payload for the local notification's payload (for tap handling)
    NotificationBody notificationBody = convertNotification(dataPayload);
    String payloadJson = jsonEncode(notificationBody.toJson());

    try {
      if (imageUrl != null && imageUrl.isNotEmpty) {
        debugPrint(
            "   Attempting to show Big Picture Notification with image: $imageUrl");
        await showBigPictureNotificationHiddenLargeIcon(
            title, body, notificationBody, imageUrl, fln, payloadJson);
      } else {
        debugPrint("   Attempting to show Big Text Notification (no image)");
        await showBigTextNotification(
            title, body, notificationBody, fln, payloadJson);
      }
    } catch (e, s) {
      debugPrint("❌ Error displaying local notification: $e");
      debugPrint("   Stack trace: $s");
      // Fallback to a simple text notification on error
      await showTextNotification(
          title, "Error displaying details.", null, fln, null);
    }
  }

  // --- Simplified showTextNotification ---
  static Future<void> showTextNotification(
      String title,
      String body,
      NotificationBody? notificationBody, // Keep for potential direct use
      FlutterLocalNotificationsPlugin fln,
      String? payload // Use pre-encoded payload string
      ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Resalate_channel_id', // Use a unique ID
      'Resalate Notifications', // Channel Name
      channelDescription:
          'Channel for Resalate app notifications', // Channel Description
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      sound: RawResourceAndroidNotificationSound(
          'notification'), // Ensure 'notification.mp3' etc. is in android/app/src/main/res/raw
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(
        DateTime.now().millisecondsSinceEpoch.toUnsigned(30), // Use unique ID
        title,
        body,
        platformChannelSpecifics,
        payload: payload);
  }

  // --- Simplified showBigTextNotification ---
  static Future<void> showBigTextNotification(
      String title,
      String body,
      NotificationBody notificationBody,
      FlutterLocalNotificationsPlugin fln,
      String payload // Use pre-encoded payload string
      ) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true, // Be cautious if body isn't always HTML
      contentTitle: title,
      htmlFormatContentTitle: true, // Be cautious if title isn't always HTML
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'dentopia_channel_id', // Use the same unique ID
      'Dentopia Notifications', // Channel Name
      channelDescription:
          'Channel for Dentopia app notifications', // Channel Description
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.max,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(
        DateTime.now().millisecondsSinceEpoch.toUnsigned(31), // Use unique ID
        title,
        body,
        platformChannelSpecifics,
        payload: payload);
  }

  // --- Simplified showBigPictureNotification ---
  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      String title,
      String body,
      NotificationBody notificationBody,
      String imageUrl,
      FlutterLocalNotificationsPlugin fln,
      String payload // Use pre-encoded payload string
      ) async {
    debugPrint("   Downloading image for notification: $imageUrl");
    String? largeIconPath;
    String? bigPicturePath;
    try {
      largeIconPath = await _downloadAndSaveFile(imageUrl, 'largeIcon');
      bigPicturePath = await _downloadAndSaveFile(imageUrl, 'bigPicture');
    } catch (e) {
      debugPrint("❌ Error downloading image for notification: $e");
      // Fallback to BigText notification if image fails
      await showBigTextNotification(
          title, body, notificationBody, fln, payload);
      return;
    }

    // Ensure paths are not null after download attempt
    if (largeIconPath == null || bigPicturePath == null) {
      debugPrint("❌ Failed to get valid paths for downloaded images.");
      await showBigTextNotification(
          title, body, notificationBody, fln, payload);
      return;
    }

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon:
          FilePathAndroidBitmap(largeIconPath), // Show icon in collapsed view
      hideExpandedLargeIcon:
          false, // Set true if you want ONLY the picture when expanded
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: body, // This is the text shown when expanded
      htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'dentopia_channel_id_big_picture', // Use a different ID for picture channel if desired
      'Dentopia Image Notifications', // Channel Name
      channelDescription:
          'Channel for Dentopia notifications with images', // Channel Description
      // largeIcon: FilePathAndroidBitmap(largeIconPath), // Already set in style
      priority: Priority.max,
      playSound: true,
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(
        DateTime.now().millisecondsSinceEpoch.toUnsigned(31), // Use unique ID
        title,
        body,
        platformChannelSpecifics, // Body here is for the collapsed view
        payload: payload);
  }

  // --- Added error handling ---
  // static Future<String?> _downloadAndSaveFile(
  //     // Return nullable string
  //     String url,
  //     String fileName) async {
  //   try {
  //     final Directory directory = await getApplicationDocumentsDirectory();
  //     final String filePath = '${directory.path}/$fileName';
  //     final http.Response response = await http
  //         .get(Uri.parse(url))
  //         .timeout(const Duration(seconds: 10)); // Add timeout

  //     if (response.statusCode == 200) {
  //       final File file = File(filePath);
  //       await file.writeAsBytes(response.bodyBytes);
  //       debugPrint("   ✅ Image downloaded and saved to: $filePath");
  //       return filePath;
  //     } else {
  //       debugPrint(
  //           "❌ Failed to download file: Status code ${response.statusCode} for URL $url");
  //       return null;
  //     }
  //   } catch (e) {
  //     debugPrint("❌ Exception downloading or saving file from $url: $e");
  //     return null; // Return null on error
  //   }
  // }

  static Future<String?> _downloadAndSaveFile(
      String url, String fileName) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName';

      final Dio dio = Dio();

      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes, // Get bytes for file saving
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final File file = File(filePath);
        await file.writeAsBytes(response.data!);
        debugPrint("   ✅ Image downloaded and saved to: $filePath");
        return filePath;
      } else {
        debugPrint(
            "❌ Failed to download file: Status code ${response.statusCode} for URL $url");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Exception downloading or saving file from $url: $e");
      return null; // Return null on error
    }
  }

  // --- Fixed and safer conversion ---
  static NotificationBody convertNotification(Map<String, dynamic> data) {
    String? url;
    int? courseId;

    if (data.containsKey('url') && data['url'] != null) {
      url = data['url'].toString();
    }

    if (data.containsKey('course_id') && data['course_id'] != null) {
      courseId = int.tryParse(data['course_id'].toString());
      if (courseId == null) {
        debugPrint("⚠️ Could not parse course_id: '${data['course_id']}'");
      }
    }

    // Prioritize courseId if both are present? Adjust if needed.
    if (courseId != null) {
      return NotificationBody(
          courseId: courseId, url: null); // Clear URL if courseId is primary
    } else if (url != null && url.isNotEmpty) {
      return NotificationBody(courseId: null, url: url);
    } else {
      debugPrint(
          "ℹ️ Notification data contains neither valid 'url' nor 'course_id'. Data: $data");
      return NotificationBody(courseId: null, url: null); // Fallback
    }
  }
}
