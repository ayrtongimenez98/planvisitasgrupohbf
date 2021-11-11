import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/objetivovisita/objetivovisita-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';

class PaginationPlanModel {
  final int CantidadTotal;
  final List<PlanSemanal> Listado;

  PaginationPlanModel({this.CantidadTotal, this.Listado});

  factory PaginationPlanModel.fromJson(Map<String, dynamic> json) {
    var items = json["Listado"] as List<dynamic>;

    return PaginationPlanModel(
        CantidadTotal: json["CantidadTotal"] as int,
        Listado: items.map((e) => PlanSemanal.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'CantidadTotal': CantidadTotal,
      'Listado': Listado.map((x) => x.toJson()).toList(),
    };
  }
}

class PaginationClienteModel {
  final int CantidadTotal;
  final List<ClienteModel> Listado;

  PaginationClienteModel({this.CantidadTotal, this.Listado});

  factory PaginationClienteModel.fromJson(Map<String, dynamic> json) {
    var items = json["Listado"] as List<dynamic>;

    return PaginationClienteModel(
        CantidadTotal: json["CantidadTotal"] as int,
        Listado: items.map((e) => ClienteModel.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'CantidadTotal': CantidadTotal,
      'Listado': Listado.map((x) => x.toJson()).toList(),
    };
  }
}

class PaginationObjetivoVisitaModel {
  final int CantidadTotal;
  final List<ObjetivoVisitaModel> Listado;

  PaginationObjetivoVisitaModel({this.CantidadTotal, this.Listado});

  factory PaginationObjetivoVisitaModel.fromJson(Map<String, dynamic> json) {
    var items = json["Listado"] as List<dynamic>;

    return PaginationObjetivoVisitaModel(
        CantidadTotal: json["CantidadTotal"] as int,
        Listado: items.map((e) => ObjetivoVisitaModel.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'CantidadTotal': CantidadTotal,
      'Listado': Listado.map((x) => x.toJson()).toList(),
    };
  }
}
