import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoreViewCuota extends StatefulWidget {
  MoreViewCuota({Key? key}) : super(key: key);

  @override
  _MoreViewCuotaState createState() => _MoreViewCuotaState();
}

class _MoreViewCuotaState extends State<MoreViewCuota> {
  List deudas = [];
  @override
  void initState() {
    super.initState();
    listView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[700],
        title: Text('Últimos 3 cobros'),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: ListView.builder(
              itemCount: deudas.length,
              itemBuilder: (BuildContext ctx, int index) {
                return deudas[index];
              }),
        ),
      ),
    );
  }

  listView() {
    final deuda = Provider.of<EventProvider>(context, listen: false).deudas;

    for (int i = 0; i < deuda.length; i++) {
      if (i == 3) {
        return print('ya');
      } else {
        deudas.add(accountItems(
            "Cuota Mensual",
            "\$ ${deuda[i].montoCuota}",
            '${deuda[i].fechaLimite!.day}/0${deuda[i].fechaLimite!.month}/${deuda[i].fechaLimite!.year}',
            deuda[i].pago == 1 ? 'pagado' : 'debe'));
      }
    }
  }

  estadodepago() {
    String? estado;
    final deuda = Provider.of<EventProvider>(context, listen: false).deudas;
    for (int i = 0; i < deuda.length; i++) {
      if (deuda[i].pago == 1) {
        estado = 'No deudas';
      } else {
        if (DateTime.now().day <= deuda[i].fechaLimite!.day &&
            DateTime.now().month <= deuda[i].fechaLimite!.month &&
            DateTime.now().year <= deuda[i].fechaLimite!.year) {
          return estado = 'Pendiente';
        } else {
          return estado = 'Atrazado';
        }
      }
    }
    return estado;
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
