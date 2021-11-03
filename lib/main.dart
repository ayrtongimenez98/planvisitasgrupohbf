import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc-provider.dart';
import 'package:planvisitas_grupohbf/bloc/shared/global-bloc.dart';
import 'package:planvisitas_grupohbf/screens/login.dart';
import 'package:planvisitas_grupohbf/splash/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final GlobalBloc _globalBloc = GlobalBloc();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GlobalBloc>(
      bloc: _globalBloc,
      child: MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        title: 'Plan Visitas',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
