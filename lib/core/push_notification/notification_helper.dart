import 'dart:convert';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
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
    // --- Android Initialization ---
    const AndroidInitializationSettings androidInitialize =
        AndroidInitializationSettings('notification_icon'); // in res/drawable

    // --- iOS Initialization ---
    const DarwinInitializationSettings iOSInitialize =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    // --- Initialize Local Notifications ---
    await flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint("🔔 Local Notification Tapped!");
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            Map<String, dynamic> data = jsonDecode(response.payload!);
            _handleNotificationTap(data);
          } catch (e, s) {
            debugPrint('❌ Error decoding local notification payload: $e');
            debugPrint('   Stack trace: $s');
          }
        }
      },
    );

    // --- Explicit Android 13+ Notification Permission ---
    if (Platform.isAndroid) {
      final androidImpl =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();
    }

    // --- Request FCM Permissions ---
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.notification.request();
      if (kDebugMode) debugPrint("🔔 Android Notification Permission: $status");
    } else if (Platform.isIOS) {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (kDebugMode) {
        debugPrint(
            "📲 iOS Notification Permission: ${settings.authorizationStatus}");
      }
    }

    // --- Get FCM Token (and retry APNs if iOS) ---
    try {
      String? token;
      if (Platform.isIOS) {
        int attempts = 0;
        String? apnsToken;
        do {
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          if (kDebugMode) {
            debugPrint("🔁 Waiting for APNs token... attempt ${attempts + 1}");
          }
          await Future.delayed(const Duration(milliseconds: 500));
          attempts++;
        } while (apnsToken == null && attempts < 10);

        if (apnsToken == null) {
          debugPrint("❌ APNs token not available.");
        } else {
          debugPrint("✅ APNs token: $apnsToken");
        }
        token = await FirebaseMessaging.instance.getToken();
      } else {
        token = await FirebaseMessaging.instance.getToken();
      }

      if (kDebugMode) debugPrint("🔥 FCM Token: $token");

      if (token != null) {
        FCMTokenUtil.saveFCMToken(token);
        if (kDebugMode)
          debugPrint(
              "🔥 Saved FCM Token: ${await FCMTokenUtil.getFCMTokenFromMemory()}");
        // await _sendTokenToServer(token); // 🔥 send API request
      }
    } catch (e, stack) {
      debugPrint("❌ Error getting FCM token: $e");
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    // --- Subscribe to Topic ---
    await FirebaseMessaging.instance.subscribeToTopic("general");

    // --- Foreground Messages ---
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🟢 [onMessage] Foreground message received!');
      debugPrint('   Message data: ${message.data}');
      if (message.notification != null) {
        debugPrint('   Notification: ${message.notification!.title}');
      }
      NotificationHelper.showNotification(
          message, flutterLocalNotificationsPlugin, false);
    });

    // --- Background (app in background) ---
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🟡 [onMessageOpenedApp] Message clicked!');
      _handleNotificationTap(message.data);
    });
  }

  /// Send FCM token to your server
  // static Future<void> _sendTokenToServer(String token) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //           "https://masjid.super-coding.com/wp-json/collections/save-fcm-token?user_id=${await UserIdUtil.getUserIdFromMemory()}&fcm_token=$token"),
  //       body: {},
  //     );

  //     if (response.statusCode == 200) {
  //       debugPrint("✅ FCM token updated on server");
  //     } else {
  //       debugPrint("❌ Failed to update FCM token: ${response.body}");
  //     }
  //   } catch (e) {
  //     debugPrint("❌ Exception sending FCM token to server: $e");
  //   }
  // }

  // static Future<void> initialize(
  //     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  //   // --- Android Initialization ---
  //   const AndroidInitializationSettings androidInitialize =
  //       AndroidInitializationSettings(
  //           'notification_icon'); // Ensure this icon exists in res/drawable

  //   // --- iOS Initialization ---
  //   const DarwinInitializationSettings iOSInitialize =
  //       DarwinInitializationSettings(
  //     requestAlertPermission: true, // Request permissions when initializing
  //     requestBadgePermission: true,
  //     requestSoundPermission: true,
  //     // onDidReceiveLocalNotification: onDidReceiveLocalNotification // Optional: for older iOS foreground
  //   );

  //   const InitializationSettings initializationsSettings =
  //       InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

  //   // --- Request Android 13+ Permission Explicitly (if not done in main) ---
  //   // Consider doing this earlier (like in main.dart) for better UX
  //   if (Platform.isAndroid) {
  //     final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
  //         flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin>();
  //     await androidImplementation?.requestNotificationsPermission();
  //   }

  //   // --- Initialize Local Notifications Plugin ---
  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationsSettings,
  //     // --- Handler for when a user taps a LOCAL notification shown by this plugin ---
  //     onDidReceiveNotificationResponse: (NotificationResponse response) async {
  //       debugPrint("🔔 Local Notification Tapped!");
  //       debugPrint("   Payload: ${response.payload}");
  //       if (response.payload != null && response.payload!.isNotEmpty) {
  //         try {
  //           Map<String, dynamic> data = jsonDecode(response.payload!);
  //           _handleNotificationTap(data); // Use the common handler
  //         } catch (e, s) {
  //           debugPrint('❌ Error decoding local notification payload: $e');
  //           debugPrint('   Stack trace: $s');
  //         }
  //       } else {
  //         debugPrint(
  //             "   Local notification tapped, but payload was empty or null.");
  //       }
  //     },
  //     // --- Handler for older iOS versions when app is in foreground ---
  //     // onDidReceiveBackgroundNotificationResponse: (details) { ... } // For background actions
  //   );

  //   await FirebaseMessaging.instance.subscribeToTopic("general");

  //   // --- FCM Listeners ---
  //   // --- Listener for FOREGROUND messages ---
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     debugPrint('🟢 [onMessage] Foreground message received!');
  //     debugPrint('   Message data: ${message.data}');
  //     if (message.notification != null) {
  //       debugPrint(
  //           '   Message also contained a notification: ${message.notification!.title}');
  //     }

  //     // --- Show a local notification when app is in foreground ---
  //     // Decide if you want this on iOS too. If yes, remove the Platform check.
  //     // if (!Platform.isIOS) {  // REMOVE THIS if you want foreground notifications on iOS too
  //     NotificationHelper.showNotification(message,
  //         flutterLocalNotificationsPlugin, false); // Pass plugin instance
  //     // } else {
  //     //    debugPrint("   (iOS foreground: Not showing local notification via helper due to Platform check)");
  //     // }
  //   });

  //   // --- Listener for messages clicked when app is in BACKGROUND (not terminated) ---
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     debugPrint('🟡 [onMessageOpenedApp] Message clicked!');
  //     debugPrint('   Message data: ${message.data}');
  //     _handleNotificationTap(message.data); // Use the common handler
  //   });
  // }

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
  static Future<String?> _downloadAndSaveFile(
      // Return nullable string
      String url,
      String fileName) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName';
      final http.Response response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10)); // Add timeout

      if (response.statusCode == 200) {
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
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

// --- Model remains the same (ensure it exists) ---
// class NotificationBody {
//   final String? url;
//   final int? courseId;

//   NotificationBody({this.url, this.courseId});

//   factory NotificationBody.fromJson(Map<String, dynamic> json) {
//     return NotificationBody(
//       url: json['url'] as String?,
//       courseId: json['course_id'] as int?, // Adjust parsing if needed
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'url': url,
//       'course_id': courseId,
//     };
//   }
// }
