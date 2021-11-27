// To parse this JSON data, do
//
//     final seguimiento = seguimientoFromJson(jsonString);

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
    this.rutaLogo,
    this.diaAtencion,
    this.horaInitAten,
    this.horaFinAten,
    this.formaPago1,
    this.formaPago2,
    this.formaPago3,
    this.compania,
    this.productos,
  });

  String? rutaLogo;
  String? diaAtencion;
  String? horaInitAten;
  String? horaFinAten;
  String? formaPago1;
  String? formaPago2;
  String? formaPago3;
  String? compania;
  List<Producto>? productos;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        rutaLogo: json["RUTA_LOGO"] == null ? null : json["RUTA_LOGO"],
        diaAtencion: json["DIA_ATENCION"] == null ? null : json["DIA_ATENCION"],
        horaInitAten:
            json["HORA_INIT_ATEN"] == null ? null : json["HORA_INIT_ATEN"],
        horaFinAten:
            json["HORA_FIN_ATEN"] == null ? null : json["HORA_FIN_ATEN"],
        formaPago1: json["FORMA_PAGO_1"] == null ? null : json["FORMA_PAGO_1"],
        formaPago2: json["FORMA_PAGO_2"] == null ? null : json["FORMA_PAGO_2"],
        formaPago3: json["FORMA_PAGO_3"] == null ? null : json["FORMA_PAGO_3"],
        compania: json["COMPANIA"] == null ? null : json["COMPANIA"],
        productos: json["PRODUCTOS"] == null
            ? null
            : List<Producto>.from(
                json["PRODUCTOS"].map((x) => Producto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RUTA_LOGO": rutaLogo == null ? null : rutaLogo,
        "DIA_ATENCION": diaAtencion == null ? null : diaAtencion,
        "HORA_INIT_ATEN": horaInitAten == null ? null : horaInitAten,
        "HORA_FIN_ATEN": horaFinAten == null ? null : horaFinAten,
        "FORMA_PAGO_1": formaPago1 == null ? null : formaPago1,
        "FORMA_PAGO_2": formaPago2 == null ? null : formaPago2,
        "FORMA_PAGO_3": formaPago3 == null ? null : formaPago3,
        "COMPANIA": compania == null ? null : compania,
        "PRODUCTOS": productos == null
            ? null
            : List<dynamic>.from(productos!.map((x) => x.toJson())),
      };
}

class Producto {
  Producto({
    this.unidad,
    this.descripcion,
    this.presLogoRuta,
  });

  String? unidad;
  String? descripcion;
  dynamic presLogoRuta;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        unidad: json["UNIDAD"] == null ? null : json["UNIDAD"],
        descripcion: json["DESCRIPCION"] == null ? null : json["DESCRIPCION"],
        presLogoRuta: json["PRES_LOGO_RUTA"],
      );

  Map<String, dynamic> toJson() => {
        "UNIDAD": unidad == null ? null : unidad,
        "DESCRIPCION": descripcion == null ? null : descripcion,
        "PRES_LOGO_RUTA": presLogoRuta,
      };
}
