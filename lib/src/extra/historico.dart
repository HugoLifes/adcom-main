import 'package:flutter/material.dart';
import 'package:glyphicon/glyphicon.dart';

class Historico extends StatefulWidget {
  Historico({Key? key}) : super(key: key);

  @override
  _HistoricoState createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  bool open1 = false;
  bool open2 = false;

  List<Historicoh> pagos = [
    new Historicoh(fecha: DateTime.now(), monto: '\$700.00', concepto: 'Mmto'),
    new Historicoh(fecha: DateTime.now(), monto: '\$700.00', concepto: 'PA'),
    new Historicoh(fecha: DateTime.now(), monto: '\$700.00', concepto: 'ACCS')
  ];
  List<Historicoh> pendientes = [
    new Historicoh(fecha: DateTime.now(), monto: '\$700.00', concepto: 'Mmto'),
    new Historicoh(fecha: DateTime.now(), monto: '\$700.00', concepto: 'Mmto'),
    new Historicoh(fecha: DateTime.now(), monto: '\$700.00', concepto: 'Mmto')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.lightGreen[700],
          ),
          backgroundColor: Colors.lightGreen[700],
          title: Text(
            'Historico',
            style: TextStyle(
              color: Colors.white,
              fontSize: 29,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(11.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    if (open1 == false) {
                      setState(() {
                        open1 = true;
                      });
                    } else {
                      setState(() {
                        open1 = false;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      open1 == true
                          ? Icon(Icons.arrow_drop_down)
                          : Icon(Icons.arrow_right),
                      Text(
                        'Pendientes',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  style: TextButton.styleFrom(primary: Colors.black),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: pagos.length,
                      itemBuilder: (_, int index) {
                        return Container();
                      }),
                ),
                TextButton(
                    onPressed: () {
                      if (open2 == false) {
                        setState(() {
                          open2 = true;
                        });
                      } else {
                        setState(() {
                          open2 = false;
                        });
                      }
                    },
                    style: TextButton.styleFrom(primary: Colors.black),
                    child: Row(
                      children: [
                        open2 == true
                            ? Icon(Icons.arrow_drop_down)
                            : Icon(Icons.arrow_right),
                        Text(
                          'Pagos',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    )),
                Expanded(
                  child: ListView.builder(
                      itemCount: pendientes.length,
                      itemBuilder: (_, int index) {
                        return Container();
                      }),
                )
              ],
            ),
          ),
        ));
  }
}

class Historicoh {
  DateTime? fecha;
  String? concepto;
  String? monto;

  Historicoh({this.concepto, this.fecha, this.monto});
}
