import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:planvisitas_grupohbf/bloc/shared/global-bloc.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/screens/visitas/detalleVisitaPorMarcar.dart';

class VisitasAMarcarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VisitasAMarcarPageState();
  }
}

class _VisitasAMarcarPageState extends State<VisitasAMarcarPage>
    with WidgetsBindingObserver {
  List<PlanSemanal> planes = [];

  bool refresh = true;

  bool activeOrder = false;
  bool _isConnected = false;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((connectionResult) {
      _isConnected = connectionResult != ConnectivityResult.none;
      if ((_connectivityResult == ConnectivityResult.wifi ||
              _connectivityResult == ConnectivityResult.mobile) &&
          (connectionResult == ConnectivityResult.wifi ||
              connectionResult == ConnectivityResult.mobile)) {
        _connectivityResult = connectionResult;
        return;
      }

      _connectivityResult = connectionResult;
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () async {},
    );

    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confimar"),
      content: Text("Desea confirmar visita?"),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Color renderHubStateColor() {
    return Colors.green;
  }

  Widget renderHubState() {
    return Text("Conectado");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
          child: Padding(
              child: Row(children: [
                Icon(
                  Icons.radio_button_checked,
                  color: renderHubStateColor(),
                  size: 15,
                ),
                renderHubState()
              ]),
              padding: EdgeInsets.only(top: 10, left: 10)),
        ),
        Divider(color: Colors.grey, height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: 2,
            itemBuilder: (_, index) {
              return Card(
                borderOnForeground: true,
                clipBehavior: Clip.hardEdge,
                color: Colors.white,
                child: Container(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("27/10/2021", style: TextStyle(fontSize: 20)),
                            Text("10:00", style: TextStyle(fontSize: 20))
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15, bottom: 15),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.map),
                            Flexible(
                              child: Padding(
                                child: Text("Avenida Caaguazu c/ Calle Colon"),
                                padding: EdgeInsets.only(left: 10),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.format_list_bulleted),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text('BIGGIE EXPRESS'),
                            )
                          ],
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.check),
                                Text("Aceptar")
                              ],
                            ),
                            onPressed: () {
                              showAlertDialog(context);
                            },
                            color: Colors.white,
                            textColor: Colors.green,
                          ),
                          FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.info_outline),
                                Text("  Info")
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => VisitasAMarcarViewPage(
                                        visitasAMarcar: PlanSemanal(),
                                        visitasAMarcarId: 0,
                                      )));
                            },
                            color: Colors.white,
                            textColor: Colors.black,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _orderBloc {}
