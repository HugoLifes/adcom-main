import 'dart:convert';

Check checkFromJson(String str) => Check.fromJson(json.decode(str));

String checkToJson(Check data) => json.encode(data.toJson());

class Check {
  Check({
    this.value,
    this.data,
  });

  int? value;
  Data? data;

  factory Check.fromJson(Map<String, dynamic> json) => Check(
        value: json["value"] == null ? null : json["value"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "value": value == null ? null : value,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.diasemana,
    this.disp,
  });

  String? diasemana;
  String? disp;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        diasemana: json["diasemana"] == null ? null : json["diasemana"],
        disp: json["disp"] == null ? null : json["disp"],
      );

  Map<String, dynamic> toJson() => {
        "diasemana": diasemana == null ? null : diasemana,
        "disp": disp == null ? null : disp,
      };
}
