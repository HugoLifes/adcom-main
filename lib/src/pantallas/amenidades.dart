import 'dart:convert';

import 'package:adcom/json/jsonAmenidades.dart';
import 'package:adcom/src/methods/eventDashboard.dart';
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
  prefs!.setInt('id', id);
}

Future<Places?> idso() async {
  prefs = await SharedPreferences.getInstance();
  var id = prefs!.getInt('idCom');

  final Uri url = Uri.parse(
      'http://187.189.53.8/AdcomBackend/backend/web/index.php?r=adcom/get-amenidades');
  final response = await http.post(url, body: {
    "params": json.encode({"usuarioId": id})
  });
  if (response.statusCode == 200) {
    var data = response.body;
    print(data);

    return placesFromJson(data);
  } else {
    print('error');
  }
}

class _AmenidadesState extends State<Amenidades> {
  gtData() async {

    try{
    var places = (await idso())!;

    final provider = Provider.of<EventProvider>(context, listen: false);
    for (int i = 0; i < places.data!.length; i++) {
      provider.addAmenidad(new Amenidad(id: places.data![i].id));
    }
    }catch(e){
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addAmenidad(new Amenidad(error: 'Su comunidad no tiene este servicio'));
    }
  }

  @override
  void initState() {
    super.initState();
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
          elevation: 6,
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: size.width >= 880 ? Stack(
          children: [
            Container(
              height: size.height * .40,
              decoration: BoxDecoration(color: Colors.deepPurpleAccent),
            ),
            Container(
              padding: EdgeInsets.only(top: 95),
              alignment: Alignment.topRight,
              child: Icon(
                Icons.event,
                color: Colors.white,
                size: 170,
              ),
            ),
            SafeArea(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Amenidades",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Disfruta las ventajas de tu comunidad',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  SizedBox(
                    width: size.width * .5,
                    child: Text(
                      'Enterate de la disponibilidad de tus areas recreativas o aparta con tiempo para tus eventos',
                      style: TextStyle(color: Colors.white, fontSize: size.width >=880?19:17),
                    ),
                  ),
                  SizedBox(
                    height:20,
                  ),
                  EventDashboard()
                ],
              ),
            ))
          ],
        ): Stack(
          children: [
            Container(
              height: size.height * .40,
              decoration: BoxDecoration(color: Colors.deepPurpleAccent),
            ),
            Container(
              padding: EdgeInsets.only(top: 95),
              alignment: Alignment.topRight,
              child: Icon(
                Icons.event,
                color: Colors.white,
                size: 150,
              ),
            ),
            SafeArea(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Amenidades",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 15,
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
                      style: TextStyle(color: Colors.white, fontSize: size.width >=880?19:19),
                    ),
                  ),
                  SizedBox(
                    height:20,
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
