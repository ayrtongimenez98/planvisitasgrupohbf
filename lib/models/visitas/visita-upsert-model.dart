class VisitaUpsertModel {
  final int Visita_Id;
  final int Vendedor_Id;
  DateTime Visita_Hora_Entrada;
  DateTime Visita_Hora_Salida;
  final String Sucursal_Id;
  final String Cliente_Cod;
  final DateTime Visita_fecha;
  String Visita_Observacion;
  int Estado_Id;
  int Motivo_Id;
  String Direccion;
  String Ciudad;
  String Cliente;
  String Visita_Ubicacion_Entrada;
  String Visita_Ubicacion_Salida;

  VisitaUpsertModel(
      {this.Visita_Id,
      this.Vendedor_Id,
      this.Visita_Hora_Entrada,
      this.Visita_Hora_Salida,
      this.Sucursal_Id,
      this.Cliente_Cod,
      this.Estado_Id,
      this.Motivo_Id,
      this.Visita_Observacion,
      this.Visita_Ubicacion_Entrada,
      this.Visita_Ubicacion_Salida,
      this.Visita_fecha,
      this.Ciudad,
      this.Cliente,
      this.Direccion});

  factory VisitaUpsertModel.fromJson(dynamic json) {
    return VisitaUpsertModel(
      Visita_Id: json["Visita_Id"] as int,
      Vendedor_Id: json["Vendedor_Id"] as int,
      Ciudad: json["Ciudad"] as String,
      Cliente: json["Cliente"] as String,
      Direccion: json["Direccion"] as String,
      Visita_fecha: json['Visita_fecha'] != null
          ? DateTime.parse(json['Visita_fecha'])
          : null,
      Visita_Hora_Entrada: json['Visita_Hora_Entrada'] != null
          ? DateTime.parse(json['Visita_Hora_Entrada'])
          : null,
      Visita_Hora_Salida: json['Visita_Hora_Salida'] != null
          ? DateTime.parse(json['Visita_Hora_Salida'])
          : null,
      Sucursal_Id: json["Sucursal_Id"] as String,
      Cliente_Cod: json["Cliente_Cod"] as String,
      Estado_Id: json["Estado_Id"] as int,
      Motivo_Id: json["Motivo_Id"] as int,
      Visita_Observacion: json["Visita_Observacion"] as String,
      Visita_Ubicacion_Entrada: json["Visita_Ubicacion_Entrada"] as String,
      Visita_Ubicacion_Salida: json["Visita_Ubicacion_Salida"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Visita_Id": Visita_Id,
      "Vendedor_Id": Vendedor_Id,
      "Sucursal_Id": Sucursal_Id,
      "Ciudad": Ciudad,
      "Cliente": Cliente,
      "Direccion": Direccion,
      "Cliente_Cod": Cliente_Cod,
      "Visita_Observacion": Visita_Observacion,
      "Visita_Ubicacion_Entrada": Visita_Ubicacion_Entrada,
      "Visita_Ubicacion_Salida": Visita_Ubicacion_Salida,
      "Estado_Id": Estado_Id,
      "Motivo_Id": Motivo_Id,
      "Visita_Hora_Entrada": Visita_Hora_Entrada == null
          ? null
          : Visita_Hora_Entrada.toIso8601String(),
      "Visita_Hora_Salida": Visita_Hora_Salida == null
          ? null
          : Visita_Hora_Salida.toIso8601String(),
      'Visita_fecha':
          Visita_fecha == null ? null : Visita_fecha.toIso8601String()
    };
  }
}
