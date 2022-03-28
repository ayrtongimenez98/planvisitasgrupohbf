import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:planvisitas_grupohbf/models/acciones_competencia/acciones.model.dart';
import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/vencimientos/vencimiento.model.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-upsert-model.dart';
import 'package:planvisitas_grupohbf/screens/plansemanal/agregar-nuevo-plan.dart';
import 'package:planvisitas_grupohbf/screens/visitas/detalleVisitaPorMarcar.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasMarcadas.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasPorMarcar.dart';
import 'package:planvisitas_grupohbf/services/acciones_competencia/acciones.service.dart';
import 'package:planvisitas_grupohbf/services/cliente/cliente.service.dart';
import 'package:planvisitas_grupohbf/services/hoja-de-ruta/hoja-de-ruta.service.dart';
import 'package:planvisitas_grupohbf/services/vencimiento/vencimiento.service.dart';
import 'package:planvisitas_grupohbf/services/visitas/visitas.service.dart';
import 'package:planvisitas_grupohbf/sidenav/sidenav.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AgregarAccionesPage extends StatefulWidget {
  @override
  _AgregarAccionesPageState createState() => _AgregarAccionesPageState();
}

class _AgregarAccionesPageState extends State<AgregarAccionesPage> {
  AccionesCompetenciaService service;
  PaginationAccionesModel _acciones =
      new PaginationAccionesModel(CantidadTotal: 0, Listado: []);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController precio;
  TextEditingController precioOferta;
  TextEditingController descripcion;
  TextEditingController observacion;
  bool _isSearching = false;
  String searchQuery = "";

  List<String> diviones = ["DPGP", "Nutrición", "Farmacia"];
  List<String> canales = ["Supermercado", "Mayorista", "Farmacia", "Interior"];
  int index = 0;
  int total = 0;
  int take = 10;
  DateTime selectedDate = DateTime.now();
  TextEditingController dateinput = TextEditingController();
  String date = "";
  DateTime selectedDateDesde = DateTime.now();
  DateTime selectedDateHasta = DateTime.now();
  bool loading = false;
  String division = "DPGP";
  String canal = "Supermercado";
  @override
  void initState() {
    super.initState();
    precio = new TextEditingController();
    precioOferta = new TextEditingController();
    descripcion = new TextEditingController();
    observacion = new TextEditingController();
    service = new AccionesCompetenciaService();
    loading = true;
  }

  _selectDate(BuildContext context, bool desde) async {
    final DateTime selected = await showDatePicker(
        context: context,
        locale: const Locale('es', 'PY'),
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.grey,
              splashColor: Colors.black,
              textTheme: TextTheme(
                subtitle1: TextStyle(color: Colors.black),
                button: TextStyle(color: Colors.black),
              ),
              colorScheme: ColorScheme.light(
                  primary: Color(0xFF74CCBB),
                  primaryVariant: Colors.black,
                  secondaryVariant: Colors.black,
                  onSecondary: Colors.black,
                  onPrimary: Colors.white,
                  surface: Colors.black,
                  onSurface: Colors.black,
                  secondary: Colors.black),
              dialogBackgroundColor: Colors.white,
            ),
            child: child ?? Text(""),
          );
        });
    if (selected != null && selected != selectedDate) {
      //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(selected);
      selectedDate = selected;
      setState(() {
        dateinput.text = formattedDate; //set output date to TextField value.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xFF74CCBB),
            title: Text("Agregar nuevo")),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: division,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'División',
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (String newValue) {
                  setState(() {
                    division = newValue;
                  });
                },
                items: diviones.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: canal,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Canal',
                ),
                onChanged: (String newValue) {
                  setState(() {
                    canal = newValue;
                  });
                },
                items: canales.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                controller: precio,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Precio',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                controller: precioOferta,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Precio de oferta',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                controller: descripcion,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Descripción del producto',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                controller: observacion,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Observación',
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF74CCBB),
          child: Icon(Icons.send),
          onPressed: () {
            final ProgressDialog pr = ProgressDialog(context);
            pr.show();
            var model = new AccionesCompetenciaModel(
                AccionesCompetencia_Canal: canal,
                AccionesCompetencia_Colaborador: "",
                AccionesCompetencia_Descripcion: descripcion.text,
                AccionesCompetencia_Division: division,
                AccionesCompetencia_Id: 0,
                AccionesCompetencia_Observacion: observacion.text,
                AccionesCompetencia_Precio: precio.text,
                AccionesCompetencia_PrecioOferta: precioOferta.text);

            if (model.AccionesCompetencia_Precio == null ||
                model.AccionesCompetencia_Precio == "") {
              showAlertDialog(context, "Debe ingresar un precio");
              return false;
            }
            if (model.AccionesCompetencia_PrecioOferta == null ||
                model.AccionesCompetencia_PrecioOferta == "") {
              showAlertDialog(context, "Debe ingresar un precio de oferta");
              return false;
            }
            if (model.AccionesCompetencia_Descripcion == null ||
                model.AccionesCompetencia_Descripcion == "") {
              showAlertDialog(
                  context, "Debe ingresar una descripción del producto");
              return false;
            }

            service.agregarAccionesCompetencia(model).then((value) {
              pr.hide();
              if (value.Success) {
                showConfirmDialog(context);
              } else {
                showAlertDialog(context, value.Message);
              }
            });
          },
          heroTag: null,
        ));
  }

  showAlertDialog(BuildContext context, String error) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () async {
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
      title: Text("Atención!"),
      content: Text(error),
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

  showConfirmDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () async {
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
      title: Text("Confirmado!"),
      content: Text("Agregado con éxito!"),
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
}
