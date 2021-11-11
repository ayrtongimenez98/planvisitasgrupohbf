import 'dart:convert';
import 'package:planvisitas_grupohbf/config/config.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/services/http_helpers/http.service.dart';

class ObjetivoVisitaService {
  final String endPoint = Config.objetivoVisita;
  final HttpService http = HttpService();

  Future<PaginationObjetivoVisitaModel> listarObjetivos(
      {String filtro = "", int take = 20, int skip = 0}) async {
    try {
      final response = await http.get(
          Uri.parse(endPoint + "?Skip=${skip}&Take=${take}&Filtro=${filtro}"));
      if (response.statusCode == 200) {
        var result = json.decode(response.body) as dynamic;
        return PaginationObjetivoVisitaModel.fromJson(result);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
