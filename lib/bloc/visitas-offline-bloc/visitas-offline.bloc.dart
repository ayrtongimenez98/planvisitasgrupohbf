import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc.dart';
import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/session-info.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-model.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-upsert-model.dart';
import 'package:planvisitas_grupohbf/services/authentication/login.service.dart';
import 'package:planvisitas_grupohbf/services/cliente/cliente.service.dart';
import 'package:planvisitas_grupohbf/services/hoja-de-ruta/hoja-de-ruta.service.dart';
import 'package:planvisitas_grupohbf/services/storage/secure_storage_helper.service.dart';

class VisitasOfflineBloc implements Bloc {
  ClienteService _service = ClienteService();

  List<VisitaUpsertModel> lista = [];

  List<VisitaUpsertModel> get currentList => lista;
  final _visitasController =
      StreamController<List<VisitaUpsertModel>>.broadcast();
  Stream<List<VisitaUpsertModel>> get visitaStream => _visitasController.stream;

  final _storage = const FlutterSecureStorage();

  VisitasOfflineBloc() {}

  Future<void> getVisitasLocal() async {
    var jsonClientes = await _storage.read(key: "visitasoffline");
    if (jsonClientes != null) {
      var result = json.decode(jsonClientes) as List<dynamic>;
      lista = result.map((e) => VisitaUpsertModel.fromJson(e)).toList();
      _visitasController.add(lista);
    }
  }

  Future<void> guardarVisitas() async {
    await _storage.write(
        key: "visitasoffline",
        value: lista != null
            ? jsonEncode(lista.map((x) => x.toJson()).toList())
            : null);
  }

  Future<void> agregarNuevaVisita(VisitaUpsertModel v) async {
    lista.add(v);
    _visitasController.add(lista);
    await guardarVisitas();
  }

  Future<void> borrarVisita(VisitaUpsertModel v) async {
    lista.remove(v);
    _visitasController.add(lista);
    await guardarVisitas();
  }

  Future<void> agregarSalidaVisita(VisitaUpsertModel v) async {
    var items = lista.where((element) =>
        element.Cliente_Cod == v.Cliente_Cod &&
        element.Sucursal_Id == v.Sucursal_Id &&
        element.Visita_Ubicacion_Salida == "");
    if (items.length > 0) {
      var visitaEntrada = items.first;
      var index = lista.indexOf(visitaEntrada);
      lista[index] = v;
      _visitasController.add(lista);
      await guardarVisitas();
    }
  }

  @override
  void dispose() {
    _visitasController.close();
  }
}
