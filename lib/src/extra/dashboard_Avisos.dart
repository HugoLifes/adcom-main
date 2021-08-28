import 'package:flutter/material.dart';

import 'package:glyphicon/glyphicon.dart';

class AvisosDashboard extends StatefulWidget {
  AvisosDashboard({Key? key}) : super(key: key);

  @override
  _AvisosDashboardState createState() => _AvisosDashboardState();
}

class _AvisosDashboardState extends State<AvisosDashboard> {
  List<Avisos> list = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFF455A64).withOpacity(0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                Container(
                  height: 51,
                  width: size.width / 9,
                  decoration: BoxDecoration(
                      color: Colors.grey[300], shape: BoxShape.circle),
                  child: Image.asset('assets/images/logo.png'),
                ),
                SizedBox(
                  width: size.width / 45,
                ),
                Text(
                  'Administrador',
                  style: (TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                )
              ],
            ),
          ),
          Divider(
            color: Color(0xFF455A64).withOpacity(0.3),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Text(
                  'Comunicado! aviso a los residentes que esta semana se cobrara la reparacion del acueducto que se vera reflejadon en sus aplicaciones si tienen dudas pedir detalles a los administradores muchas gracias!',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        'Archivo.txt',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(Glyphicon.download)
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: Color(0xFF455A64).withOpacity(0.3),
          ),
          Container(
              padding: EdgeInsets.only(left: 18),
              child: Row(
                children: [
                  Icon(Glyphicon.heart),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text('Likes 20'))
                ],
              )),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  viewAvisos() {
    return Flexible(
        child: GridView.builder(
            padding: EdgeInsets.only(),
            itemCount: list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3.9,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemBuilder: (_, int data) {
              return Container();
            }));
  }
}

class Avisos {}
