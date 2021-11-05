import 'package:adcom/json/jsonReporte.dart';
import 'package:adcom/json/jsonRespuesta.dart';
import 'package:adcom/src/methods/reporteDashboard.dart';
import 'package:adcom/src/methods/searchBar.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

class Reportes extends StatefulWidget {
  final id;
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Reportes({Key? key, this.id}) : super(key: key);

  @override
  _ReportesState createState() => _ReportesState();
}

class _ReportesState extends State<Reportes> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Reportes",
          style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700),
        ),
        elevation: 5,
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Container(
            height: size.height * .30,
            decoration: BoxDecoration(color: Colors.blue),
          ),
          Container(
            padding:
                EdgeInsets.only(top: size.width / 10, right: size.width / 40),
            alignment: Alignment.topRight,
            child: Icon(
              Icons.report,
              color: Colors.white,
              size: size.height * .18,
            ),
          ),
          SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2,
                ),
                SizedBox(height: 15),
                Text(
                  'Si vez algo inusual !Reportalo!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17),
                ),
                SizedBox(
                  height: 18,
                ),
                SizedBox(
                  width: size.width * .6,
                  child: Text(
                    'Reporta incidencias en tu comunidad para que todos estén al tanto de comportamientos inusuales o faltas a la comunidad.',
                    style: TextStyle(
                        color: Colors.white, fontSize: size.width / 18),
                  ),
                ),
                SizedBox(
                  height: size.width / 8,
                ),
                ReportesDashboard()
              ],
            ),
          ))
        ],
      ),
    );
  }
}
