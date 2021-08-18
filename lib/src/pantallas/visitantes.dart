import 'package:adcom/src/methods/searchBar.dart';
import 'package:flutter/material.dart';

class Visitantes extends StatefulWidget {
  final id;
  Visitantes({Key? key, this.id}) : super(key: key);

  @override
  _VisitantesState createState() => _VisitantesState();
}

class _VisitantesState extends State<Visitantes> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          Container(
            height: size.height * .40,
            decoration: BoxDecoration(color: Colors.teal),
          ),
          Container(
            padding: EdgeInsets.only(top: 75),
            alignment: Alignment.topRight,
            child: Icon(
              Icons.accessibility_new,
              color: Colors.white,
              size: 175,
            ),
          ),
          SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Visitantes",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Mantente unido con tus seres queridos',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width * .6,
                  child: Text(
                    'Genera codigos de acceso para que familiares y amigos puedan acceder a tu localidad.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: size.width * .55,
                  child: SearchBar(),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
