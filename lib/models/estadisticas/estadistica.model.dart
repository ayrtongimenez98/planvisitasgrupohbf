class EstadisticaModel {
  final int Objetivo;
  final int Realizado;
  final int Porcentaje;
  final int HechoPorDia;
  final int ObjetivoPorDia;
  final int CantidadSucursalesNoVisitados;
  final int CantidadSucursalesVisitados;

  EstadisticaModel(
      {this.Realizado,
      this.CantidadSucursalesNoVisitados,
      this.CantidadSucursalesVisitados,
      this.HechoPorDia,
      this.Objetivo,
      this.ObjetivoPorDia,
      this.Porcentaje});

  factory EstadisticaModel.fromJson(dynamic json) {
    return EstadisticaModel(
        Realizado: json["Realizado"] as int,
        CantidadSucursalesVisitados: json["CantidadSucursalesVisitados"] as int,
        HechoPorDia: json["HechoPorDia"] as int,
        Objetivo: json["Objetivo"] as int,
        ObjetivoPorDia: json["ObjetivoPorDia"] as int,
        Porcentaje: json["Porcentaje"] as int,
        CantidadSucursalesNoVisitados:
            json["CantidadSucursalesNoVisitados"] as int);
  }
}

EstadisticaModel defaultObjetivo = EstadisticaModel(
    CantidadSucursalesNoVisitados: null,
    CantidadSucursalesVisitados: null,
    HechoPorDia: null,
    Objetivo: null,
    ObjetivoPorDia: null,
    Porcentaje: null,
    Realizado: null);
