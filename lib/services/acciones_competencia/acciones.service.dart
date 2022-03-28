import 'dart:convert';

import 'package:planvisitas_grupohbf/config/config.dart';
import 'package:planvisitas_grupohbf/models/acciones_competencia/acciones.model.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plansemanal-upsert-model.dart';
import 'package:planvisitas_grupohbf/models/shared/system-validation-model.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-upsert-model.dart';
import 'package:planvisitas_grupohbf/services/http_helpers/http.service.dart';

class AccionesCompetenciaService {
  final String endPoint = Config.acciones;
  final HttpService http = HttpService();

  Future<PaginationAccionesModel> traerAccionesCompetencias(
      {String filtro = "", int skip = 0, int take = 10}) async {
    try {
      final response = await http
          .get(Uri.parse(endPoint + "?Skip=$skip&Take=$take&Filtro=$filtro"));
      if (response.statusCode == 200) {
        var result = json.decode(response.body) as dynamic;
        return PaginationAccionesModel.fromJson(result);
      } else {
        return PaginationAccionesModel(CantidadTotal: 0, Listado: []);
      }
    } catch (error) {
      return PaginationAccionesModel(CantidadTotal: 0, Listado: []);
    }
  }

  Future<SystemValidationModel> agregarAccionesCompetencia(
      AccionesCompetenciaModel model) async {
    try {
      var bodyJson = model.toJson();
      final response = await http.post(Uri.parse(endPoint), body: bodyJson);
      if (response.statusCode == 200) {
        var result = json.decode(response.body) as dynamic;
        return SystemValidationModel.fromJson(result);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
