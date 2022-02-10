import 'dart:convert';
import 'dart:io';

import 'package:adcom/json/jsonAmenidades.dart';
import 'package:adcom/src/methods/eventDashboard.dart';
import 'package:adcom/src/methods/exeptions.dart';
import 'package:adcom/src/methods/searchBar.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/material.dart';
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
        'http://www.adcom.mx:8081/backend/web/index.php?r=adcom/get-amenidades');
    final response = await http.post(url, body: {
      "params": json.encode({"usuarioId": id})
    }).timeout(Duration(), onTimeout: () {
      return http.Response('Timeout', 408);
    });
    var data = returnResponse(response);
    print(data);

    return placesFromJson(data);
  } on SocketException {
    throw FetchDataException('Error de conexion');
  }
}

class _AmenidadesState extends State<Amenidades> {
  gtData() async {
    try {
      var places = (await idso())!;

      final provider = Provider.of<EventProvider>(context, listen: false);
      for (int i = 0; i < places.data!.length; i++) {
        // provider.addAmenidad(new Amenidad(id: places.data![i].idAmenidad));
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
    gtData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
      create: (_) => EventProvider(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Amenidades', style:TextStyle(fontSize: 25 )),
          elevation: 6,
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Stack(
          children: [
            Container(
              height: size.height * .28,
              decoration: BoxDecoration(color: Colors.deepPurpleAccent),
            ),
            Container(
              padding: EdgeInsets.only(top: 90, right: 20),
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
                    height: 15,
                  ),
                  Text(
                    'Disfruta las ventajas de tu comunidad',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: size.width * .5,
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                      'Enterate de la disponibilidad de tus areas recreativas o aparta con tiempo para tus eventos',
                      style: TextStyle(
                          color: Colors.white, fontSize: size.width / 20),
                    ),
                    ),
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
}
