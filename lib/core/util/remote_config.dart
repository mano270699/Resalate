import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  late final FirebaseRemoteConfig _remoteConfig;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval:
              kDebugMode ? Duration.zero : const Duration(hours: 12),
        ),
      );

      await _remoteConfig.setDefaults({
        'show_google_auth': false,
      });

      await _remoteConfig.fetchAndActivate().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint(
            '[RemoteConfig] ⚠️ fetchAndActivate timed out, using defaults',
          );
          return false;
        },
      );

      _initialized = true;

      _listenToUpdates();
    } on FirebaseException catch (e) {
      debugPrint('[RemoteConfig] Firebase error: ${e.code} — ${e.message}');
      _initialized = true;
    } catch (e) {
      debugPrint('[RemoteConfig] Initialization failed: $e');
      _initialized = true;
    }
  }

  // Real-time listener for instant maintenance/update toggling
  void _listenToUpdates() {
    _remoteConfig.onConfigUpdated.listen(
      (_) async {
        await _remoteConfig.activate();
        debugPrint('[RemoteConfig] 🔄 Real-time update activated');
      },
      onError: (e) {
        debugPrint('[RemoteConfig] Real-time listener error: $e');
      },
    );
  }

  /// Public method for retry buttons (e.g. maintenance screen)
  Future<void> refreshConfig() async {
    try {
      await _remoteConfig.fetch();
      await _remoteConfig.activate();
    } catch (e) {
      debugPrint('[RemoteConfig] Refresh failed: $e');
    }
  }

  // ─── Auth ───
  bool get showGoogleAuth => _remoteConfig.getBool('show_google_auth');
}
