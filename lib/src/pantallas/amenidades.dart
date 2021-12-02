import 'dart:convert';
import 'dart:io';

import 'package:adcom/json/jsonAmenidades.dart';
import 'package:adcom/src/methods/eventDashboard.dart';
import 'package:adcom/src/methods/exeptions.dart';
import 'package:adcom/src/methods/searchBar.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

SharedPreferences? prefs;

class Amenidades extends StatefulWidget {
  final id;

  Amenidades({Key? key, this.id}) : super(key: key);
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  _AmenidadesState createState() => _AmenidadesState();
}

dataOff4(id) async {
  await Amenidades.init();
  prefs!.setInt('idPrimario', id);
}

Future<Places?> idso() async {
  try {
    prefs = await SharedPreferences.getInstance();
    var id = prefs!.getInt('idPrimario');

    final Uri url = Uri.parse(
        'http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-amenidades');
    final response = await http.post(url, body: {
      "params": json.encode({"usuarioId": id})
    }).timeout(Duration(seconds: 8), onTimeout: () {
      return http.Response('Timeout', 408);
    });

    var data = returnResponse(response);
    print(data);

    return placesFromJson(data);
  } on SocketException {
    throw FetchDataException('');
  }
}

class _AmenidadesState extends State<Amenidades> {
  var id;
  gtData() async {
    try {
      var places = (await idso().catchError((e) {
        alerta5();
      }))!;

      final provider = Provider.of<EventProvider>(context, listen: false);
      for (int i = 0; i < places.data!.length; i++) {
        /* provider.addAmenidad(new Amenidad(id: places.data![i].idAmenidad)); */
      }
    } catch (e) {
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addAmenidad(
          new Amenidad(error: 'Su comunidad no tiene este servicio'));
    }
  }

  @override
  void initState() {
    super.initState();
    print(DateTime.now());
    gtData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
      create: (_) => EventProvider(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Amenidades ",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700),
          ),
          elevation: 6,
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Stack(
          children: [
            Container(
              height: size.height * .31,
              decoration: BoxDecoration(color: Colors.deepPurpleAccent),
            ),
            Container(
              padding:
                  EdgeInsets.only(top: size.width / 7, right: size.width / 20),
              alignment: Alignment.topRight,
              child: Icon(
                Icons.event,
                color: Colors.white,
                size: size.width / 3,
              ),
            ),
            SafeArea(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Disfruta las ventajas de tu comunidad',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  SizedBox(
                    width: size.width * .5,
                    child: Text(
                      'Enterate de la disponibilidad de tus areas recreativas o aparta con tiempo para tus eventos',
                      style: TextStyle(
                          color: Colors.white, fontSize: size.width / 20),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  EventDashboard()
                ],
              ),
            ))
          ],
        ),
      ),
    );
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
          Navigator.of(context)
            ..pop()
            ..pop();
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
            Text('Tiempo de espera largo, error 408, timeout serv')
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert);
  }
}
