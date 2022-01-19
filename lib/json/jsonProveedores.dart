// To parse this JSON data, do
//
//     final proveedores = proveedoresFromJson(jsonString);

import 'dart:convert';

Proveedores proveedoresFromJson(String str) =>
    Proveedores.fromJson(json.decode(str));

String proveedoresToJson(Proveedores data) => json.encode(data.toJson());

class Proveedores {
  Proveedores({
    this.value,
    this.message,
    this.data,
  });

  int? value;
  String? message;
  List<Datum>? data;

  factory Proveedores.fromJson(Map<String, dynamic> json) => Proveedores(
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
  Datum(
      {this.idProveedor,
      this.compaia,
      this.domicilio,
      this.contacto,
      this.telContacto1,
      this.telContacto2,
      this.telGuardia,
      this.idTipoProveedor,
      this.diaAtencion,
      this.activo});

  int? idProveedor;
  String? compaia;
  String? domicilio;
  String? contacto;
  String? telContacto1;
  String? telContacto2;
  String? telGuardia;
  int? idTipoProveedor;
  String? diaAtencion;
  dynamic activo;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      idProveedor: json["ID_PROVEEDOR"] == null ? null : json["ID_PROVEEDOR"],
      compaia: json["COMPAÑIA"] == null ? null : json["COMPAÑIA"],
      domicilio: json["DOMICILIO"] == null ? null : json["DOMICILIO"],
      contacto: json["CONTACTO"] == null ? null : json["CONTACTO"],
      telContacto1:
          json["TEL_CONTACTO1"] == null ? null : json["TEL_CONTACTO1"],
      telContacto2:
          json["TEL_CONTACTO2"] == null ? null : json["TEL_CONTACTO2"],
      telGuardia: json["TEL_GUARDIA"] == null ? null : json["TEL_GUARDIA"],
      idTipoProveedor:
          json["ID_TIPO_PROVEEDOR"] == null ? null : json["ID_TIPO_PROVEEDOR"],
      diaAtencion: json["DIA_ATENCION"] == null ? null : json["DIA_ATENCION"],
      activo: json["ACTIVO"] == null ? null : json["ACTIVO"]);

  Map<String, dynamic> toJson() => {
        "ID_PROVEEDOR": idProveedor == null ? null : idProveedor,
        "COMPAÑIA": compaia == null ? null : compaia,
        "DOMICILIO": domicilio == null ? null : domicilio,
        "CONTACTO": contacto == null ? null : contacto,
        "TEL_CONTACTO1": telContacto1 == null ? null : telContacto1,
        "TEL_CONTACTO2": telContacto2 == null ? null : telContacto2,
        "TEL_GUARDIA": telGuardia == null ? null : telGuardia,
        "ID_TIPO_PROVEEDOR": idTipoProveedor == null ? null : idTipoProveedor,
        "DIA_ATENCION": diaAtencion == null ? null : diaAtencion,
        "ACTIVO": activo == null ? null : activo
      };
}
