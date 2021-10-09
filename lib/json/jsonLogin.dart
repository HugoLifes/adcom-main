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
    this.comunidad,
    this.nombreResidente,
    this.tiempoSecion,
    this.infoUusario,
  });

  int? value;
  String? message;
  int? idCom;
  int? idPerfil;
  int? id;
  int? idResidente;
  String? usuario;
  List<dynamic>? comunidad;
  String? nombreResidente;
  int? tiempoSecion;
  InfoUusario? infoUusario;

  factory Posting.fromJson(Map<String, dynamic> json) => Posting(
        value: json["value"] == null ? null : json["value"],
        message: json["message"] == null ? null : json["message"],
        idCom: json["ID_COM"] == null ? null : json["ID_COM"],
        idPerfil: json["ID_PERFIL"] == null ? null : json["ID_PERFIL"],
        id: json["ID"] == null ? null : json["ID"],
        idResidente: json["ID_RESIDENTE"] == null ? null : json["ID_RESIDENTE"],
        usuario: json["USUARIO"] == null ? null : json["USUARIO"],
        comunidad: json["COMUNIDAD"] == null
            ? null
            : List<dynamic>.from(json["COMUNIDAD"].map((x) => x)),
        nombreResidente:
            json["NombreResidente"] == null ? null : json["NombreResidente"],
        tiempoSecion:
            json["tiempoSecion"] == null ? null : json["tiempoSecion"],
        infoUusario: json["infoUusario"] == null
            ? null
            : InfoUusario.fromJson(json["infoUusario"]),
      );

  Map<String, dynamic> toJson() => {
        "value": value == null ? null : value,
        "message": message == null ? null : message,
        "ID_COM": idCom == null ? null : idCom,
        "ID_PERFIL": idPerfil == null ? null : idPerfil,
        "ID": id == null ? null : id,
        "ID_RESIDENTE": idResidente == null ? null : idResidente,
        "USUARIO": usuario == null ? null : usuario,
        "COMUNIDAD": comunidad == null
            ? null
            : List<dynamic>.from(comunidad!.map((x) => x)),
        "NombreResidente": nombreResidente == null ? null : nombreResidente,
        "tiempoSecion": tiempoSecion == null ? null : tiempoSecion,
        "infoUusario": infoUusario == null ? null : infoUusario!.toJson(),
      };
}

class InfoUusario {
  InfoUusario({
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

  factory InfoUusario.fromJson(Map<String, dynamic> json) => InfoUusario(
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
