import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planvisitas_grupohbf/bloc/hoja-de-ruta-bloc/hoja-de-ruta-bloc.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc-provider.dart';
import 'package:planvisitas_grupohbf/bloc/shared/global-bloc.dart';
import 'package:planvisitas_grupohbf/bloc/visitas-bloc/visitas.bloc.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasMarcadas.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasMarcadasOffline.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasPorMarcar.dart';
import 'package:planvisitas_grupohbf/sidenav/sidenav.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _rememberMe = false;
  PlanSemanalBloc _planSemanalBloc;
  VisitasBloc _visitasBloc;
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _planSemanalBloc = BlocProvider.of<GlobalBloc>(context).planSemanalBloc;
    _visitasBloc = BlocProvider.of<GlobalBloc>(context).visitasBloc;
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: SideMenu(),
          appBar: AppBar(
            backgroundColor: const Color(0xFF74CCBB),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.sync),
                onPressed: () async {
                  await _planSemanalBloc.getPlanDiaServidor();
                  await _visitasBloc.getVisitasServidor();
                },
              )
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.assignment),
                ),
                Tab(icon: Icon(Icons.assignment_turned_in)),
                Tab(icon: Icon(Icons.wifi_off_outlined)),
              ],
              indicatorColor: Color(0xFF8C44C0),
            ),
            title: const Text("Visitas"),
          ),
          body: TabBarView(
            children: [
              VisitasAMarcarPage(),
              VisitasMarcadasPage(),
              VisitasMarcadasOfflinePage()
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
