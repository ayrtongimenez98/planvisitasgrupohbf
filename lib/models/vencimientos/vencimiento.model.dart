class VencimientoModel {
  final int Vencimiento_Id;
  final String Vencimiento_Division;
  final String Vencimiento_Canal;
  final String Vencimiento_Cargo;
  final String Vencimiento_Colaborador;
  final String Vencimiento_PuntoVentaDireccion;
  final String Vencimiento_Codigo_Barras;
  final String Vencimiento_Descripcion_Producto;
  final String Vencimiento_Cantidad_SKU;
  final DateTime Vencimiento_Rango_Fecha;

  VencimientoModel(
      {this.Vencimiento_Id,
      this.Vencimiento_Division,
      this.Vencimiento_Canal,
      this.Vencimiento_Cargo,
      this.Vencimiento_Colaborador,
      this.Vencimiento_PuntoVentaDireccion,
      this.Vencimiento_Codigo_Barras,
      this.Vencimiento_Descripcion_Producto,
      this.Vencimiento_Cantidad_SKU,
      this.Vencimiento_Rango_Fecha});

  factory VencimientoModel.fromJson(dynamic json) {
    return VencimientoModel(
        Vencimiento_Id: json["Vencimiento_Id"] as int,
        Vencimiento_Division: json["Vencimiento_Division"] as String,
        Vencimiento_Rango_Fecha: json['Vencimiento_Rango_Fecha'] != null
            ? DateTime.parse(json['Vencimiento_Rango_Fecha'])
            : null,
        Vencimiento_Canal: json["Vencimiento_Canal"] as String,
        Vencimiento_Cargo: json["Vencimiento_Cargo"] as String,
        Vencimiento_Colaborador: json["Vencimiento_Colaborador"] as String,
        Vencimiento_PuntoVentaDireccion:
            json["Vencimiento_PuntoVentaDireccion"] as String,
        Vencimiento_Codigo_Barras: json["Vencimiento_Codigo_Barras"] as String,
        Vencimiento_Descripcion_Producto:
            json["Vencimiento_Descripcion_Producto"] as String,
        Vencimiento_Cantidad_SKU: json["Vencimiento_Cantidad_SKU"] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "Vencimiento_Id": Vencimiento_Id,
      "Vencimiento_Division": Vencimiento_Division,
      "Vencimiento_Canal": Vencimiento_Canal,
      "Vencimiento_Cargo": Vencimiento_Cargo,
      "Vencimiento_Colaborador": Vencimiento_Colaborador,
      "Vencimiento_PuntoVentaDireccion": Vencimiento_PuntoVentaDireccion,
      "Vencimiento_Codigo_Barras": Vencimiento_Codigo_Barras,
      "Vencimiento_Descripcion_Producto": Vencimiento_Descripcion_Producto,
      "Vencimiento_Cantidad_SKU": Vencimiento_Cantidad_SKU,
      // ignore: prefer_null_aware_operators
      'Vencimiento_Rango_Fecha': Vencimiento_Rango_Fecha == null
          ? null
          : Vencimiento_Rango_Fecha.toIso8601String()
    };
  }
}

VencimientoModel defaultPlan = VencimientoModel(
    Vencimiento_Id: null,
    Vencimiento_Division: null,
    Vencimiento_Canal: null,
    Vencimiento_Cargo: null,
    Vencimiento_Colaborador: null,
    Vencimiento_PuntoVentaDireccion: null,
    Vencimiento_Codigo_Barras: null,
    Vencimiento_Descripcion_Producto: null,
    Vencimiento_Cantidad_SKU: null,
    Vencimiento_Rango_Fecha: null);
