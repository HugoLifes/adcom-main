// To parse this JSON data, do
//
//     final adeudos = adeudosFromJson(jsonString);

import 'dart:convert';

AdeudosJ adeudosFromJson(String str) => AdeudosJ.fromJson(json.decode(str));

String adeudosToJson(AdeudosJ data) => json.encode(data.toJson());

class AdeudosJ {
  AdeudosJ({
    this.value,
    this.message,
    this.data,
  });

  int? value;
  String? message;
  List<Datum>? data;

  factory AdeudosJ.fromJson(Map<String, dynamic> json) => AdeudosJ(
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
      {this.idComu,
      this.idResidente,
      this.montoCuota,
      this.montoPagoTardio,
      this.totadeudo,
      this.idConcepto,
      this.mes,
      this.formaPago,
      this.folio,
      this.referencia});

  String? idComu;
  String? idResidente;
  String? montoCuota;
  String? montoPagoTardio;
  String? totadeudo;
  String? idConcepto;
  String? mes;
  String? formaPago;
  String? referencia;
  String? folio;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idComu: json["ID_COMU"] == null ? null : json["ID_COMU"],
        idResidente: json["ID_RESIDENTE"] == null ? null : json["ID_RESIDENTE"],
        montoCuota: json["MONTO_CUOTA"] == null ? null : json["MONTO_CUOTA"],
        montoPagoTardio: json["MONTO_PAGO_TARDIO"] == null
            ? null
            : json["MONTO_PAGO_TARDIO"],
        totadeudo: json["TOTADEUDO"] == null ? null : json["TOTADEUDO"],
        idConcepto: json["ID_CONCEPTO"] == null ? null : json["ID_CONCEPTO"],
        mes: json["Mes"] == null ? null : json["Mes"],
        formaPago: json["FormaPago"] == null ? null : json["FormaPago"],
        referencia: json["REFERENCIA"] == null ? null : json["REFERENCIA"],
        folio: json["Folio"] == null ? null : json["Folio"],
      );

  Map<String, dynamic> toJson() => {
        "ID_COMU": idComu == null ? null : idComu,
        "ID_RESIDENTE": idResidente == null ? null : idResidente,
        "MONTO_CUOTA": montoCuota == null ? null : montoCuota,
        "MONTO_PAGO_TARDIO": montoPagoTardio == null ? null : montoPagoTardio,
        "TOTADEUDO": totadeudo == null ? null : totadeudo,
        "ID_CONCEPTO": idConcepto == null ? null : idConcepto,
        "Mes": mes == null ? null : mes,
        "REFERENCIA": referencia == null ? null : referencia,
        "FormaPago": formaPago == null ? null : formaPago,
        "Folio": folio == null ? null : folio
      };
}