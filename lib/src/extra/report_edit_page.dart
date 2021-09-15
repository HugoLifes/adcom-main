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

  /// variable que indiga el progreso actual del estatus.
  Map<dynamic, Map>? progreso;

  ///  variable que muestra los comentarios por progreso.
  Map<dynamic, Map>? datos;

  /// variables que muestra las fechas de los comentarios.
  Map<dynamic, Map>? fechas;

  Map? superMap = <dynamic, Map>{};

  ReportEditPage(
      {Key? key,
      required this.report,
      required this.data,
      this.datos,
      this.progreso,
      this.fechas,
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
  bool finalizado = false;
  List<FechaReporte> f = [];

  /// funcion que retorna el estatus y lo asigna en arreglo
  /// recorre el mapeado de dos niveles
  estatus() {
    /// recorre el mapeado
    widget.progreso!.forEach((key, value) {
      if (widget.id == key) {
        /// recorre el segundo mapeado
        value.forEach((key, value) {
          if (key == 'Progreso') {
            setState(() {
              for (int i = 0; i < value.length; i++) {
                value.sort();
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

  ///mismo metodo que el mapeato del estatus
  /// chechar [estatus]
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

  ///Funcion para mapeado de fecha
  /// checar estatus
  fechasR() {
    widget.fechas!.forEach((key, value) {
      if (widget.id == key) {
        value.forEach((key, value) {
          if (key == 'Fechas') {
            setState(() {
              for (int i = 0; i < value.length; i++) {
                f.add(new FechaReporte(f: value[i]));
              }
            });
          }
        });
      }
    });
  }

  @override
  void initState() {
    /// carga los datos para poder procesarlos
    /// en lo que abre la pantalla
    estatus();
    datos();
    fechasR();

    super.initState();
  }

  /// validacion que indica el exito de un proceso
  isFinalizado() {
    if (progres.isNotEmpty) {
      if (progres.last.id == 4) {
        setState(() {
          /// enciende estados como el click en el stepper
          finalizado = true;
        });
      } else {
        finalizado = false;
      }
    }
    return finalizado;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    //var size2 = MediaQuery.of(context).size.width;
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
                enableStepTapping: isFinalizado(),
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

  /// funcion que muesta el encabezado del proceso
  /// [setpColor] sirve para cambiar el color segun el proceso
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

  /// Switch case que muestra el estatus del reporte
  /// cada case es un caso del proceso del 1 al 4
  Widget plainText(size) {
    switch (progres.isEmpty ? 0 : progres.last.id) {
      case 1:
        return datosp.isEmpty
            ? Container(
                child: Column(
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
                      'Tu reporte se encuentra en revision',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                    )
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size / 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text('Comentarios:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                  ),
                  respuestaView(size),
                ],
              );
      case 2:
        return datosp.isEmpty
            ? Container(
                child: Column(
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
                      'Tu reporte esta siendo procesado',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                    )
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 50),
                    child: Text('Comentarios:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                  ),
                  respuestaView(size),
                ],
              );
      case 3:
        return datosp.isEmpty
            ? Container(
                child: Column(
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
                      'No hay comentarios',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                    )
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Respuesta de Asesor:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
                  respuestaView(size),
                ],
              );
      case 4:
        return datosp.isEmpty
            ? Container(
                child: Column(
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
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                    )
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 30),
                    child: Text('Respuestas:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        )),
                  ),
                  respuestaView(size),
                ],
              );
      default:
        return Container();
    }
  }

  /// es la vista de la respuesta
  ListView respuestaView(size) {
    return ListView.builder(
        padding: EdgeInsets.only(left: size / 4.3, top: 10),
        shrinkWrap: true,

        /// recorre el largo de los datos procesados
        itemCount: datosp.length,
        itemBuilder: (_, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                  '${f[index].f!.day}/${f[index].f!.month}/${f[index].f!.year}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                width: size / 2,
                child: Text(datosp[index].coment,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
              ),
            ],
          );
        });
  }

  ///  funcion que cambia de color segun en el estatus
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

  ///muesta el nombre segun el estatus
  String? headerText() {
    switch (progres.isEmpty ? 0 : progres.last.id) {
      case 1:
        return 'Revisión';
      case 2:
        return 'En proceso';
      case 3:
        return 'Respuesta';
      case 4:
        return 'Finalizado';
      default:
        return 'Enviado';
    }
  }

  /// funcion que constuye la imagen o la cantidad de imagenes
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

  ///muestra el titulo del reporte y las imagenes del reporte
  /// chechar buildImage para cualquier detalle de imagenes
  help() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.report.descripCorta!,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
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

class FechaReporte {
  DateTime? f;

  FechaReporte({this.f});
}

class DatosProgreso {
  var coment;

  DatosProgreso({this.coment});
}
