import 'package:adcom/src/methods/searchBar.dart';
import 'package:flutter/material.dart';

class NetWorking extends StatefulWidget {
  final id;
  NetWorking({Key? key, this.id}) : super(key: key);

  @override
  _NetWorkingState createState() => _NetWorkingState();
}

class _NetWorkingState extends State<NetWorking> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          Container(
            height: size.height * .40,
            decoration: BoxDecoration(color: Colors.red),
          ),
          Container(
            padding: EdgeInsets.only(top: 75),
            alignment: Alignment.topRight,
            child: Icon(
              Icons.assistant,
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
                  Text(
                    "Networking",
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
                    '¿Ofreces algún servicio? Anunciate',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: size.width * .6,
                    child: Text(
                      'Si ofreces algún servicio, anunciate y haz que tu comunidad lo sepa.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: size.width * .55,
                    child: SearchBar(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
