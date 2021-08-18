// To parse this JSON data, do
//
//     final places = placesFromJson(jsonString);

// To parse this JSON data, do
//
//     final accounts = accountsFromJson(jsonString);

import 'dart:convert';

Accounts accountsFromJson(String str) => Accounts.fromJson(json.decode(str));

String accountsToJson(Accounts data) => json.encode(data.toJson());

class Accounts {
  Accounts({
    this.value,
    this.message,
    this.data,
  });

  int? value;
  String? message;
  List<Datum>? data;

  factory Accounts.fromJson(Map<String, dynamic> json) => Accounts(
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
  Datum(
      {this.idAdeudo,
      this.idComu,
      this.idResidente,
      this.montoCuota,
      this.idConcepto,
      this.fechaGeneracion,
      this.fechaLimite,
      this.fechaPago,
      this.montoPago,
      this.idFormaPago,
      this.idTipoCuota,
      this.referencia,
      this.pagoTardio,
      this.montoPagoTardio,
      this.pago,
      this.totalApagar});

  int? idAdeudo;
  int? idComu;
  int? idResidente;
  String? montoCuota;
  String? idConcepto;
  DateTime? fechaGeneracion;
  DateTime? fechaLimite;
  DateTime? fechaPago;
  String? montoPago;
  int? idFormaPago;
  dynamic? idTipoCuota;
  String? referencia;
  dynamic? pagoTardio;
  String? montoPagoTardio;
  int? pago;
  int? totalApagar;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      idAdeudo: json["ID_ADEUDO"],
      idComu: json["ID_COMU"],
      idResidente: json["ID_RESIDENTE"],
      montoCuota: json["MONTO_CUOTA"],
      idConcepto: json["ID_CONCEPTO"],
      fechaGeneracion: DateTime.parse(json["FECHA_GENERACION"]),
      fechaLimite: DateTime.parse(json["FECHA_LIMITE"]),
      fechaPago: json["FECHA_PAGO"] == null
          ? null
          : DateTime.parse(json["FECHA_PAGO"]),
      montoPago: json["MONTO_PAGO"],
      idFormaPago: json["ID_FORMA_PAGO"] == null ? null : json["ID_FORMA_PAGO"],
      idTipoCuota: json["ID_TIPO_CUOTA"],
      referencia: json["REFERENCIA"],
      pagoTardio: json["PAGO_TARDIO"],
      montoPagoTardio: json["MONTO_PAGO_TARDIO"],
      pago: json["PAGO"],
      totalApagar: json["TOTAL_APAGAR"]);

  Map<String, dynamic> toJson() => {
        "ID_ADEUDO": idAdeudo,
        "ID_COMU": idComu,
        "ID_RESIDENTE": idResidente,
        "MONTO_CUOTA": montoCuota,
        "ID_CONCEPTO": idConcepto,
        "FECHA_GENERACION": fechaGeneracion!.toIso8601String(),
        "FECHA_LIMITE": fechaLimite!.toIso8601String(),
        "FECHA_PAGO": fechaPago == null ? null : fechaPago!.toIso8601String(),
        "MONTO_PAGO": montoPago,
        "ID_FORMA_PAGO": idFormaPago == null ? null : idFormaPago,
        "ID_TIPO_CUOTA": idTipoCuota,
        "REFERENCIA": referencia,
        "PAGO_TARDIO": pagoTardio,
        "MONTO_PAGO_TARDIO": montoPagoTardio,
        "PAGO": pago,
        "TOTAL_APAGAR": totalApagar
      };
}
