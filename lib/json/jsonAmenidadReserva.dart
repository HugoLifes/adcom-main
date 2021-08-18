// To parse this JSON data, do
//
//     final reservaData = reservaDataFromJson(jsonString);

import 'dart:convert';

ReservaData reservaDataFromJson(String str) =>
    ReservaData.fromJson(json.decode(str));

String reservaDataToJson(ReservaData data) => json.encode(data.toJson());

class ReservaData {
  ReservaData({
    this.value,
    this.message,
    this.data,
  });

  int? value;
  String? message;
  Data? data;

  factory ReservaData.fromJson(Map<String, dynamic> json) => ReservaData(
        value: json["value"] == null ? null : json["value"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "value": value == null ? null : value,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.descripcionCorta,
    this.reservaCosto,
    this.descripcionLarga,
    this.reservas,
  });

  String? descripcionCorta;
  dynamic? reservaCosto;
  String? descripcionLarga;
  List<Reserva>? reservas;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        descripcionCorta: json["DESCRIPCION_CORTA"] == null
            ? null
            : json["DESCRIPCION_CORTA"],
        reservaCosto: json["RESERVA_COSTO"],
        descripcionLarga: json["DESCRIPCION_LARGA"] == null
            ? null
            : json["DESCRIPCION_LARGA"],
        reservas: json["RESERVAS"] == null
            ? null
            : List<Reserva>.from(
                json["RESERVAS"].map((x) => Reserva.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "DESCRIPCION_CORTA": descripcionCorta == null ? null : descripcionCorta,
        "RESERVA_COSTO": reservaCosto,
        "DESCRIPCION_LARGA": descripcionLarga == null ? null : descripcionLarga,
        "RESERVAS": reservas == null
            ? null
            : List<dynamic>.from(reservas!.map((x) => x.toJson())),
      };
}

class Reserva {
  Reserva({
    this.fechaIni,
    this.fechafinEvent,
    this.comentario,
  });

  DateTime? fechaIni;
  DateTime? fechafinEvent;
  String? comentario;

  factory Reserva.fromJson(Map<String, dynamic> json) => Reserva(
        fechaIni: json["FECHA_INI"] == null
            ? null
            : DateTime.parse(json["FECHA_INI"]),
        fechafinEvent: json["FECHAFIN_EVENT"] == null
            ? null
            : DateTime.parse(json["FECHAFIN_EVENT"]),
        comentario: json["COMENTARIO"] == null ? null : json["COMENTARIO"],
      );

  Map<String, dynamic> toJson() => {
        "FECHA_INI": fechaIni == null ? null : fechaIni!.toIso8601String(),
        "FECHAFIN_EVENT":
            fechafinEvent == null ? null : fechafinEvent!.toIso8601String(),
        "COMENTARIO": comentario == null ? null : comentario,
      };
}
