import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resalate/firebase_options.dart';
import 'core/base/dependency_injection.dart' as di;
import 'core/base/main_app.dart';
import 'core/push_notification/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  if (kDebugMode) {
    print("📩 Background message: ${message.messageId}");
    print("📦 Data: ${message.data}");
    if (message.notification != null) {
      print(
          "🔔 Notification: ${message.notification!.title}/${message.notification!.body}");
    }
  }

  // To display notifications for data-only messages in the background/terminated state
  final FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();

  // Initialize the plugin in the background isolate to provide the default icon.
  // Without this, showing a notification without an explicit icon will crash with 'no valid small icon'.
  const androidInit = AndroidInitializationSettings('notification_icon');
  const iOSInit = DarwinInitializationSettings();
  await fln.initialize(
      const InitializationSettings(android: androidInit, iOS: iOSInit));

  // Make sure not to duplicate notifications if FCM already shows them for messages with 'notification' payload
  // However, it's safer to always show it if the backend relies on data-only push notifications, OR if we want to ensure our custom styles.
  // Actually, if message.notification != null, FCM system tray will show it automatically. To prevent double showing:
  if (message.notification == null) {
    await NotificationHelper.showNotification(message, fln, true);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await di.init();
  // Local notification setup also requests iOS notification permission.
  await NotificationHelper.initialize(flutterLocalNotificationsPlugin);

  if (Platform.isAndroid) {
    PermissionStatus status = await Permission.notification.request();
    if (kDebugMode) print("🔔 Android Notification Permission: $status");
  }

  runApp(const MainApp());
}
