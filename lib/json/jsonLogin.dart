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
    this.infoUsuario,
  });

  int? value;
  String? message;
  int? idCom;
  int? idPerfil;
  int? id;
  int? idResidente;
  String? usuario;
  String? nombreResidente;
  InfoUsuario? infoUsuario;

  factory Posting.fromJson(Map<String, dynamic> json) => Posting(
        value: json["value"],
        message: json["message"],
        idCom: json["ID_COM"],
        idPerfil: json["ID_PERFIL"],
        id: json["ID"],
        idResidente: json["ID_RESIDENTE"],
        usuario: json["USUARIO"],
        nombreResidente: json["NombreResidente"],
        infoUsuario: json["infoUsuario"] == null
            ? null
            : InfoUsuario.fromJson(json["infoUsuario"]),
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
        "infoUsuario": infoUsuario == null ? null : infoUsuario!.toJson(),
      };
}

class InfoUsuario {
  InfoUsuario({
    this.noInterior,
    this.noExterno,
    this.tipoLote,
    this.cp,
    this.comunidad,
    this.calle,
  });

  String? noInterior;
  String? noExterno;
  String? tipoLote;
  String? cp;
  String? comunidad;
  String? calle;

  factory InfoUsuario.fromJson(Map<String, dynamic> json) => InfoUsuario(
        noInterior: json["NO_INTERIOR"] == null ? null : json["NO_INTERIOR"],
        noExterno: json["NO_EXTERNO"] == null ? null : json["NO_EXTERNO"],
        tipoLote: json["TIPO_LOTE"] == null ? null : json["TIPO_LOTE"],
        cp: json["CP"] == null ? null : json["CP"],
        comunidad: json["COMUNIDAD"] == null ? null : json["COMUNIDAD"],
        calle: json["CALLE"] == null ? null : json["CALLE"],
      );

  Map<String, dynamic> toJson() => {
        "NO_INTERIOR": noInterior == null ? null : noInterior,
        "NO_EXTERNO": noExterno == null ? null : noExterno,
        "TIPO_LOTE": tipoLote == null ? null : tipoLote,
        "CP": cp == null ? null : cp,
        "COMUNIDAD": comunidad == null ? null : comunidad,
        "CALLE": calle == null ? null : calle,
      };
}
