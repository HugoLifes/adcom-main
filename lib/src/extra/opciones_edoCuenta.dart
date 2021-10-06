import 'dart:typed_data';
import 'package:adcom/src/pantallas/finanzas.dart';
import 'package:flutter/material.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class OpcionesEdoCuenta extends StatefulWidget {
  List<DatosCuenta>? newList = [];
  Users? users;
  String? userName;
  DatosUsuario? datosUsuario;

  OpcionesEdoCuenta(
      {Key? key, this.newList, this.users, this.userName, this.datosUsuario})
      : super(key: key);

  @override
  _OpcionesEdoCuentaState createState() => _OpcionesEdoCuentaState();
}

SharedPreferences? prefs;

class _OpcionesEdoCuentaState extends State<OpcionesEdoCuenta> {
  late pw.ImageProvider image;
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: accountItems("Mensual", "\$ 1,500 MXN",
            'Recibo del mes ${widget.users!.concepto}', 'Descargar',
            oddColour: Colors.black));
  }

  accountItems(String item, String charge, String dateString, String type,
          {Color oddColour = Colors.white}) =>
      Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 6, offset: Offset(0, 1))
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding:
            EdgeInsets.only(top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Recibo de pago',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                InkWell(
                  onTap: () async {
                    Printing.layoutPdf(
                        dynamicLayout: true,
                        onLayout: (PdfPageFormat format) {
                          return buildPdf(format);
                        });
                  },
                  child: Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.file_present,
                        size: 30,
                      )),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(dateString,
                    style: TextStyle(color: Colors.black, fontSize: 14.0)),
                InkWell(
                  onTap: () async {
                    Printing.layoutPdf(
                        dynamicLayout: true,
                        onLayout: (PdfPageFormat format) {
                          return buildPdf(format);
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 5),
                    child: Text(type,
                        style: TextStyle(color: Colors.black, fontSize: 14.0)),
                  ),
                )
              ],
            ),
          ],
        ),
      );

  Future<Uint8List> buildPdf(PdfPageFormat format) async {
    final ByteData bytes =
        await rootBundle.load('assets/images/rinconadas.jpg');
    final Uint8List byteList = bytes.buffer.asUint8List();

    final ByteData bytesImg = await rootBundle.load('assets/images/logo.png');
    final Uint8List bytesImgList = bytesImg.buffer.asUint8List();

    final pw.Document doc = pw.Document();
    doc.addPage(pw.MultiPage(
        pageFormat: format,
        build: (context) => <pw.Widget>[
              _buildCustomHeadline(byteList, bytesImgList),
              _buildDataUser(),
              pw.Divider(thickness: 10),
              _buildMiddleHeadline(),
              _buildTable(),
              pw.Divider(thickness: 10),
              _totales(),
            ]));
    return await doc.save();
  }

  _totales() {
    return pw.Container(
      padding: pw.EdgeInsets.only(right: 40, top: 20, left: 380),
      alignment: pw.Alignment.centerRight,
      child: pw.Column(children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Paragraph(
              text: 'Sub Total',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(width: 50),
          pw.Paragraph(
              text: '\$ ${widget.users!.monto}',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        ]),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Paragraph(
              text: 'Recargos',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(width: 50),
          pw.Paragraph(
              text: widget.users!.deuda == null
                  ? '\$ 0.00'
                  : '\$ ${widget.users!.deuda}',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        ]),
        pw.Divider(),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Paragraph(
              text: 'Total',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(width: 50),
          pw.Paragraph(
              text: '\$ ${widget.users!.monto}',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        ]),
      ]),
    );
  }

  _buildCustomHeadline(byteList, bytesImgList) {
    return pw.Header(
      child: pw
          .Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Image(pw.MemoryImage(byteList), height: 65, fit: pw.BoxFit.contain),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Container(
            padding: pw.EdgeInsets.only(right: 70),
            child: pw.Text('${widget.datosUsuario!.comunidad}',
                style: pw.TextStyle(
                    fontSize: 21,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black)),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: pw.EdgeInsets.only(right: 80),
            child: pw.Paragraph(
                text: '${widget.users!.referencia} ',
                style:
                    pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
          ),
        ]),
        pw.Container(
          padding: pw.EdgeInsets.only(right: 50),
          child: pw.Image(pw.MemoryImage(bytesImgList),
              height: 60, fit: pw.BoxFit.contain),
        ),
      ]),
      padding: pw.EdgeInsets.all(10.0),
    );
  }

  _buildMiddleHeadline() {
    return pw.Container(
        padding: pw.EdgeInsets.only(left: 30, right: 30, top: 10),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Fecha: ${widget.users!.fecha}',
                  style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black)),
              pw.Container(
                padding: pw.EdgeInsets.only(right: 20),
                child: pw.Text('Recibo de Pago',
                    style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black)),
              ),
              pw.Text('Folio: ${widget.users!.folio}',
                  style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black)),
            ]));
  }

  /// construye la tabla que tiene el concepor y el por que pago
  _buildTable() {
    final headers = ['Concepto', 'Referencia', 'Monto', 'Forma de pago'];
    final users = [
      Users(
          concepto: 'Mantenimiento ${widget.users!.concepto}',
          referencia: widget.users!.referenciaP == 0
              ? widget.users!.referencia
              : widget.users!.referenciaP,
          monto: widget.users!.monto,
          tipoPago: widget.users!.tipoPago),
    ];

    final data = users
        .map((users) => [
              users.concepto,
              users.referencia,
              users.monto,
              users.tipoPago,
            ])
        .toList();

    return pw.Padding(
        padding: pw.EdgeInsets.all(10.0),
        child: pw.Table.fromTextArray(
            headers: headers,
            data: data,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
  }

  ///Datos como el residente, Domicilio, Nombre etc
  _buildDataUser() {
    return pw.Container(
        padding: const pw.EdgeInsets.all(11.0),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Paragraph(
                        textAlign: pw.TextAlign.justify,
                        text: 'Residente: ${widget.userName}',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Paragraph(
                        textAlign: pw.TextAlign.justify,
                        text: 'Domicilio: ${widget.datosUsuario!.calle}',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Paragraph(
                        text: 'Tipo Lote: ${widget.datosUsuario!.tipoLote}',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Paragraph(
                        text: 'C.P: ${widget.datosUsuario!.cp} ',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  ]),
            ]));
  }
}

class Users {
  final String? tipoPago;

  final int? referencia;
  final double? monto;
  final String? concepto;
  final double? deuda;
  final String? fecha;
  final int? folio;
  final int? referenciaP;

  const Users(
      {this.tipoPago,
      this.referencia,
      this.referenciaP,
      this.monto,
      this.concepto,
      this.deuda,
      this.folio,
      this.fecha});
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
