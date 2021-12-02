import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:adcom/src/extra/report_edit_page.dart' as p;
import 'package:adcom/json/jsonReporte.dart';
import 'package:adcom/src/extra/add_reporte.dart';
import 'package:adcom/src/methods/exeptions.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:adcom/src/pantallas/avisos.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

SharedPreferences? prefs;

class LevantarReporte extends StatefulWidget {
  const LevantarReporte({Key? key}) : super(key: key);

  @override
  _LevantarReporteState createState() => _LevantarReporteState();
}

Future<GetReportes?> getReportes() async {
  try {
    prefs = await SharedPreferences.getInstance();
    var id = prefs!.getInt('userId');
    print(id);
    Uri url = Uri.parse(
        'http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-reportes');

    final response = await http.post(url, body: {"idResidente": id.toString()});

    var data = returnResponse(response);

    return getReportesFromJson(data);
  } on SocketException {
    throw FetchDataException('Error');
  }
}

class _LevantarReporteState extends State<LevantarReporte> {
  List<DataReporte> myList = [];
  List<Progreso> listProgreso = [];
  List<dynamic> idProgress = [];
  List<DataReporte> myListReversed = [];
  var progress = [];

  /// progreso data
  var maps = <dynamic, Map>{};
  var progreso = <dynamic, dynamic>{};
  List<Map<dynamic, Map>> superMap = [];

  /// datos del progreso
  ///     mapeado dinamico que espera otro mapeado
  var maps2 = <dynamic, Map>{};

  /// mapeado dinamico que espera dinamico
  ///     dinamico es tu tipo de variable que toma cualquier valor
  var datos = <dynamic, dynamic>{};

  /// lista mapeada dinamica que espera otro mapeado
  List<Map<dynamic, Map>> superMap2 = [];

  var fechasMap = <dynamic, Map>{};
  var fDatos = <dynamic, dynamic>{};
  List<Map<dynamic, Map>> fechasSuperMap = [];

  /// Declaraciones de futuras listas en reversa
  ///   checar la asignacion en la funcion data, antes de cualquier alteracion
  ///
  List<DataReporte> reversedList = [];
  List<Map<dynamic, Map>> reversedList2 = [];
  List<Map<dynamic, Map>> reversedList3 = [];
  List<Map<dynamic, Map>> reversedList4 = [];
  List<Map<dynamic, Map>> reversedList5 = [];
  List<AvisosCall> comunities = [];
  String? comunidad;
  String? numero;
  String? interior;
  var userType;
  List<String> idComName = [];
  GetReportes? cuentas;
  List<String> evidencia = [];
  List<p.ProgressIndicator> progres = [];
  var idCom;
  var idUser;
  bool error = false;
  var maps3 = <dynamic, Map>{};
  var evidencias = <dynamic, dynamic>{};
  bool siTieneDatos = false;
  List<Map<dynamic, Map>> superEvidencia = [];

  /// Activa el guardado en memoria
  addata() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        /// obtiene el id comunidad y la del usuario
        idCom = prefs!.getInt('idCom');
        idUser = prefs!.getInt('userId');
        userType = prefs!.getInt('userType');
      });
    }
  }

  Future getComunidades() async {
    AvisosCall().getComunidades().then((value) => {
          for (int i = 0; i < value!.data!.length; i++)
            {
              idComName.add(value.data![i].nombreComu!),
              comunities.add(AvisosCall(
                  id: value.data![i].idCom,
                  nombreComu: value.data![i].nombreComu,
                  ubicacion: value.data![i].ubicacion,
                  cp: value.data![i].cp,
                  idAdmin: value.data![i].idAdministrador == null
                      ? 0
                      : value.data![i].idAdministrador,
                  idComite: value.data![i].idComite == null
                      ? 0
                      : value.data![i].idComite,
                  idTipoComu: value.data![i].idTipoComu,
                  banco: value.data![i].banco,
                  cuentaBanco: value.data![i].cuentaBanco,
                  cuentaClabe: value.data![i].cuentaClabe,
                  RFC: value.data![i].rfc)),
            }
        });
  }

  /// Llama al service y asigna los datos obtenido a una clase
  Future data() async {
    cuentas = await getReportes().catchError((e) {
      alerta5();
    });
    await addata();
    await getComunidades();

    for (int i = 0; i < cuentas!.data!.length; i++) {
      if (userType == 2 || userType == 4) {
        myList.add(new DataReporte(
            id: cuentas!.data![i].idReporte,
            descripCorta: cuentas!.data![i].descCorta,
            desperfecto: cuentas!.data![i].descDesperfecto,
            fechaRep: cuentas!.data![i].fechaRep,
            uri: cuentas!.data![i].evidencia!.toList(),
            comunidad: cuentas!.data![i].comunidad!.trimRight(),
            numero: cuentas!.data![i].numero!.trimRight(),
            interior: cuentas!.data![i].interior!.trimRight()));
      } else {
        myList.add(new DataReporte(
            id: cuentas!.data![i].idReporte,
            descripCorta: cuentas!.data![i].descCorta,
            desperfecto: cuentas!.data![i].descDesperfecto,
            fechaRep: cuentas!.data![i].fechaRep,
            uri: cuentas!.data![i].evidencia!.toList()));
      }

      for (int j = 0; j < cuentas!.data![i].progreso!.length; j++) {
        //mapeado del estatus asgigando id
        var progress = [];
        //añade los estatus a la lista progress
        cuentas!.data![i].progreso!.forEach((element) {
          if (mounted) {
            setState(() {
              progress.add(element.idProgreso);
            });
          }
        });
        //se mapea la lista progress

        progreso = {"Progreso": progress};

        //mapeado
        maps.addAll({cuentas!.data![i].idReporte: progreso});

        var datosProgres = [];
        cuentas!.data![i].progreso!.forEach((element) {
          setState(() {
            datosProgres.add(element.comentario);
          });
        });
        datos = {"Datos": datosProgres};
        maps2.addAll({cuentas!.data![i].idReporte: datos});

        var fechasList = [];
        cuentas!.data![i].progreso!.forEach((element) {
          setState(() {
            fechasList.add(element.fechaSeg);
          });
        });

        fDatos = {"Fechas": fechasList};
        fechasMap.addAll({cuentas!.data![i].idReporte: fDatos});

        cuentas!.data![i].progreso!.forEach((element) {
          setState(() {
            evidencias = {"Evidencias": element.evidencia!.toList()};
          });
        });

        maps3.addAll({cuentas!.data![i].idReporte: evidencias});
      }
      fechasSuperMap.add(fechasMap);
      superEvidencia.add(maps3);
      superMap2.add(maps2);
      superMap.add(maps);
    }
    reversedList2 = fechasSuperMap.reversed.toList();
    reversedList3 = superMap2.reversed.toList();
    reversedList4 = superMap.reversed.toList();
    reversedList5 = superEvidencia.reversed.toList();
    reversedList = myList.reversed.toList();
  }

  @override
  void initState() {
    data().then((value) {
      print(value);
      if (mounted) {
        setState(() {
          if (value.data!) {
            listview();
            siTieneDatos = true;
          } else {}
        });
      }
    });

    super.initState();
  }

  refresh() {
    if (mounted) {
      setState(() {
        if (myList.isNotEmpty) {
          myList.clear();
          fechasSuperMap.clear();
          superMap.clear();
          superMap2.clear();
          reversedList.clear();
          reversedList2.clear();
          reversedList3.clear();
          reversedList4.clear();
          reversedList5.clear();
          comunities.clear();
          data().catchError((e) {
            alerta5();
          });
        } else {
          data().catchError((e) {
            alerta5();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.blue,
        title: Text('Reportes'),
      ),
      body: LoaderOverlay(
          child: reversedList.length == 0
              ? SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        reversedList.length == 0
                            ? Text(
                                'Presiona + para añadir un nuevo caso',
                                style: TextStyle(
                                    fontSize: 21, color: Colors.black),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ],
                    ),
                  ),
                )
              : listview()),
      floatingActionButton: FloatingActionButton(
        elevation: 7,
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (_) => AddReporte(
                      comunities: comunities,
                      idComu: idComName,
                    )))
            .then(onGoBack),
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  FutureOr onGoBack(dynamic value) {
    refresh();
  }

  listview() {
    return Container(
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 3,
            color: Colors.grey[350],
          );
        },
        itemCount: reversedList.length,
        itemBuilder: (context, int index) {
          estatus(index);

          return Container(
            padding: EdgeInsets.all(8),
            child: ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (_) => p.ReportEditPage(
                            evidencia: reversedList5[index],
                            report: reversedList[index],
                            data: listProgreso,
                            progreso: reversedList4[index],
                            datos: reversedList3[index],
                            id: reversedList[index].id,
                            fechas: reversedList2[index])))
                    .then((value) {
                  onGoBack(value);
                });
              },
              title: Text(
                '${reversedList[index].descripCorta}',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            '${reversedList[index].desperfecto}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.23,
                            height: 20,
                            padding: EdgeInsets.only(left: 6, top: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: stepColor(index),
                            ),
                            child: Text('${headerText(index)}'))
                      ],
                    ),
                  ),
                  Column(children: [
                    Text('${transform12Hrs(index)}'),
                    Text(
                      '${reversedList[index].fechaRep!.day}/${reversedList[index].fechaRep!.month}/${reversedList[index].fechaRep!.year}',
                      style: TextStyle(fontSize: 18),
                    ),
                    reversedList[index].comunidad == null
                        ? Text('')
                        : SizedBox(
                            width: 100,
                            child: Text(
                              reversedList[index].comunidad!,
                              textAlign: TextAlign.center,
                            )),
                    reversedList[index].numero == null
                        ? Text('')
                        : Row(
                            children: [
                              Text(reversedList[index].numero!),
                              Text('-'),
                              Text(reversedList[index].interior!)
                            ],
                          ),
                  ]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  transform12Hrs(int index) {
    var formarhr = DateFormat("hh:mma");
    var newTime = formarhr.format(reversedList[index].fechaRep!);

    return newTime;
  }

  estatus(int index) {
    /// recorre el mapeado
    reversedList4[index].forEach((key, value) {
      if (reversedList[index].id == key) {
        /// recorre el segundo mapeado
        value.forEach((key, value) {
          if (key == 'Progreso') {
            for (int i = 0; i < value.length; i++) {
              progres.add(new p.ProgressIndicator(id: value[i]));
            }
          }
        });
      } else {
        return;
      }
    });
  }

  Color? stepColor(index) {
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

  String? headerText(index) {
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

  alerta5() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context)..pop();
          data();
        },
        child: Text(
          'Si, continuar',
          style: TextStyle(color: Colors.red[900]),
        ));
    Widget backButton = TextButton(
        onPressed: () {
          Navigator.of(context)..pop()..pop();
        },
        child: Text(
          'Regresar',
          style: TextStyle(color: Colors.orange),
        ));
    AlertDialog alert = AlertDialog(
      actions: [backButton, okButton],
      title: Text(
        'Atención!',
        style: TextStyle(
          fontSize: 25,
        ),
      ),
      content: Container(
        width: 140,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atencion!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            Text('Ha sucedido un error inesperado, vuelva a intentar')
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
  }
}

class Progreso {
  int? id;
  DateTime? time;
  String? comentario;
  String? progreso;

  Progreso({this.time, this.comentario, this.progreso, this.id});
  /* @override
  String toString() {
    return "($id, $time, $comentario, $progreso)";
  } */
}

class DataReporte {
  int? id;
  String? descripCorta;
  String? desperfecto;
  DateTime? fechaRep;
  List<String>? uri = [];
  List<dynamic>? progreso = [];
  String? comunidad;
  String? numero;
  String? interior;

  DataReporte(
      {this.id,
      this.descripCorta,
      this.desperfecto,
      this.fechaRep,
      this.uri,
      this.progreso,
      this.comunidad,
      this.interior,
      this.numero});
}
