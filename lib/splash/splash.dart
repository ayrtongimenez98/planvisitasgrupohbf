import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:planvisitas_grupohbf/bloc/session-bloc/session-bloc.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc-provider.dart';
import 'package:planvisitas_grupohbf/bloc/shared/global-bloc.dart';
import 'package:planvisitas_grupohbf/screens/dashboard.dart';
import 'package:planvisitas_grupohbf/screens/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  SessionBloc _sessionBloc;

  @override
  void initState() {
    super.initState();
    _sessionBloc = BlocProvider.of<GlobalBloc>(context).sessionBloc;

    Connectivity().checkConnectivity().then((connectionResult) {
      if (connectionResult == ConnectivityResult.mobile ||
          connectionResult == ConnectivityResult.wifi) {
        _sessionBloc.validateSession().then((value) {
          onDoneLoading(value);
        });
      } else {
        onDoneLoading(true);
      }
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
