class ObjetivoVisitaModel {
  final int ObjetivoVisita_Id;
  final String ObjetivoVisita_Descripcion;

  ObjetivoVisitaModel(
      {this.ObjetivoVisita_Id, this.ObjetivoVisita_Descripcion});

  factory ObjetivoVisitaModel.fromJson(dynamic json) {
    return ObjetivoVisitaModel(
        ObjetivoVisita_Id: json["ObjetivoVisita_Id"] as int,
        ObjetivoVisita_Descripcion:
            json["ObjetivoVisita_Descripcion"] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "ObjetivoVisita_Id": ObjetivoVisita_Id,
      "ObjetivoVisita_Descripcion": ObjetivoVisita_Descripcion
    };
  }
}

ObjetivoVisitaModel defaultObjetivo = ObjetivoVisitaModel(
    ObjetivoVisita_Id: null, ObjetivoVisita_Descripcion: null);
