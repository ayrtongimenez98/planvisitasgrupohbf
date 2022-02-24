import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:planvisitas_grupohbf/bloc/hoja-de-ruta-bloc/hoja-de-ruta-bloc.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc-provider.dart';
import 'package:planvisitas_grupohbf/bloc/shared/global-bloc.dart';
import 'package:planvisitas_grupohbf/bloc/visitas-offline-bloc/visitas-offline.bloc.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/shared/system-validation-model.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-upsert-model.dart';
import 'package:planvisitas_grupohbf/screens/visitas/detalleVisitaPorMarcar.dart';
import 'package:planvisitas_grupohbf/services/hoja-de-ruta/hoja-de-ruta.service.dart';
import 'package:intl/intl.dart';
import 'package:planvisitas_grupohbf/services/visitas/visitas.service.dart';
import 'package:progress_dialog/progress_dialog.dart';

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
  VisitasOfflineBloc visitasOfflineBloc;
  bool refresh = true;
  StreamSubscription planSemanalSubscription;
  Location location = new Location();
  bool loading = false;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  StreamSubscription connectivitySubscription;
  var connectivity = false;
  VisitasService visitasService;
  @override
  void initState() {
    super.initState();
    location = new Location();
    visitasService = VisitasService();
    location.hasPermission().then((value) => _permissionGranted = value);
    getLocation();
    loading = true;

    _planSemanalBloc = BlocProvider.of<GlobalBloc>(context).planSemanalBloc;
    visitasOfflineBloc =
        BlocProvider.of<GlobalBloc>(context).visitasOfflineBloc;
    planes = _planSemanalBloc.currentList.Listado;
    _planSemanalBloc.getPlanDiaLocal();
    planSemanalSubscription = _planSemanalBloc.planStream.listen((data) async {
      setState(() {
        planes = data.Listado;
        loading = false;
      });
    });

    Connectivity().checkConnectivity().then((data) {
      if (data == ConnectivityResult.mobile ||
          data == ConnectivityResult.wifi) {
        connectivity = true;
      } else {
        connectivity = false;
      }
    });

    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((connectionResult) {
      if (connectionResult == ConnectivityResult.mobile ||
          connectionResult == ConnectivityResult.wifi) {
        connectivity = true;
      } else {
        connectivity = false;
      }
    });
  }

  getLocation() {
    location.getLocation().then((value) async {
      _locationData = value;
    });
  }

  @override
  dispose() {
    super.dispose();
    planSemanalSubscription.cancel();
    connectivitySubscription.cancel();
  }

  showNoticeDialog(BuildContext context, SystemValidationModel model) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(model.Success ? "Confirmado" : "Error"),
      content: Text(model.Message),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context, VisitaUpsertModel model) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () async {
        final ProgressDialog pr = ProgressDialog(context);
        pr.show();
        if (connectivity) {
          visitasService.agregarEntrada(model).then((value) async {
            pr.hide();
            showNoticeDialog(context, value);
          });
        } else {
          visitasOfflineBloc.agregarNuevaVisita(model).then((value) {
            pr.hide();
            showNoticeDialog(
                context,
                new SystemValidationModel(
                    Success: true, Message: "Agregado con éxito sin conexión"));
          });
        }
      },
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
                              padding: EdgeInsets.only(left: 15, bottom: 15),
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
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Row(
                                children: <Widget>[
                                  Icon(planes[index].Estado == 'N'
                                      ? Icons.clear
                                      : Icons.check),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(
                                        "${planes[index].Estado == 'N' ? 'Sin marcar' : 'Marcado'}"),
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
                                    if (planes[index].Estado == 'N') {
                                      var plan = new VisitaUpsertModel(
                                          Ciudad: planes[index].SucursalCiudad,
                                          Cliente:
                                              planes[index].Cliente_RazonSocial,
                                          Cliente_Cod:
                                              planes[index].Cliente_Cod,
                                          Direccion:
                                              planes[index].SucursalDireccion,
                                          Estado_Id: 1,
                                          Motivo_Id: 1,
                                          Sucursal_Id: planes[index].SucursalId,
                                          Vendedor_Id: 0,
                                          Visita_fecha: new DateTime.now(),
                                          Visita_Hora_Entrada:
                                              new DateTime.now(),
                                          Visita_Hora_Salida:
                                              new DateTime.now(),
                                          Visita_Id: 0,
                                          Visita_Observacion: "",
                                          Visita_Ubicacion_Entrada:
                                              _locationData != null
                                                  ? "${_locationData.latitude},${_locationData.longitude}"
                                                  : "",
                                          Visita_Ubicacion_Salida: "");
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VisitasAMarcarViewPage(
                                                    visitasAMarcar: plan,
                                                    visitasAMarcarId:
                                                        plan.Visita_Id,
                                                  )));
                                    } else {}
                                  },
                                  color: Colors.white,
                                  textColor: planes[index].Estado == 'N'
                                      ? Color(0xFF8C44C0)
                                      : Colors.grey,
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
