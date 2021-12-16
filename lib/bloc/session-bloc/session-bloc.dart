import 'dart:async';
import 'package:planvisitas_grupohbf/bloc/shared/bloc.dart';
import 'package:planvisitas_grupohbf/models/session-info.dart';
import 'package:planvisitas_grupohbf/services/authentication/login.service.dart';
import 'package:planvisitas_grupohbf/services/storage/secure_storage_helper.service.dart';
import 'package:planvisitas_grupohbf/services/storage/shared_preferences_helper.dart';

class SessionBloc implements Bloc {
  LoginService _service = LoginService();
  SessionInfo session = defaultSession;
  SecureStorageHelper helper = new SecureStorageHelper();
  SessionInfo get currentSession => session;
  final _sessionInfoController = StreamController<SessionInfo>.broadcast();
  Stream<SessionInfo> get sessionStream => _sessionInfoController.stream;

  SessionBloc() {
    helper = new SecureStorageHelper();
  }

  Future<void> getUser({SessionInfo info}) async {
    if (info != null) {
      session = info;
    } else {
      session = await helper.getSessionInfo();
    }

    await saveSession();
  }

  Future<bool> validateSession() async {
    try {
      if (session.Usuario_Id != 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String userName, String pass) async {
    var loginInfo = await _service.iniciarSesion(userName, pass);
    if (loginInfo != null) {
      session = loginInfo;
      await saveSession();
      return true;
    } else {
      return false;
    }
  }

  Future<void> removeSession() async {
    session = defaultSession;
    await saveSession();
  }

  Future<void> saveSession() async {
    _sessionInfoController.add(session);
    await helper.setSession(session);
  }

  @override
  void dispose() {
    _sessionInfoController.close();
  }
}
