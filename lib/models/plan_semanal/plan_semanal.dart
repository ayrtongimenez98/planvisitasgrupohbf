class PlanSemanal {
  final int PlanSemanalId;
  final String Periodo;
  final int VendedorId;
  final String NombreVendedor;
  final String SucursalId;
  final String SucursalDireccion;
  final String SucursalCiudad;
  final String Cliente_Cod;
  final String Cliente_RazonSocial;
  final DateTime PlanSemanal_Horario;
  final String Estado;

  PlanSemanal(
      {this.Cliente_Cod,
      this.Cliente_RazonSocial,
      this.NombreVendedor,
      this.Periodo,
      this.PlanSemanalId,
      this.PlanSemanal_Horario,
      this.SucursalCiudad,
      this.SucursalDireccion,
      this.SucursalId,
      this.VendedorId,
      this.Estado});

  factory PlanSemanal.fromJson(dynamic json) {
    return PlanSemanal(
      Cliente_Cod: json["CodCliente"] as String,
      Estado: json["PlanSemanal_Estado"] as String,
      Cliente_RazonSocial: json["Cliente"] as String,
      PlanSemanal_Horario: json['PlanSemanal_Horario'] != null
          ? DateTime.parse(json['PlanSemanal_Horario'])
          : null,
      NombreVendedor: json["Vendedor"] as String,
      Periodo: json["Periodo"] as String,
      PlanSemanalId: json["PlanSemanal_Id"] as int,
      SucursalCiudad: json["Ciudad"] as String,
      SucursalDireccion: json["Direccion"] as String,
      SucursalId: json["Sucursal_Id"] as String,
      VendedorId: json["Vendedor_Id"] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "CodCliente": Cliente_Cod,
      "Cliente": Cliente_RazonSocial,
      "Vendedor": NombreVendedor,
      "Periodo": Periodo,
      "PlanSemanal_Id": PlanSemanalId,
      "Ciudad": SucursalCiudad,
      "Direccion": SucursalDireccion,
      "Sucursal_Id": SucursalId,
      "Vendedor_Id": VendedorId,
      "PlanSemanal_Estado": Estado,
      // ignore: prefer_null_aware_operators
      'PlanSemanal_Horario': PlanSemanal_Horario == null
          ? null
          : PlanSemanal_Horario.toIso8601String()
    };
  }
}

PlanSemanal defaultPlan = PlanSemanal(
    Cliente_Cod: null,
    Cliente_RazonSocial: null,
    NombreVendedor: null,
    Periodo: null,
    PlanSemanalId: null,
    PlanSemanal_Horario: null,
    SucursalCiudad: null,
    SucursalDireccion: null,
    SucursalId: null,
    VendedorId: null,
    Estado: null);
