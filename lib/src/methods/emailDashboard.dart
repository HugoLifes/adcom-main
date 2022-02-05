import 'dart:convert';
import 'dart:io';

import 'package:adcom/src/extra/filter_section.dart';
import 'package:adcom/src/extra/vistaContactos.dart';
import 'package:adcom/src/methods/exeptions.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/services.dart';
import 'package:adcom/json/json.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

// ignore: must_be_immutable
class ContactDashboard extends StatefulWidget {
  List<Items>? contactos = [];
  final bool filtrar;
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  ContactDashboard({this.filtrar = false, this.contactos});
  @override
  _ContactDashboardState createState() => _ContactDashboardState();
}

Future<Welcome?> getData() async {
  print('Se esta ejecutando');
  try {
    prefs = await SharedPreferences.getInstance();
    var id = prefs!.getInt('id');

    print(id.toString());

    Uri uri = Uri.parse(
        'http://www.adcom.com.mx:8081/backend/web/index.php?r=adcom/get-directorio');
    final response = await http.post(uri, body: {
      "params": json.encode({"usuarioId": id})
    }).timeout(Duration(seconds: 8), onTimeout: () {
      return http.Response('Timeout', 408);
    });

    var data = returnResponse(response);

    return welcomeFromJson(data);
  } on SocketException {
    throw FetchDataException('Error conection');
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

  @override
  void initState() {
    super.initState();
  }

  refresh() {}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return vistaContactos(size);
  }

  vistaContactos(size) => Flexible(
        child: GridView.builder(
          shrinkWrap: false,
          padding: EdgeInsets.only(left: 5, right: 5, top: 17),
          itemCount: widget.contactos!.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 4.0,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, int index) {
            return InkWell(
              onTap: () {
                ///navigator a vista contactos
                HapticFeedback.mediumImpact();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => VistaContactos(
                              contactos: widget.contactos![index],
                            )));
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
                        child: widget.contactos![index].icon == null
                            ? SizedBox()
                            : widget.contactos![index].icon,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        children: [
                          widget.contactos![index].title == null
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.only(top: size / 50),
                                  child: SizedBox(
                                    width: size / 2,
                                    child: Text(
                                      widget.contactos![index].title!
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: size / 29,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
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
