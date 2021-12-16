import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:planvisitas_grupohbf/bloc/clientes-bloc/clientes.bloc.dart';
import 'package:planvisitas_grupohbf/bloc/datos-menores-bloc/estado-motivo.bloc.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc-provider.dart';
import 'package:planvisitas_grupohbf/bloc/shared/global-bloc.dart';
import 'package:planvisitas_grupohbf/bloc/visitas-offline-bloc/visitas-offline.bloc.dart';
import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/distance-matrix.dart';
import 'package:planvisitas_grupohbf/models/estado-motivo-visita/estado-motivo-model.dart';
import 'package:planvisitas_grupohbf/models/objetivovisita/objetivovisita-model.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plansemanal-upsert-model.dart';
import 'package:planvisitas_grupohbf/models/shared/system-validation-model.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-upsert-model.dart';
import 'package:planvisitas_grupohbf/services/cliente/cliente.service.dart';
import 'package:planvisitas_grupohbf/services/google-maps.service.dart';
import 'package:planvisitas_grupohbf/services/hoja-de-ruta/hoja-de-ruta.service.dart';
import 'package:planvisitas_grupohbf/services/objetivovisita/objetivovisita.service.dart';
import 'package:planvisitas_grupohbf/services/visitas/visitas.service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SincronizarDatosPage extends StatefulWidget {
  SincronizarDatosPage();

  @override
  _SincronizarDatosPageState createState() => _SincronizarDatosPageState();
}

class _SincronizarDatosPageState extends State<SincronizarDatosPage> {
  List<EstadoModel> _estados = [];
  List<MotivoModel> _motivos = [];
  List<ClienteModel> _clientes = [];
  List<VisitaUpsertModel> _visitas = [];

  bool loadingC = false;
  bool loadingE = false;
  bool loadingM = false;
  bool loadingV = false;
  EstadoMotivoBloc _estadoMotivoBloc;
  ClientesBloc _clientesBloc;
  StreamSubscription estadoSubscription;
  StreamSubscription motivoSubscription;
  StreamSubscription clientesSubscription;
  AnimationController controller;
  VisitasService visitasService;

  VisitasOfflineBloc _visitasOfflineBloc;
  StreamSubscription visitasSubscription;
  List<int> indexes = [];
  @override
  void initState() {
    visitasService = VisitasService();
    _estadoMotivoBloc = BlocProvider.of<GlobalBloc>(context).estadoMotivoBloc;
    _clientesBloc = BlocProvider.of<GlobalBloc>(context).clientesBloc;
    _clientes = _clientesBloc.currentList.Listado;
    _estados = _estadoMotivoBloc.currentList.Listado;
    _motivos = _estadoMotivoBloc.currentListM.Listado;

    _estadoMotivoBloc.getEstadosLocal();
    _estadoMotivoBloc.getMotivosLocal();
    _clientesBloc.getClientesLocal();

    clientesSubscription = _clientesBloc.clienteStream.listen((data) async {
      setState(() {
        _clientes = data.Listado;
        loadingC = false;
      });
    });

    estadoSubscription = _estadoMotivoBloc.estadoStream.listen((data) async {
      setState(() {
        _estados = data.Listado;
        loadingE = false;
      });
    });

    motivoSubscription = _estadoMotivoBloc.motivoStream.listen((data) async {
      setState(() {
        _motivos = data.Listado;
        loadingM = false;
      });
    });

    _visitasOfflineBloc =
        BlocProvider.of<GlobalBloc>(context).visitasOfflineBloc;
    _visitas = _visitasOfflineBloc.currentList;
    _visitasOfflineBloc.getVisitasLocal();
    visitasSubscription =
        _visitasOfflineBloc.visitaStream.listen((event) async {
      setState(() {
        _visitas = event;
      });
    });

    super.initState();
  }

  @override
  dispose() {
    estadoSubscription.cancel();
    motivoSubscription.cancel();
    clientesSubscription.cancel();
    visitasSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF74CCBB),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.download),
                text: "Recibir",
              ),
              Tab(icon: Icon(Icons.upload), text: "Enviar")
            ],
          ),
          title: const Text('Sincronizar Datos'),
        ),
        body: TabBarView(
          children: [
            Container(
              child: ListView(
                children: [
                  Card(
                    child: ListTile(
                      title: Text('Clientes'),
                      trailing: loadingC
                          ? CircularProgressIndicator(
                              color: Color(0xFF8C44C0),
                              strokeWidth: 2,
                            )
                          : (_clientes.length == 0
                              ? Icon(Icons.clear, color: Colors.red)
                              : Icon(Icons.check, color: Colors.green)),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Motivos de visitas'),
                      trailing: loadingM
                          ? CircularProgressIndicator(
                              color: Color(0xFF8C44C0),
                              strokeWidth: 2,
                            )
                          : (_motivos.length == 0
                              ? Icon(Icons.clear, color: Colors.red)
                              : Icon(Icons.check, color: Colors.green)),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Estados de visitas'),
                      trailing: loadingE
                          ? CircularProgressIndicator(
                              color: Color(0xFF8C44C0),
                              strokeWidth: 2,
                            )
                          : (_estados.length == 0
                              ? Icon(Icons.clear, color: Colors.red)
                              : Icon(Icons.check, color: Colors.green)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Center(
                        child: TextButton.icon(
                      style: ButtonStyle(
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Color((0xFF8C44C0))))),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Color((0xFF8C44C0))),
                      ),
                      onPressed: () {
                        setState(() {
                          loadingC = true;
                          loadingM = true;
                          loadingE = true;
                        });
                        _estadoMotivoBloc.getEstadosServidor(
                            filtro: "", skip: 0, take: 1000);
                        _estadoMotivoBloc.getMotivosServidor(
                            filtro: "", skip: 0, take: 1000);
                        _clientesBloc.getClientesServidor(
                            filtro: "", skip: 0, take: 1000);
                      },
                      label: Text('Sincronizar'),
                      icon: Icon(Icons.download),
                    )),
                  )
                ],
              ),
            ),
            Container(
              child: ListView.builder(
                itemCount: _visitas.length + 1,
                itemBuilder: (_, i) {
                  return (_visitas.length == i)
                      ? Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: Center(
                              child: TextButton.icon(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(
                                          color: Color((0xFF8C44C0))))),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Color((0xFF8C44C0))),
                            ),
                            onPressed: () {
                              setState(() {
                                loadingV = true;
                                for (var visi in _visitas) {
                                  visitasService
                                      .agregarEntrada(visi)
                                      .then((value) {
                                    if (value.Success) {
                                      _visitasOfflineBloc
                                          .borrarVisita(visi)
                                          .then((value) {
                                        setState(() {
                                          loadingV = false;
                                          indexes.add(_visitas.indexOf(visi));
                                        });
                                      });
                                    }
                                  });
                                }
                              });
                            },
                            label: Text('Sincronizar'),
                            icon: Icon(Icons.upload),
                          )),
                        )
                      : Card(
                          child: ListTile(
                            title: Text('${_visitas[i].Cliente}'),
                            subtitle: Text('${_visitas[i].Direccion}'),
                            leading: Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                  '${new DateFormat('HH:mm').format(_visitas[i].Visita_Hora_Entrada.toLocal())}'),
                            ),
                            trailing: loadingV
                                ? CircularProgressIndicator(
                                    color: Color(0xFF8C44C0),
                                    strokeWidth: 2,
                                  )
                                : (indexes.length != 0 &&
                                        indexes.any((element) => element == i)
                                    ? Icon(Icons.check, color: Colors.green)
                                    : Icon(Icons.clear, color: Colors.red)),
                          ),
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
