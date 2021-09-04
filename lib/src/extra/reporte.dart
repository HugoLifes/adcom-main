import 'dart:convert';

import 'package:adcom/json/jsonReporte.dart';
import 'package:adcom/src/extra/report_edit_page.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

SharedPreferences? prefs;

class LevantarReporte extends StatefulWidget {
  const LevantarReporte({Key? key}) : super(key: key);
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  _LevantarReporteState createState() => _LevantarReporteState();
}

dataOff5(id) async {
  await LevantarReporte.init();
  prefs!.setInt('id', id);
}

Future<GetReportes?> getReportes() async {
  prefs = await SharedPreferences.getInstance();
  var id = prefs!.getInt('userId'); //CAMBIAR POR id
  Uri url = Uri.parse(
      'http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-reportes');

  final response = await http.post(url, body: {"idResidente": id.toString()});

  if (response.statusCode == 200) {
    var data = response.body;

    return getReportesFromJson(data);
  } else {
    print('error');
  }
}

class _LevantarReporteState extends State<LevantarReporte> {
  List<DataReporte> myList = [];
  List<Progreso> listProgreso = [];
  List<dynamic> idProgress = [];
  // progreso data
  var maps = <dynamic, Map>{};
  var progreso = <dynamic, dynamic>{};
  List<Map<dynamic, Map>> superMap = [];

  // datos del progreso
  //mapeado dinamico que espera otro mapeado
  var maps2 = <dynamic, Map>{};
  // mapeado dinamico que espera dinamico
  //dinamico es tu tipo de variable que toma cualquier valor
  var datos = <dynamic, dynamic>{};
  //lista mapeada dinamica que espera otro mapeado
  List<Map<dynamic, Map>> superMap2 = [];

  GetReportes? cuentas;

  //obtiene los datos del service
  data() async {
    cuentas = await getReportes();
    for (int i = 0; i < cuentas!.data!.length; i++) {
      myList.add(new DataReporte(
          id: cuentas!.data![i].idReporte,
          descripCorta: cuentas!.data![i].descCorta,
          desperfecto: cuentas!.data![i].descDesperfecto,
          fechaRep: cuentas!.data![i].fechaRep,
          uri: cuentas!.data![i].evidencia!.toList()));

      for (int j = 0; j < cuentas!.data![i].progreso!.length; j++) {
        //mapeado del estatus asgigando id
        var progress = [];
        //añade los estatus a la lista progress
        cuentas!.data![i].progreso!.forEach((element) {
          setState(() {
            progress.add(element.idProgreso);
          });
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

        /* listProgreso.add(new Progreso(
            time: cuentas!.data![i].progreso![j].fechaSeg,
            comentario: cuentas!.data![i].progreso![j].comentario,
            progreso: cuentas!.data![i].progreso![j].progreso)); */
      }
      superMap2.add(maps2);
      superMap.add(maps);
      print(superMap[0]);
      print(superMap2[0]);

      superMap = superMap;
    }
  }

  @override
  void initState() {
    data();
    super.initState();

    Future.delayed(Duration(milliseconds: 988), () => {refresh()});
  }

  refresh() {
    setState(() {
      listview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.blue,
        title: Text('Reportes'),
      ),
      body: myList.length == 0
          ? SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Presiona + para añadir un nuevo caso',
                      style: TextStyle(fontSize: 21, color: Colors.black),
                    ),
                  ],
                ),
              ),
            )
          : listview(),
      floatingActionButton: FloatingActionButton(
        elevation: 7,
        onPressed: () => Navigator.of(context).popAndPushNamed('/screen18'),
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Container listview() {
    return Container(
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 3,
            color: Colors.grey[350],
          );
        },
        itemCount: myList.length,
        itemBuilder: (context, int index) {
          return Container(
            padding: EdgeInsets.all(8),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ReportEditPage(
                          report: myList[index],
                          data: listProgreso,
                          progreso: superMap[index],
                          datos: superMap2[index],
                          id: myList[index].id,
                        )));
              },
              title: Text(
                '${myList[index].descripCorta}',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(
                      '${myList[index].desperfecto}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Text(
                    '${myList[index].fechaRep!.day}/${myList[index].fechaRep!.month}/${myList[index].fechaRep!.year}',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
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

  DataReporte(
      {this.id,
      this.descripCorta,
      this.desperfecto,
      this.fechaRep,
      this.uri,
      this.progreso});
}
