import 'package:flutter/material.dart';

class MoreViewCuenta extends StatefulWidget {
  MoreViewCuenta({Key? key}) : super(key: key);

  @override
  _MoreViewCuentaState createState() => _MoreViewCuentaState();
}

class _MoreViewCuentaState extends State<MoreViewCuenta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Estado de cuenta',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            children: [
              accountItems(
                "En proceso",
                "\$ 850 MXN",
                '05/27/1935',
                'pagado',
              ),
              accountItems(
                  "Aceptado", "\$ 1,500 MXN", 'REF:012549856', 'REF:012549856',
                  oddColour: Color(0xFFF7F7F9)),
              accountItems(
                  "Aceptado", "\$ 2,000 MXN", '05/27/ 2 D.C', 'REF:012549856'),
              accountItems(
                  "Aceptado", "\$ 2,000 MXN", '05/27/ 2 D.C', 'REF:012549856',
                  oddColour: Color(0xFFF7F7F9)),
            ],
          ),
        ),
      ),
    );
  }

  accountItems(String item, String charge, String dateString, String type,
          {Color oddColour = Colors.white}) =>
      Container(
        decoration: BoxDecoration(color: oddColour),
        padding:
            EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(item, style: TextStyle(fontSize: 16.0)),
                Text(charge, style: TextStyle(fontSize: 16.0))
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(dateString,
                    style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                Text(type, style: TextStyle(color: Colors.grey, fontSize: 14.0))
              ],
            ),
          ],
        ),
      );
}
