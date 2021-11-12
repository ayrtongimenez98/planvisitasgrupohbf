import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/screens/visitas/detalleVisitaPorMarcar.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasMarcadas.dart';
import 'package:planvisitas_grupohbf/screens/visitas/visitasPorMarcar.dart';
import 'package:planvisitas_grupohbf/services/cliente/cliente.service.dart';
import 'package:planvisitas_grupohbf/sidenav/sidenav.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListaClientes extends StatefulWidget {
  @override
  _ListaClientesState createState() => _ListaClientesState();
}

class _ListaClientesState extends State<ListaClientes> {
  ClienteService service;
  PaginationClienteModel _clientes =
      new PaginationClienteModel(CantidadTotal: 0, Listado: []);

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

  bool loading = false;

  @override
  void initState() {
    loading = true;
    super.initState();

    _searchQuery = new TextEditingController();
    service = new ClienteService();
    service
        .traerClientesAsignados(
            filtro: searchQuery, skip: index * take, take: take)
        .then((value) => {
              setState(() {
                _clientes = value;
                loading = false;
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
      updateSearchQuery("Clientes");
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    service
        .traerClientesAsignados(
            filtro: searchQuery, skip: index * take, take: take)
        .then((value) => {
              setState(() {
                total = value.CantidadTotal;
                _clientes = value;
                _refreshController.refreshCompleted();
              })
            });
    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    if ((index + 1) * take < total) {
      index++;
      service
          .traerClientesAsignados(
              filtro: searchQuery, skip: index * take, take: take)
          .then((value) => {
                setState(() {
                  total = value.CantidadTotal;
                  _clientes = value;
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
            const Text('Clientes'),
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
        service.traerClientesAsignados(filtro: text).then((value) => {
              setState(() {
                index = 0;
                total = value.CantidadTotal;
                _clientes = value;
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
                    child: ListTile(
                  onTap: () {
                    var plan = new PlanSemanal(
                        Cliente_Cod: _clientes.Listado[i].Cliente_Cod,
                        Cliente_RazonSocial:
                            _clientes.Listado[i].Cliente_RazonSocial,
                        Estado: "N",
                        NombreVendedor: null,
                        Periodo: null,
                        PlanSemanalId: 0,
                        PlanSemanal_Horario: new DateTime.now(),
                        SucursalCiudad: _clientes.Listado[i].SucursalCiudad,
                        SucursalDireccion:
                            _clientes.Listado[i].SucursalDireccion,
                        SucursalId: _clientes.Listado[i].SucursalId,
                        VendedorId: 0);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => VisitasAMarcarViewPage(
                              visitasAMarcar: plan,
                              visitasAMarcarId: plan.PlanSemanalId,
                            )));
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text("${_clientes.Listado[i].Cantidad_Visitas}",
                        style:
                            TextStyle(color: Color(0xFF74CCBB), fontSize: 30)),
                  ),
                  title: Text("${_clientes.Listado[i].Cliente_RazonSocial}"),
                  subtitle: Text("${_clientes.Listado[i].SucursalDireccion}"),
                  trailing: Icon(
                    Icons.location_on,
                    color: Colors.pink,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                )),
                itemExtent: 100.0,
                itemCount: _clientes.Listado.length,
              ),
      ),
    );
  }
}
