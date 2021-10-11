import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/utilities/constants.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _rememberMe = false;

  bool passwordVisible = false;

  @override
  void initState() {
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF74CCBB),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.sync),
                onPressed: () {},
              )
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.assignment),
                ),
                Tab(icon: Icon(Icons.assignment_turned_in)),
              ],
            ),
            title: Text("Sucursales"),
          ),
          body: TabBarView(
            children: [
              Container(),
              Container(),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
