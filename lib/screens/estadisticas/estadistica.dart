import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/estadisticas/estadistica.model.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/vencimientos/vencimiento.model.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-upsert-model.dart';
import 'package:planvisitas_grupohbf/screens/plansemanal/agregar-nuevo-plan.dart';
import 'package:planvisitas_grupohbf/screens/visitas/detalleVisitaPorMarcar.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasMarcadas.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasPorMarcar.dart';
import 'package:planvisitas_grupohbf/services/cliente/cliente.service.dart';
import 'package:planvisitas_grupohbf/services/estadisticas/estadistica.service.dart';
import 'package:planvisitas_grupohbf/services/hoja-de-ruta/hoja-de-ruta.service.dart';
import 'package:planvisitas_grupohbf/services/vencimiento/vencimiento.service.dart';
import 'package:planvisitas_grupohbf/services/visitas/visitas.service.dart';
import 'package:planvisitas_grupohbf/sidenav/sidenav.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EstadisticaPage extends StatefulWidget {
  @override
  _EstadisticaPageState createState() => _EstadisticaPageState();
}

class _EstadisticaPageState extends State<EstadisticaPage> {
  EstadisticaService service;
  EstadisticaModel model = new EstadisticaModel();
  DateTime today;
  DateTime lastDayOfMonth;
  DateTime month;
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    service = new EstadisticaService();
    today = DateTime.now();
    lastDayOfMonth = DateTime(today.year, today.month + 1, 0);
    month = DateTime(today.year, today.month, 1);
    service.traerEstadistica(month, lastDayOfMonth).then((value) {
      setState(() {
        model = value.Listado.first;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF74CCBB),
        title: Text("Estadísticas"),
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: [
          Card(
              child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Cantidad objetivo de visitas:"),
                Text(model.Objetivo != null ? model.Objetivo.toString() : "")
              ],
            ),
          )),
          Card(
              child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Cantidad de visitas realizadas:"),
                Text(model.Realizado != null ? model.Realizado.toString() : "")
              ],
            ),
          )),
          Card(
              child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Porcentaje realizado:"),
                Text(model.Porcentaje != null
                    ? model.Porcentaje.toString() + "%"
                    : "")
              ],
            ),
          )),
          Card(
              child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Objetivo promedio por día:"),
                Text(model.ObjetivoPorDia != null
                    ? model.ObjetivoPorDia.toString()
                    : "")
              ],
            ),
          )),
          Card(
              child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Visitas promedio por día:"),
                Text(model.HechoPorDia != null
                    ? model.HechoPorDia.toString()
                    : "")
              ],
            ),
          )),
          Card(
              child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Sucusales Visitadas:"),
                Text(model.CantidadSucursalesVisitados != null
                    ? model.CantidadSucursalesVisitados.toString()
                    : "")
              ],
            ),
          )),
          Card(
              child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Sucusales No Visitadas:"),
                Text(model.CantidadSucursalesNoVisitados != null
                    ? model.CantidadSucursalesNoVisitados.toString()
                    : "")
              ],
            ),
          )),
        ],
      ),
    );
  }
}
