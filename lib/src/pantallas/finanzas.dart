import 'dart:async';
import 'dart:convert';
import 'package:adcom/json/jsonFinanzas.dart';
import 'package:adcom/main.dart';
import 'package:adcom/src/extra/opciones_edoCuenta.dart';
import 'package:adcom/src/extra/referencia_view.dart';
import 'package:adcom/src/extra/vista_tarjeta.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';

SharedPreferences? prefs;

class Finanzas extends StatefulWidget {
  final id;
  Finanzas({Key? key, this.id}) : super(key: key);
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  _FinanzasState createState() => _FinanzasState();
}

dataOff3(id) async {
  await Finanzas.init();

  prefs!.setInt('u', id);
}

Future<Accounts?> getAdeudos() async {
  prefs = await SharedPreferences.getInstance();
  var id = prefs!.getInt('userId');
  print(id);
  final Uri url = Uri.parse(
      'http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-adeudos');
  final response = await http.post(url, body: {
    "params": json.encode({"usuarioId": id.toString()})
  });

  if (response.statusCode == 200) {
    var data = response.body;

    return accountsFromJson(data);
  }
}

class _FinanzasState extends State<Finanzas> {
  bool isdone = false;
  Accounts? cuentas;
  List<DatosCuenta> mylist = [];
  List<DatosCuenta>? mylist2 = [];
  List localList = [];
  int? idComu;
  var montoCuota;
  Timer? timer;
  VoidCallback? _showPersBottomSheetCallBack;
  bool itsTrue = true;

  data() async {
    cuentas = await getAdeudos();

    if (cuentas!.data!.isNotEmpty) {
      for (int i = 0; i < cuentas!.data!.length; i++) {
        localList.add(new DatosCuenta(
            idComu: cuentas!.data![i].idComu,
            montoCuota: cuentas!.data![i].montoCuota,
            fechaGenerada: cuentas!.data![i].fechaGeneracion!,
            fechaLimite: cuentas!.data![i].fechaLimite!,
            fechaPago: cuentas!.data![i].fechaPago,
            referencia: cuentas!.data![i].referencia,
            pago: cuentas!.data![i].pago));
      }
    } else {
      setState(() {
        if (mounted) {
          itsTrue = false;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _showPersBottomSheetCallBack = _showPersBottomSheetCallBack;
    data();
    if (itsTrue == false) {
    } else {
      Future.delayed(Duration(seconds: 1), () => {refresh()});
    }
  }

  refresh() {
    setState(() {
      if (mounted) {
        mainView();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Mis Pagos',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700),
          ),
          elevation: 7,
          backgroundColor: Colors.lightGreen[700],
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              height: size.height * .25,
              decoration: BoxDecoration(color: Colors.lightGreen[700]),
            ),
            Container(
              padding: EdgeInsets.only(top: size.height / 20),
              alignment: Alignment.topRight,
              child: Icon(
                Icons.show_chart_rounded,
                size: size.width / 2,
                color: Colors.white,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView(shrinkWrap: true, children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.width / 20,
                      ),
                      Text(
                        'Toma el control de tus gastos',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 17),
                      ),
                      SizedBox(
                        height: size.width / 20,
                      ),
                      SizedBox(
                        width: size.width * .6,
                        child: Text(
                          'Mantente actualizado revisando tus estados de cuenta y adeudos pendientes.',
                          style: TextStyle(
                              color: Colors.white, fontSize: size.width / 21),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                            top: size.width / 5,
                          ),
                          child: localList.isEmpty
                              ? Center(
                                  child: itsTrue == false
                                      ? Container(
                                          padding:
                                              const EdgeInsets.only(top: 90),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/magic.png',
                                                width: size.width / 1,
                                                height: 200,
                                              ),
                                              Text(
                                                'Lo sentimos, por el momento no cuenta con adeudos',
                                                style: TextStyle(
                                                  fontSize: size.width / 20,
                                                  color: Colors.lightGreen[700],
                                                ),
                                                textAlign: TextAlign.justify,
                                              )
                                            ],
                                          ))
                                      : CircularProgressIndicator(),
                                )
                              : mainView())
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ));
  }

  mainView() {
    return InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
        },
        child: VistaTarjeta());
  }

  referenciaApagar() {
    final deudas = Provider.of<EventProvider>(context, listen: false).deudas;

    String? ref;
    for (int i = 0; i < deudas.length; i++) {
      if (deudas[i].pago == 1) {
        //no debe
      } else {
        //si debe
        setState(() {
          ref = deudas[i].referencia!;
        });
      }
    }
    return ref;
  }
}

// ignore: must_be_immutable
class EstadoCuenta extends StatefulWidget {
  late dynamic? d;
  late int? m;
  late int? yy;

  EstadoCuenta({Key? key, this.d, this.m, this.yy}) : super(key: key);

  @override
  _EstadoCuentaState createState() => _EstadoCuentaState();
}

class _EstadoCuentaState extends State<EstadoCuenta> {
  Accounts? cuentas;

  List<DatosCuenta> mylist = [];
  data() async {
    cuentas = await getAdeudos();

    for (int i = 0; i < cuentas!.data!.length; i++) {
      mylist.add(new DatosCuenta(
          idComu: cuentas!.data![i].idComu,
          montoCuota: cuentas!.data![i].montoCuota,
          fechaGenerada: cuentas!.data![i].fechaGeneracion!,
          fechaLimite: cuentas!.data![i].fechaLimite!,
          fechaPago: cuentas!.data![i].fechaPago,
          referencia: cuentas!.data![i].referencia,
          pago: cuentas!.data![i].pago!));
    }
  }

  @override
  void initState() {
    super.initState();
    data();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        ultimaDeuda();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 175,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 6, offset: Offset(0, 1))
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 13, right: 13, top: 10, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado de cuenta',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Información Actualizada:',
                          style: TextStyle(
                              fontSize: size.width / 28,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: size.width * .19,
                        ),
                        Text(
                          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  child: Text(
                    'Ultimo mes',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                )),
                Text('|', style: TextStyle(color: Colors.black)),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                  },
                  child: Text('Fecha limite de pago',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black)),
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      '\$${ultimaDeuda()}MXN',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width / 17),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    '${fechadepago()}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
    );
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
            print('${total}');
            return debe = monto + total;
          }
        }
      }
    }
    return debe == 0.0 ? '0.0' : debe;
  }

  referenciaApagar() {
    String? ref;
    for (int i = 0; i < mylist.length; i++) {
      if (mylist[i].pago == 1 && mylist[i].pagoTardio == 0) {
        print('no debe');
      } else {
        setState(() {
          ref = mylist[i].referencia!;
        });
        return ref == null ? " " : ref;
      }
    }
    return ref == null ? " " : ref;
  }

  //te dice cuanto dinero debe
  saldoDeudor() {
    double contador = 0.0;
    double deuda;
    for (int i = 0; i < mylist.length; i++) {
      deuda = double.parse(mylist[i].montoCuota!);
      if (mylist[i].pago == 1) {
      } else {
        if (DateTime.now().day <= mylist[i].fechaLimite!.day &&
            DateTime.now().month <= mylist[i].fechaLimite!.month &&
            DateTime.now().year <= mylist[i].fechaLimite!.year) {
        } else {
          setState(() {
            contador += deuda;
          });
        }
      }
    }
    return contador;
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

  //te dice cuantos meses debe
  /* cuantoDebe() {
    int contador = 0;
    for (int i = 0; i < mylist.length; i++) {
      if (mylist[i].pago == 1) {
      } else {
        if (DateTime.now().day <= mylist[i].fechaLimite!.day &&
            DateTime.now().month <= mylist[i].fechaLimite!.month &&
            DateTime.now().year <= mylist[i].fechaLimite!.year) {
        } else {
          setState(() {
            contador++;
          });
        }
      }
    }
    return contador.toString();
  } */
}
// ignore: must_be_immutable

class DatosCuenta {
  int? idComu;
  int? idResidente;
  String? montoCuota;
  String? idConcepto;
  String? montoPago;
  int? idFormaPago;
  String? referencia;
  int? pagoTardio;
  String? montoTardio;
  DateTime? fechaLimite;
  DateTime? fechaGenerada;
  DateTime? fechaPago;
  int? pago;
  int? totalApagar;

  DatosCuenta(
      {this.idComu,
      this.fechaGenerada,
      this.fechaLimite,
      this.fechaPago,
      this.idResidente,
      this.montoCuota,
      this.idConcepto,
      this.montoPago,
      this.idFormaPago,
      this.montoTardio,
      this.pagoTardio,
      this.referencia,
      this.pago,
      this.totalApagar});
}
