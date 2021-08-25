import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:printing/printing.dart';

class OpcionesEdoCuenta extends StatefulWidget {
  OpcionesEdoCuenta({Key? key}) : super(key: key);

  @override
  _OpcionesEdoCuentaState createState() => _OpcionesEdoCuentaState();
}

SharedPreferences? prefs;

class _OpcionesEdoCuentaState extends State<OpcionesEdoCuenta> {
  late ImageProvider image;
  String? user;
  int? idComu;
  String? comunidad;
  String? nombreFrac;
  String? domicilio;
  String? numInt;
  String? tipoLote;
  String? cp;
  String? ref;
  DateTime? timenow = DateTime.now().toUtc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Historial de pagos',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            children: [
              accountItems("Mensual", "\$ 1,500 MXN",
                  'Esté al pendiente de sus pagos del mes', 'Descargar',
                  oddColour: Color(0xFFF7F7F9)),
            ],
          ),
        ),
      ),
    );
  }

  accountItems(String item, String charge, String dateString, String type,
          {Color oddColour = Colors.white}) =>
      Container(
        decoration: BoxDecoration(color: oddColour),
        padding:
            EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Cuota', style: TextStyle(fontSize: 16.0)),
                Text('')
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(dateString,
                    style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                Text(type, style: TextStyle(color: Colors.grey, fontSize: 14.0))
              ],
            ),
          ],
        ),
      );

  Future<Uint8List> buildPdf(PdfPageFormat format) async {
    final pw.Document doc = pw.Document();
    doc.addPage(pw.MultiPage(
        pageFormat: format,
        build: (context) => <pw.Widget>[
              _buildCustomHeadline(),
              _buildDataUser(),
              _buildDataUser()
            ]));
    return await doc.save();
  }

  _buildCustomHeadline() {
    return pw.Header(
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('AdCom',
                  style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white)),
              pw.Text('$nombreFrac',
                  style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white)),
              pw.Text('Estado de cuenta',
                  style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white)),
            ]),
        padding: pw.EdgeInsets.all(9.0),
        decoration: pw.BoxDecoration(color: PdfColors.red));
  }

  _buildTable() {
    final headers = ['Concepto', 'Referencia', 'Monto', 'Pagado Tardio'];
    final users = [
      Users(name: 'Enero', referencia: 190991, monto: 700, pagado: 'No'),
      Users(name: 'Febrero', referencia: 20123, monto: 750, pagado: 'Si'),
      Users(name: 'Marzo', referencia: 251231, monto: 700, pagado: 'No')
    ];

    final data = users
        .map((users) =>
            [users.name, users.referencia, users.monto, users.pagado])
        .toList();
    return pw.Padding(
        padding: pw.EdgeInsets.all(10.0),
        child: pw.Table.fromTextArray(
            headers: headers,
            data: data,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
  }

  _buildDataUser() {
    return pw.Container(
        padding: const pw.EdgeInsets.all(11.0),
        child:
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Column(children: [
            pw.Paragraph(
                textAlign: pw.TextAlign.justify,
                text: 'Residente: $user',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Paragraph(
                textAlign: pw.TextAlign.justify,
                text: 'Domicilio: $domicilio',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Paragraph(
                textAlign: pw.TextAlign.justify,
                text:
                    'Estado de cuenta del día: ${timenow!.day}/${timenow!.month}/${timenow!.year} ',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ]),
          pw.Column(children: [
            pw.Paragraph(
                text: 'Tipo Lote: $tipoLote',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Paragraph(
                text: 'C.P: $cp ',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Paragraph(
                text: 'Saldo del día:  ',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))
          ]),
          pw.Column(children: [
            pw.Paragraph(
                text: 'Referencia: $ref ',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Paragraph(
                text: 'Saldo para liquidar el año: ',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))
          ]),
        ]));
  }

  saveData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs!.getString('user');
      nombreFrac = prefs!.getString('nombreFracc');
      domicilio = prefs!.getString('domicilio');
      numInt = prefs!.getString('numInt');
      tipoLote = prefs!.getString('tipoLote');
      cp = prefs!.getString('cp');
      ref = prefs!.getString('reference');
    });
  }
}

class Users {
  final String? name;
  final int? referencia;
  final int? monto;
  final String? pagado;

  const Users({this.name, this.referencia, this.monto, this.pagado});
}

class Comunidad {
  final String? nombreFracc;
  final String? domicilio;
  final String? numInt;
  final String? tipoLote;
  final String? cp;
  const Comunidad(
      {this.nombreFracc, this.cp, this.domicilio, this.numInt, this.tipoLote});
}
