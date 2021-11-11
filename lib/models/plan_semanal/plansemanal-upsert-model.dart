class PlanSemanalUpsertModel {
  final int PlanSemanalId;
  final int VendedorId;
  final String SucursalId;
  final String Cliente_Cod;
  String Cliente_RazonSocial;
  String Sucursal_Direccion;
  String Hora;
  DateTime PlanSemanal_Horario;
  final String Estado;
  int ObjetivoVisita_Id;

  PlanSemanalUpsertModel(
      {this.Cliente_Cod,
      this.Estado,
      this.ObjetivoVisita_Id,
      this.PlanSemanalId,
      this.PlanSemanal_Horario,
      this.SucursalId,
      this.VendedorId,
      this.Cliente_RazonSocial,
      this.Sucursal_Direccion,
      this.Hora});

  factory PlanSemanalUpsertModel.fromJson(dynamic json) {
    return PlanSemanalUpsertModel(
        Cliente_Cod: json["Cliente_Cod"] as String,
        Estado: json["PlanSemanal_Estado"] as String,
        PlanSemanal_Horario: json['PlanSemanal_Horario'] != null
            ? DateTime.parse(json['PlanSemanal_Horario'])
            : null,
        PlanSemanalId: json["PlanSemanal_Id"] as int,
        SucursalId: json["Sucursal_Id"] as String,
        VendedorId: json["Vendedor_Id"] as int,
        ObjetivoVisita_Id: json["ObjetivoVisita_Id"] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      "Cliente_Cod": Cliente_Cod,
      "PlanSemanal_Id": PlanSemanalId,
      "Sucursal_Id": SucursalId,
      "Vendedor_Id": VendedorId,
      "PlanSemanal_Estado": Estado,
      "ObjetivoVisita_Id": ObjetivoVisita_Id,
      'PlanSemanal_Horario': PlanSemanal_Horario == null
          ? null
          : PlanSemanal_Horario.toIso8601String()
    };
  }
}
