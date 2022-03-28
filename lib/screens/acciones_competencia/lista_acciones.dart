import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-upsert-model.dart';
import 'package:planvisitas_grupohbf/screens/acciones_competencia/agregar_competencia.dart';
import 'package:planvisitas_grupohbf/screens/plansemanal/agregar-nuevo-plan.dart';
import 'package:planvisitas_grupohbf/screens/vencimiento/agregar_vencimiento.dart';
import 'package:planvisitas_grupohbf/screens/visitas/detalleVisitaPorMarcar.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasMarcadas.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasPorMarcar.dart';
import 'package:planvisitas_grupohbf/services/acciones_competencia/acciones.service.dart';
import 'package:planvisitas_grupohbf/services/cliente/cliente.service.dart';
import 'package:planvisitas_grupohbf/services/hoja-de-ruta/hoja-de-ruta.service.dart';
import 'package:planvisitas_grupohbf/services/vencimiento/vencimiento.service.dart';
import 'package:planvisitas_grupohbf/services/visitas/visitas.service.dart';
import 'package:planvisitas_grupohbf/sidenav/sidenav.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ListaAccionesPage extends StatefulWidget {
  @override
  _ListaAccionesPageState createState() => _ListaAccionesPageState();
}

class _ListaAccionesPageState extends State<ListaAccionesPage> {
  AccionesCompetenciaService service;
  PaginationAccionesModel _acciones =
      new PaginationAccionesModel(CantidadTotal: 0, Listado: []);

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
  bool loading = false;
  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
    service = new AccionesCompetenciaService();
    loading = true;
    service.traerAccionesCompetencias().then((value) => {
          setState(() {
            loading = false;
            _acciones = value;
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
      updateSearchQuery("Acciones Competencia");
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    service.traerAccionesCompetencias().then((value) => {
          setState(() {
            total = value.CantidadTotal;
            _acciones = value;
            _refreshController.refreshCompleted();
          })
        });

    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    if ((index + 1) * take < total) {
      index++;
      service.traerAccionesCompetencias().then((value) => {
            setState(() {
              total = value.CantidadTotal;
              _acciones = value;
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
            const Text('Acciones Competencia'),
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
        service.traerAccionesCompetencias(filtro: text).then((value) => {
              setState(() {
                index = 0;
                total = value.CantidadTotal;
                _acciones = value;
                loading = false;
              })
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF74CCBB),
          leading: _isSearching ? const BackButton() : null,
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          actions: _buildActions(),
        ),
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
                            padding:
                                EdgeInsets.only(left: 15, bottom: 15, top: 15),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.people),
                                Flexible(
                                  child: Padding(
                                    child: Text(
                                        "${_acciones.Listado[i].AccionesCompetencia_Division}"),
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
                                Icon(Icons.map),
                                Flexible(
                                  child: Padding(
                                    child: Text(
                                        "${_acciones.Listado[i].AccionesCompetencia_Canal}"),
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
                                      "${_acciones.Listado[i].AccionesCompetencia_Descripcion}"),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, bottom: 15),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.add_business),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                      "${_acciones.Listado[i].AccionesCompetencia_Canal}"),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  itemCount: _acciones.Listado.length,
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
              service.traerAccionesCompetencias().then((value) => {
                    setState(() {
                      total = value.CantidadTotal;
                      _acciones = value;
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AgregarAccionesPage()));
            },
            heroTag: null,
          )
        ]));
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
