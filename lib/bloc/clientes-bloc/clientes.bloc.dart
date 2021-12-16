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
import 'package:planvisitas_grupohbf/services/hoja-de-ruta/hoja-de-ruta.service.dart';
import 'package:planvisitas_grupohbf/services/storage/secure_storage_helper.service.dart';

class ClientesBloc implements Bloc {
  ClienteService _service = ClienteService();

  PaginationClienteModel lista =
      PaginationClienteModel(CantidadTotal: 0, Listado: []);
  SecureStorageHelper helper = new SecureStorageHelper();
  PaginationClienteModel get currentList => lista;
  final _clienteController =
      StreamController<PaginationClienteModel>.broadcast();
  Stream<PaginationClienteModel> get clienteStream => _clienteController.stream;
  final _storage = const FlutterSecureStorage();

  ClientesBloc() {}

  Future<void> getClientesServidor({String filtro, int skip, int take}) async {
    var model = await _service.traerClientesAsignados(
        filtro: filtro, skip: skip, take: take);
    lista = model;
    _clienteController.add(lista);
    guardarClientes();
  }

  Future<void> getClientesLocal() async {
    var jsonClientes = await _storage.read(key: "clientes");
    if (jsonClientes != null) {
      var result = json.decode(jsonClientes) as dynamic;
      lista = PaginationClienteModel.fromJson(result);
      _clienteController.add(lista);
      guardarClientes();
    }
  }

  Future<void> guardarClientes() async {
    await _storage.write(
        key: "clientes",
        value: lista != null ? jsonEncode(lista.toJson()) : null);
  }

  @override
  void dispose() {
    _clienteController.close();
  }
}
