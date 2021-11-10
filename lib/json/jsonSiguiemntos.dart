import 'dart:convert';

Seguimiento seguimientoFromJson(String str) =>
    Seguimiento.fromJson(json.decode(str));

String seguimientoToJson(Seguimiento data) => json.encode(data.toJson());

class Seguimiento {
  Seguimiento({
    this.value,
    this.message,
    this.data,
  });

  int? value;
  String? message;
  List<Datum>? data;

  factory Seguimiento.fromJson(Map<String, dynamic> json) => Seguimiento(
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
  Datum({
    this.idProgreso,
    this.descProgreso,
  });

  int? idProgreso;
  String? descProgreso;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idProgreso: json["ID_PROGRESO"] == null ? null : json["ID_PROGRESO"],
        descProgreso:
            json["DESC_PROGRESO"] == null ? null : json["DESC_PROGRESO"],
      );

  Map<String, dynamic> toJson() => {
        "ID_PROGRESO": idProgreso == null ? null : idProgreso,
        "DESC_PROGRESO": descProgreso == null ? null : descProgreso,
      };
}
