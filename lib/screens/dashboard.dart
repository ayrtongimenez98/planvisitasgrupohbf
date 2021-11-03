import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasMarcadas.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasPorMarcar.dart';
import 'package:planvisitas_grupohbf/sidenav/sidenav.dart';

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
          drawer: SideMenu(),
          appBar: AppBar(
            backgroundColor: const Color(0xFF74CCBB),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.sync),
                onPressed: () {},
              )
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.assignment),
                ),
                Tab(icon: Icon(Icons.assignment_turned_in)),
              ],
              indicatorColor: Color(0xFF8C44C0),
            ),
            title: const Text("Visitas"),
          ),
          body: TabBarView(
            children: [
              VisitasAMarcarPage(),
              VisitasMarcadasPage(),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
