import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planvisitas_grupohbf/bloc/clientes-bloc/clientes.bloc.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc-provider.dart';
import 'package:planvisitas_grupohbf/bloc/shared/global-bloc.dart';
import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-upsert-model.dart';
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
  ClientesBloc _clienteBloc;
  bool refresh = true;
  StreamSubscription clienteSubscription;
  int index = 0;
  int total = 0;
  int take = 10;
  List<ClienteModel> listaFiltrada = [];
  bool loading = false;

  @override
  void initState() {
    loading = true;
    super.initState();

    _searchQuery = new TextEditingController();

    _clienteBloc = BlocProvider.of<GlobalBloc>(context).clientesBloc;
    _clientes = _clienteBloc.currentList;
    _clienteBloc.getClientesLocal();
    clienteSubscription = _clienteBloc.clienteStream.listen((data) async {
      setState(() {
        total = data.CantidadTotal;
        _clientes = data;
        listaFiltrada = data.Listado;
        loading = false;
        _refreshController.refreshCompleted();
      });
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
    _clienteBloc.getClientesServidor(
        filtro: searchQuery, skip: index * take, take: take);
  }

  void _onLoading() async {
    if ((index + 1) * take < total) {
      index++;
      _clienteBloc.getClientesServidor(
          filtro: searchQuery, skip: index * take, take: take);
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

  @override
  dispose() {
    clienteSubscription.cancel();
    super.dispose();
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
          if (text.length > 0) {
            listaFiltrada = listaFiltrada
                .where((element) =>
                    element.SucursalDireccion.toLowerCase()
                        .contains(text.toLowerCase()) ||
                    element.Cliente_RazonSocial.toLowerCase()
                        .contains(text.toLowerCase()))
                .toList();
          } else {
            listaFiltrada = _clientes.Listado;
          }
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
      body: ListView.builder(
        itemBuilder: (c, i) => Card(
            child: ListTile(
          onTap: () {
            var plan = new VisitaUpsertModel(
                Cliente_Cod: listaFiltrada[i].Cliente_Cod,
                Cliente: listaFiltrada[i].Cliente_RazonSocial,
                Visita_Observacion: "",
                Estado_Id: 1,
                Motivo_Id: 1,
                Visita_Id: 0,
                Visita_fecha: new DateTime.now(),
                Ciudad: listaFiltrada[i].SucursalCiudad,
                Direccion: listaFiltrada[i].SucursalDireccion,
                Sucursal_Id: listaFiltrada[i].SucursalId,
                Vendedor_Id: 0,
                Visita_Ubicacion_Entrada: "",
                Visita_Ubicacion_Salida: "",
                Visita_Hora_Entrada: new DateTime.now(),
                Visita_Hora_Salida: new DateTime.now());
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VisitasAMarcarViewPage(
                      visitasAMarcar: plan,
                      visitasAMarcarId: plan.Vendedor_Id,
                    )));
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text("${listaFiltrada[i].Cantidad_Visitas}",
                style: TextStyle(color: Color(0xFF74CCBB), fontSize: 30)),
          ),
          title: Text("${listaFiltrada[i].Cliente_RazonSocial}"),
          subtitle: Text("${listaFiltrada[i].SucursalDireccion}"),
          trailing: Icon(
            Icons.location_on,
            color: Colors.pink,
            size: 24.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
        )),
        itemExtent: 100.0,
        itemCount: listaFiltrada.length,
      ),
    );
  }
}
