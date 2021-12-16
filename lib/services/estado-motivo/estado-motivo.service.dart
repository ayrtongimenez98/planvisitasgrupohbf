import 'dart:convert';
import 'package:planvisitas_grupohbf/config/config.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/services/http_helpers/http.service.dart';

class EstadoMotivoService {
  final String endPointMotivo = Config.motivo;
  final String endPointEstado = Config.estado;
  final HttpService http = HttpService();

  Future<PaginationMotivoModel> listarMotivos(
      {String filtro = "", int take = 20, int skip = 0}) async {
    try {
      final response = await http.get(Uri.parse(
          endPointMotivo + "?Skip=${skip}&Take=${take}&Filtro=${filtro}"));
      if (response.statusCode == 200) {
        var result = json.decode(response.body) as dynamic;
        return PaginationMotivoModel.fromJson(result);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<PaginationEstadoModel> listarEstados(
      {String filtro = "", int take = 20, int skip = 0}) async {
    try {
      final response = await http.get(Uri.parse(
          endPointEstado + "?Skip=${skip}&Take=${take}&Filtro=${filtro}"));
      if (response.statusCode == 200) {
        var result = json.decode(response.body) as dynamic;
        return PaginationEstadoModel.fromJson(result);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
