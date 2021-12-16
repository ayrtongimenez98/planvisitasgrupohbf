import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/vencimientos/vencimiento.model.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-upsert-model.dart';
import 'package:planvisitas_grupohbf/screens/plansemanal/agregar-nuevo-plan.dart';
import 'package:planvisitas_grupohbf/screens/visitas/detalleVisitaPorMarcar.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasMarcadas.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasPorMarcar.dart';
import 'package:planvisitas_grupohbf/services/cliente/cliente.service.dart';
import 'package:planvisitas_grupohbf/services/hoja-de-ruta/hoja-de-ruta.service.dart';
import 'package:planvisitas_grupohbf/services/vencimiento/vencimiento.service.dart';
import 'package:planvisitas_grupohbf/services/visitas/visitas.service.dart';
import 'package:planvisitas_grupohbf/sidenav/sidenav.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AgregarVencimientoPage extends StatefulWidget {
  @override
  _AgregarVencimientoPageState createState() => _AgregarVencimientoPageState();
}

class _AgregarVencimientoPageState extends State<AgregarVencimientoPage> {
  VencimientoService service;
  PaginationVencimientosModel _vencimientos =
      new PaginationVencimientosModel(CantidadTotal: 0, Listado: []);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController puntoVenta;
  TextEditingController codigoBarra;
  TextEditingController descripcion;
  TextEditingController sku;
  bool _isSearching = false;
  String searchQuery = "";

  List<String> diviones = ["DPGP", "Nutrición", "Farmacia"];
  List<String> cargos = ["Vendedor/a", "Consultor/a", "Repositor/a"];
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
  String cargo = "Vendedor/a";
  @override
  void initState() {
    super.initState();
    puntoVenta = new TextEditingController();
    codigoBarra = new TextEditingController();
    descripcion = new TextEditingController();
    sku = new TextEditingController();
    service = new VencimientoService();
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
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: cargo,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Cargo',
                ),
                onChanged: (String newValue) {
                  setState(() {
                    cargo = newValue;
                  });
                },
                items: cargos.map<DropdownMenuItem<String>>((String value) {
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
                controller: puntoVenta,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Punto de venta / Dirección',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                controller: codigoBarra,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Código de barra',
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
              padding: EdgeInsets.only(bottom: 20),
              child: Container(
                margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: dateinput,
                  decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today, color: Colors.black),
                      labelText: "Rango de vencimiento",
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                      )),
                  readOnly: true,
                  onTap: () async {
                    await _selectDate(context, true);
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                controller: sku,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Cantidad de SKU',
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF74CCBB),
          child: Icon(Icons.save),
          onPressed: () {
            final ProgressDialog pr = ProgressDialog(context);
            pr.show();
            var model = new VencimientoModel(
                Vencimiento_Canal: canal,
                Vencimiento_Cantidad_SKU: sku.text,
                Vencimiento_Cargo: cargo,
                Vencimiento_Codigo_Barras: codigoBarra.text,
                Vencimiento_Colaborador: "",
                Vencimiento_Descripcion_Producto: descripcion.text,
                Vencimiento_Division: division,
                Vencimiento_Id: 0,
                Vencimiento_PuntoVentaDireccion: puntoVenta.text,
                Vencimiento_Rango_Fecha: selectedDate);

            if (model.Vencimiento_PuntoVentaDireccion == null ||
                model.Vencimiento_PuntoVentaDireccion == "") {
              showAlertDialog(context, "Debe ingresar un punto de venta");
              return false;
            }
            if (model.Vencimiento_Codigo_Barras == null ||
                model.Vencimiento_Codigo_Barras == "") {
              showAlertDialog(context, "Debe ingresar un código de barras");
              return false;
            }
            if (model.Vencimiento_Descripcion_Producto == null ||
                model.Vencimiento_Descripcion_Producto == "") {
              showAlertDialog(
                  context, "Debe ingresar una descripción del producto");
              return false;
            }
            if (model.Vencimiento_Cantidad_SKU == null ||
                model.Vencimiento_Cantidad_SKU == "") {
              showAlertDialog(context, "Debe ingresar una cantidad de SKU");
              return false;
            }

            service.agregarVencimiento(model).then((value) {
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
