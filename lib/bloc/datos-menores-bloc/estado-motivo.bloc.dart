import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc.dart';
import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/session-info.dart';
import 'package:planvisitas_grupohbf/services/authentication/login.service.dart';
import 'package:planvisitas_grupohbf/services/cliente/cliente.service.dart';
import 'package:planvisitas_grupohbf/services/estado-motivo/estado-motivo.service.dart';
import 'package:planvisitas_grupohbf/services/hoja-de-ruta/hoja-de-ruta.service.dart';
import 'package:planvisitas_grupohbf/services/storage/secure_storage_helper.service.dart';

class EstadoMotivoBloc implements Bloc {
  EstadoMotivoService estadoMotivoService = EstadoMotivoService();

  PaginationEstadoModel lista =
      PaginationEstadoModel(CantidadTotal: 0, Listado: []);

  PaginationEstadoModel get currentList => lista;

  final _estadoController = StreamController<PaginationEstadoModel>.broadcast();
  Stream<PaginationEstadoModel> get estadoStream => _estadoController.stream;

  PaginationMotivoModel listaM =
      PaginationMotivoModel(CantidadTotal: 0, Listado: []);

  PaginationMotivoModel get currentListM => listaM;

  final _motivoController = StreamController<PaginationMotivoModel>.broadcast();
  Stream<PaginationMotivoModel> get motivoStream => _motivoController.stream;

  final _storage = const FlutterSecureStorage();

  EstadoMotivoBloc() {}

  Future<void> getMotivosServidor({String filtro, int skip, int take}) async {
    var model = await estadoMotivoService.listarMotivos(
        filtro: filtro, skip: skip, take: take);
    listaM = model;
    _motivoController.add(listaM);
    guardarMotivos();
  }

  Future<void> getMotivosLocal() async {
    var jsonClientes = await _storage.read(key: "motivosVisita");
    if (jsonClientes != null) {
      var result = json.decode(jsonClientes) as dynamic;
      listaM = PaginationMotivoModel.fromJson(result);
      _motivoController.add(listaM);
    }
  }

  Future<void> guardarMotivos() async {
    await _storage.write(
        key: "motivosVisita",
        value: lista != null ? jsonEncode(listaM.toJson()) : null);
  }

  Future<void> getEstadosServidor({String filtro, int skip, int take}) async {
    var model = await estadoMotivoService.listarEstados(
        filtro: filtro, skip: skip, take: take);
    lista = model;
    _estadoController.add(lista);
    guardarEstados();
  }

  Future<void> getEstadosLocal() async {
    var jsonEstados = await _storage.read(key: "estadosVisita");
    if (jsonEstados != null) {
      var result = json.decode(jsonEstados) as dynamic;
      lista = PaginationEstadoModel.fromJson(result);
      _estadoController.add(lista);
    }
  }

  Future<void> guardarEstados() async {
    await _storage.write(
        key: "estadosVisita",
        value: lista != null ? jsonEncode(lista.toJson()) : null);
  }

  @override
  void dispose() {
    _estadoController.close();
    _motivoController.close();
  }
}
