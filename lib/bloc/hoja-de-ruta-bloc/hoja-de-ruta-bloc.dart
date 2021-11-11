import 'dart:async';
import 'package:planvisitas_grupohbf/bloc/shared/bloc.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/session-info.dart';
import 'package:planvisitas_grupohbf/services/authentication/login.service.dart';
import 'package:planvisitas_grupohbf/services/hoja-de-ruta/hoja-de-ruta.service.dart';
import 'package:planvisitas_grupohbf/services/storage/secure_storage_helper.service.dart';

class PlanSemanalBloc implements Bloc {
  HojaRutaService _service = HojaRutaService();
  List<PlanSemanal> lista = [];
  SecureStorageHelper helper = new SecureStorageHelper();
  List<PlanSemanal> get currentList => lista;
  final _planSemanalController =
      StreamController<List<PlanSemanal>>.broadcast();
  Stream<List<PlanSemanal>> get planStream => _planSemanalController.stream;

  SessionBloc() {
    getPlanDia();
  }

  Future<List<PlanSemanal>> getPlanDia() async {
    var model = await _service.traerPlanDelDia();
    lista = model.Listado;
    _planSemanalController.add(lista);
  }

  Future<PaginationPlanModel> getPlanes(DateTime desde, DateTime hasta) async {
    var model = await _service.traerPlanes(desde, hasta);
    return model;
  }

  @override
  void dispose() {
    _planSemanalController.close();
  }
}
