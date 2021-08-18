// To parse this JSON data, do
//
//     final places = placesFromJson(jsonString);

import 'dart:convert';

Places placesFromJson(String str) => Places.fromJson(json.decode(str));

String placesToJson(Places data) => json.encode(data.toJson());

class Places {
  Places({
    this.value,
    this.message,
    this.data,
  });

  int? value;
  String? message;
  List<Datum>? data;

  factory Places.fromJson(Map<String, dynamic> json) => Places(
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
  Datum(
      {this.id,
      this.idCom,
      this.amenidadDesc,
      this.estadoAct,
      this.descrip,
      this.reserva});

  int? id;
  int? idCom;
  String? amenidadDesc;
  int? estadoAct;
  String? descrip;
  String? reserva;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      id: json["ID_AMENIDAD"],
      idCom: json["ID_COM"],
      amenidadDesc: json["AMENIDAD_DESC"],
      estadoAct: json["ESTADO_ACT"],
      descrip: json["DESCRIP"],
      reserva: json["RESERVA_COSTO"]);

  Map<String, dynamic> toJson() => {
        "ID_AMENIDAD": id,
        "ID_COM": idCom,
        "AMENIDAD_DESC": amenidadDesc,
        "ESTADO_ACT": estadoAct,
        "DESCRIP": descrip,
      };
}
