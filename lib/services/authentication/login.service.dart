import 'dart:convert';

import 'package:planvisitas_grupohbf/config/config.dart';
import 'package:planvisitas_grupohbf/models/session-info.dart';
import 'package:planvisitas_grupohbf/services/http_helpers/http.service.dart';

class LoginService {
  final String endPoint = Config.loginUrl;
  final HttpService http = HttpService();

  Future<SessionInfo> iniciarSesion(String userName, String pass) async {
    var body = {"Username": userName, "Password": pass};

    try {
      final response = await http.post(Uri.parse(endPoint), body: body);
      if (response.statusCode == 200) {
        var result = json.decode(response.body) as dynamic;
        return SessionInfo.fromJson(result);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
