import 'dart:async';
import 'dart:convert';
import 'package:adcom/json/jsonFinanzas.dart';
import 'package:adcom/src/extra/vista_tarjeta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  refresh() {
    setState(() {
      if (mounted) {
        mainView();
      }
    });
  }

  data() async {
    cuentas = await getAdeudos();

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
            ));
          }
        }
      }
    } else {
      setState(() {
        if (mounted) {
          itsTrue = false;
        }
      });
    }
  }

  mainView() {
    return InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
        },

        /// vista para la tarjeta
        child: VistaTarjeta(
          newList: localList,
        ));
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
