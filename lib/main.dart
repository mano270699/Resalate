import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:resalate/firebase_options.dart';
import 'core/base/dependency_injection.dart' as di;
import 'core/base/main_app.dart';
import 'core/push_notification/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await di.init();

  await NotificationHelper.initialize(flutterLocalNotificationsPlugin);

  runApp(const MainApp());
}
