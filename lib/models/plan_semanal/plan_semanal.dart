class PlanSemanal {
  final int PlanSemanalId;
  final int NroSemana;
  final String Periodo;
  final String DiaSemana;
  final int VendedorId;
  final String NombreVendedor;
  final int SucursalId;
  final String SucursalDireccion;
  final String SucursalCiudad;
  final int CodigoJefe;
  final String NombreJefe;
  final int Cantidad;
  final int ObjetivoVisita;
  final String Cliente_Cod;
  final String Cliente_RazonSocial;
  final DateTime PlanSemanal_Horario;

  PlanSemanal(
      {this.Cantidad,
      this.Cliente_Cod,
      this.Cliente_RazonSocial,
      this.CodigoJefe,
      this.DiaSemana,
      this.NombreJefe,
      this.NombreVendedor,
      this.NroSemana,
      this.ObjetivoVisita,
      this.Periodo,
      this.PlanSemanalId,
      this.PlanSemanal_Horario,
      this.SucursalCiudad,
      this.SucursalDireccion,
      this.SucursalId,
      this.VendedorId});

  factory PlanSemanal.fromJson(dynamic json) {
    return PlanSemanal(
      Cantidad: json["Cantidad"] as int,
      Cliente_Cod: json["Cliente_Cod"] as String,
      Cliente_RazonSocial: json["Cliente_RazonSocial"] as String,
      PlanSemanal_Horario: json['PlanSemanal_Horario'] != null
          ? DateTime.parse(json['PlanSemanal_Horario'])
          : null,
      CodigoJefe: json["CodigoJefe"] as int,
      DiaSemana: json["DiaSemana"] as String,
      NombreJefe: json["NombreJefe"] as String,
      NombreVendedor: json["NombreVendedor"] as String,
      NroSemana: json["NroSemana"] as int,
      ObjetivoVisita: json["ObjetivoVisita"] as int,
      Periodo: json["Periodo"] as String,
      PlanSemanalId: json["PlanSemanalId"] as int,
      SucursalCiudad: json["SucursalCiudad"] as String,
      SucursalDireccion: json["SucursalDireccion"] as String,
      SucursalId: json["SucursalId"] as int,
      VendedorId: json["VendedorId"] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Cantidad": Cantidad,
      "Cliente_Cod": Cliente_Cod,
      "Cliente_RazonSocial": Cliente_RazonSocial,
      "CodigoJefe": CodigoJefe,
      "DiaSemana": DiaSemana,
      "NombreJefe": NombreJefe,
      "NombreVendedor": NombreVendedor,
      "NroSemana": NroSemana,
      "ObjetivoVisita": ObjetivoVisita,
      "Periodo": Periodo,
      "PlanSemanalId": PlanSemanalId,
      "SucursalCiudad": SucursalCiudad,
      "SucursalDireccion": SucursalDireccion,
      "SucursalId": SucursalId,
      "VendedorId": VendedorId,
      // ignore: prefer_null_aware_operators
      'PlanSemanal_Horario': PlanSemanal_Horario == null
          ? null
          : PlanSemanal_Horario.toIso8601String()
    };
  }
}

PlanSemanal defaultPlan = PlanSemanal(
    Cantidad: null,
    Cliente_Cod: null,
    Cliente_RazonSocial: null,
    CodigoJefe: null,
    DiaSemana: null,
    NombreJefe: null,
    NombreVendedor: null,
    NroSemana: null,
    ObjetivoVisita: null,
    Periodo: null,
    PlanSemanalId: null,
    PlanSemanal_Horario: null,
    SucursalCiudad: null,
    SucursalDireccion: null,
    SucursalId: null,
    VendedorId: null);
