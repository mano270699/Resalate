import 'constants.dart';
import 'preference_manger.dart';

class TokenUtil {
  static String _token = '';

  static Future<void> loadTokenToMemory() async {
    _token =
        (await PreferenceManager.getInstance()!.getString(Constants.token)) ??
            '';
  }

  static Future<String> getTokenFromMemory() async {
    await loadTokenToMemory();
    return _token;
  }

  static void saveToken(String token) {
    PreferenceManager.getInstance()!.saveString(Constants.token, token);
    loadTokenToMemory();
  }

  static void clearToken() async {
    PreferenceManager.getInstance()!.remove(Constants.token);

    _token = '';
  }
}

class FCMTokenUtil {
  static String _token = '';

  static Future<void> loadFCMTokenToMemory() async {
    _token = (await PreferenceManager.getInstance()!
            .getString(Constants.fcmToken)) ??
        '';
  }

  static Future<String> getFCMTokenFromMemory() async {
    await loadFCMTokenToMemory();
    return _token;
  }

  static void saveFCMToken(String token) {
    PreferenceManager.getInstance()!.saveString(Constants.fcmToken, token);
    loadFCMTokenToMemory();
  }

  static void clearFCMToken() async {
    PreferenceManager.getInstance()!.remove(Constants.fcmToken);

    _token = '';
  }
}

class UserIdUtil {
  static String _userId = '';

  static Future<void> loadUserIdToMemory() async {
    _userId =
        (await PreferenceManager.getInstance()!.getString(Constants.userId)) ??
            '';
  }

  static Future<String> getUserIdFromMemory() async {
    await loadUserIdToMemory();
    return _userId;
  }

  static void saveUserId(String userID) {
    PreferenceManager.getInstance()!.saveString(Constants.userId, userID);
    loadUserIdToMemory();
  }

  static void clearUserId() {
    PreferenceManager.getInstance()!.remove(Constants.userId);
    _userId = '';
  }
}
