import 'dart:io';
import 'package:adcom/src/extra/add_reporte.dart';
import 'package:adcom/src/extra/reporte.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'dart:convert';

// ignore: must_be_immutable
class ReportEditPage extends StatefulWidget {
  final int? id;
  final DataReporte report;
  final List<Progreso> data;

  Map<dynamic, Map>? progreso;
  Map<dynamic, Map>? datos;
  Map? superMap = <dynamic, Map>{};

  ReportEditPage(
      {Key? key,
      required this.report,
      required this.data,
      this.datos,
      this.progreso,
      this.id})
      : super(key: key);

  @override
  _ReportEditPageState createState() => _ReportEditPageState();
}

class _ReportEditPageState extends State<ReportEditPage> {
  var activestep = 0;
  List<dynamic> progreso = [];
  var data;
  List<ProgressIndicator> progres = [];
  List<DatosProgreso> datosp = [];

  List<int> progresFromJson(String str) =>
      List<int>.from(json.decode(str).map((x) => x));

  String progresToJson(List<dynamic> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x)));
  estatus() {
    widget.progreso!.forEach((key, value) {
      if (widget.id == key) {
        value.forEach((key, value) {
          if (key == 'Progreso') {
            setState(() {
              for (int i = 0; i < value.length; i++) {
                progres.add(new ProgressIndicator(id: value[i]));
              }
            });
          }
        });
      } else {
        return;
      }
    });
  }

  datos() {
    widget.datos!.forEach((key, value) {
      if (widget.id == key) {
        value.forEach((key, value) {
          if (key == 'Datos') {
            setState(() {
              for (int i = 0; i < value.length; i++) {
                datosp.add(new DatosProgreso(coment: value[i]));
              }
            });
          }
        });
      } else {
        return;
      }
    });
  }

  @override
  void initState() {
    estatus();
    datos();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var size2 = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Seguimiento de reporte'),
          backgroundColor: Colors.blue,
          leading: CloseButton(),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              IconStepper(
                icons: [
                  Icon(Icons.supervised_user_circle),
                  Icon(Icons.check),
                  Icon(Icons.flag),
                  Icon(Icons.access_alarm),
                  Icon(Icons.check)
                ],
                activeStep: progres.isEmpty ? 0 : progres.last.id,
                onStepReached: (index) {
                  setState(() {
                    if (progres.isEmpty) {
                      activestep = index;
                    } else {
                      progres.last.id = index;
                    }
                  });
                },
              ),
              header(),
              SizedBox(
                height: 10,
              ),
              help(),
              SizedBox(
                height: 20,
              ),
              plainText(size)
            ],
          ),
        ));
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
          color: stepColor(), borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(9.0),
            child: Text(
              'Status: ${headerText()!}',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget plainText(size) {
    switch (progres.isEmpty ? 0 : progres.last.id) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atencion:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Se ha enviado su reporte',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Se le notificara el cambio de estado del reporte',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            )
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asesor:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Su estado se encuentra en revisión',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Se le notificara el cambio de estado del reporte',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            )
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asesor:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Tu estado se ha revisado y se esta atendiendo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'Comentarios:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  width: size / 20,
                ),
                SizedBox(
                  width: size / 2,
                  child: Text('${datosp[2].coment}',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
            )
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Asesor:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              'Tu reporte se ha atendido y ha finalizado con éxito',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
            )
          ],
        );
      default:
        return Container();
    }
  }

  Color? stepColor() {
    switch (progres.isEmpty ? 0 : progres.last.id) {
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.lightGreen[200];
      case 3:
        return Colors.lightGreen[300];
      case 4:
        return Colors.lightGreen;

      default:
        return Colors.grey;
    }
  }

  String? headerText() {
    switch (progres.isEmpty ? 0 : progres.last.id) {
      case 1:
        return 'En proceso';
      case 2:
        return 'Revision';
      case 3:
        return 'Respuesta';
      case 4:
        return 'Finalizado';
      default:
        return 'Enviado';
    }
  }

  buildImage() => GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 200,
            mainAxisSpacing: 15,
            crossAxisSpacing: 14,
            childAspectRatio: 1.1),
        itemCount: widget.report.uri!.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(widget.report.uri![index]);
        },
      );

  help() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.report.descripCorta!,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(right: 170),
                child: Text(
                  widget.report.desperfecto!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              buildImage(),
            ],
          ),
        )
      ],
    );
  }
}

class ProgressIndicator {
  var id;

  ProgressIndicator({this.id});
}

class DatosProgreso {
  var coment;

  DatosProgreso({this.coment});
}
