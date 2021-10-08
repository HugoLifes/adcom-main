import 'dart:convert';

import 'package:adcom/json/json-getComunidades.dart';
import 'package:adcom/json/obtenerAvisos.dart';
import 'package:adcom/src/extra/dashboard_Avisos.dart';
import 'package:adcom/src/extra/nuevo_post.dart';
import 'package:adcom/src/methods/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

class Avisos extends StatefulWidget {
  final id;
  Avisos({Key? key, this.id}) : super(key: key);

  @override
  _AvisosState createState() => _AvisosState();
}

class _AvisosState extends State<Avisos> {
  bool _requierConsent = true;
  int _selectedIndex = 0;
  List<AvisosCall> comunities = [];
  List<String> idComName = [];

  List<AvisosUsuario> avisos = [];
  List? links;
  List? name;

  List<String> hLinks = [];
  var nombres = <dynamic, dynamic>{};
  var Link = <dynamic, Map>{};
  List<Map<dynamic, Map>> superMap2 = [];
  var typeUser;
  var idComu;
  bool itsTrue = true;
  //funcion que checa el usuario y llama a las funciones si es el usuario maestro
  Future userCheck() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      typeUser = prefs!.getInt('userType');
      idComu = prefs!.getInt('idCom');
    });

    print('$typeUser');
    print('here $idComu');

    if (typeUser == 2) {
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
    } else {
      print('usario no aceptado');
    }

    AvisosUsuario()
        .getAvisos(idComu)
        .then((value) => {
              if (value!.data!.isNotEmpty)
                {
                  for (int i = 0; i < value.data!.length; i++)
                    {
                      avisos.add(new AvisosUsuario(
                        avisos: value.data![i].aviso,
                        tipoAviso: value.data![i].tipoAviso,
                        fecha: value.data![i].fechaAviso,
                      )),
                    },
                  links = List.generate(
                      value.data!.length,
                      (index2) => List.generate(
                          value.data![index2].archivos!.length,
                          (index) => value
                              .data![index2].archivos![index].direccionArchivo),
                      growable: true),
                  name = List.generate(
                      value.data!.length,
                      (index2) => List.generate(
                          value.data![index2].archivos!.length,
                          (index) => value
                              .data![index2].archivos![index].nombreArchivo),
                      growable: true),
                }
              else
                {esFalso()}
            })
        .whenComplete(() => mounted == true
            ? setState(() {
                AvisosDashboard(
                  avisos: avisos,
                );
              })
            : null);
  }

  esFalso() {
    setState(() {
      itsTrue = false;
    });
  }

  @override
  void initState() {
    userCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Avisos',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700)),
          elevation: 4.0,
          backgroundColor: Colors.blueGrey[700],
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              height: size.width / 2.0,
              decoration: BoxDecoration(color: Colors.blueGrey[700]),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: size.height / 30, right: size.width / 20),
              alignment: Alignment.topRight,
              child: Icon(
                Icons.announcement_rounded,
                color: Colors.white,
                size: size.width / 4.5,
              ),
            ),
            SafeArea(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.width / 50,
                  ),
                  Text(
                    'Comunicados de la comunidad',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: size.width / 1.5,
                    child: Text(
                      'Enterate de lo que sucede en tu comunidad! Desde recordatorios, alertas, novedades y más.',
                      style: TextStyle(
                          color: Colors.white, fontSize: size.width / 19),
                    ),
                  ),
                  avisos.isEmpty
                      ? Center(
                          child: itsTrue == false
                              ? Container(
                                  padding: const EdgeInsets.only(top: 90),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/magic.png',
                                        width: size.width / 1,
                                        height: 200,
                                      ),
                                      Text(
                                        'Lo sentimos, por el momento no hay avisos',
                                        style: TextStyle(
                                          fontSize: size.width / 20,
                                          color: Colors.blueGrey[700],
                                        ),
                                        textAlign: TextAlign.justify,
                                      )
                                    ],
                                  ))
                              : Container(
                                  padding: EdgeInsets.only(top: size.width / 5),
                                  child: CircularProgressIndicator()))
                      : AvisosDashboard(
                          links: links,
                          name: name,
                          avisos: avisos,
                        )
                ],
              ),
            ))
          ],
        ),
        bottomNavigationBar: typeUser == 2
            ? BottomAppBar(
                shape: const CircularNotchedRectangle(),
                child: Container(height: 50.0),
              )
            : null,
        floatingActionButton: typeUser == 2
            ? FloatingActionButton(
                elevation: 5,
                backgroundColor: Colors.blueGrey[700],
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => MakeNewPost(
                            idComu: idComName,
                            comunities: comunities,
                          )));
                },
                tooltip: 'add post',
                child: const Icon(
                  Icons.add,
                ),
              )
            : null,
        floatingActionButtonLocation:
            typeUser == 2 ? FloatingActionButtonLocation.centerDocked : null);
  }

  Future<void>? initStatePlatform() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requierConsent);

    OneSignal.shared.setNotificationOpenedHandler((result) {
      print('Notification ha sido abierta $result');
      this.setState(() {});
    });

    OneSignal.shared.setInAppMessageClickedHandler((action) {
      this.setState(() {});
    });

    OneSignal.shared.setSubscriptionObserver((changes) {
      print('La subscripcion ha cambiado ${changes.jsonRepresentation()}');
    });

    OneSignal.shared.setPermissionObserver((changes) {
      print('El permiso ha cambiado ${changes.jsonRepresentation()}');
    });
  }
}

class AvisosCall {
  int? id;
  String? nombreComu;
  String? ubicacion;
  int? cp;
  int? idAdmin;
  int? idComite;
  String? idTipoComu;
  String? banco;
  String? cuentaBanco;
  String? cuentaClabe;
  String? RFC;

  AvisosCall(
      {this.id,
      this.nombreComu,
      this.RFC,
      this.banco,
      this.cp,
      this.idTipoComu,
      this.cuentaBanco,
      this.cuentaClabe,
      this.idAdmin,
      this.idComite,
      this.ubicacion});

  Future<Comunities?> getComunidades() async {
    Uri url = Uri.parse(
        "http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-comunities");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = response.body;

      return comunitiesFromJson(data);
    }
  }
}

class AvisosUsuario {
  int? id;
  String? avisos;
  int? tipoAviso;
  DateTime? fecha;

  AvisosUsuario({
    this.avisos,
    this.fecha,
    this.tipoAviso,
    this.id,
  });

  Future<GetAvisos?> getAvisos(int id) async {
    Uri url = Uri.parse(
        "http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-avisos-by-residente");
    final response = await http.post(url, body: {'idCom': id.toString()});

    if (response.statusCode == 200) {
      var data = response.body;
      print(data);
      return getAvisosFromJson(data);
    }
  }
}
