class SystemValidationModel {
  final bool Success;
  final String Message;

  SystemValidationModel({this.Success, this.Message});

  factory SystemValidationModel.fromJson(dynamic json) {
    return SystemValidationModel(
        Success: json["Success"] as bool, Message: json["Message"] as String);
  }

  Map<String, dynamic> toJson() {
    return {"Success": Success, "Message": Message};
  }
}

SystemValidationModel defaultObjetivo =
    SystemValidationModel(Message: null, Success: null);
