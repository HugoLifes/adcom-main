// To parse this JSON data, do
//
//     final getReportes = getReportesFromJson(jsonString);

import 'dart:convert';

GetReportes getReportesFromJson(String str) =>
    GetReportes.fromJson(json.decode(str));

String getReportesToJson(GetReportes data) => json.encode(data.toJson());

class GetReportes {
  GetReportes({
    this.value,
    this.message,
    this.data,
  });

  int? value;
  String? message;
  List<Datum>? data;

  factory GetReportes.fromJson(Map<String, dynamic> json) => GetReportes(
        value: json["value"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.descCorta,
    this.descDesperfecto,
    this.fechaRep,
    this.evidencia,
  });

  String? descCorta;
  String? descDesperfecto;
  DateTime? fechaRep;
  List<String>? evidencia;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        descCorta: json["DESC_CORTA"],
        descDesperfecto: json["DESC_DESPERFECTO"],
        fechaRep: DateTime.parse(json["FECHA_REP"]),
        evidencia: List<String>.from(json["EVIDENCIA"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "DESC_CORTA": descCorta,
        "DESC_DESPERFECTO": descDesperfecto,
        "FECHA_REP": fechaRep!.toIso8601String(),
        "EVIDENCIA": List<dynamic>.from(evidencia!.map((x) => x)),
      };
}
