# Firebase Messaging
-keep class io.flutter.plugins.firebase.messaging.** { *; }
-dontwarn io.flutter.plugins.firebase.messaging.**

# WorkManager (used internally by Firebase Messaging)
-keep class androidx.work.impl.** { *; }
-dontwarn androidx.work.**

# Keep Flutter generated classes
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.engine.**
