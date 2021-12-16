import 'dart:convert';

import 'package:planvisitas_grupohbf/config/config.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/services/http_helpers/http.service.dart';

class ClienteService {
  final String endPoint = Config.clienteUrl;
  final HttpService http = HttpService();

  Future<PaginationClienteModel> traerClientesAsignados(
      {String filtro = "", int take = 10, int skip = 0}) async {
    try {
      final response = await http.get(
          Uri.parse(endPoint + "?Skip=${skip}&Take=${take}&Filtro=${filtro}"));
      if (response.statusCode == 200) {
        var result = json.decode(response.body) as dynamic;
        return PaginationClienteModel.fromJson(result);
      } else {
        return PaginationClienteModel(CantidadTotal: 0, Listado: []);
      }
    } catch (error) {
      return PaginationClienteModel(CantidadTotal: 0, Listado: []);
    }
  }
}
