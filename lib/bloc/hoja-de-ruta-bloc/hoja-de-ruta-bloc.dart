import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/session-info.dart';
import 'package:planvisitas_grupohbf/services/authentication/login.service.dart';
import 'package:planvisitas_grupohbf/services/hoja-de-ruta/hoja-de-ruta.service.dart';
import 'package:planvisitas_grupohbf/services/storage/secure_storage_helper.service.dart';

class PlanSemanalBloc implements Bloc {
  HojaRutaService _service = HojaRutaService();
  PaginationPlanModel lista =
      PaginationPlanModel(CantidadTotal: 0, Listado: []);
  SecureStorageHelper helper = new SecureStorageHelper();
  PaginationPlanModel get currentList => lista;
  final _planSemanalController =
      StreamController<PaginationPlanModel>.broadcast();
  Stream<PaginationPlanModel> get planStream => _planSemanalController.stream;
  final _storage = const FlutterSecureStorage();

  PlanSemanalBloc() {}

  Future<void> getPlanDiaServidor() async {
    var model = await _service.traerPlanDelDia();
    lista = model;
    _planSemanalController.add(lista);
    guardarPlanesDelDia();
  }

  Future<PaginationPlanModel> getPlanes(DateTime desde, DateTime hasta) async {
    var model = await _service.traerPlanes(desde, hasta);
    return model;
  }

  Future<void> getPlanDiaLocal() async {
    var jsonClientes = await _storage.read(key: "plandeldia");
    if (jsonClientes != null) {
      var result = json.decode(jsonClientes) as dynamic;
      lista = PaginationPlanModel.fromJson(result);
      _planSemanalController.add(lista);
    } else {
      _planSemanalController.add(lista);
    }
  }

  Future<void> guardarPlanesDelDia() async {
    await _storage.write(
        key: "plandeldia",
        value: lista != null ? jsonEncode(lista.toJson()) : null);
  }

  @override
  void dispose() {
    _planSemanalController.close();
  }
}
