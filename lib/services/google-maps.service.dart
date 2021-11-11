import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:planvisitas_grupohbf/models/distance-matrix.dart';

const apiKey = "AIzaSyCv_sMgaUuzlpdSVIL0G-7IryUBmwq8wKs";

class GoogleMapsServices {
  Future<String> getRouteCoordinates(
      LatLng l1, LatLng l2, String waypoint) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&waypoints=optimize:true|$waypoint&key=$apiKey";
    http.Response response = await http.get(Uri.parse(url));
    Map values = jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }

  Future<DistanceMatrix> getDistance(
      LatLng l1, LatLng l2, String waypoints, String destino) async {
    String url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins=${l1.latitude},${l1.longitude}&destinations=${destino.replaceAll("E/", "esq ")}&mode=driving&language=es-419&key=$apiKey";
    http.Response response = await http.get(Uri.parse(url));
    Map values = jsonDecode(response.body);
    return DistanceMatrix.fromJson(values);
  }
}
