import 'dart:convert';
import 'dart:io';

import 'package:adcom/json/json-getComunidades.dart';
import 'package:adcom/json/obtenerAvisos.dart';
import 'package:adcom/src/extra/dashboard_Avisos.dart';
import 'package:adcom/src/extra/nuevo_post.dart';
import 'package:adcom/src/methods/exeptions.dart';
import 'package:adcom/src/methods/searchBar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
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
  bool error = false;
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
                  /// lista para obtener los links de los avisos
                  links = List.generate(
                    value.data!.length,
                    (index2) => List.generate(
                        value.data![index2].archivos!.length,
                        (index) => value
                            .data![index2].archivos![index].direccionArchivo),
                  ),
                  for (int i = 0; i < value.data!.length; i++)
                    {
                      avisos.add(new AvisosUsuario(
                        avisos: value.data![i].aviso,
                        tipoAviso: value.data![i].tipoAviso,
                        fecha: value.data![i].fechaAviso,
                        nombreComu: value.data![i].comunidades,
                        links: List.generate(
                            value.data![i].archivos!.length,
                            (index) => value
                                .data![i].archivos![index].direccionArchivo),
                      )),
                    },

                  /// lista para los nombres de los archivos
                  name = List.generate(
                    value.data!.length,
                    (index2) => List.generate(
                        value.data![index2].archivos!.length,
                        (index) =>
                            value.data![index2].archivos![index].nombreArchivo),
                  ),

                  printAvisos(),
                }
              else
                {esFalso()}
            })
        .whenComplete(() => mounted == true
            ? setState(() {
                AvisosDashboard2(
                  comunities: comunities,
                  links: links,
                  avisos: avisos,
                  name: name,
                );
              })
            : null);
  }

  esFalso() {
    setState(() {
      itsTrue = false;
    });
  }

  printAvisos() {
    for (int i = 0; i < avisos.length; i++) {
      print(avisos[i].avisos);
      print(avisos[i].links);
    }
  }

  printLinks() {
    for (int i = 0; i < links!.length; i++) {
      print(links);
    }
  }

  printNames() {
    for (int i = 0; i < name!.length; i++) {
      print(name);
    }
  }

  @override
  void initState() {
    userCheck().catchError((e) {
      setState(() {
        alerta5();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          actions: [
            idComu == 99
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      final result = showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(
                            arraySearch: avisos,
                            name: name!,
                            links: links!,
                            comunities: comunities),
                      );

                      result.then((value) => {
                            if (links!.any((element) =>
                                element.toString().contains(value)))
                              {
                                print(value),
                                download2(value, value.split('/').last),
                              }
                          });
                    },
                  )
                : Container()
          ],
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
        body: LoaderOverlay(
          child: Stack(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    padding:
                                        EdgeInsets.only(top: size.width / 5),
                                    child: CircularProgressIndicator()))
                        : AvisosDashboard2(
                            comunities: comunities,
                            links: links,
                            name: name,
                            avisos: avisos,
                          )
                  ],
                ),
              ))
            ],
          ),
        ),
        bottomNavigationBar: typeUser == 2
            ? BottomAppBar(
                shape: const CircularNotchedRectangle(),
                child: Container(height: 50.0),
              )
            : null,
        floatingActionButton: typeUser == 2
            ? FloatingActionButton(
                mini: true,
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

  alerta5() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
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
      actions: [backButton],
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

  Future download2(String url, String names) async {
    print(url.replaceAll(" ", "%20"));
    print(names);
    Dio dio = Dio();

    String savePath = await getPath(names);
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      print(response.data);
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
    await OpenFile.open(savePath);
  }

  Future<String> getPath(String names) async {
    Directory path = await getApplicationDocumentsDirectory();

    print(path.path);

    var filePath;
    names.contains('.pdf');
    if (names.contains('.pdf') == false) {
      filePath = path.path + '/' + names + '.pdf';
    } else {
      filePath = path.path + '/$names';
    }

    print('here $filePath');
    return filePath;
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
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
    try {
      Uri url = Uri.parse(
          "http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-comunities");

      final response =
          await http.get(url).timeout(Duration(seconds: 7), onTimeout: () {
        return http.Response('Error', 400);
      });
      var data = returnResponse(response);

      return comunitiesFromJson(data);
    } on SocketException {
      throw FetchDataException('');
    }
  }
}

class AvisosUsuario {
  int? id;
  String? avisos;
  int? tipoAviso;
  DateTime? fecha;
  String? nombreComu;
  List<dynamic>? links;

  AvisosUsuario({
    this.avisos,
    this.fecha,
    this.tipoAviso,
    this.id,
    this.nombreComu,
    this.links,
  });

  Future<GetAvisos?> getAvisos(int id) async {
    try {
      Uri url = Uri.parse(
          "http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-avisos-by-residente");
      var response = await http
          .post(url, body: {'idCom': id.toString()}).timeout(
              Duration(seconds: 7), onTimeout: () {
        return http.Response('Error', 500);
      });
      var data = returnResponse(response);

      return getAvisosFromJson(data);
    } on SocketException {
      throw FetchDataException('');
    }
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<AvisosUsuario>? arraySearch;
  List<dynamic>? name;
  List<dynamic>? links;
  List<AvisosCall>? comunities;
  List<dynamic>? name2;
  List<dynamic>? links2;
  CustomSearchDelegate(
      {this.arraySearch, this.name, this.links, this.comunities});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  /// construye los resultados de la busqueda
  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 90,
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width / 1.2,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 7, offset: Offset(0, 5))
            ]),
        child: Column(
          children: [
            Text(query),
          ],
        ),
      ),
    );
  }

  /// construye posibles sugerencias de busqueda
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = arraySearch
        ?.where((p) => p.nombreComu!.toLowerCase().contains(query))
        .toList();

    return ListView.builder(
      itemCount: suggestionsList?.length ?? 0,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () async {
            query = suggestionsList![index].links![0];
            close(context, query);
          },
          leading: Icon(Glyphicon.newspaper),
          title: RichText(
            text: TextSpan(
              text: suggestionsList![index]
                  .nombreComu!
                  .substring(0, query.length),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: suggestionsList[index]
                      .nombreComu!
                      .substring(query.length),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          subtitle: Text(suggestionsList[index].avisos!),
        );
      },
    );
  }
}
