import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc-provider.dart';
import 'package:planvisitas_grupohbf/bloc/shared/global-bloc.dart';
import 'package:planvisitas_grupohbf/bloc/visitas-offline-bloc/visitas-offline.bloc.dart';
import 'package:planvisitas_grupohbf/models/distance-matrix.dart';
import 'package:planvisitas_grupohbf/models/estado-motivo-visita/estado-motivo-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/shared/system-validation-model.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-upsert-model.dart';
import 'package:planvisitas_grupohbf/services/estado-motivo/estado-motivo.service.dart';
import 'package:planvisitas_grupohbf/services/google-maps.service.dart';
import 'package:planvisitas_grupohbf/services/visitas/visitas.service.dart';
import 'package:progress_dialog/progress_dialog.dart';

class VisitasAMarcarViewPage extends StatefulWidget {
  final VisitaUpsertModel visitasAMarcar;
  final int visitasAMarcarId;
  VisitasAMarcarViewPage({this.visitasAMarcar, this.visitasAMarcarId});

  @override
  _VisitasAMarcarViewPageState createState() => _VisitasAMarcarViewPageState();
}

class _VisitasAMarcarViewPageState extends State<VisitasAMarcarViewPage> {
  Location location = new Location();

  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  final Set<Polyline> _polyLines = {};
  Set<Polyline> get polyLines => _polyLines;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  String route;
  DistanceMatrix distance = defaultDistanceMatrix;
  bool loadingVisitasAMarcar = false;
  VisitasService visitasService;
  StreamSubscription connectivitySubscription;
  var connectivity = false;
  VisitasOfflineBloc visitasOfflineBloc;
  @override
  void initState() {
    super.initState();
    visitasService = VisitasService();
    location.hasPermission().then((value) => _permissionGranted = value);
    getLocation();
    visitasOfflineBloc =
        BlocProvider.of<GlobalBloc>(context).visitasOfflineBloc;
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
      LatLng destination = LatLng(-25.3794133, -57.5541792);
      LatLng origen = LatLng(_locationData.latitude, _locationData.longitude);
      
    });
  }

  showNoticeDialog(BuildContext context, SystemValidationModel model) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
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
                      Success: true,
                      Message: "Agregado con éxito sin conexión"));
            });
          }
        });

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
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  void guardar() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                widget.visitasAMarcar.Visita_Ubicacion_Entrada =
                    "${_locationData.latitude},${_locationData.longitude}";
                widget.visitasAMarcar.Visita_Hora_Entrada = DateTime.now();
                showAlertDialog(context, widget.visitasAMarcar);
              },
            )
          ],
          title: Text('Visitar'),
          backgroundColor: const Color(0xFF74CCBB),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: loadingVisitasAMarcar
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Datos del cliente',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                  child: new CircleAvatar(
                                    backgroundColor: const Color(0xFF74CCBB),
                                    radius: 14.0,
                                    child: new Icon(
                                      Icons.place,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                  ),
                                  onTap: () {},
                                )
                              ],
                            )
                          ],
                        )),
                    Card(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Cliente: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Container(
                                    width: 180,
                                    child: Text(
                                      "${widget.visitasAMarcar.Cliente}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 8,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Dirección: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Container(
                                    width: 180,
                                    child: Text(
                                      "${widget.visitasAMarcar.Direccion} - ${widget.visitasAMarcar.Ciudad}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 8,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Ubicación: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Container(
                                    width: 180,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        MapsLauncher.launchQuery(
                                            '${widget.visitasAMarcar.Direccion} Paraguay');
                                      },
                                      label: Text('Ver en Google Maps'),
                                      icon: Image.asset(
                                        'assets/maps.png',
                                        width: 50,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Hora Entrada: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Text(
                                      "${new DateFormat('HH:mm').format(widget.visitasAMarcar.Visita_Hora_Entrada.toLocal())}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }
}
