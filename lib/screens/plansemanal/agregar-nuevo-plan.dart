import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/distance-matrix.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plansemanal-upsert-model.dart';
import 'package:planvisitas_grupohbf/screens/plansemanal/enviar-plan-semanal.dart';
import 'package:planvisitas_grupohbf/services/cliente/cliente.service.dart';
import 'package:planvisitas_grupohbf/services/google-maps.service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AgregarPlanPage extends StatefulWidget {
  AgregarPlanPage();

  @override
  _AgregarPlanPageState createState() => _AgregarPlanPageState();
}

class _AgregarPlanPageState extends State<AgregarPlanPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController dateinput = TextEditingController();
  ClienteService service;
  PaginationClienteModel _clientes =
      new PaginationClienteModel(CantidadTotal: 0, Listado: []);
  List<ClienteModel> _listaClientes = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController _searchQuery;
  bool _isSearching = false;
  String searchQuery = "";

  int index = 0;
  int total = 0;
  int take = 10;

  int present = 0;
  int perPage = 15;

  bool loading = false;

  @override
  void initState() {
    loading = true;
    super.initState();
    service = new ClienteService();
    String formattedDateDesde = DateFormat('yyyy-MM-dd').format(selectedDate);
    dateinput.text = formattedDateDesde;

    service
        .traerClientesAsignados(
            filtro: searchQuery, skip: index * take, take: take)
        .then((value) => {
              setState(() {
                total = value.CantidadTotal;
                _clientes = value;
                _listaClientes.addAll(_clientes.Listado);
                loading = false;
              })
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
          title: Text('Agregar plan'),
          backgroundColor: const Color(0xFF74CCBB),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Card(
                color: Colors.white,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 10,
                child: Column(
                  children: [
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Ingrese la fecha que desea planear',
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
                                      Icons.calendar_today,
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
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Container(
                        margin:
                            const EdgeInsets.only(left: 30, right: 30, top: 20),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: dateinput,
                          decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today,
                                  color: Colors.black),
                              labelText: "Fecha",
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              )),
                          readOnly: true,
                          onTap: () async {
                            await _selectDate(context, true);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Card(
                  color: Colors.white,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 10,
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Seleccione las sucursales',
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
                                        Icons.list,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Buscar sucursales',
                          ),
                          onSubmitted: (text) {
                            setState(() {
                              loading = true;
                            });
                            service
                                .traerClientesAsignados(filtro: text)
                                .then((value) => {
                                      setState(() {
                                        index = 0;
                                        total = value.CantidadTotal;
                                        _clientes = value;
                                        _listaClientes = _clientes.Listado;
                                        loading = false;
                                      })
                                    });
                          },
                        ),
                      ),
                      Container(
                        height: 400,
                        child: loading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF74CCBB),
                                ),
                              )
                            : NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (scrollInfo.metrics.pixels ==
                                      scrollInfo.metrics.maxScrollExtent) {
                                    loadMore();
                                  }
                                },
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: ((index * take) <= total)
                                      ? _listaClientes.length + 1
                                      : _listaClientes.length,
                                  itemBuilder: (context, i) {
                                    return (i == _listaClientes.length)
                                        ? Container(
                                            color: Color(0xFF74CCBB),
                                            child: FlatButton(
                                              child: Text("Cargar más.."),
                                              onPressed: () {
                                                loadMore();
                                              },
                                            ),
                                          )
                                        : Card(
                                            child: ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 10),
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Text(
                                                  "${_listaClientes[i].Cantidad_Visitas}",
                                                  style: TextStyle(
                                                      color: Color(0xFF74CCBB),
                                                      fontSize: 30)),
                                            ),
                                            title: Text(
                                                "${_listaClientes[i].Cliente_RazonSocial}"),
                                            subtitle: Text(
                                                "${_listaClientes[i].SucursalDireccion}"),
                                            trailing: Checkbox(
                                              value: _listaClientes[i].Checked,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  _listaClientes[i].Checked =
                                                      value;
                                                });
                                              },
                                            ),
                                          ));
                                  },
                                ),
                              ),
                      )
                    ],
                  )),
              Padding(
                padding:
                    EdgeInsets.only(bottom: 20, top: 15, left: 20, right: 20),
                child: Container(
                    child: Center(
                        child: FlatButton(
                  onPressed: () async {
                    var list =
                        _listaClientes.where((element) => element.Checked);
                    var fecha = selectedDate;
                    var models = list
                        .map((e) => new PlanSemanalUpsertModel(
                            Cliente_RazonSocial: e.Cliente_RazonSocial,
                            Cliente_Cod: e.Cliente_Cod,
                            Estado: "N",
                            ObjetivoVisita_Id: 1,
                            PlanSemanalId: 0,
                            PlanSemanal_Horario: fecha,
                            SucursalId: e.SucursalId,
                            VendedorId: 0,
                            Sucursal_Direccion: e.SucursalDireccion,
                            Hora: "07:00"))
                        .toList();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EnviarPlanPage(
                                  visitas: models,
                                  fecha: fecha,
                                )));
                  },
                  padding: EdgeInsets.all(16),
                  color: Color(0xFF8C44C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text(
                        'SIGUIENTE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 25,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ))),
              )
            ],
          ),
        ));
  }

  void loadMore() {
    if ((index * take) < total) {
      index++;
      setState(() {
        service
            .traerClientesAsignados(
                filtro: searchQuery, skip: index * take, take: take)
            .then((value) => {
                  setState(() {
                    total = value.CantidadTotal;
                    _clientes = value;
                    _listaClientes.addAll(_clientes.Listado);
                  })
                });
      });
    }
  }

  _selectDate(BuildContext context, bool desde) async {
    final DateTime selected = await showDatePicker(
        context: context,
        locale: const Locale('es', 'PY'),
        initialDate: selectedDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2025),
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
}
