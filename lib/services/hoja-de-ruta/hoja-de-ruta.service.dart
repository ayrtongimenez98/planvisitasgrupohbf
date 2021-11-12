import 'dart:convert';

import 'package:planvisitas_grupohbf/config/config.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plansemanal-upsert-model.dart';
import 'package:planvisitas_grupohbf/models/shared/system-validation-model.dart';
import 'package:planvisitas_grupohbf/services/http_helpers/http.service.dart';

class HojaRutaService {
  final String endPoint = Config.planSemanalUrl;
  final HttpService http = HttpService();

  Future<PaginationPlanModel> traerPlanDelDia() async {
    try {
      final response = await http.get(Uri.parse(endPoint +
          "?Fecha_Desde=${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}&Fecha_Hasta=${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}&Vendedor_Id=0&Skip=0&Take=10&Cliente_Cod="
              "&Filtro="
              ""));
      if (response.statusCode == 200) {
        var result = json.decode(response.body) as dynamic;
        return PaginationPlanModel.fromJson(result);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<PaginationPlanModel> traerPlanes(DateTime desde, DateTime hasta,
      {String filtro = ""}) async {
    try {
      final response = await http.get(Uri.parse(endPoint +
          "?Fecha_Desde=${desde.month}/${desde.day}/${desde.year}&Fecha_Hasta=${hasta.month}/${hasta.day}/${hasta.year}&Vendedor_Id=0&Skip=0&Take=10&Cliente_Cod="
              "&Filtro="
              ""));
      if (response.statusCode == 200) {
        var result = json.decode(response.body) as dynamic;
        return PaginationPlanModel.fromJson(result);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<SystemValidationModel> agregarPlanes(
      List<PlanSemanalUpsertModel> lista) async {
    try {
      var bodyJson = lista.map((x) => x.toJson()).toList();
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
