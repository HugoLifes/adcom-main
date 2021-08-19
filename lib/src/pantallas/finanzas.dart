import 'dart:async';
import 'dart:convert';
import 'package:adcom/json/jsonFinanzas.dart';
import 'package:adcom/main.dart';
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
  var id = prefs!.getInt('idUser');

  final Uri url = Uri.parse(
      'http://187.189.53.8:8080/AdcomBackend/backend/web/index.php?r=adcom/get-adeudos');
  final response = await http.post(url, body: {
    "params": json.encode({"usuarioId": id})
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
  List<Widget> estado = [];
  VoidCallback? _showPersBottomSheetCallBack;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  data() async {
    cuentas = await getAdeudos();
    final provider = Provider.of<EventProvider>(context, listen: false);
    for (int i = 0; i < cuentas!.data!.length; i++) {
      provider.addDeudas(new DatosCuenta(
          idComu: cuentas!.data![i].idComu,
          idResidente: cuentas!.data![i].idComu,
          montoCuota: cuentas!.data![i].montoCuota!,
          fechaGenerada: cuentas!.data![i].fechaGeneracion!,
          fechaLimite: cuentas!.data![i].fechaLimite!,
          fechaPago: cuentas!.data![i].fechaPago,
          referencia: cuentas!.data![i].referencia,
          pago: cuentas!.data![i].pago!,
          totalApagar: cuentas!.data![i].totalApagar,
          pagoTardio: cuentas!.data![i].pagoTardio,
          montoTardio: cuentas!.data![i].montoPagoTardio));

      localList.add(new DatosCuenta(
          idComu: cuentas!.data![i].idComu,
          montoCuota: cuentas!.data![i].montoCuota,
          fechaGenerada: cuentas!.data![i].fechaGeneracion!,
          fechaLimite: cuentas!.data![i].fechaLimite!,
          fechaPago: cuentas!.data![i].fechaPago,
          pago: cuentas!.data![i].pago));
    }
    estado.add(EstadoCuenta());
    estado.add(VistaTarjeta());
  }

  @override
  void initState() {
    super.initState();
    _showPersBottomSheetCallBack = _showPersBottomSheetCallBack;
    data();
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51JAjdHAoDnRH9C3fzuzLNpJaSlrcUVBJhDzN6ACKV8jocJSLvDCoBa1d1oBTX46CfOpC8wCLQ76H0aDOTZCo3xtO00a3pBNqw1",
        merchantId: "Test",
        androidPayMode: 'test'));
    Future.delayed(Duration(seconds : 1 ), () => {refresh()});
  }

  refresh() {
    setState(() {
      mainView();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 7,
          backgroundColor: Colors.lightGreen[700],
        ),
        resizeToAvoidBottomInset: false,
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          header: WaterDropHeader(),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          footer: ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
            completeDuration: Duration(milliseconds: 500),
          ),
          child: size.width >= 880 ? Stack(
            children: [
              Container(
                height: size.height * .35,
                decoration: BoxDecoration(color: Colors.lightGreen[700]),
              ),
              Container(
                padding: EdgeInsets.only(top: 80),
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.show_chart_rounded,
                  size: 190,
                  color: Colors.white,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Mis Pagos',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: size.width >= 880 ? 25:20,
                      ),
                      Text(
                        'Toma el control de tus gastos',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: size.width >= 880? 35: 23,
                      ),
                      SizedBox(
                        width: size.width * .6,
                        child: Text(
                          'Mantente actualizado revisando tus estados de cuenta y adeudos pendientes.',
                          style: TextStyle(color: Colors.white, fontSize: 19),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: size.width >= 880 ? 45:25, left: size.width >=880?5:0, right: size.width >= 880? 5:0),
                          child: localList.isEmpty
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : mainView()
                              
                              )
                    ],
                  ),
                ),
              ),
            ],
          ): Stack(
            children: [
              Container(
                height: size.height * .35,
                decoration: BoxDecoration(color: Colors.lightGreen[700]),
              ),
              Container(
                padding: EdgeInsets.only(top: size.height * .10),
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.show_chart_rounded,
                  size: 155,
                  color: Colors.white,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    shrinkWrap: true,
                    children:[
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mis Pagos',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: size.width /19,
                        ),
                        Text(
                          'Toma el control de tus gastos',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17),
                        ),
                        SizedBox(
                          height: size.width/20,
                        ),
                        SizedBox(
                          width: size.width * .6,
                          child: Text(
                            'Mantente actualizado revisando tus estados de cuenta y adeudos pendientes.',
                            style: TextStyle(color: Colors.white, fontSize: size.width / 20),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: size.width /10, left: size.width >=880?5:0, right: size.width >= 880? 5:0),
                            child: localList.isEmpty
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : mainView()  )
                      ],
                    ),
                    ] 
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  mainView() {
    return ListView(
      shrinkWrap: true,
      children: [
        InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => RefView()));
              },
              child: VistaTarjeta()),
          SizedBox(
            height: 15,
          ),
          InkWell(
              /* onTap: () {
                                    HapticFeedback.mediumImpact();
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => OpcionesEdoCuenta()));
                                  }, */
              child: EstadoCuenta()),
      ],
      
    );
  }

  

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000), () {});
    // if failed,use refreshFailed()
    //getAdeudos();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000), () => {});
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    Finanzas();
    if (mounted) setState(() {});

    _refreshController.loadComplete();
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
          pago: cuentas!.data![i].pago!));
    }
  }

  @override
  void initState() {
    super.initState();
    data();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        saldoDeudor();
        cuantoDebe();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    return size.width >= 880 ? Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 6, offset: Offset(0, 1))
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
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
                      'Estado de cuenta',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Información Actualizada:'),
                        SizedBox(
                          width: size.width >= 880?100 : 50,
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
                    '¿Cuánto debo?',
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
                  child: Text('Cuotas de atraso',
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
                      '\$ ${saldoDeudor()} MXN',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    '${cuantoDebe()}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
    ): Container(
      width: MediaQuery.of(context).size.width,
      height: 170,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 6, offset: Offset(0, 1))
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 11, right: 11, top: 10, bottom: 20),
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
                        Text('Información Actualizada:', style: TextStyle(fontSize: size.width/28, fontWeight: FontWeight.bold),),
                        SizedBox(
                          width: size.width * .13,
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
                    '¿Cuánto debo?',
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
                  child: Text('Cuotas de atraso',
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
                      '\$${saldoDeudor()}MXN',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width/ 17),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    '${cuantoDebe()}',
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

  //te dice cuantos meses debe
  cuantoDebe() {
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
  }
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
