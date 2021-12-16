class VisitaModel {
  final int Visita_Id;
  final String Periodo;
  final int Vendedor_Id;
  final String Visita_Hora_Entrada;
  final String Visita_Hora_Salida;
  final String Vendedor;
  final String Sucursal_Id;
  final String Direccion;
  final String Ciudad;
  final String CodCliente;
  final String Cliente;
  final DateTime Visita_fecha;
  final String Observacion;
  final String Visita_Ubicacion_Entrada;
  final String Visita_Ubicacion_Salida;

  VisitaModel(
      {this.Visita_Id,
      this.Periodo,
      this.Vendedor_Id,
      this.Visita_Hora_Entrada,
      this.Visita_Hora_Salida,
      this.Vendedor,
      this.Sucursal_Id,
      this.Direccion,
      this.Ciudad,
      this.CodCliente,
      this.Cliente,
      this.Observacion,
      this.Visita_Ubicacion_Entrada,
      this.Visita_Ubicacion_Salida,
      this.Visita_fecha});

  factory VisitaModel.fromJson(dynamic json) {
    return VisitaModel(
      Visita_Id: json["Visita_Id"] as int,
      Periodo: json["Periodo"] as String,
      Vendedor_Id: json["Vendedor_Id"] as int,
      Visita_fecha: json['Visita_fecha'] != null
          ? DateTime.parse(json['Visita_fecha'])
          : null,
      Visita_Hora_Entrada: json["Visita_Hora_Entrada"] as String,
      Visita_Hora_Salida: json["Visita_Hora_Salida"] as String,
      Vendedor: json["Vendedor"] as String,
      Sucursal_Id: json["Sucursal_Id"] as String,
      Direccion: json["Direccion"] as String,
      Ciudad: json["Ciudad"] as String,
      CodCliente: json["CodCliente"] as String,
      Cliente: json["Cliente"] as String,
      Observacion: json["Observacion"] as String,
      Visita_Ubicacion_Entrada: json["Visita_Ubicacion_Entrada"] as String,
      Visita_Ubicacion_Salida: json["Visita_Ubicacion_Salida"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Visita_Id": Visita_Id,
      "Periodo": Periodo,
      "Vendedor_Id": Vendedor_Id,
      "Visita_Hora_Entrada": Visita_Hora_Entrada,
      "Visita_Hora_Salida": Visita_Hora_Salida,
      "Vendedor": Vendedor,
      "Sucursal_Id": Sucursal_Id,
      "Direccion": Direccion,
      "Ciudad": Ciudad,
      "CodCliente": CodCliente,
      "Cliente": Cliente,
      "Observacion": Observacion,
      "Visita_Ubicacion_Entrada": Visita_Ubicacion_Entrada,
      "Visita_Ubicacion_Salida": Visita_Ubicacion_Salida,
      // ignore: prefer_null_aware_operators
      'Visita_fecha':
          Visita_fecha == null ? null : Visita_fecha.toIso8601String()
    };
  }
}

VisitaModel defaultPlan = VisitaModel(
    Ciudad: null,
    Cliente: null,
    CodCliente: null,
    Direccion: null,
    Observacion: null,
    Periodo: null,
    Sucursal_Id: null,
    Vendedor: null,
    Vendedor_Id: null,
    Visita_Hora_Entrada: null,
    Visita_Hora_Salida: null,
    Visita_Id: null,
    Visita_Ubicacion_Entrada: null,
    Visita_Ubicacion_Salida: null,
    Visita_fecha: null);
