import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:planvisitas_grupohbf/bloc/datos-menores-bloc/estado-motivo.bloc.dart';
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

class VisitaMarcadaViewPage extends StatefulWidget {
  final VisitaUpsertModel VisitaMarcada;
  final int VisitaMarcadaId;
  VisitaMarcadaViewPage({this.VisitaMarcada, this.VisitaMarcadaId});

  @override
  _VisitaMarcadaViewPageState createState() => _VisitaMarcadaViewPageState();
}

class _VisitaMarcadaViewPageState extends State<VisitaMarcadaViewPage> {
  Location location = new Location();

  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  final Set<Polyline> _polyLines = {};
  Set<Polyline> get polyLines => _polyLines;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  String route;
  DistanceMatrix distance = defaultDistanceMatrix;
  bool loadingVisitaMarcada = false;

  TextEditingController observacionController = TextEditingController();

  EstadoMotivoService estadoMotivoService;

  List<EstadoModel> _estados = [];
  List<MotivoModel> _motivos = [];
  bool loading = false;
  EstadoMotivoBloc _estadoMotivoBloc;
  StreamSubscription estadoSubscription;
  StreamSubscription motivoSubscription;
  VisitasService visitasService;
  StreamSubscription connectivitySubscription;
  var connectivity = false;
  VisitasOfflineBloc visitasOfflineBloc;

  @override
  void initState() {
    super.initState();
    visitasService = VisitasService();
    estadoMotivoService = EstadoMotivoService();
    getLocation();

    _estadoMotivoBloc = BlocProvider.of<GlobalBloc>(context).estadoMotivoBloc;
    _estados = _estadoMotivoBloc.currentList.Listado;
    _motivos = _estadoMotivoBloc.currentListM.Listado;

    _estadoMotivoBloc.getEstadosLocal();
    _estadoMotivoBloc.getMotivosLocal();

    estadoSubscription = _estadoMotivoBloc.estadoStream.listen((data) async {
      setState(() {
        _estados = data.Listado;
        loading = false;
      });
    });

    motivoSubscription = _estadoMotivoBloc.motivoStream.listen((data) async {
      setState(() {
        _motivos = data.Listado;
        loading = false;
      });
    });
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
    loading = true;

    location.hasPermission().then((value) {
      _permissionGranted = value;
      location.getLocation().then((value) async {
        setState(() {
          _locationData = value;
        });
      });
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
          visitasService.agregarSalida(model).then((value) async {
            pr.hide();
            showNoticeDialog(context, value);
          });
        } else {
          visitasOfflineBloc.agregarSalidaVisita(model).then((value) {
            pr.hide();
            showNoticeDialog(
                context,
                new SystemValidationModel(
                    Success: true,
                    Message: "Actualizado con éxito sin conexión"));
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
      content: Text("Desea confirmar salida?"),
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
  dispose() {
    super.dispose();
    estadoSubscription.cancel();
    motivoSubscription.cancel();
    connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                try {
                  if (_locationData != null) {
                    widget.VisitaMarcada.Visita_Ubicacion_Salida =
                        "${_locationData.latitude},${_locationData.longitude}";
                    widget.VisitaMarcada.Visita_Hora_Salida = DateTime.now();
                    widget.VisitaMarcada.Visita_Observacion =
                        observacionController.text;
                    showAlertDialog(context, widget.VisitaMarcada);
                  } else {
                    location.hasPermission().then((value) {
                      _permissionGranted = value;
                      if (value != null) {
                        location.getLocation().then((value) async {
                          setState(() {
                            _locationData = value;
                            widget.VisitaMarcada.Visita_Ubicacion_Salida =
                                "${_locationData.latitude},${_locationData.longitude}";
                            widget.VisitaMarcada.Visita_Hora_Salida =
                                DateTime.now();
                            widget.VisitaMarcada.Visita_Observacion =
                                observacionController.text;
                            showAlertDialog(context, widget.VisitaMarcada);
                          });
                        });
                      } else {
                        Widget cancelButton = FlatButton(
                          child: Text("Ok"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        );

                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: Text("Error"),
                          content: Text(value.toString()),
                          actions: [cancelButton],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      }
                    });
                  }
                } catch (e) {
                  Widget cancelButton = FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  );

                  // set up the AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: Text("Error"),
                    content: Text(e.toString()),
                    actions: [cancelButton],
                  );

                  // show the dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                }
              },
            )
          ],
          title: Text('Visita del dia'),
          backgroundColor: const Color(0xFF74CCBB),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: loadingVisitaMarcada
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
                                      widget.VisitaMarcada.Cliente,
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
                                      widget.VisitaMarcada.Direccion,
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
                                            '${widget.VisitaMarcada.Direccion} Paraguay');
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
                                  Text("Hora Salida: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Text(
                                      "${new DateFormat('HH:mm').format(DateTime.now().toLocal())}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1),
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
                                  Text("Estado: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Text("Entrada",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1),
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
                                  Text("Hora Planeada: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Text("10:00",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Estado: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Padding(
                                    padding: EdgeInsets.only(left: 150),
                                    child: Text("Motivo:",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 5, 30, 0),
                                      width: 200,
                                      child: _estados.length == 0
                                          ? LinearProgressIndicator()
                                          : DropdownButton<EstadoModel>(
                                              isExpanded: true,
                                              value: _estados
                                                  .where((element) =>
                                                      element.Estado_Id ==
                                                      widget.VisitaMarcada
                                                          .Estado_Id)
                                                  .first,
                                              icon: const Icon(
                                                  Icons.arrow_downward),
                                              iconSize: 24,
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              underline: Container(
                                                height: 2,
                                                color: Colors.black,
                                              ),
                                              onChanged:
                                                  (EstadoModel newValue) {
                                                setState(() {
                                                  widget.VisitaMarcada
                                                          .Estado_Id =
                                                      newValue.Estado_Id;
                                                });
                                              },
                                              items: _estados.map<
                                                      DropdownMenuItem<
                                                          EstadoModel>>(
                                                  (EstadoModel value) {
                                                return DropdownMenuItem<
                                                    EstadoModel>(
                                                  value: value,
                                                  child: Text(
                                                      value.Estado_Descripcion),
                                                );
                                              }).toList(),
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      width: 150,
                                      child: _motivos.length == 0
                                          ? LinearProgressIndicator()
                                          : DropdownButton<MotivoModel>(
                                              isExpanded: true,
                                              value: _motivos
                                                  .where((element) =>
                                                      element.Motivo_Id ==
                                                      widget.VisitaMarcada
                                                          .Motivo_Id)
                                                  .first,
                                              icon: const Icon(
                                                  Icons.arrow_downward),
                                              iconSize: 24,
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              underline: Container(
                                                height: 2,
                                                color: Colors.black,
                                              ),
                                              onChanged:
                                                  (MotivoModel newValue) {
                                                setState(() {
                                                  widget.VisitaMarcada
                                                          .Motivo_Id =
                                                      newValue.Motivo_Id;
                                                });
                                              },
                                              items: _motivos.map<
                                                      DropdownMenuItem<
                                                          MotivoModel>>(
                                                  (MotivoModel value) {
                                                return DropdownMenuItem<
                                                    MotivoModel>(
                                                  value: value,
                                                  child: Text(
                                                      value.Motivo_Descripcion),
                                                );
                                              }).toList(),
                                            ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                controller: observacionController,
                                decoration: InputDecoration(
                                    hintText: "Observaciones",
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                    )),
                                maxLines: 8,
                                maxLength: 1000,
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
