class SessionInfo {
  final String Id;
  final String Usuario;
  final String Nombre;
  final int Usuario_Id;
  final String Email;
  final bool Es_Jefe;

  SessionInfo(
      {this.Id,
      this.Usuario,
      this.Nombre,
      this.Usuario_Id,
      this.Email,
      this.Es_Jefe});

  factory SessionInfo.fromJson(dynamic json) {
    return SessionInfo(
      Id: json["Id"] as String,
      Email: json["Email"] as String,
      Nombre: json["Nombre"] as String,
      Es_Jefe: json["Es_Jefe"] as bool,
      Usuario: json["Usuario"] as String,
      Usuario_Id: json["Usuario_Id"] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Id": Id,
      "Email": Email,
      "Nombre": Nombre,
      "Usuario": Usuario,
      "Usuario_Id": Usuario_Id,
      "Es_Jefe": Es_Jefe,
    };
  }
}

SessionInfo defaultSession = SessionInfo(
    Email: null,
    Es_Jefe: false,
    Id: null,
    Nombre: null,
    Usuario: null,
    Usuario_Id: 0);
