import 'dart:convert';
import 'package:planvisitas_grupohbf/config/config.dart';
import 'package:planvisitas_grupohbf/models/pagination-model.dart';
import 'package:planvisitas_grupohbf/services/http_helpers/http.service.dart';

class EstadisticaService {
  final String endPoint = Config.estadisticaVisita;
  final HttpService http = HttpService();

  Future<PaginationEstadisticaModel> traerEstadistica(
      DateTime desde, DateTime hasta) async {
    try {
      final response = await http.get(Uri.parse(endPoint +
          "?fechaDesde=${desde.month}/${desde.day}/${desde.year}&fechaHasta=${hasta.month}/${hasta.day}/${hasta.year}"));
      if (response.statusCode == 200) {
        var result = json.decode(response.body) as dynamic;
        return PaginationEstadisticaModel.fromJson(result);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
