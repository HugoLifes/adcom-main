import 'package:adcom/json/jsonFinanzas.dart';
import 'package:adcom/src/extra/detalles_pago.dart';
import 'package:adcom/src/extra/more_view_cuota.dart';
import 'package:adcom/src/extra/referencia_view.dart';

import 'package:adcom/src/models/event_provider.dart';
import 'package:adcom/src/pantallas/finanzas.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class VistaTarjeta extends StatefulWidget {
  List<DatosCuenta>? newList = [];
  VistaTarjeta({Key? key, this.newList}) : super(key: key);

  @override
  _VistaTarjetaState createState() => _VistaTarjetaState();
}

class _VistaTarjetaState extends State<VistaTarjeta> {
  VoidCallback? _showPersBottomSheetCallBack;
  Accounts? cuentas;
  List<DatosCuenta> mylist = [];
  List<String> mesFormat = [];

  @override
  void initState() {
    super.initState();
    _showPersBottomSheetCallBack = _showPersBottomSheetCallBack;
    data();

    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          ultimaDeuda();
          estadodepago();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var size2 = MediaQuery.of(context).size.width;

    return mylist.isEmpty
        ? SizedBox()
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 220,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 6, offset: Offset(0, 1))
                ],
                color: estadodepagoColor(),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 13, right: 13, top: 13, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monto de cuota',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            '${estadodepago()}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 30,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => RefView(
                                      list: mylist,
                                    )));
                          },
                          child: Icon(Icons.add, size: 25, color: Colors.white),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  width: 1.0, color: Colors.transparent)),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '\$ ${saldoDeudor()}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        mylist.isEmpty
                            ? 'Pagar antes del día: '
                            : 'Pagar antes del día: ${fechadepago()}',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _showModalSheet();
                        },
                        child: Text(
                          'Pagar Ahora',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 1.0, color: Colors.white)),
                      ),
                      //Text('|', style: TextStyle(color: Colors.white, fontSize: 15)),

                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => DetallesPago(
                                    list: mylist,
                                  )));
                        },
                        child: Text('Detalles',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 1.0, color: Colors.white)),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  }

  void _showModalSheet() {
    showModalBottomSheet(
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (builder) {
          return new Container(
            height: 250,
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Seleccioné su método de pago',
                    style: TextStyle(fontSize: 21),
                  ),
                  SizedBox(
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.lightGreen[700],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/debit-card.gif',
                              height: 40,
                              width: 50,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Pago con tarjeta',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 110),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/mastercard.png',
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'assets/images/visa.png',
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'assets/images/google-wallet.png',
                                height: 20,
                                width: 20,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _showAlertDialog({size}) async {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context)..pop();
        },
        child: Text('OK', style: TextStyle(color: Colors.black)));

    AlertDialog alert = AlertDialog(
      title: Text(
        'Detalles de pago',
        style: TextStyle(fontSize: 25),
      ),
      content: Container(
        width: size / 20,
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('Cuota',
                    style: TextStyle(
                      fontSize: size / 20,
                      fontWeight: FontWeight.w400,
                      textBaseline: TextBaseline.alphabetic,
                    )),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            /*  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [Text('${mesesDeAtraso()}')],
                )
              ],
            ), */
            SizedBox(
              height: 15,
              child: Divider(
                color: Colors.black,
              ),
            ),
            Column(
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      textBaseline: TextBaseline.alphabetic),
                ),
                saldoDeudor() == null
                    ? Text('\$0.0',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          textBaseline: TextBaseline.alphabetic,
                        ))
                    : Text('\$${totalApagars()}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          textBaseline: TextBaseline.alphabetic,
                        ))
              ],
            ),
          ],
        ),
      ),
      actions: [okButton],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  data() async {
    cuentas = await getAdeudos();

    for (int i = 0; i < cuentas!.data!.length; i++) {
      mylist.add(new DatosCuenta(
          idComu: cuentas!.data![i].idComu,
          montoCuota: cuentas!.data![i].montoCuota,
          fechaGenerada: cuentas!.data![i].fechaGeneracion!,
          fechaLimite: cuentas!.data![i].fechaLimite!,
          fechaPago: cuentas!.data![i].fechaPago,
          pago: cuentas!.data![i].pago!,
          totalApagar: cuentas!.data![i].totalApagar,
          referencia: cuentas!.data![i].referencia,
          pagoTardio: cuentas!.data![i].pagoTardio,
          montoTardio: cuentas!.data![i].montoPagoTardio));
    }
  }

  mesesDeAtraso() {
    DateTime? mesesAtrazo;

    for (int i = 0; i < mylist.length; i++) {
      if (mylist[i].pago == 1) {
      } else {
        setState(() {
          mesesAtrazo = mylist[i].fechaGenerada;
          mesFormat
              .add((DateFormat('MMM').format(DateTime(0, mesesAtrazo!.month))));
        });

        print(DateFormat('MMM').format(DateTime(0, mesesAtrazo!.month)));
      }
    }
    return DateFormat('MMM').format(DateTime(0, mesesAtrazo!.month));
  }

  ultimaDeuda() {
    double debe = 0.0;
    double? monto;
    int? total;
    for (int i = 0; i < mylist.length; i++) {
      monto = double.parse(mylist[i].montoCuota!);
      if (mylist[i].pago == 1 && mylist[i].pagoTardio == 0) {
      } else {
        if (DateTime.now().day <= mylist[i].fechaLimite!.day &&
            DateTime.now().month <= mylist[i].fechaLimite!.month &&
            DateTime.now().year <= mylist[i].fechaLimite!.year) {
          return debe = monto;
        } else {
          if (mylist[i].pagoTardio == 0 || mylist[i].pagoTardio == null) {
            return debe = monto;
          } else {
            total = int.parse(mylist[i].montoTardio!);
            return debe = monto + total;
          }
        }
      }
    }
    return debe == 0.0 ? '0.0' : debe;
  }

  ultimaDeuda2() {
    double debe = 0.0;
    double? monto;

    for (int i = 0; i < mylist.length; i++) {
      monto = double.parse(mylist[i].montoCuota!);
      if (mylist[i].pago == 1 && mylist[i].pagoTardio == 0) {
      } else {
        if (DateTime.now().day <= mylist[i].fechaLimite!.day &&
            DateTime.now().month <= mylist[i].fechaLimite!.month &&
            DateTime.now().year <= mylist[i].fechaLimite!.year) {
          return debe = monto;
        } else {
          if (mylist[i].pagoTardio == 0) {
            return debe = monto;
          } else {
            return debe = monto;
          }
        }
      }
    }
    return debe == 0.0 ? '0.0' : debe;
  }

  fechadepago() {
    int? dia;
    int? mes;
    int? year;
    for (int i = 0; i < mylist.length; i++) {
      if (mylist[i].pago == 1) {
        print('no debe');
      } else {
        setState(() {
          dia = mylist[i].fechaLimite!.day;
          mes = mylist[i].fechaLimite!.month;
          year = mylist[i].fechaLimite!.year;
        });
        return dia == null ? '' : '$dia/$mes/$year';
      }
    }

    return dia == null ? '' : '$dia/$mes/$year';
  }

  saldoDeudor() {
    double contador = 0.0;
    double deuda;
    double tardio;
    for (int i = 0; i < widget.newList!.length; i++) {
      deuda = double.parse(widget.newList![i].montoCuota!);
      tardio = double.parse(widget.newList![i].montoTardio!);
      if (widget.newList![i].pago == 1) {
        contador;
      } else {
        if (widget.newList![i].pagoTardio == 0) {
          if (DateTime.now().day <= widget.newList![i].fechaLimite!.day &&
              DateTime.now().month <= widget.newList![i].fechaLimite!.month &&
              DateTime.now().year <= widget.newList![i].fechaLimite!.year) {
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

  estadodepago() {
    String? estado;
    for (int i = 0; i < widget.newList!.length; i++) {
      if (widget.newList![i].pago == 1) {
        estado = 'No deudas';
      } else {
        if (DateTime.now().day <= widget.newList![i].fechaLimite!.day &&
                DateTime.now().month <= widget.newList![i].fechaLimite!.month &&
                DateTime.now().year <= widget.newList![i].fechaLimite!.year ||
            widget.newList![i].fechaLimite!.isAfter(DateTime.now())) {
          setState(() {
            estado = 'Pendiente';
          });
          return estado;
        } else {
          setState(() {
            estado = 'Atrasado';
          });
          return estado;
        }
      }
    }
    return estado == null ? '' : estado;
  }

  cuotaExtra() {
    bool? estado;
    for (int i = 0; i < widget.newList!.length; i++) {
      if (widget.newList![i].pago == 1) {
        estado = true;
      } else {
        if (DateTime.now().day <= widget.newList![i].fechaLimite!.day &&
            DateTime.now().month <= widget.newList![i].fechaLimite!.month &&
            DateTime.now().year <= widget.newList![i].fechaLimite!.year) {
          return estado = true;
        } else {
          return estado = false;
        }
      }
    }
    return estado;
  }

  ///ok
  estadodepagoColor() {
    Color? estado;
    for (int i = 0; i < widget.newList!.length; i++) {
      if (widget.newList![i].pago == 1) {
        estado = Colors.lightGreen[700];
      } else {
        if (DateTime.now().day <= widget.newList![i].fechaLimite!.day &&
                DateTime.now().month <= widget.newList![i].fechaLimite!.month &&
                DateTime.now().year <= widget.newList![i].fechaLimite!.year ||
            widget.newList![i].fechaLimite!.isAfter(DateTime.now())) {
          return estado = Colors.amber[400];
        } else {
          return estado = Colors.red[700];
        }
      }
    }
    return estado == null ? estado = Colors.lightGreen[700] : estado;
  }

  ///ok
  atraso() {
    int? atraso = 0;

    for (int i = 0; i < widget.newList!.length; i++) {
      if (widget.newList![i].pago == 1 && widget.newList![i].pagoTardio == 0) {
        return atraso = 0;
      } else {
        return atraso = int.parse(widget.newList![i].montoTardio!);
      }
    }
    return atraso;
  }

  ///ok
  totalApagars() {
    late int total;

    for (int i = 0; i < widget.newList!.length; i++) {
      total = widget.newList![i].totalApagar!;
      if (widget.newList![i].pagoTardio == 1) {
        return total;
      } else {
        total = 0;
      }
    }
  }

  ///ok
  referenciaApagar() {
    String? ref;
    for (int i = 0; i < widget.newList!.length; i++) {
      if (widget.newList![i].pago == 1 && widget.newList![i].pagoTardio == 0) {
      } else {
        setState(() {
          ref = widget.newList![i].referencia!;
        });

        return ref;
      }
    }
    return ref;
  }
}
