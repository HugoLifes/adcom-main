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
    this.idAmenidad,
    this.idCom,
    this.amenidadDesc,
    this.estadoAct,
    this.reservaCosto,
    this.descrip,
    this.necReserva,
    this.maxTiempoReserva,
    this.comReserva,
    this.rtaArchRegla,
  });

  int? idAmenidad;
  int? idCom;
  String? amenidadDesc;
  int? estadoAct;
  String? reservaCosto;
  String? descrip;
  int? necReserva;
  String? maxTiempoReserva;
  String? comReserva;
  dynamic? rtaArchRegla;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idAmenidad: json["ID_AMENIDAD"] == null ? null : json["ID_AMENIDAD"],
        idCom: json["ID_COM"] == null ? null : json["ID_COM"],
        amenidadDesc:
            json["AMENIDAD_DESC"] == null ? null : json["AMENIDAD_DESC"],
        estadoAct: json["ESTADO_ACT"] == null ? null : json["ESTADO_ACT"],
        reservaCosto:
            json["RESERVA_COSTO"] == null ? null : json["RESERVA_COSTO"],
        descrip: json["DESCRIP"] == null ? null : json["DESCRIP"],
        necReserva: json["NEC_RESERVA"] == null ? null : json["NEC_RESERVA"],
        maxTiempoReserva: json["MAX_TIEMPO_RESERVA"] == null
            ? null
            : json["MAX_TIEMPO_RESERVA"],
        comReserva: json["COM_RESERVA"] == null ? null : json["COM_RESERVA"],
        rtaArchRegla: json["RTA_ARCH_REGLA"],
      );

  Map<String, dynamic> toJson() => {
        "ID_AMENIDAD": idAmenidad == null ? null : idAmenidad,
        "ID_COM": idCom == null ? null : idCom,
        "AMENIDAD_DESC": amenidadDesc == null ? null : amenidadDesc,
        "ESTADO_ACT": estadoAct == null ? null : estadoAct,
        "RESERVA_COSTO": reservaCosto == null ? null : reservaCosto,
        "DESCRIP": descrip == null ? null : descrip,
        "NEC_RESERVA": necReserva == null ? null : necReserva,
        "MAX_TIEMPO_RESERVA":
            maxTiempoReserva == null ? null : maxTiempoReserva,
        "COM_RESERVA": comReserva == null ? null : comReserva,
        "RTA_ARCH_REGLA": rtaArchRegla,
      };
}
