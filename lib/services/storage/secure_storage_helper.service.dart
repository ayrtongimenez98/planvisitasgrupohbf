import 'dart:convert';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/session-info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static final FlutterSecureStorage _storage = new FlutterSecureStorage();
  Future<SessionInfo> getSessionInfo() async {
    try {
      var value = await _storage?.read(key: "session");
      return value != null
          ? SessionInfo.fromJson(json.decode(value))
          : defaultSession;
    } catch (er) {
      await setSession(defaultSession);
      return defaultSession;
    }
  }

  Future<void> setSession(SessionInfo session) async {
    await _storage.write(key: "session", value: jsonEncode(session.toJson()));
  }

  Future<List<PlanSemanal>> getActivePlans() async {
    try {
      var value = await _storage.read(key: "activePlan");
      return value != null
          ? (json.decode(value) as List<dynamic>)
              .map((f) => PlanSemanal.fromJson(f))
              .toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<void> setActivePlans(List<PlanSemanal> orders) async {
    if (orders == null) {
      await removeActivePlans();
      return;
    }
    await _storage.write(
        key: "activePlan",
        value: orders != null
            ? jsonEncode(orders.map((f) => f.toJson()).toList())
            : null);
  }

  Future<void> removeActivePlans() async {
    await _storage.delete(key: "activePlan");
  }
}
