import 'dart:convert';

import 'package:adcom/src/extra/filter_section.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/services.dart';
import 'package:adcom/json/json.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

class ContactDashboard extends StatefulWidget {
  final bool filtrar;
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  ContactDashboard({this.filtrar = false});
  @override
  _ContactDashboardState createState() => _ContactDashboardState();
}

obtainId(id) async {
  await ContactDashboard.init();
  prefs!.setInt('id', id);
}

Future<Welcome?> getData() async {
  print('Se esta ejecutando');

  prefs = await SharedPreferences.getInstance();
  var id = prefs!.getInt('id');

  Uri uri = Uri.parse(
      'http://187.189.53.8:8080/AdcomBackend/backend/web/index.php?r=adcom/get-directorio');
  final response = await http.post(uri, body: {
    "params": json.encode({'usuarioId': id})
  });

  if (response.statusCode == 200) {
    var data = response.body;

    return welcomeFromJson(data);
  }
}

class _ContactDashboardState extends State<ContactDashboard> {
  /* Welcome? dt; */
  late Welcome? dt;
  List<Comu> list = [];
  List<Items> myList = [];
  List<Items> filtroComu = [];
  var items;
  var com;
  holi() async {
    dt = await getData();
    final provider = Provider.of<EventProvider>(context, listen: false);
    for (int i = 0; i < dt!.residente!.length; i++) {
      myList.add(new Items(
          idResidente: dt!.residente![i].idResidente,
          title: dt!.residente![i].nombreResidente,
          numero: dt!.residente![i].numero,
          idComunidad: dt!.residente![i].idCom,
          calle: dt!.residente![i].calle,
          cp: dt!.residente![i].cp,
          email: dt!.residente![i].email,
          interior: dt!.residente![i].interior,
          telCel: dt!.residente![i].telefonoCel,
          telEme: dt!.residente![i].telefonoEmergencia,
          telFijo: dt!.residente![i].telefonoFijo,
          comNombre: dt!.residente![i].comNombre,
          icon: Icon(
            Icons.person,
            size: 30,
            color: Colors.lightGreen,
          )));

      //Arreglar el valor nulo entrante
      //
      provider.addContacts(new Items(
          idResidente: dt!.residente![i].idResidente,
          title: dt!.residente![i].nombreResidente,
          numero: dt!.residente![i].numero,
          idComunidad: dt!.residente![i].idCom,
          calle: dt!.residente![i].calle,
          cp: dt!.residente![i].cp,
          email: dt!.residente![i].email,
          interior: dt!.residente![i].interior,
          telCel: dt!.residente![i].telefonoCel,
          telEme: dt!.residente![i].telefonoEmergencia,
          telFijo: dt!.residente![i].telefonoFijo,
          comNombre: dt!.residente![i].comNombre));
    }
  }

  @override
  void initState() {
    super.initState();
    holi();

    Future.delayed(Duration(seconds: 1), () => {refresh()});
  }

  refresh() {
    setState(() {
      vistaContactos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return myList.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : vistaContactos();
  }

  vistaContactos() => Flexible(
        child: GridView.builder(
          shrinkWrap: false,
          padding: EdgeInsets.only(left: 4, right: 4, top: 17),
          itemCount: myList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 3.15,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, int index) {
            return InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                //Navigator.pushNamed(context, data.route);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 6,
                          offset: Offset(0, 1))
                    ]),
                child: Container(
                  //margin: EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey[300], shape: BoxShape.circle),
                        child: myList[index].icon == null
                            ? SizedBox()
                            : myList[index].icon,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          myList[index].title == null
                              ? Container()
                              : Text(
                                  myList[index].title!.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Comu:',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              myList[index].comNombre == null
                                  ? Container()
                                  : Text("${myList[index].comNombre}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Celular:',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              myList[index].telCel == null
                                  ? Container()
                                  : Text(myList[index].telCel!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
}

class Items {
  String? route;
  String? title;
  String? calle;
  String? numero;
  String? interior;
  String? cp;
  String? telFijo;
  String? telCel;
  String? telEme;
  String? email;
  int? idResidente;
  int? idComunidad;
  String? subtitle;
  String? comNombre;
  //el evento puede ayudar a las notificaciones, checar despues
  String? event;
  Icon? icon;
  Items(
      {required this.title,
      required this.comNombre,
      this.icon,
      this.subtitle,
      this.route,
      required this.idResidente,
      required this.numero,
      required this.idComunidad,
      required this.calle,
      required this.cp,
      required this.email,
      required this.interior,
      required this.telCel,
      required this.telEme,
      required this.telFijo});

  @override
  String toString() => 'Comu $comNombre\n ' 'Nombre $title';
}
