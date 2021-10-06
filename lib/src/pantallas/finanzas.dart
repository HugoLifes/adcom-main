import 'dart:async';
import 'dart:convert';
import 'package:adcom/json/jsonFinanzas.dart';
import 'package:adcom/src/extra/opciones_edoCuenta.dart';
import 'package:adcom/src/extra/vista_tarjeta.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


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
  List<DatosCuenta> localList = [];
  int? idComu;
  var montoCuota;
  Timer? timer;
  VoidCallback? _showPersBottomSheetCallBack;
  bool itsTrue = true;
  String? mes;
  String? ref;
  List<Users> users = [];
  String? userName;
  DatosUsuario? datosUsuario;

  /// El init state inicializa funciones cuando abre el boton mis pagos
  @override
  void initState() {
    super.initState();

    /// no tocar, muestra la vista para pagar con tarjeta
    _showPersBottomSheetCallBack = _showPersBottomSheetCallBack;

    /// funcion que obtiene datos del service
    data();

    ///refresqueo cuando hay datos
    if (itsTrue == false) {
    } else {
      Future.delayed(Duration(seconds: 1), () => {refresh()});
    }
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

  SharedPreferences? prefs;
  getNameUser() async {
    prefs = await SharedPreferences.getInstance();
    if(mounted){
      setState(() {
      userName = prefs!.getString('user');
    });
    }
    
  }

  //Se usa para atualizar el estado de la tarjeta
  refresh() {
    setState(() {
      if (mounted) {
        mainView();
      }
    });
  }

  recargos() {
    for (int i = 0; i < localList.length; i++) {
      if (localList[i].pagoTardio == 1) {}
    }
  }

  /// esta funcion se usa para crear el pdf
  /// pasa el ultimo mes pagado,
  /// no retrona valor
  ultimoMes() async {
    int? mesPagado;
    double monto;
    double tardio;
    String tipoPago;
    int folio;
    var fecha;
    print(' ${localList.length}');
    for (int i = 0; i < localList.length; i++) {
      monto = double.parse(localList[i].montoPago!);
      tardio = double.parse(localList[i].montoTardio!);
      if (localList[i].pago == 1) {
        mesPagado = localList[i].fechaPago!.month;
        fecha =
            '${localList[i].fechaPago!.day}/${localList[i].fechaPago!.month}/${localList[i].fechaPago!.year}';
        tipoPago = localList[i].formaDePago!;
        folio = localList[i].folio!;

        if (localList[i].pagoTardio == 1) {
          setState(() {
            monto += tardio;
          });
        } else {
          setState(() {
            monto;
          });
        }

        print(fecha);

        switch (mesPagado) {
          case 1:
            setState(() {
              users.add(new Users(
                  concepto: 'Enero',
                  monto: monto,
                  referencia: int.parse(
                    localList[i].referencia!,
                  ),
                  fecha: fecha,
                  deuda: tardio,
                  folio: folio,
                  tipoPago: tipoPago));
            });
            break;
          case 2:
            setState(() {
              users.add(new Users(
                  concepto: 'Febrero',
                  monto: monto,
                  referencia: int.parse(
                    localList[i].referencia!,
                  ),
                  fecha: fecha,
                  deuda: tardio,
                  folio: folio,
                  tipoPago: tipoPago));
            });
            break;
          case 3:
            setState(() {
              users.add(new Users(
                  concepto: 'Marzo',
                  monto: monto,
                  fecha: fecha,
                  referencia: int.parse(
                    localList[i].referencia!,
                  ),
                  deuda: tardio,
                  folio: folio,
                  tipoPago: tipoPago));
            });
            break;
          case 4:
            setState(() {
              users.add(new Users(
                  concepto: 'Abril',
                  monto: monto,
                  fecha: fecha,
                  referencia: int.parse(
                    localList[i].referencia!,
                  ),
                  deuda: tardio,
                  folio: folio,
                  tipoPago: tipoPago));
            });
            break;
          case 5:
            setState(() {
              users.add(new Users(
                  concepto: 'Mayo',
                  monto: monto,
                  referencia: int.parse(
                    localList[i].referencia!,
                  ),
                  fecha: fecha,
                  deuda: tardio,
                  folio: folio,
                  tipoPago: tipoPago));
            });
            break;

          case 6:
            setState(() {
              users.add(new Users(
                  concepto: 'Junio',
                  monto: monto,
                  fecha: fecha,
                  referencia: int.parse(
                    localList[i].referencia!,
                  ),
                  deuda: tardio,
                  folio: folio,
                  tipoPago: tipoPago));
            });
            break;
          case 7:
            setState(() {
              users.add(new Users(
                  concepto: 'Julio',
                  monto: monto,
                  fecha: fecha,
                  referencia: int.parse(
                    localList[i].referencia!,
                  ),
                  deuda: tardio,
                  folio: folio,
                  tipoPago: tipoPago));
            });
            break;
          case 8:
            setState(() {
              users.add(new Users(
                  concepto: 'Agosto',
                  monto: monto,
                  fecha: fecha,
                  referencia: int.parse(
                    localList[i].referencia!,
                  ),
                  deuda: tardio,
                  folio: folio,
                  tipoPago: tipoPago));
            });
            break;
          case 9:
            setState(() {
              users.add(new Users(
                  concepto: 'Septiembre',
                  monto: monto,
                  fecha: fecha,
                  referencia: int.parse(
                    localList[i].referencia!,
                  ),
                  deuda: tardio,
                  folio: folio,
                  tipoPago: tipoPago));
            });

            break;
          case 10:
            setState(() {
              users.add(new Users(
                  concepto: 'Octubre',
                  monto: monto,
                  fecha: fecha,
                  referencia: int.parse(
                    localList[i].referencia!,
                  ),
                  deuda: tardio,
                  folio: folio,
                  tipoPago: tipoPago));
            });
            break;
          case 11:
            setState(() {
              users.add(new Users(
                  concepto: 'Noviembre',
                  monto: monto,
                  fecha: fecha,
                  referencia: int.parse(
                    localList[i].referencia!,
                  ),
                  deuda: tardio,
                  folio: folio,
                  tipoPago: tipoPago));
            });
            break;
          case 12:
            setState(() {
              users.add(new Users(
                  concepto: 'Diciembre',
                  monto: monto,
                  fecha: fecha,
                  referencia: int.parse(
                    localList[i].referencia!,
                  ),
                  deuda: tardio,
                  folio: folio,
                  tipoPago: tipoPago));
            });
            break;
        }

        print(users[i].concepto);
      } else {
        return;
      }
    }
  }

   data() async {
    cuentas = await getAdeudos();
    await getNameUser();
    prefs = await SharedPreferences.getInstance();
    if (cuentas!.data!.isNotEmpty) {
      for (int i = 0; i < cuentas!.data!.length; i++) {
        if (cuentas!.data![i].idConcepto == "PA        ") {
          
        } else {
          if (cuentas!.data![i].idConcepto == "ACCTEL    ") {
          } else {
            localList.add(new DatosCuenta(
                idComu: cuentas!.data![i].idComu,
                montoCuota: cuentas!.data![i].montoCuota,
                
                idConcepto: cuentas!.data![i].idConcepto,
                fechaGenerada: cuentas!.data![i].fechaGeneracion!,
                fechaLimite: cuentas!.data![i].fechaLimite == null
                    ? DateTime.now()
                    : cuentas!.data![i].fechaLimite,
                fechaPago: cuentas!.data![i].fechaPago,
                pago: cuentas!.data![i].pago!,
                montoPago: cuentas!.data![i].montoPago,
                totalApagar: cuentas!.data![i].totalApagar,
                referencia: cuentas!.data![i].referencia,
                pagoTardio: cuentas!.data![i].pagoTardio,
                montoTardio: cuentas!.data![i].montoPagoTardio,
                folio: cuentas!.data![i].folio!,
                formaDePago: cuentas!.data![i].formaPago,
                ));
          }
        }
      }

      

      setState(() {
        datosUsuario = DatosUsuario(
            noExt: cuentas!.data2!.noExterno,
            noInt: cuentas!.data2!.noInterior,
            calle: cuentas!.data2!.calle,
            comunidad: cuentas!.data2!.comunidad,
            cp: cuentas!.data2!.cp,
            tipoLote: cuentas!.data2!.tipoLote);
      });
    } else {
      setState(() {
        if (mounted) {
          itsTrue = false;
        }
      });
    }
    await ultimoMes();
  }

  mainView() {
    return Column(
      children: [
        VistaTarjeta(
          newList: localList,
        ),
        SizedBox(
          height: 15,
        ),
    /*     users.isEmpty
            ? SizedBox()
            : OpcionesEdoCuenta(
                newList: localList,
                users: users.length >= 2 ? users[users.length - 2] : users.last,
                userName: userName,
                datosUsuario: datosUsuario,
              ),
        SizedBox(
          height: 15,
        ),
        users.length >= 2
            ? OpcionesEdoCuenta(
                newList: localList,
                users: users.last,
                userName: userName,
                datosUsuario: datosUsuario,
              )
            : SizedBox() */
      ],
    );
  }
}

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
  String? formaDePago;
  int? folio;

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
      this.totalApagar,
      this.folio,
      this.formaDePago});
}

class DatosUsuario {
  String? noInt;
  String? noExt;
  String? tipoLote;
  String? cp;
  String? comunidad;
  String? calle;

  DatosUsuario(
      {this.noExt,
      this.calle,
      this.comunidad,
      this.cp,
      this.noInt,
      this.tipoLote});
}