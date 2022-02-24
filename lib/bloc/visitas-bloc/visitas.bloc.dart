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
import 'package:planvisitas_grupohbf/services/visitas/visitas.service.dart';

class VisitasBloc implements Bloc {
  VisitasService _service = VisitasService();

  PaginationVisitasModel lista =
      PaginationVisitasModel(CantidadTotal: 0, Listado: []);
  SecureStorageHelper helper = new SecureStorageHelper();
  PaginationVisitasModel get currentList => lista;
  final _visitaController =
      StreamController<PaginationVisitasModel>.broadcast();
  Stream<PaginationVisitasModel> get Visitastream => _visitaController.stream;
  final _storage = const FlutterSecureStorage();

  VisitasBloc() {}

  Future<void> getVisitasServidor({String filtro, int skip, int take}) async {
    var model =
        await _service.traerVisitasDelDia(filtro: "", skip: 0, take: 40);
    lista = model;
    _visitaController.add(lista);
  }

  @override
  void dispose() {
    _visitaController.close();
  }
}
