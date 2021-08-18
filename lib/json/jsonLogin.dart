// To parse this JSON data, do
//
//     final posting = postingFromJson(jsonString);

import 'dart:convert';

Posting postingFromJson(String str) => Posting.fromJson(json.decode(str));

String postingToJson(Posting data) => json.encode(data.toJson());

class Posting {
  Posting({
    this.value,
    this.message,
    this.idCom,
    this.idPerfil,
    this.id,
    this.idResidente,
    this.usuario,
    this.nombreResidente,
  });

  int? value;
  String? message;
  int? idCom;
  int? idPerfil;
  int? id;
  int? idResidente;
  String? usuario;
  String? nombreResidente;

  factory Posting.fromJson(Map<String, dynamic> json) => Posting(
        value: json["value"],
        message: json["message"],
        idCom: json["ID_COM"],
        idPerfil: json["ID_PERFIL"],
        id: json["ID"],
        idResidente: json["ID_RESIDENTE"],
        usuario: json["USUARIO"],
        nombreResidente: json["NombreResidente"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "ID_COM": idCom,
        "ID_PERFIL": idPerfil,
        "ID": id,
        "ID_RESIDENTE": idResidente,
        "USUARIO": usuario,
        "NombreResidente": nombreResidente,
      };
}
