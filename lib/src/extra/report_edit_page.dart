import 'dart:io';
import 'package:adcom/src/extra/add_reporte.dart';
import 'package:adcom/src/extra/reporte.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';

// ignore: must_be_immutable
class ReportEditPage extends StatefulWidget {
  final DataReporte report;
  final List<Progreso> progreso;

  ReportEditPage({Key? key, required this.report, required this.progreso})
      : super(key: key);

  @override
  _ReportEditPageState createState() => _ReportEditPageState();
}

class _ReportEditPageState extends State<ReportEditPage> {
  var activestep = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  Icon(Icons.flag),
                  Icon(Icons.access_alarm),
                  Icon(Icons.check)
                ],
                activeStep: widget.progreso.last.id!,
                onStepReached: (index) {
                  setState(() {
                    for (int i = 0; i < widget.progreso.length; i++) {
                      widget.progreso[i].id = index;
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
              plainText()
            ],
          ),
        ));
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(5)),
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

  Widget plainText() {
    switch (widget.progreso.last.id!) {
      case 1:
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
            Text('Tu estado se ha revisado y se esta atendiendo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              'Comentarios:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
      case 3:
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

  String? headerText() {
    switch (widget.progreso.last.id!) {
      case 1:
        return 'Revision';
      case 2:
        return 'Respuesta';
      case 4:
        return 'Finalizado';

      default:
        return 'En proceso';
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
