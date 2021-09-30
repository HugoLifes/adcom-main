import 'package:adcom/src/pantallas/finanzas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetallesPago extends StatefulWidget {
  late List<DatosCuenta>? list = [];
  DetallesPago({Key? key, this.list}) : super(key: key);

  @override
  _DetallesPagoState createState() => _DetallesPagoState();
}

class _DetallesPagoState extends State<DetallesPago> {
  List<String> mesFormat = [];
  List<double> debt = [];

  @override
  void initState() {
    super.initState();
    sacarMesDeAtrazo();
    totalApagars();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de pago'),
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    'Cuotas pendietes',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(
              height: size.width / 19,
            ),
            mesesView(),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 180, top: 10),
                  child: Row(
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: size.width / 25,
                      ),
                      Text(
                        '\$ ${saldoDeudor()}MXN',
                        style: TextStyle(fontSize: 19),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  ListView mesesView() {
    return ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 3,
            color: Colors.grey[350],
          );
        },
        itemCount: mesFormat.length & debt.length,
        itemBuilder: (context, int index) {
          return Container(
            decoration: BoxDecoration(color: Color(0xFFF7F7F9)),
            padding: EdgeInsets.only(
                top: 10.0, bottom: 20.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Mantenimiento del mes',
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold)),
                    Text('Monto',
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(mesFormat[index],
                        style:
                            TextStyle(color: Colors.grey[800], fontSize: 14.0)),
                    Text('${debt[index]}',
                        style:
                            TextStyle(color: Colors.grey[800], fontSize: 14.0))
                  ],
                ),
              ],
            ),
          );
        });
  }

  sacarMesDeAtrazo() {
    DateTime? mesesAtrazo;

    for (int i = 0; i < widget.list!.length; i++) {
      if (widget.list![i].pago == 1) {
      } else {
        setState(() {
          mesesAtrazo = widget.list![i].fechaGenerada;
        });
        mesFormat
            .add((DateFormat('MMM').format(DateTime(0, mesesAtrazo!.month))));
        //print(DateFormat('MMM').format(DateTime(0, mesesAtrazo!.month)));
      }
    }
  }

  totalApagars() {
    late double total;
    double deuda;

    for (int i = 0; i < widget.list!.length; i++) {
      if (widget.list![i].montoCuota == null) {
        total = 0.0;
      } else {
        total = double.parse(widget.list![i].montoCuota!);
      }
      deuda = double.parse(widget.list![i].montoTardio!);

      if (widget.list![i].pago == 1) {
      } else {
        //si sigue en fecha
        if (widget.list![i].pagoTardio == 0) {
          if (DateTime.now().day <= widget.list![i].fechaLimite!.day &&
              DateTime.now().month <= widget.list![i].fechaLimite!.month &&
              DateTime.now().year <= widget.list![i].fechaLimite!.year) {
            //solo monto cuota
            debt.add(total);
          } else {
            //si no esta en fecha añadir deuda extra
            total = total + deuda;
            debt.add(total);
          }
        } else {
          total = total + deuda;
          debt.add(total);
        }
      }
    }
  }

  saldoDeudor() {
    double contador = 0.0;
    double deuda;
    double tardio;
    for (int i = 0; i < widget.list!.length; i++) {
      if (widget.list![i].montoCuota == null) {
        deuda = 0.0;
      } else {
        deuda = double.parse(widget.list![i].montoCuota!);
      }

      tardio = double.parse(widget.list![i].montoTardio!);
      if (widget.list![i].pago == 1) {
        contador;
      } else {
        if (widget.list![i].pagoTardio == 0) {
          if (DateTime.now().day <= widget.list![i].fechaLimite!.day &&
              DateTime.now().month <= widget.list![i].fechaLimite!.month &&
              DateTime.now().year <= widget.list![i].fechaLimite!.year) {
            setState(() {
              contador += deuda;
            });
          } else {
            setState(() {
              contador += deuda + tardio;
            });
          }
        } else {
          setState(() {
            contador += deuda + tardio;
          });
        }
      }
    }
    return contador;
  }
}
