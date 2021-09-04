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
    this.idAdeudo,
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
    this.impAplicado,
    this.impMonto,
    this.inpcPorcentaje,
    this.pago,
    this.totalApagar,
  });

  int? idAdeudo;
  int? idComu;
  int? idResidente;
  String? montoCuota;
  String? idConcepto;
  DateTime? fechaGeneracion;
  DateTime? fechaLimite;
  DateTime? fechaPago;
  String? montoPago;
  dynamic? idFormaPago;
  dynamic? idTipoCuota;
  String? referencia;
  int? pagoTardio;
  String? montoPagoTardio;
  dynamic? impAplicado;
  dynamic? impMonto;
  dynamic? inpcPorcentaje;
  int? pago;
  int? totalApagar;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idAdeudo: json["ID_ADEUDO"] == null ? null : json["ID_ADEUDO"],
        idComu: json["ID_COMU"] == null ? null : json["ID_COMU"],
        idResidente: json["ID_RESIDENTE"] == null ? null : json["ID_RESIDENTE"],
        montoCuota: json["MONTO_CUOTA"] == null ? null : json["MONTO_CUOTA"],
        idConcepto: json["ID_CONCEPTO"] == null ? null : json["ID_CONCEPTO"],
        fechaGeneracion: json["FECHA_GENERACION"] == null
            ? null
            : DateTime.parse(json["FECHA_GENERACION"]),
        fechaLimite: json["FECHA_LIMITE"] == null
            ? null
            : DateTime.parse(json["FECHA_LIMITE"]),
        fechaPago: json["FECHA_PAGO"] == null
            ? null
            : DateTime.parse(json["FECHA_PAGO"]),
        montoPago: json["MONTO_PAGO"] == null ? null : json["MONTO_PAGO"],
        idFormaPago: json["ID_FORMA_PAGO"],
        idTipoCuota: json["ID_TIPO_CUOTA"],
        referencia: json["REFERENCIA"] == null ? null : json["REFERENCIA"],
        pagoTardio: json["PAGO_TARDIO"] == null ? null : json["PAGO_TARDIO"],
        montoPagoTardio: json["MONTO_PAGO_TARDIO"] == null
            ? null
            : json["MONTO_PAGO_TARDIO"],
        impAplicado: json["IMP_APLICADO"],
        impMonto: json["IMP_MONTO"],
        inpcPorcentaje: json["INPC_PORCENTAJE"],
        pago: json["PAGO"] == null ? null : json["PAGO"],
        totalApagar: json["TOTAL_APAGAR"] == null ? null : json["TOTAL_APAGAR"],
      );

  Map<String, dynamic> toJson() => {
        "ID_ADEUDO": idAdeudo == null ? null : idAdeudo,
        "ID_COMU": idComu == null ? null : idComu,
        "ID_RESIDENTE": idResidente == null ? null : idResidente,
        "MONTO_CUOTA": montoCuota == null ? null : montoCuota,
        "ID_CONCEPTO": idConcepto == null ? null : idConcepto,
        "FECHA_GENERACION":
            fechaGeneracion == null ? null : fechaGeneracion!.toIso8601String(),
        "FECHA_LIMITE":
            fechaLimite == null ? null : fechaLimite!.toIso8601String(),
        "FECHA_PAGO": fechaPago == null ? null : fechaPago!.toIso8601String(),
        "MONTO_PAGO": montoPago == null ? null : montoPago,
        "ID_FORMA_PAGO": idFormaPago,
        "ID_TIPO_CUOTA": idTipoCuota,
        "REFERENCIA": referencia == null ? null : referencia,
        "PAGO_TARDIO": pagoTardio == null ? null : pagoTardio,
        "MONTO_PAGO_TARDIO": montoPagoTardio == null ? null : montoPagoTardio,
        "IMP_APLICADO": impAplicado,
        "IMP_MONTO": impMonto,
        "INPC_PORCENTAJE": inpcPorcentaje,
        "PAGO": pago == null ? null : pago,
        "TOTAL_APAGAR": totalApagar == null ? null : totalApagar,
      };
}
