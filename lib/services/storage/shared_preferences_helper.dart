import 'dart:convert';
import 'package:planvisitas_grupohbf/models/session-info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  Future<SessionInfo> getSessionInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var value = prefs.getString('session');
      return value != null
          ? SessionInfo.fromJson(json.decode(value))
          : defaultSession;
    } catch (er) {
      await setSession(defaultSession);
      return defaultSession;
    }
  }

  Future<void> setSession(SessionInfo session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session', jsonEncode(session.toJson()));
  }
}
