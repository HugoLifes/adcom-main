// To parse this JSON data, do
//
//     final getAvisos = getAvisosFromJson(jsonString);

import 'dart:convert';

GetAvisos getAvisosFromJson(String str) => GetAvisos.fromJson(json.decode(str));

String getAvisosToJson(GetAvisos data) => json.encode(data.toJson());

class GetAvisos {
  GetAvisos({
    this.value,
    this.data,
  });

  int? value;
  List<Datum>? data;

  factory GetAvisos.fromJson(Map<String, dynamic> json) => GetAvisos(
        value: json["value"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.aviso,
    this.tipoAviso,
    this.fechaAviso,
    this.archivos,
  });

  String? aviso;
  int? tipoAviso;
  DateTime? fechaAviso;
  List<Archivo>? archivos;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        aviso: json["AVISO"],
        tipoAviso: json["TIPO_AVISO"],
        fechaAviso: DateTime.parse(json["FECHA_AVISO"]),
        archivos: List<Archivo>.from(
            json["ARCHIVOS"].map((x) => Archivo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AVISO": aviso,
        "TIPO_AVISO": tipoAviso,
        "FECHA_AVISO": fechaAviso!.toIso8601String(),
        "ARCHIVOS": List<dynamic>.from(archivos!.map((x) => x.toJson())),
      };
}

class Archivo {
  Archivo({
    this.direccionArchivo,
    this.nombreArchivo,
  });

  String? direccionArchivo;
  String? nombreArchivo;

  factory Archivo.fromJson(Map<String, dynamic> json) => Archivo(
        direccionArchivo: json["DIRECCION_ARCHIVO"],
        nombreArchivo: json["NOMBRE_ARCHIVO"],
      );

  Map<String, dynamic> toJson() => {
        "DIRECCION_ARCHIVO": direccionArchivo,
        "NOMBRE_ARCHIVO": nombreArchivo,
      };
}
