// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.value,
    this.message,
    this.residente,
    this.comunidad,
  });

  int? value;
  String? message;
  List<Residente>? residente;
  List<Comunidad>? comunidad;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        value: json["value"],
        message: json["message"],
        residente: List<Residente>.from(
            json["residente"].map((x) => Residente.fromJson(x))),
        comunidad: List<Comunidad>.from(
            json["comunidad"].map((x) => Comunidad.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "residente": List<dynamic>.from(residente!.map((x) => x.toJson())),
        "comunidad": List<dynamic>.from(comunidad!.map((x) => x.toJson())),
      };
}

class Comunidad {
  Comunidad({
    this.idCom,
    this.nobreComu,
    this.ubicacion,
    this.cp,
    this.idAdministrador,
    this.idComite,
    this.idTipoComu,
    this.banco,
    this.cuentaBanco,
    this.cuentaClabe,
    this.rfc,
  });

  int? idCom;
  String? nobreComu;
  String? ubicacion;
  int? cp;
  dynamic? idAdministrador;
  dynamic? idComite;
  String? idTipoComu;
  String? banco;
  String? cuentaBanco;
  String? cuentaClabe;
  String? rfc;

  factory Comunidad.fromJson(Map<String, dynamic> json) => Comunidad(
        idCom: json["ID_COM"],
        nobreComu: json["NOBRE_COMU"],
        ubicacion: json["UBICACION"],
        cp: json["CP"] == null ? null : json["CP"],
        idAdministrador: json["ID_ADMINISTRADOR"],
        idComite: json["ID_COMITE"],
        idTipoComu: json["ID_TIPO_COMU"],
        banco: json["BANCO"],
        cuentaBanco: json["CUENTA_BANCO"],
        cuentaClabe: json["CUENTA_CLABE"],
        rfc: json["RFC"] == null ? null : json["RFC"],
      );

  Map<String, dynamic> toJson() => {
        "ID_COM": idCom,
        "NOBRE_COMU": nobreComu,
        "UBICACION": ubicacion,
        "CP": cp == null ? null : cp,
        "ID_ADMINISTRADOR": idAdministrador,
        "ID_COMITE": idComite,
        "ID_TIPO_COMU": idTipoComu,
        "BANCO": banco,
        "CUENTA_BANCO": cuentaBanco,
        "CUENTA_CLABE": cuentaClabe,
        "RFC": rfc == null ? null : rfc,
      };
}

class Residente {
  Residente({
    this.idResidente,
    this.nombreResidente,
    this.calle,
    this.numero,
    this.interior,
    this.cp,
    this.telefonoFijo,
    this.telefonoCel,
    this.telefonoEmergencia,
    this.email,
    this.idCom,
    this.comNombre,
  });

  int? idResidente;
  String? nombreResidente;
  String? calle;
  String? numero;
  String? interior;
  String? cp;
  String? telefonoFijo;
  String? telefonoCel;
  String? telefonoEmergencia;
  String? email;
  int? idCom;
  String? comNombre;

  factory Residente.fromJson(Map<String, dynamic> json) => Residente(
        idResidente: json["ID_RESIDENTE"],
        nombreResidente:
            json["NOMBRE_RESIDENTE"] == null ? null : json["NOMBRE_RESIDENTE"],
        calle: json["CALLE"] == null ? null : json["CALLE"],
        numero: json["NUMERO"] == null ? null : json["NUMERO"],
        interior: json["INTERIOR"] == null ? null : json["INTERIOR"],
        cp: json["CP"] == null ? null : json["CP"],
        telefonoFijo:
            json["TELEFONO_FIJO"] == null ? null : json["TELEFONO_FIJO"],
        telefonoCel: json["TELEFONO_CEL"] == null ? null : json["TELEFONO_CEL"],
        telefonoEmergencia: json["TELEFONO_EMERGENCIA"] == null
            ? null
            : json["TELEFONO_EMERGENCIA"],
        email: json["EMAIL"],
        idCom: json["ID_COM"] == null ? null : json["ID_COM"],
        comNombre: json["COM_NOMBRE"],
      );

  Map<String, dynamic> toJson() => {
        "ID_RESIDENTE": idResidente,
        "NOMBRE_RESIDENTE": nombreResidente == null ? null : nombreResidente,
        "CALLE": calle == null ? null : calle,
        "NUMERO": numero == null ? null : numero,
        "INTERIOR": interior == null ? null : interior,
        "CP": cp == null ? null : cp,
        "TELEFONO_FIJO": telefonoFijo == null ? null : telefonoFijo,
        "TELEFONO_CEL": telefonoCel == null ? null : telefonoCel,
        "TELEFONO_EMERGENCIA":
            telefonoEmergencia == null ? null : telefonoEmergencia,
        "EMAIL": email,
        "ID_COM": idCom == null ? null : idCom,
        "COM_NOMBRE": comNombre,
      };
}
