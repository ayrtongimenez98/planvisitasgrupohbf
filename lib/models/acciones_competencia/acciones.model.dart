class AccionesCompetenciaModel {
  final int AccionesCompetencia_Id;
  final String AccionesCompetencia_Division;
  final String AccionesCompetencia_Canal;
  final String AccionesCompetencia_Precio;
  final String AccionesCompetencia_Colaborador;
  final String AccionesCompetencia_PrecioOferta;
  final String AccionesCompetencia_Observacion;
  final String AccionesCompetencia_Descripcion;

  AccionesCompetenciaModel(
      {this.AccionesCompetencia_Id,
      this.AccionesCompetencia_Division,
      this.AccionesCompetencia_Canal,
      this.AccionesCompetencia_Precio,
      this.AccionesCompetencia_Colaborador,
      this.AccionesCompetencia_PrecioOferta,
      this.AccionesCompetencia_Observacion,
      this.AccionesCompetencia_Descripcion});

  factory AccionesCompetenciaModel.fromJson(dynamic json) {
    return AccionesCompetenciaModel(
        AccionesCompetencia_Id: json["AccionesCompetencia_Id"] as int,
        AccionesCompetencia_Division:
            json["AccionesCompetencia_Division"] as String,
        AccionesCompetencia_Canal: json["AccionesCompetencia_Canal"] as String,
        AccionesCompetencia_Precio:
            json["AccionesCompetencia_Precio"] as String,
        AccionesCompetencia_Colaborador:
            json["AccionesCompetencia_Colaborador"] as String,
        AccionesCompetencia_PrecioOferta:
            json["AccionesCompetencia_PrecioOferta"] as String,
        AccionesCompetencia_Descripcion:
            json["AccionesCompetencia_Descripcion"] as String,
        AccionesCompetencia_Observacion:
            json["AccionesCompetencia_Observacion"] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "AccionesCompetencia_Id": AccionesCompetencia_Id,
      "AccionesCompetencia_Division": AccionesCompetencia_Division,
      "AccionesCompetencia_Canal": AccionesCompetencia_Canal,
      "AccionesCompetencia_Precio": AccionesCompetencia_Precio,
      "AccionesCompetencia_Colaborador": AccionesCompetencia_Colaborador,
      "AccionesCompetencia_PrecioOferta": AccionesCompetencia_PrecioOferta,
      "AccionesCompetencia_Descripcion": AccionesCompetencia_Descripcion,
      "AccionesCompetencia_Observacion": AccionesCompetencia_Observacion
    };
  }
}

AccionesCompetenciaModel defaultPlan = AccionesCompetenciaModel(
    AccionesCompetencia_Id: null,
    AccionesCompetencia_Division: null,
    AccionesCompetencia_Canal: null,
    AccionesCompetencia_Precio: null,
    AccionesCompetencia_Colaborador: null,
    AccionesCompetencia_PrecioOferta: null,
    AccionesCompetencia_Descripcion: null,
    AccionesCompetencia_Observacion: null);
