import 'dart:convert';

Correo correoFromJson(String str) => Correo.fromJson(json.decode(str));

String correoToJson(Correo data) => json.encode(data.toJson());

class Correo {
  Correo({
    this.value,
    this.message,
  });

  int? value;
  String? message;

  factory Correo.fromJson(Map<String, dynamic> json) => Correo(
        value: json["value"] == null ? null : json["value"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "value": value == null ? null : value,
        "message": message == null ? null : message,
      };
}
