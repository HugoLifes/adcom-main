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
        value: json["value"] == null ? null : json["value"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "value": value == null ? null : value,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.descCorta,
    this.descDesperfecto,
    this.fechaRep,
    this.evidencia,
    this.progreso,
    this.idReporte,
  });

  String? descCorta;
  String? descDesperfecto;
  DateTime? fechaRep;
  List<String>? evidencia;
  List<Progreso>? progreso;
  int? idReporte;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        descCorta: json["DESC_CORTA"] == null ? null : json["DESC_CORTA"],
        descDesperfecto:
            json["DESC_DESPERFECTO"] == null ? null : json["DESC_DESPERFECTO"],
        fechaRep: json["FECHA_REP"] == null
            ? null
            : DateTime.parse(json["FECHA_REP"]),
        evidencia: json["EVIDENCIA"] == null
            ? null
            : List<String>.from(json["EVIDENCIA"].map((x) => x)),
        progreso: json["PROGRESO"] == null
            ? null
            : List<Progreso>.from(
                json["PROGRESO"].map((x) => Progreso.fromJson(x))),
        idReporte: json["ID_REPORTE"] == null ? null : json["ID_REPORTE"],
      );

  Map<String, dynamic> toJson() => {
        "DESC_CORTA": descCorta == null ? null : descCorta,
        "DESC_DESPERFECTO": descDesperfecto == null ? null : descDesperfecto,
        "FECHA_REP": fechaRep == null ? null : fechaRep!.toIso8601String(),
        "EVIDENCIA": evidencia == null
            ? null
            : List<dynamic>.from(evidencia!.map((x) => x)),
        "PROGRESO": progreso == null
            ? null
            : List<dynamic>.from(progreso!.map((x) => x.toJson())),
        "ID_REPORTE": idReporte == null ? null : idReporte,
      };
}

class Progreso {
  Progreso({
    this.fechaSeg,
    this.comentario,
    this.progreso,
    this.idProgreso,
  });

  DateTime? fechaSeg;
  String? comentario;
  String? progreso;
  int? idProgreso;

  factory Progreso.fromJson(Map<String, dynamic> json) => Progreso(
        fechaSeg: json["FECHA_SEG"] == null
            ? null
            : DateTime.parse(json["FECHA_SEG"]),
        comentario: json["COMENTARIO"] == null ? null : json["COMENTARIO"],
        progreso: json["PROGRESO"] == null ? null : json["PROGRESO"],
        idProgreso: json["ID_PROGRESO"] == null ? null : json["ID_PROGRESO"],
      );

  Map<String, dynamic> toJson() => {
        "FECHA_SEG": fechaSeg == null ? null : fechaSeg!.toIso8601String(),
        "COMENTARIO": comentario == null ? null : comentario,
        "PROGRESO": progreso == null ? null : progreso,
        "ID_PROGRESO": idProgreso == null ? null : idProgreso,
      };
}
