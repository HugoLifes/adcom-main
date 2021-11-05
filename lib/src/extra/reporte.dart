
import 'package:adcom/json/jsonReporte.dart';
import 'package:adcom/src/extra/add_reporte.dart';
import 'package:adcom/src/extra/report_edit_page.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:adcom/src/pantallas/avisos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

SharedPreferences? prefs;

class LevantarReporte extends StatefulWidget {
  const LevantarReporte({Key? key}) : super(key: key);

  @override
  _LevantarReporteState createState() => _LevantarReporteState();
}

Future<GetReportes?> getReportes() async {
  prefs = await SharedPreferences.getInstance();
  var id = prefs!.getInt('userId');
  Uri url = Uri.parse(
      'http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-reportes');

  final response = await http.post(url, body: {"idResidente": id.toString()});

  if (response.statusCode == 200) {
    var data = response.body;

    return getReportesFromJson(data);
  } else {
    print('${response.body}');
  }
}

class _LevantarReporteState extends State<LevantarReporte> {
  List<DataReporte> myList = [];
  List<Progreso> listProgreso = [];
  List<dynamic> idProgress = [];
  List<DataReporte> myListReversed = [];
  var progress = [];
  List<AvisosCall> comunities = [];
  /// progreso data
  var maps = <dynamic, Map>{};
  var progreso = <dynamic, dynamic>{};
  List<Map<dynamic, Map>> superMap = [];
  String? comunidad;
  String? numero;
  String? interior;
  List<String> idComName = [];

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

  GetReportes? cuentas;

  var idCom;
  var idUser;
  var userType;

  /// Activa el guardado en memoria
  addata() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      /// obtiene el id comunidad y la del usuario
      idCom = prefs!.getInt('idCom');
      idUser = prefs!.getInt('userId');
      userType = prefs!.getInt('userType');
    });
  }

   getComunidades() async {
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
  data() async {
    cuentas = await getReportes();
    await addata();
    await getComunidades();
    print(idCom);
    print(idUser);
    print(userType);

    for (int i = 0; i < cuentas!.data!.length; i++) {
      if (userType == 2) {
        print('aqui?');
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

        var fechasList = [];
        cuentas!.data![i].progreso!.forEach((element) {
          setState(() {
            fechasList.add(element.fechaSeg);
          });
        });

        fDatos = {"Fechas": fechasList};
        fechasMap.addAll({cuentas!.data![i].idReporte: fDatos});
      }
      fechasSuperMap.add(fechasMap);
      superMap2.add(maps2);
      superMap.add(maps);
    }
    reversedList2 = fechasSuperMap.reversed.toList();
    reversedList3 = superMap2.reversed.toList();
    reversedList4 = superMap.reversed.toList();
    reversedList = myList.reversed.toList();

    refresh();
  }

  @override
  void initState() {
    data();
    super.initState();
  }

  refresh() {
    if (mounted) {
      setState(() {
        listview();
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
      body: reversedList.length == 0
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 7,
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AddReporte(
              comunities: comunities,
              idComu: idComName,
            ))),
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
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
          return Container(
            padding: EdgeInsets.all(8),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ReportEditPage(
                        report: reversedList[index],
                        data: listProgreso,
                        progreso: reversedList4[index],
                        datos: reversedList3[index],
                        id: reversedList[index].id,
                        fechas: reversedList2[index])));
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
                    width: 160,
                    child: Text(
                      '${reversedList[index].desperfecto}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Column(
                    children: [
                      Text('${transform12hrs(index)}'),
                      Text(
                        '${reversedList[index].fechaRep!.day}/${reversedList[index].fechaRep!.month}/${reversedList[index].fechaRep!.year}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      reversedList[index].comunidad == null
                          ? Text('')
                          : SizedBox(
                              width: 110,
                              child: Text(reversedList[index].comunidad!, textAlign: TextAlign.center,)),
                      reversedList[index].numero == null
                          ? Text('')
                          : Row(
                              children: [
                                Text(reversedList[index].numero!),
                                Text('-'),
                                Text(reversedList[index].interior!)
                              ],
                            ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  transform12hrs(int index){
    var fromhr = DateFormat("hh:mma");
    var newTime = fromhr.format(reversedList[index].fechaRep!);

    return newTime;
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