class ClienteModel {
  final int Canal_Id;
  final String SucursalId;
  final String SucursalDireccion;
  final String SucursalCiudad;
  final String Cliente_Cod;
  final String Local;
  final String Cliente_RazonSocial;
  final int Cantidad_Visitas;
  bool Checked;

  ClienteModel(
      {this.Cliente_Cod,
      this.Cliente_RazonSocial,
      this.Local,
      this.SucursalCiudad,
      this.SucursalDireccion,
      this.SucursalId,
      this.Canal_Id,
      this.Cantidad_Visitas,
      this.Checked});

  factory ClienteModel.fromJson(dynamic json) {
    return ClienteModel(
        Cliente_Cod: json["Cliente_Cod"] as String,
        Cantidad_Visitas: json["Cantidad_Visitas"] as int,
        Cliente_RazonSocial: json["Cliente_RazonSocial"] as String,
        Local: json["Sucursal_Local"] as String,
        Canal_Id: json["Canal_Id"] as int,
        SucursalCiudad: json["Sucursal_Ciudad"] as String,
        SucursalDireccion: json["Sucursal_Direccion"] as String,
        SucursalId: json["Sucursal_Id"] as String,
        Checked: false);
  }

  Map<String, dynamic> toJson() {
    return {
      "Cliente_Cod": Cliente_Cod,
      "Cliente_RazonSocial": Cliente_RazonSocial,
      "Sucursal_Ciudad": SucursalCiudad,
      "Sucursal_Direccion": SucursalDireccion,
      "Sucursal_Id": SucursalId,
      "Canal_Id": Canal_Id,
      "Cantidad_Visitas": Cantidad_Visitas,
      "Sucursal_Local": Local,
      "Checked": Checked
    };
  }
}

ClienteModel defaultPlan = ClienteModel(
    Cliente_Cod: null,
    Cliente_RazonSocial: null,
    Canal_Id: null,
    Cantidad_Visitas: null,
    Local: null,
    SucursalCiudad: null,
    SucursalDireccion: null,
    SucursalId: null,
    Checked: false);
