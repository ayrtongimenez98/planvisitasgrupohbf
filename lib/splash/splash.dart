import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:planvisitas_grupohbf/bloc/session-bloc/session-bloc.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc-provider.dart';
import 'package:planvisitas_grupohbf/bloc/shared/global-bloc.dart';
import 'package:planvisitas_grupohbf/models/session-info.dart';
import 'package:planvisitas_grupohbf/screens/dashboard.dart';
import 'package:planvisitas_grupohbf/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      var session = prefs.getString('session');
      SessionInfo info;
      if (session != null) {
        info = SessionInfo.fromJson(json.decode(session));
      } else {
        info = defaultSession;
      }
      onDoneLoading(info.Usuario_Id != 0);
    });
  }

  onDoneLoading(bool value) {
    if (value) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          "assets/logos/logo.png",
          fit: BoxFit.fitHeight,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
