import 'dart:convert';

ReferenciaP referenciaPFromJson(String str) =>
    ReferenciaP.fromJson(json.decode(str));

String referenciaPToJson(ReferenciaP data) => json.encode(data.toJson());

class ReferenciaP {
  ReferenciaP({
    this.value,
    this.message,
    this.referenciaP,
  });

  int? value;
  String? message;
  String? referenciaP;

  factory ReferenciaP.fromJson(Map<String, dynamic> json) => ReferenciaP(
        value: json["value"] == null ? null : json["value"],
        message: json["message"] == null ? null : json["message"],
        referenciaP: json["REFERENCIA_P"] == null ? null : json["REFERENCIA_P"],
      );

  Map<String, dynamic> toJson() => {
        "value": value == null ? null : value,
        "message": message == null ? null : message,
        "REFERENCIA_P": referenciaP == null ? null : referenciaP,
      };
}