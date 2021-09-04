// To parse this JSON data, do
//
//     final tipoAviso = tipoAvisoFromJson(jsonString);

import 'dart:convert';

TipoAviso tipoAvisoFromJson(String str) => TipoAviso.fromJson(json.decode(str));

String tipoAvisoToJson(TipoAviso data) => json.encode(data.toJson());

class TipoAviso {
  TipoAviso({
    this.value,
    this.message,
    this.data,
  });

  int? value;
  String? message;
  List<Datum>? data;

  factory TipoAviso.fromJson(Map<String, dynamic> json) => TipoAviso(
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
    this.idCatTipoaviso,
    this.tipoAviso,
    this.idCom,
  });

  int? idCatTipoaviso;
  String? tipoAviso;
  int? idCom;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idCatTipoaviso: json["ID_CAT_TIPOAVISO"],
        tipoAviso: json["TIPO_AVISO"],
        idCom: json["ID_COM"],
      );

  Map<String, dynamic> toJson() => {
        "ID_CAT_TIPOAVISO": idCatTipoaviso,
        "TIPO_AVISO": tipoAviso,
        "ID_COM": idCom,
      };
}
