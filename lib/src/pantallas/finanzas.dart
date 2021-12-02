import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:adcom/json/jsonAdeudos.dart';
import 'package:adcom/json/jsonFinanzas.dart';
import 'package:adcom/src/extra/historico.dart';
import 'package:adcom/src/extra/vistaPagos.dart';
import 'package:adcom/src/methods/exeptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:adcom/src/extra/opciones_edoCuenta.dart';
import 'package:adcom/src/extra/servicios.dart';

import 'package:adcom/src/extra/vista_tarjeta.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glyphicon/glyphicon.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

class Finanzas extends StatefulWidget {
  final id;
  Finanzas({Key? key, this.id}) : super(key: key);

  @override
  _FinanzasState createState() => _FinanzasState();
}

/// llama a los adeudos basado en el modelo de datos [Accounts]
Future<Accounts?> getAdeudos() async {
  try {
    prefs = await SharedPreferences.getInstance();
    var id = prefs!.getInt('userId');
    print(id);
    final Uri url = Uri.parse(
        'http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-adeudos');
    final response = await http.post(url, body: {
      "params": json.encode({"usuarioId": id.toString()})
    }).timeout(Duration(seconds: 5), onTimeout: () {
      return http.Response('Error', 500);
    });

    var data = returnResponse(response);

    return accountsFromJson(data);
  } on SocketException {
    throw FetchDataException('');
  }
}

///Apartado de toda la seccion de finanzas o Mis Pagos
class _FinanzasState extends State<Finanzas> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
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
  bool hayRefPadre = false;
  String? ref;
  List<Users> users = [];
  String? userName;
  DatosUsuario? datosUsuario;
  List<DatosCuenta> refPadre = [];
  String? bandera;
  int _selectedIndex = 0;
  List<Deudas> deudas = [];
  List<Deudas> deudas2 = [];
  bool notiene = false;
  List<Deudas> deudasReverse = [];
  List<Deudas> deudasReverse2 = [];
  bool error = false;

  /// El init state inicializa funciones cuando abre el boton mis pagos
  @override
  void initState() {
    super.initState();

    /// no tocar, muestra la vista para pagar con tarjeta
    _showPersBottomSheetCallBack = _showPersBottomSheetCallBack;

    /// funcion que obtiene datos del service
    data();
    _scaffoldKey = GlobalKey();

    ///refresqueo cuando hay datos
  }

  @override
  void dispose() {
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /// apartado del barra de navegacion, son las vistas que se muestran cuando seleccionas
    List<Widget> bodies = [
      mainView(size),
      pagosRecientes(deudasReverse2, false, deudas2, size),
      pagosRecientes(deudasReverse, true, deudas, size)
    ];
    return Scaffold(
      appBar: _selectedIndex == 1
          ? null
          : AppBar(
              title: Text(
                'Mis Pagos',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700),
              ),
              elevation: 7,
              leading: BackButton(),
              backgroundColor: Colors.lightGreen[700],
            ),
      resizeToAvoidBottomInset: false,
      body: MisPagosView(size, bodies),
    );
  }

  Stack MisPagosView(Size size, List<Widget> bodies) {
    return Stack(
      children: [
        Container(
          height: size.height * .25,
          decoration: BoxDecoration(color: Colors.lightGreen[700]),
        ),
        Container(
          padding: EdgeInsets.only(top: size.height / 22),
          alignment: Alignment.topRight,
          child: Icon(
            Icons.show_chart_rounded,
            size: size.width / 2,
            color: Colors.white,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: RefreshIndicator(
              onRefresh: () {
                /// hace el refresh de la pagina completa y recarga lo servicios
                return Future.delayed(Duration(seconds: 1), () {
                  setState(() {
                    if (localList.isNotEmpty) {
                      localList.clear();
                      deudas.clear();
                      deudas2.clear();
                      data().catchError((e) {
                        alerta5();
                      });
                    } else {
                      data().catchError((e) {
                        alerta5();
                      });
                    }
                  });
                });
              },
              child: Stack(
                children: [
                  SizedBox(
                    height: size.width / 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Toma el control de tus gastos',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17),
                    ),
                  ),
                  SizedBox(
                    height: size.width / 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 55),
                    child: SizedBox(
                      width: size.width * .6,
                      child: Text(
                        'Mantente actualizado revisando tus estados de cuenta y adeudos pendientes.',
                        style: TextStyle(
                            color: Colors.white, fontSize: size.width / 20),
                      ),
                    ),
                  ),
                  Container(
                      child: localList.isEmpty
                          ? Center(
                              child: itsTrue == false
                                  ? Container(
                                      padding: const EdgeInsets.only(top: 90),
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
                          : Stack(
                              children: [
                                ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: size.width / 1.75),
                                      width: size.width / 1,
                                      child: CupertinoSlidingSegmentedControl(
                                        thumbColor: Colors.lightGreen,
                                        backgroundColor: Colors.grey[300]!,
                                        //padding: EdgeInsets.only(bottom: 16),
                                        children: vistaPagos,
                                        onValueChanged: (c) {
                                          setState(() {
                                            groupValue = c;
                                          });
                                        },
                                        groupValue: groupValue,
                                      ),
                                    ),
                                  ],
                                ),
                                bodies[groupValue]
                              ],
                            ))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  getNameUser() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        userName = prefs!.getString('user');
      });
    }
  }

  ///Se usa para atualizar el estado de la tarjeta
  refresh() {
    setState(() {
      var size = MediaQuery.of(context).size;
      if (mounted) {
        mainView(size);
      }
    });
  }

  /// esta funcion se usa para crear el pdf
  /// pasa el ultimo mes pagado,
  /// no retrona valor
  ultimoMes() async {
    int? mesPagado;
    double cuota;
    double monto;
    double tardio;
    String tipoPago;
    int folio;
    var fecha;
    print('aqui ultimo mes');
    print(' ${localList.length}');
    for (int i = 0; i < localList.length; i++) {
      cuota = double.parse(localList[i].montoCuota!);
      monto = double.parse(localList[i].montoPago!);
      tardio = double.parse(localList[i].montoTardio!);

      mesPagado = localList[i].fechaGenerada!.month;
      fecha = localList[i].fechaPago == null
          ? ''
          : '${localList[i].fechaPago!.day}/${localList[i].fechaPago!.month}/${localList[i].fechaPago!.year}';
      tipoPago =
          localList[i].formaDePago == null ? '' : localList[i].formaDePago!;
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
                cuota: cuota,
                concepto: 'Enero',
                monto: monto,
                referencia: localList[i].referencia!,
                fecha: fecha,
                deuda: tardio,
                folio: folio,
                tipoPago: tipoPago));
          });
          break;
        case 2:
          setState(() {
            users.add(new Users(
                cuota: cuota,
                concepto: 'Febrero',
                monto: monto,
                referencia: localList[i].referencia!,
                fecha: fecha,
                deuda: tardio,
                folio: folio,
                tipoPago: tipoPago));
          });
          break;
        case 3:
          setState(() {
            users.add(new Users(
                cuota: cuota,
                concepto: 'Marzo',
                monto: monto,
                fecha: fecha,
                referencia: localList[i].referencia!,
                deuda: tardio,
                folio: folio,
                tipoPago: tipoPago));
          });
          break;
        case 4:
          setState(() {
            users.add(new Users(
                cuota: cuota,
                concepto: 'Abril',
                monto: monto,
                fecha: fecha,
                referencia: localList[i].referencia!,
                deuda: tardio,
                folio: folio,
                tipoPago: tipoPago));
          });
          break;
        case 5:
          setState(() {
            users.add(new Users(
                cuota: cuota,
                concepto: 'Mayo',
                monto: monto,
                referencia: localList[i].referencia!,
                fecha: fecha,
                deuda: tardio,
                folio: folio,
                tipoPago: tipoPago));
          });
          break;

        case 6:
          setState(() {
            users.add(new Users(
                cuota: cuota,
                concepto: 'Junio',
                monto: monto,
                fecha: fecha,
                referencia: localList[i].referencia!,
                deuda: tardio,
                folio: folio,
                tipoPago: tipoPago));
          });
          break;
        case 7:
          setState(() {
            users.add(new Users(
                cuota: cuota,
                concepto: 'Julio',
                monto: monto,
                fecha: fecha,
                referencia: localList[i].referencia!,
                deuda: tardio,
                folio: folio,
                tipoPago: tipoPago));
          });
          break;
        case 8:
          setState(() {
            users.add(new Users(
                cuota: cuota,
                concepto: 'Agosto',
                monto: monto,
                fecha: fecha,
                referencia: localList[i].referencia!,
                deuda: tardio,
                folio: folio,
                tipoPago: tipoPago));
          });
          break;
        case 9:
          setState(() {
            users.add(new Users(
                cuota: cuota,
                concepto: 'Septiembre',
                monto: monto,
                fecha: fecha,
                referencia: localList[i].referencia!,
                deuda: tardio,
                folio: folio,
                tipoPago: tipoPago));
          });

          break;
        case 10:
          setState(() {
            users.add(new Users(
                cuota: cuota,
                concepto: 'Octubre',
                monto: monto,
                fecha: fecha,
                referencia: localList[i].referencia!,
                deuda: tardio,
                folio: folio,
                tipoPago: tipoPago));
          });
          break;
        case 11:
          setState(() {
            users.add(new Users(
                cuota: cuota,
                concepto: 'Noviembre',
                monto: monto,
                fecha: fecha,
                referencia: localList[i].referencia!,
                deuda: tardio,
                folio: folio,
                tipoPago: tipoPago));
          });
          break;
        case 12:
          setState(() {
            users.add(new Users(
                cuota: cuota,
                concepto: 'Diciembre',
                monto: monto,
                fecha: fecha,
                referencia: localList[i].referencia!,
                deuda: tardio,
                folio: folio,
                tipoPago: tipoPago));
          });
          break;
      }

      print(users[i].concepto);
    }
  }

  Future data() async {
    cuentas = await getAdeudos().catchError((e) {
      alerta5();
    });
    await getNameUser();
    await pagosAcreditados();

    prefs = await SharedPreferences.getInstance();
    if (cuentas!.data!.isNotEmpty) {
      if (mounted) {
        setState(() {
          bandera = cuentas!.bandera;
        });
      }

      for (int i = 0; i < cuentas!.data!.length; i++) {
        if (cuentas!.data![i].idConcepto == "PA        ") {
          setState(() {
            hayRefPadre = true;
          });

          refPadre.add(new DatosCuenta(
              pago: cuentas!.data![i].pago,
              referenciaP: cuentas!.data![i].referencaiP!,
              idConcepto: cuentas!.data![i].idConcepto!));
        } else {
          if (cuentas!.data![i].idConcepto == "ACCTEL    ") {
          } else {
            localList.add(new DatosCuenta(
                idComu: cuentas!.data![i].idComu,
                montoCuota: cuentas!.data![i].montoCuota,
                idAdeudo: cuentas!.data![i].idAdeudo,
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
                referenciaP: cuentas!.data![i].referencaiP));
          }
        }
      }

      if (hayRefPadre == true) {
        prefs!.setBool('PA', true);
      } else {
        prefs!.setBool('PA', false);
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
    await pagosPendientes();
    if (itsTrue == false) {
    } else {
      refresh();
    }
  }

  dynamic groupValue = 0;
  final Map<int, Widget> vistaPagos = const <int, Widget>{
    0: Text(
      'Mis Pagos',
      style: TextStyle(color: Colors.black),
    ),
    1: Text('Pagos', style: TextStyle(color: Colors.black)),
    2: Text('Pendientes', style: TextStyle(color: Colors.black))
  };

  /// Es la segunda pestaña de la tab bar
  /// usa como referencia localList obtenida de [data]
  /// y tambien la lista de users obtenida en la misma funcion
  /// userName y datosUsuarios se actualizan por estado en [data]
  ///  List<DatosCuenta> localList, List<Users> users, List<Deudas> parametros opcionales
  pagosRecientes(deudas, bool esPendiente, List<Deudas> dd, Size size) {
    print(users.length);
    return Container(
      child: dd.isEmpty
          ? esPendiente == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      'No hay pagos pendientes',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      'No cuenta con pagos acreditados',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
          : Container(
              padding: EdgeInsets.only(top: size.width / 1.5),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 2.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: deudas.length,
                  itemBuilder: (_, int index) {
                    return Container(
                        padding: EdgeInsets.all(12),
                        child: VistaPagos(
                          users: users[index],
                          deudas: deudas[index],
                          datosUsuario: datosUsuario,
                          userName: userName,
                          esPendiente: esPendiente,
                          deudasList: deudas,
                        ));
                  }),
            ),
    );
  }

  /// main view representa la vista a la tarjeta, donde salen los adeudos
  mainView(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.width / 1.5),
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          //vista tarejeta es la tarjeta en si
          VistaTarjeta(
            newList: localList,
            refP: refPadre,
            bandera: bandera,
          ),
        ],
      ),
    );
  }

  ///cumple la funcion de traer lo pagos pendientes
  ///dentro se añade en un arreglo propio [adeudos]
  pagosPendientes() async {
    await Deudas()
        .getDeudas(0)
        .then((value) => {
              if (value!.value == 1)
                {
                  if (value.data!.isNotEmpty)
                    {
                      for (int i = 0; i < value.data!.length; i++)
                        {
                          deudas.add(Deudas(
                              id: value.data![i].idComu,
                              idResidente: value.data![i].idResidente,
                              montoCuota: value.data![i].montoCuota,
                              montoPagoTardio: value.data![i].montoPagoTardio,
                              totalAdeudo: value.data![i].totadeudo,
                              idConcepto: value.data![i].idConcepto!.trimLeft(),
                              mes: value.data![i].mes,
                              referencia: value.data![i].referencia,
                              noTiene: false,
                              descripcion: value.data![i].formaPago,
                              folio: value.data![i].folio))
                        },
                      deudasReverse = deudas.reversed.toList()
                    }
                  else
                    {}
                }
              else
                {}
            })
        .catchError((e) {
      setState(() {
        error = true;
      });
    });
    ;
  }

  /// hace la funcion de traer los pagos acreditados
  /// dentro se añade en un arreglo propio [adeudos2]
  pagosAcreditados() async {
    await Deudas()
        .getDeudas(1)
        .then((value) => {
              if (value!.value == 1)
                {
                  if (value.data!.isNotEmpty)
                    {
                      for (int i = 0; i < value.data!.length; i++)
                        {
                          print('aqui12'),
                          deudas2.add(Deudas(
                              id: value.data![i].idComu,
                              idResidente: value.data![i].idResidente,
                              montoCuota: value.data![i].montoCuota,
                              montoPagoTardio: value.data![i].montoPagoTardio,
                              totalAdeudo: value.data![i].totadeudo,
                              idConcepto: value.data![i].idConcepto!.trimLeft(),
                              mes: value.data![i].mes,
                              referencia: value.data![i].referencia,
                              noTiene: false,
                              descripcion: value.data![i].formaPago,
                              folio: value.data![i].folio)),
                          deudasReverse2 = deudas2.reversed.toList()
                        }
                    }
                  else
                    {}
                }
            })
        .catchError((e) {
      setState(() {
        error = true;
      });
    });
  }

  alerta5() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'Si, continuar',
          style: TextStyle(color: Colors.red[900]),
        ));
    Widget backButton = TextButton(
        onPressed: () {
          Navigator.of(context)..pop()..pop();
        },
        child: Text(
          'Regresar',
          style: TextStyle(color: Colors.orange),
        ));
    AlertDialog alert = AlertDialog(
      actions: [backButton],
      title: Text(
        'Atención!',
        style: TextStyle(
          fontSize: 25,
        ),
      ),
      content: Container(
        width: 140,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atencion!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            Text('Ha sucedido un error inesperado, vuelva a intentar')
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
  }
}

/// Esta clase se usa para los datos en general de la cuenta o deuda que tenga el usuario
/// muestra todo el el get principal
/// checar la variable [localList] almacena todos estos valores en forma de lista
class DatosCuenta {
  int? idComu;
  int? idResidente;
  int? idAdeudo;
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
  String? referenciaP;
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
      this.idAdeudo,
      this.formaDePago,
      this.referenciaP});
}

/// esta clase se usa para la info del usuario y su fraccionamiento
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

/// esta clase se usa para los datos de pagos y pagos pendientes
class Deudas {
  String? id;
  String? idResidente;
  String? montoCuota;
  String? montoPagoTardio;
  String? totalAdeudo;
  String? idConcepto;
  String? mes;
  String? referencia;
  String? descripcion;
  bool? noTiene;
  String? folio;

  Deudas(
      {this.id,
      this.idConcepto,
      this.idResidente,
      this.montoCuota,
      this.montoPagoTardio,
      this.totalAdeudo,
      this.mes,
      this.noTiene,
      this.referencia,
      this.folio,
      this.descripcion});
  Future<AdeudosJ?> getDeudas(int i) async {
    try {
      prefs = await SharedPreferences.getInstance();
      var id = prefs!.getInt('userId');
      print('aqui es el getDeuda $id');
      final Uri url = Uri.parse(
          'http://187.189.53.8:8081/backend/web/index.php?r=adcom/deudas');
      final response = await http.post(url, body: {
        "params": json.encode({"idResidente": id.toString(), "pagoBandera": i})
      }).timeout(Duration(seconds: 1), onTimeout: () {
        return http.Response('Error', 500);
      });
      var data = returnResponse(response);

      return adeudosFromJson(data);
    } on SocketException catch (e) {
      throw FetchDataException('$e');
    }
  }
}
