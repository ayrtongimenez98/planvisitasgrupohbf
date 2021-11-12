import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:planvisitas_grupohbf/bloc/hoja-de-ruta-bloc/hoja-de-ruta-bloc.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc-provider.dart';
import 'package:planvisitas_grupohbf/bloc/shared/global-bloc.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/screens/visitas/detalleVisitaPorMarcar.dart';
import 'package:planvisitas_grupohbf/services/hoja-de-ruta/hoja-de-ruta.service.dart';
import 'package:intl/intl.dart';

class VisitasAMarcarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VisitasAMarcarPageState();
  }
}

class _VisitasAMarcarPageState extends State<VisitasAMarcarPage>
    with WidgetsBindingObserver {
  List<PlanSemanal> planes = [];
  PlanSemanalBloc _planSemanalBloc;
  bool refresh = true;
  StreamSubscription planSemanalSubscription;

  bool loading = false;

  @override
  void initState() {
    loading = true;
    super.initState();

    _planSemanalBloc = BlocProvider.of<GlobalBloc>(context).planSemanalBloc;
    planes = _planSemanalBloc.currentList;
    _planSemanalBloc.getPlanDia();
    planSemanalSubscription = _planSemanalBloc.planStream.listen((data) async {
      setState(() {
        planes = data.where((element) => element.Estado == "N").toList();
        loading = false;
      });
    });
  }

  @override
  dispose() {
    planSemanalSubscription.cancel();
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
      content: Text("Desea confirmar entrada?"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xFF74CCBB),
              ),
            )
          : Column(children: [
              Divider(color: Colors.grey, height: 1),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: planes?.length,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      "${new DateFormat('dd/MM/yyyy').format(planes[index].PlanSemanal_Horario.toLocal())}",
                                      style: TextStyle(fontSize: 20)),
                                  Text(
                                      "${new DateFormat('HH:mm').format(planes[index].PlanSemanal_Horario.toLocal())}",
                                      style: TextStyle(fontSize: 20))
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
                                      child: Text(
                                          "${planes[index].SucursalDireccion}"),
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
                                    child: Text(
                                        "${planes[index].Cliente_RazonSocial}"),
                                  )
                                ],
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FlatButton(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Icon(Icons.location_on),
                                      Text("Visitar")
                                    ],
                                  ),
                                  onPressed: () {
                                    showAlertDialog(context);
                                  },
                                  color: Colors.white,
                                  textColor: Color(0xFF8C44C0),
                                ),
                                FlatButton(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Icon(Icons.info),
                                      Text("  Datos")
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VisitasAMarcarViewPage(
                                                  visitasAMarcar: planes[index],
                                                  visitasAMarcarId:
                                                      planes[index]
                                                          .PlanSemanalId,
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
