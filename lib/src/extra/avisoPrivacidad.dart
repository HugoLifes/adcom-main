import 'package:adcom/src/pantallas/loginPage.dart';
import 'package:flutter/material.dart';

class AvisoPrivacidad extends StatefulWidget {
  AvisoPrivacidad({Key? key}) : super(key: key);

  @override
  _AvisoPrivacidadState createState() => _AvisoPrivacidadState();
}

class _AvisoPrivacidadState extends State<AvisoPrivacidad> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Text(
            'Aviso de privacidad',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Text(
            AvisoDePrivacidad().title!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.justify,
          ),
        )
      ],
    ))));
  }
}
