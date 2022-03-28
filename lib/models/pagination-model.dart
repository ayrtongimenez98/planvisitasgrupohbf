import 'package:planvisitas_grupohbf/models/acciones_competencia/acciones.model.dart';
import 'package:planvisitas_grupohbf/models/cliente/cliente-model.dart';
import 'package:planvisitas_grupohbf/models/estadisticas/estadistica.model.dart';
import 'package:planvisitas_grupohbf/models/estado-motivo-visita/estado-motivo-model.dart';
import 'package:planvisitas_grupohbf/models/objetivovisita/objetivovisita-model.dart';
import 'package:planvisitas_grupohbf/models/plan_semanal/plan_semanal.dart';
import 'package:planvisitas_grupohbf/models/vencimientos/vencimiento.model.dart';
import 'package:planvisitas_grupohbf/models/visitas/visita-model.dart';

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

class PaginationVisitasModel {
  final int CantidadTotal;
  final List<VisitaModel> Listado;

  PaginationVisitasModel({this.CantidadTotal, this.Listado});

  factory PaginationVisitasModel.fromJson(Map<String, dynamic> json) {
    var items = json["Listado"] as List<dynamic>;

    return PaginationVisitasModel(
        CantidadTotal: json["CantidadTotal"] as int,
        Listado: items.map((e) => VisitaModel.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'CantidadTotal': CantidadTotal,
      'Listado': Listado.map((x) => x.toJson()).toList(),
    };
  }
}

class PaginationVencimientosModel {
  final int CantidadTotal;
  final List<VencimientoModel> Listado;

  PaginationVencimientosModel({this.CantidadTotal, this.Listado});

  factory PaginationVencimientosModel.fromJson(Map<String, dynamic> json) {
    var items = json["Listado"] as List<dynamic>;

    return PaginationVencimientosModel(
        CantidadTotal: json["CantidadTotal"] as int,
        Listado: items.map((e) => VencimientoModel.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'CantidadTotal': CantidadTotal,
      'Listado': Listado.map((x) => x.toJson()).toList(),
    };
  }
}

class PaginationAccionesModel {
  final int CantidadTotal;
  final List<AccionesCompetenciaModel> Listado;

  PaginationAccionesModel({this.CantidadTotal, this.Listado});

  factory PaginationAccionesModel.fromJson(Map<String, dynamic> json) {
    var items = json["Listado"] as List<dynamic>;

    return PaginationAccionesModel(
        CantidadTotal: json["CantidadTotal"] as int,
        Listado:
            items.map((e) => AccionesCompetenciaModel.fromJson(e)).toList());
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
  final bool Correcto;

  PaginationClienteModel({this.CantidadTotal, this.Listado, this.Correcto});

  factory PaginationClienteModel.fromJson(Map<String, dynamic> json) {
    var items = json["Listado"] as List<dynamic>;

    return PaginationClienteModel(
        CantidadTotal: json["CantidadTotal"] as int,
        Listado: items.map((e) => ClienteModel.fromJson(e)).toList(),
        Correcto: true);
  }

  Map<String, dynamic> toJson() {
    return {
      'CantidadTotal': CantidadTotal,
      'Listado': Listado.map((x) => x.toJson()).toList(),
      'Correcto': true
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

class PaginationEstadisticaModel {
  final int CantidadTotal;
  final List<EstadisticaModel> Listado;

  PaginationEstadisticaModel({this.CantidadTotal, this.Listado});

  factory PaginationEstadisticaModel.fromJson(Map<String, dynamic> json) {
    var items = json["Listado"] as List<dynamic>;

    return PaginationEstadisticaModel(
        CantidadTotal: json["CantidadTotal"] as int,
        Listado: items.map((e) => EstadisticaModel.fromJson(e)).toList());
  }
}

class PaginationMotivoModel {
  final int CantidadTotal;
  final List<MotivoModel> Listado;

  PaginationMotivoModel({this.CantidadTotal, this.Listado});

  factory PaginationMotivoModel.fromJson(Map<String, dynamic> json) {
    var items = json["Listado"] as List<dynamic>;

    return PaginationMotivoModel(
        CantidadTotal: json["CantidadTotal"] as int,
        Listado: items.map((e) => MotivoModel.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'CantidadTotal': CantidadTotal,
      'Listado': Listado.map((x) => x.toJson()).toList(),
    };
  }
}

class PaginationEstadoModel {
  final int CantidadTotal;
  final List<EstadoModel> Listado;

  PaginationEstadoModel({this.CantidadTotal, this.Listado});

  factory PaginationEstadoModel.fromJson(Map<String, dynamic> json) {
    var items = json["Listado"] as List<dynamic>;

    return PaginationEstadoModel(
        CantidadTotal: json["CantidadTotal"] as int,
        Listado: items.map((e) => EstadoModel.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'CantidadTotal': CantidadTotal,
      'Listado': Listado.map((x) => x.toJson()).toList(),
    };
  }
}
