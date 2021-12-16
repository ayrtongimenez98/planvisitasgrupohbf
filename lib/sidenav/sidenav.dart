import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planvisitas_grupohbf/bloc/session-bloc/session-bloc.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc-provider.dart';
import 'package:planvisitas_grupohbf/bloc/shared/global-bloc.dart';
import 'package:planvisitas_grupohbf/models/session-info.dart';
import 'package:planvisitas_grupohbf/screens/clientes/listaClientes.dart';
import 'package:planvisitas_grupohbf/screens/login.dart';
import 'package:planvisitas_grupohbf/screens/plansemanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/screens/sync/sincronizar-datos.dart';
import 'package:planvisitas_grupohbf/screens/vencimiento/lista_vencimientos.dart';
import 'package:planvisitas_grupohbf/screens/visitas/lista-visitas.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  SessionBloc _sessionBloc;
  SessionInfo session = defaultSession;

  final _storage = const FlutterSecureStorage();

  String name = "Lucia Galeano", phoneNumber = "", initials = "";

  @override
  void initState() {
    super.initState();

    _sessionBloc = BlocProvider.of<GlobalBloc>(context).sessionBloc;
    session = _sessionBloc.currentSession;
    setState(() {
      name = session.Nombre;
      initials = getInitials(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF74CCBB)),
                  accountName: Text(
                    name,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                  ),
                  accountEmail: Text(
                    phoneNumber,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(initials,
                        style:
                            TextStyle(color: Color(0xFF74CCBB), fontSize: 30)),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.assignment_ind),
                  title: Text("Clientes", style: TextStyle(fontSize: 15.0)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListaClientes()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text("Historial de Visitas"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListaVisitasPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.timeline),
                  title: Text("Plan Semanal"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PlanSemanalPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.assessment),
                  title: Text("Estadisticas"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.sync),
                  title: Text("Sincronizar"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SincronizarDatosPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.texture),
                  title: Text("Vencimiento Productos"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListaVencimientosPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.close),
                  title: Text("Cerrar sesión"),
                  onTap: () {
                    _storage.delete(key: "session").then((value) =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen())));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
            child: Container(
                // This align moves the children to the bottom
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    // This container holds all the children that will be aligned
                    // on the bottom and should not scroll with the above ListView
                    child: Container(
                        child: Column(
                      children: <Widget>[
                        Divider(),
                        Container(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              ' v0.0.1-dev',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      ],
                    )))),
          ),
        ],
      ),
    );
  }
}

String getInitials(string) {
  var names = string.split(' '),
      initials = names[0].substring(0, 1).toUpperCase();

  if (names.length > 1) {
    initials += names[names.length - 1].substring(0, 1).toUpperCase();
  }
  return initials;
}
