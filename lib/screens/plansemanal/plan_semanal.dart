import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-upsert-model.dart';
import 'package:planvisitas_grupohbf/screens/plansemanal/agregar-nuevo-plan.dart';
import 'package:planvisitas_grupohbf/screens/visitas/detalleVisitaPorMarcar.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasMarcadas.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasPorMarcar.dart';
import 'package:planvisitas_grupohbf/services/cliente/cliente.service.dart';
import 'package:planvisitas_grupohbf/services/hoja-de-ruta/hoja-de-ruta.service.dart';
import 'package:planvisitas_grupohbf/sidenav/sidenav.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PlanSemanalPage extends StatefulWidget {
  @override
  _PlanSemanalPageState createState() => _PlanSemanalPageState();
}

class _PlanSemanalPageState extends State<PlanSemanalPage> {
  HojaRutaService service;
  PaginationPlanModel _planes =
      new PaginationPlanModel(CantidadTotal: 0, Listado: []);

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

  String date = "";
  DateTime selectedDateDesde = DateTime.now();
  DateTime selectedDateHasta = DateTime.now();
  TextEditingController dateinputDesde = TextEditingController();
  TextEditingController dateinputHasta = TextEditingController();
  bool loading = false;
  @override
  void initState() {
    String formattedDateDesde =
        DateFormat('yyyy-MM-dd').format(selectedDateDesde);
    String formattedDateHasta =
        DateFormat('yyyy-MM-dd').format(selectedDateHasta);
    dateinputDesde.text = formattedDateDesde;
    dateinputHasta.text = formattedDateHasta;
    super.initState();
    _searchQuery = new TextEditingController();
    service = new HojaRutaService();
    loading = true;
    service.traerPlanes(selectedDateDesde, selectedDateHasta).then((value) => {
          setState(() {
            loading = false;
            _planes = value;
          })
        });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Plan Semanal");
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    service.traerPlanes(selectedDateDesde, selectedDateHasta).then((value) => {
          setState(() {
            total = value.CantidadTotal;
            _planes = value;
            _refreshController.refreshCompleted();
          })
        });

    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    if ((index + 1) * take < total) {
      index++;
      service
          .traerPlanes(selectedDateDesde, selectedDateHasta)
          .then((value) => {
                setState(() {
                  total = value.CantidadTotal;
                  _planes = value;
                  _refreshController.loadComplete();
                })
              });
    } else {
      _refreshController.loadComplete();
    }
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
    print("search query " + newQuery);
  }

  void _startSearch() {
    print("open search box");
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            const Text('Plan Semanal'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Buscar...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      textInputAction: TextInputAction.search,
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
      onSubmitted: (text) {
        setState(() {
          loading = true;
        });
        service
            .traerPlanes(selectedDateDesde, selectedDateHasta, filtro: text)
            .then((value) => {
                  setState(() {
                    index = 0;
                    total = value.CantidadTotal;
                    _planes = value;
                    loading = false;
                  })
                });
      },
    );
  }

  _selectDate(BuildContext context, bool desde) async {
    if (desde) {
      final DateTime selected = await showDatePicker(
          context: context,
          locale: const Locale('es', 'PY'),
          initialDate: selectedDateDesde,
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
      if (selected != null && selected != selectedDateDesde) {
        //pickedDate output format => 2021-03-10 00:00:00.000
        String formattedDate = DateFormat('yyyy-MM-dd').format(selected);
        selectedDateDesde = selected;
        setState(() {
          dateinputDesde.text =
              formattedDate; //set output date to TextField value.
        });
      }
    } else {
      final DateTime selected = await showDatePicker(
          context: context,
          locale: const Locale('es', 'PY'),
          initialDate: selectedDateHasta,
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
      if (selected != null && selected != selectedDateHasta) {
        selectedDateHasta = selected;
        String formattedDate = DateFormat('yyyy-MM-dd').format(selected);
        setState(() {
          dateinputHasta.text =
              formattedDate; //set output date to TextField value.
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFF74CCBB),
          leading: _isSearching ? const BackButton() : null,
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          actions: _buildActions(),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      child: Container(
                    margin: const EdgeInsets.only(left: 10, bottom: 10),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: dateinputDesde,
                      decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today, color: Colors.white),
                          labelText: "Fecha desde",
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                          )),
                      readOnly: true,
                      onTap: () async {
                        await _selectDate(context, true);
                      },
                    ),
                  )),
                  Flexible(
                      child: Container(
                    margin: const EdgeInsets.only(right: 10, bottom: 10),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: dateinputHasta,
                      decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today, color: Colors.white),
                          labelText: "Fecha hasta",
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                          )),
                      readOnly: true,
                      onTap: () async {
                        await _selectDate(context, false);
                      },
                    ),
                  ))
                ]),
          )),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("Cargado.");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("Estire para cargar más items.");
            } else {
              body = Text("No hay más datos.");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: loading
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF74CCBB),
                ),
              )
            : ListView.builder(
                itemBuilder: (c, i) => Card(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  "${new DateFormat('dd/MM/yyyy').format(_planes.Listado[i].PlanSemanal_Horario.toLocal())}",
                                  style: TextStyle(fontSize: 20)),
                              Text(
                                  "${new DateFormat('HH:mm').format(_planes.Listado[i].PlanSemanal_Horario.toLocal())}",
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
                                      "${_planes.Listado[i].SucursalDireccion}"),
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
                                    "${_planes.Listado[i].Cliente_RazonSocial}"),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                itemCount: _planes.Listado.length,
              ),
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          backgroundColor: Color(0xFF74CCBB),
          child: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              loading = true;
            });
            service
                .traerPlanes(selectedDateDesde, selectedDateHasta)
                .then((value) => {
                      setState(() {
                        total = value.CantidadTotal;
                        _planes = value;
                        loading = false;
                      })
                    });
          },
          heroTag: null,
        ),
        SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          backgroundColor: Color(0xFF74CCBB),
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AgregarPlanPage()));
          },
          heroTag: null,
        )
      ]),
    );
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
      content: Text("Desea confirmar visita?"),
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
}
