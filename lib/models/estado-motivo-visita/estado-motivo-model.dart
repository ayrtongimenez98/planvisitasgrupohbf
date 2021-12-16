class MotivoModel {
  final int Motivo_Id;
  final String Motivo_Descripcion;

  MotivoModel({this.Motivo_Id, this.Motivo_Descripcion});

  factory MotivoModel.fromJson(dynamic json) {
    return MotivoModel(
        Motivo_Id: json["Motivo_Id"] as int,
        Motivo_Descripcion: json["Motivo_Descripcion"] as String);
  }

  Map<String, dynamic> toJson() {
    return {"Motivo_Id": Motivo_Id, "Motivo_Descripcion": Motivo_Descripcion};
  }
}

MotivoModel defaultObjetivo =
    MotivoModel(Motivo_Id: null, Motivo_Descripcion: null);

class EstadoModel {
  final int Estado_Id;
  final String Estado_Descripcion;

  EstadoModel({this.Estado_Id, this.Estado_Descripcion});

  factory EstadoModel.fromJson(dynamic json) {
    return EstadoModel(
        Estado_Id: json["Estado_Id"] as int,
        Estado_Descripcion: json["Estado_Descripcion"] as String);
  }

  Map<String, dynamic> toJson() {
    return {"Estado_Id": Estado_Id, "Estado_Descripcion": Estado_Descripcion};
  }
}

EstadoModel defaultEstado =
    EstadoModel(Estado_Id: null, Estado_Descripcion: null);
