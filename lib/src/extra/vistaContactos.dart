import 'dart:ffi';

import 'package:adcom/src/methods/emailDashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class VistaContactos extends StatefulWidget {
  Items? contactos;
  VistaContactos({Key? key, this.contactos}) : super(key: key);

  @override
  _VistaContactosState createState() => _VistaContactosState();
}

class _VistaContactosState extends State<VistaContactos> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacto Directo'),
        backgroundColor: Colors.greenAccent[700],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
              width: 500,
              height: 150,
              decoration: BoxDecoration(color: Colors.greenAccent[700]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: size.width / 2,
                    child: Text(
                      '${widget.contactos!.title}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )),
          Container(
            padding: EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Calle:',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      '${widget.contactos!.calle!.trimRight()}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Numero:',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      '${widget.contactos!.numero!.trimRight()}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Interior:',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      '${widget.contactos!.interior!.trimRight()}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cp:',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text('${widget.contactos!.cp!.trimRight()}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Celular:',
                      style: TextStyle(fontSize: 25),
                    ),
                    InkWell(
                      onTap: () {
                        _makePhoneCall(
                            'tel:${widget.contactos!.telCel!.trimRight()}');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Icon(Icons.phone),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${widget.contactos!.telCel!.trimRight()}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Email:',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text('${widget.contactos!.email}',
                        style: TextStyle(fontSize: 16))
                  ],
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  Future<void> _makePhoneCall(String num) async {
    if (await canLaunch(num)) {
      await launch(num);
    } else {
      throw 'No esta disponible $num';
    }
  }
}
