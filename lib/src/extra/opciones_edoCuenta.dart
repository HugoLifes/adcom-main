import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OpcionesEdoCuenta extends StatefulWidget {
  OpcionesEdoCuenta({Key? key}) : super(key: key);

  @override
  _OpcionesEdoCuentaState createState() => _OpcionesEdoCuentaState();
}

class _OpcionesEdoCuentaState extends State<OpcionesEdoCuenta> {
  late ImageProvider image;
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
                Text(item, style: TextStyle(fontSize: 16.0)),
                InkWell(
                  
                  child: Icon(
                    Icons.picture_as_pdf_rounded,
                    size: 30,
                  ),
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
            ]));
    return await doc.save();
  }

  _buildCustomHeadline() {
    return pw.Header(
      child: pw.Text('Adcom',
          style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black)),
      padding: pw.EdgeInsets.all(4),
    );
  }
}

class PdfVista extends StatefulWidget {
  PdfVista({Key? key}) : super(key: key);

  @override
  _PdfVistaState createState() => _PdfVistaState();
}

class _PdfVistaState extends State<PdfVista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SfPdfViewer.network(''),
      ),
    );
  }
}
