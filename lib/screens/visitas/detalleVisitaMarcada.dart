import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:planvisitas_grupohbf/models/distance-matrix.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/services/google-maps.service.dart';

class VisitaMarcadaViewPage extends StatefulWidget {
  final PlanSemanal VisitaMarcada;
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
  @override
  void initState() {
    location.hasPermission().then((value) => _permissionGranted = value);
    getLocation();
    super.initState();
  }

  getLocation() {
    location.getLocation().then((value) async {
      _locationData = value;
      LatLng destination = LatLng(-25.3794133, -57.5541792);
      LatLng origen = LatLng(_locationData.latitude, _locationData.longitude);
      _googleMapsServices
          .getRouteCoordinates(origen, destination, "-25.2658337%2C-57.5717946")
          .then((f) {
        setState(() {
          route = f;
        });
      });
      _googleMapsServices
          .getDistance(origen, destination, "-25.2658337%2C-57.5717946", "")
          .then((f) {
        setState(() {
          distance = f;
        });
      });
    });
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
      content: Text("Desea confirmar la visita?"),
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
        backgroundColor: Colors.white,
        appBar: AppBar(
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: route != null
                          ? Container(
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://maps.googleapis.com/maps/api/staticmap?center=Biggie+Ñemby&zoom=15&scale=1&size=600x300&maptype=roadmap&key=AIzaSyChUnqJMokZkBnZYlWhwsDbg2SPk2eWP5c&format=png&visual_refresh=true&markers=size:mid%7Ccolor:0xff0000%7Clabel:1%7CParaguay",
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
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
                                      "BIGGIE EXPRESS",
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
                                      "Avenida Caaguazu c/ Calle Colon - Ñemby",
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
                                  Text("Hora marcación: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Text("10:08",
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
                                  Text("Marcado",
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
                                  Text("Objetivo: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Text("Reposición",
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
