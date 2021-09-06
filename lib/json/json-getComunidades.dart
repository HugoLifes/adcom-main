import 'dart:convert';

Comunities comunitiesFromJson(String str) =>
    Comunities.fromJson(json.decode(str));

String comunitiesToJson(Comunities data) => json.encode(data.toJson());

class Comunities {
  Comunities({
    this.value,
    this.message,
    this.data,
  });

  int? value;
  String? message;
  List<Datum>? data;

  factory Comunities.fromJson(Map<String, dynamic> json) => Comunities(
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
    this.idCom,
    this.nombreComu,
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
  String? nombreComu;
  String? ubicacion;
  int? cp;
  dynamic? idAdministrador;
  dynamic? idComite;
  String? idTipoComu;
  String? banco;
  String? cuentaBanco;
  String? cuentaClabe;
  String? rfc;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idCom: json["ID_COM"],
        nombreComu: json["NOMBRE_COMU"],
        ubicacion: json["UBICACION"] == null ? null : json["UBICACION"],
        cp: json["CP"] == null ? null : json["CP"],
        idAdministrador: json["ID_ADMINISTRADOR"],
        idComite: json["ID_COMITE"],
        idTipoComu: json["ID_TIPO_COMU"] == null ? null : json["ID_TIPO_COMU"],
        banco: json["BANCO"] == null ? null : json["BANCO"],
        cuentaBanco: json["CUENTA_BANCO"] == null ? null : json["CUENTA_BANCO"],
        cuentaClabe: json["CUENTA_CLABE"] == null ? null : json["CUENTA_CLABE"],
        rfc: json["RFC"] == null ? null : json["RFC"],
      );

  Map<String, dynamic> toJson() => {
        "ID_COM": idCom,
        "NOMBRE_COMU": nombreComu,
        "UBICACION": ubicacion == null ? null : ubicacion,
        "CP": cp == null ? null : cp,
        "ID_ADMINISTRADOR": idAdministrador,
        "ID_COMITE": idComite,
        "ID_TIPO_COMU": idTipoComu == null ? null : idTipoComu,
        "BANCO": banco == null ? null : banco,
        "CUENTA_BANCO": cuentaBanco == null ? null : cuentaBanco,
        "CUENTA_CLABE": cuentaClabe == null ? null : cuentaClabe,
        "RFC": rfc == null ? null : rfc,
      };
}