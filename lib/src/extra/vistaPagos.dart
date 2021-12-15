import 'dart:typed_data';

import 'package:adcom/src/extra/opciones_edoCuenta.dart';
import 'package:adcom/src/pantallas/finanzas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

class VistaPagos extends StatefulWidget {
  Deudas? deudas;
  Users? users;
  String? userName;
  bool? notiene;
  List<Deudas>? deudasList = [];
  DatosUsuario? datosUsuario;
  bool? esPendiente;
  bool? landScape = false;
  VistaPagos(
      {Key? key,
      this.deudas,
      this.users,
      this.datosUsuario,
      this.userName,
      this.notiene,
      this.landScape = false,
      this.esPendiente,
      this.deudasList})
      : super(key: key);

  @override
  _VistaPagosState createState() => _VistaPagosState();
}

class _VistaPagosState extends State<VistaPagos> {
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: accountItems(
            "Mensual", "\$ 1,500 MXN", 'Concepto: ', widget.deudas!.idConcepto!,
            oddColour: Colors.black));
  }

  accountItems(String item, String charge, String dateString, String type,
      {Color oddColour = Colors.white}) {
    var pagoTardio =
        numberFormat.format(double.parse(widget.deudas!.montoPagoTardio!));
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 6, offset: Offset(0, 1))
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 10, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('Monto:',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: widget.deudas!.totalAdeudo == null
                    ? Container()
                    : Text('\$${widget.deudas!.totalAdeudo}',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: InkWell(
                  onTap: () {
                    widget.esPendiente == false
                        ? Fluttertoast.showToast(
                            msg: "Pagado",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 17.0)
                        : Fluttertoast.showToast(
                            msg: "Deuda más atraso",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 17.0);
                  },
                  child: Row(
                    children: [
                      widget.esPendiente == false
                          ? Icon(
                              Icons.flag,
                              color: Colors.lightGreen,
                            )
                          : Icon(
                              Icons.flag,
                              color: Colors.red,
                            ),
                      SizedBox(
                        width: 15,
                      ),
                      widget.esPendiente == true
                          ? Container()
                          : InkWell(
                              onTap: () async {
                                Printing.layoutPdf(
                                    onLayout: (PdfPageFormat format) {
                                  return buildPdf(format);
                                });
                              },
                              child: Icon(Glyphicon.download),
                            )
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              children: <Widget>[
                Text(dateString,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 12,
                ),
                Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(type,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold)),
                ),
                Text(
                  '${widget.deudas!.mes!}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  width: 19,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  imagenComu() async {}

  Future<Uint8List> buildPdf(PdfPageFormat format) async {
    ByteData bytes;
    Uint8List? byteList;
    prefs = await SharedPreferences.getInstance();
    var idCom = prefs!.getInt('idCom');
    print(idCom);
    if (idCom == 1) {
      bytes = await rootBundle.load('assets/images/bosques.jpg');
      setState(() {
        byteList = bytes.buffer.asUint8List();
      });
    } else if (idCom == 2) {
      bytes = await rootBundle.load('assets/images/cantera.jpg');
      setState(() {
        byteList = bytes.buffer.asUint8List();
      });
    } else if (idCom == 3) {
      bytes = await rootBundle.load('assets/images/EV3.png');
      setState(() {
        byteList = bytes.buffer.asUint8List();
      });
    } else if (idCom == 4) {
      bytes = await rootBundle.load('assets/images/moticello.png');
      setState(() {
        byteList = bytes.buffer.asUint8List();
      });
    } else if (idCom == 5) {
      bytes = await rootBundle.load('assets/images/rinconadas.jpeg');
      setState(() {
        byteList = bytes.buffer.asUint8List();
      });
    } else if (idCom == 6) {
      bytes = await rootBundle.load('assets/images/lomas.jpeg');
      setState(() {
        byteList = bytes.buffer.asUint8List();
      });
    } else if (idCom == 10) {
      bytes = await rootBundle.load('assets/images/natura.jpg');
      setState(() {
        byteList = bytes.buffer.asUint8List();
      });
    }

    ByteData bytesImg = await rootBundle.load('assets/images/logo.png');
    Uint8List bytesImgList = bytesImg.buffer.asUint8List();

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
              text: '\$${widget.deudas!.montoCuota}',
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
              text: '\$ ${widget.deudas!.montoPagoTardio}',
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
              text: '\$ ${widget.deudas!.totalAdeudo}',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        ]),
      ]),
    );
  }

  ///Construye el nombre principal, como el nombre del usuario y referencia
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
                text: '${widget.deudas!.referencia}',
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
              pw.Text('Fecha: ${widget.deudas!.mes}',
                  style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black)),
              pw.Container(
                padding: pw.EdgeInsets.only(right: 20),
                child: pw.Text('Recibo de Pago ',
                    style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black)),
              ),
              pw.Text('Folio:${widget.deudas!.folio}',
                  style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black)),
            ]));
  }

  /// construye la tabla que tiene el concepto y el por que pago
  _buildTable() {
    final headers = ['Concepto', 'Referencia', 'Monto', 'Forma de pago'];
    final users = [
      Users(
          concepto: 'Mantenimiento ${widget.users!.concepto}',
          referencia: widget.deudas!.referencia!,
          monto: double.parse(widget.deudas!.montoCuota!),
          tipoPago: widget.deudas!.descripcion),
    ];

    final data = users
        .map((users) => [
              '${widget.deudas!.mes}: ' + '${widget.deudas!.idConcepto}',
              widget.deudas!.referencia,
              widget.deudas!.montoCuota,
              widget.deudas!.descripcion
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
                        text: 'Residente: ${widget.userName} ',
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
                        text: 'Tipo Lote: ${widget.datosUsuario!.tipoLote} ',
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
