import 'package:adcom/src/methods/searchBar.dart';
import 'package:flutter/material.dart';

class Votaciones extends StatefulWidget {
  final id;
  Votaciones({Key? key, this.id}) : super(key: key);

  @override
  _VotacionesState createState() => _VotacionesState();
}

class _VotacionesState extends State<Votaciones> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(elevation: 0.0, backgroundColor: Colors.cyan),
      body: Stack(
        children: [
          Container(
            height: size.height * .40,
            decoration: BoxDecoration(color: Colors.cyan),
          ),
          Container(
            padding: EdgeInsets.only(top: 75),
            alignment: Alignment.topRight,
            child: Icon(
              Icons.book_rounded,
              size: 190,
              color: Colors.white,
            ),
          ),
          SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Votaciones",
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
                  'Coopera con tu comunidad',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width * .6,
                  child: Text(
                    'Toma accion en decisiones de tu comunidad o toma la iniciativa.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: size.width * .5,
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
