import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planvisitas_grupohbf/models/session-info.dart';
import 'package:planvisitas_grupohbf/screens/login.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  SessionInfo session = defaultSession;
  String name = "Lucia Galeano", phoneNumber = "";

  @override
  void initState() {
    setState(() {});
    super.initState();
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
                    "Lucia Galeano",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                  ),
                  accountEmail: Text(
                    phoneNumber,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text("LG",
                        style:
                            TextStyle(color: Color(0xFF74CCBB), fontSize: 30)),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.assignment_ind),
                  title: Text("Clientes", style: TextStyle(fontSize: 15.0)),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text("Historial de Visitas"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.timeline),
                  title: Text("Plan Semanal"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.assessment),
                  title: Text("Estadisticas"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.close),
                  title: Text("Cerrar sesión"),
                  onTap: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
                              ' v2.0.0-dev',
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
