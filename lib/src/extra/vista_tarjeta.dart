import 'package:adcom/json/jsonFinanzas.dart';
import 'package:adcom/src/extra/more_view_cuota.dart';

import 'package:adcom/src/models/event_provider.dart';
import 'package:adcom/src/pantallas/finanzas.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class VistaTarjeta extends StatefulWidget {
  VistaTarjeta({Key? key}) : super(key: key);

  @override
  _VistaTarjetaState createState() => _VistaTarjetaState();
}

class _VistaTarjetaState extends State<VistaTarjeta> {
  VoidCallback? _showPersBottomSheetCallBack;
  Accounts? cuentas;
  List<DatosCuenta> mylist = [];
  @override
  void initState() {
    super.initState();
    _showPersBottomSheetCallBack = _showPersBottomSheetCallBack;
    data();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        ultimaDeuda();
        estadodepago();
      });
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
        : size.width >= 880
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 225,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 6,
                          offset: Offset(0, 1))
                    ],
                    color: estadodepagoColor(),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 30),
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
                                    fontSize: 17),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                '${estadodepago()}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: 40,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => MoreViewCuota()));
                              },
                              child: Icon(Icons.add,
                                  size: 25, color: Colors.white),
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
                            '\$ ${ultimaDeuda()}',
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    width: 1.0, color: Colors.white)),
                          ),
                          //Text('|', style: TextStyle(color: Colors.white, fontSize: 15)),

                          OutlinedButton(
                            onPressed: () {
                              _showAlertDialog();
                            },
                            child: Text('Detalles',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    width: 1.0, color: Colors.white)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: 190,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 6,
                          offset: Offset(0, 1))
                    ],
                    color: estadodepagoColor(),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 20),
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
                                    builder: (_) => MoreViewCuota()));
                              },
                              child: Icon(Icons.add,
                                  size: 25, color: Colors.white),
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
                            '\$ ${ultimaDeuda()}',
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    width: 1.0, color: Colors.white)),
                          ),
                          //Text('|', style: TextStyle(color: Colors.white, fontSize: 15)),

                          OutlinedButton(
                            onPressed: () {
                              _showAlertDialog(size: size2);
                            },
                            child: Text('Detalles',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    width: 1.0, color: Colors.white)),
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
                    'Seleccione su método de pago',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mantenimiento',
                    style: TextStyle(
                      fontSize: size / 20,
                      fontWeight: FontWeight.w400,
                      textBaseline: TextBaseline.alphabetic,
                    )),
                Text('\$${ultimaDeuda2()}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      textBaseline: TextBaseline.alphabetic,
                    ))
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Atraso',
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      textBaseline: TextBaseline.alphabetic),
                ),
                Text('\$${atraso()}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      textBaseline: TextBaseline.alphabetic,
                    ))
              ],
            ),
            SizedBox(
              height: 15,
              child: Divider(
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      textBaseline: TextBaseline.alphabetic),
                ),
                totalApagars() == null
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
          pagoTardio: cuentas!.data![i].pagoTardio,
          montoTardio: cuentas!.data![i].montoPagoTardio));
    }
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

  estadodepago() {
    String? estado;
    for (int i = 0; i < mylist.length; i++) {
      if (mylist[i].pago == 1) {
        estado = 'No deudas';
      } else {
        if (DateTime.now().day <= mylist[i].fechaLimite!.day &&
                DateTime.now().month <= mylist[i].fechaLimite!.month &&
                DateTime.now().year <= mylist[i].fechaLimite!.year ||
            mylist[i].fechaLimite!.isAfter(DateTime.now())) {
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
    for (int i = 0; i < mylist.length; i++) {
      if (mylist[i].pago == 1) {
        estado = true;
      } else {
        if (DateTime.now().day <= mylist[i].fechaLimite!.day &&
            DateTime.now().month <= mylist[i].fechaLimite!.month &&
            DateTime.now().year <= mylist[i].fechaLimite!.year) {
          return estado = true;
        } else {
          return estado = false;
        }
      }
    }
    return estado;
  }

  estadodepagoColor() {
    Color? estado;
    for (int i = 0; i < mylist.length; i++) {
      if (mylist[i].pago == 1) {
        estado = Colors.lightGreen[700];
      } else {
        if (DateTime.now().day <= mylist[i].fechaLimite!.day &&
                DateTime.now().month <= mylist[i].fechaLimite!.month &&
                DateTime.now().year <= mylist[i].fechaLimite!.year ||
            mylist[i].fechaLimite!.isAfter(DateTime.now())) {
          return estado = Colors.amber[400];
        } else {
          return estado = Colors.red[700];
        }
      }
    }
    return estado == null ? estado = Colors.lightGreen[700] : estado;
  }

  atraso() {
    int? atraso = 0;

    for (int i = 0; i < mylist.length; i++) {
      if (mylist[i].pago == 1 && mylist[i].pagoTardio == 0) {
        return atraso = 0;
      } else {
        return atraso = int.parse(mylist[i].montoTardio!);
      }
    }
    return atraso;
  }

  totalApagars() {
    late int total;

    for (int i = 0; i < mylist.length; i++) {
      total = mylist[i].totalApagar!;
      if (mylist[i].pagoTardio == 1) {
        return total;
      } else {
        total = 0;
      }
    }
  }

  referenciaApagar() {
    String? ref;
    for (int i = 0; i < mylist.length; i++) {
      if (mylist[i].pago == 1 && mylist[i].pagoTardio == 0) {
      } else {
        setState(() {
          ref = mylist[i].referencia!;
        });

        return ref;
      }
    }
    return ref;
  }
}
