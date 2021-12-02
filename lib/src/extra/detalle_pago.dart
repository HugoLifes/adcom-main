import 'dart:convert';

import 'package:adcom/src/pantallas/finanzas.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

SharedPreferences? prefs;

// ignore: must_be_immutable
class DetallesPago extends StatefulWidget {
  late List<DatosCuenta>? list = [];
  late List<DatosCuenta>? refp = [];
  bool? hayRefPadre;
  DetallesPago({Key? key, this.list, this.refp}) : super(key: key);

  @override
  _DetallesPagoState createState() => _DetallesPagoState();
}

class _DetallesPagoState extends State<DetallesPago> {
  List<String> mesFormat = [];
  List<double> debt = [];
  bool checked = false;
  List<dynamic> check = [];
  double contador = 0.0;
  double contadorTotal = 0.0;
  bool checkedAll = false;
  int? idCom;
  int? userId;
  List<int> idAdeudos = [];
  bool pa = false;
  List<String> conceptos = [];
  bool usarSaldo = false;
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');
  @override
  void initState() {
    super.initState();
    sacarMesDeAtrazo();
    totalApagars();
    obtainData();
    sacarConcepto();
  }

  obtainData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      idCom = prefs!.getInt('idCom');
      userId = prefs!.getInt('userId');
      pa = prefs!.getBool('PA')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var size2 = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de pago'),
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: size.height * .16,
              alignment: Alignment.center,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.lightGreen[700],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 10, offset: Offset(1, 0))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: SizedBox(
                      width: size.width / 2,
                      height: 100,
                      child: Text(
                        'Elije lo que decidas pagar y genera tu referencia maestra.',
                        style: TextStyle(
                            fontSize: size.height / 40,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: size.width / 9),
                    child: Icon(Glyphicon.check2_square,
                        size: size.width / 6, color: Colors.white),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            Text(
              'Elija su pago',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                child: CheckboxListTile(
                  tileColor: Colors.lightGreen[300],
                  value: checkedAll,
                  title: Text(
                    'Pago anual ó pago restante ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onChanged: (v) {
                    if (pa == true) {
                    } else {
                      if (v == true) {
                        setState(() {
                          checkedAll = v!;
                        });
                      } else {
                        setState(() {
                          contadorTotal = 0.0;
                          setState(() {
                            checkedAll = v!;
                          });
                        });
                      }
                      pagarTodo();
                      if (contadorTotal != 0.0) {
                        showButton();
                      }
                    }
                  },
                  controlAffinity: ListTileControlAffinity.platform,
                  activeColor: Colors.lightGreen[700],
                  checkColor: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: Text('Pago individual',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
            Divider(
              color: Colors.grey,
            ),
            mesesView(size2),
            Divider(
              color: Colors.grey,
            ),
            /*  Container(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Checkbox(
                      activeColor: Colors.lightGreen[700],
                      value: usarSaldo,
                      onChanged: (v) {
                        setState(() {
                          usarSaldo = v!;
                        });
                      }),
                  Text(
                    '¿Usar saldo a favor?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: size.width / 23,
                  ),
                  usarSaldo == true
                      ? Text('Saldo',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold))
                      : Text(''),
                  SizedBox(
                    width: size.width / 26,
                  ),
                  usarSaldo == true ? Text('\$ 200 MXN') : Text('')
                ],
              ),
            ) */
            pa == false
                ? Row(
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 190, top: 0),
                          child: Row(
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: size.width / 26,
                              ),
                              checkedAll == true
                                  ? Text(
                                      '${numberFormat.format(contadorTotal)} MXN',
                                      style: TextStyle(fontSize: 19))
                                  : Text(
                                      ///contador
                                      '\$ ${numberFormat.format(contador)} MXN',
                                      style: TextStyle(fontSize: 19),
                                    ),
                              SizedBox(
                                height: size.height / 20,
                              )
                            ],
                          ))
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: size.width / 1.5,
                          child: Text(
                            'Si ya tiene una referencia no podra generar otra, hasta que venza o realice el pago.',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.justify,
                          )),
                      SizedBox(
                        height: size.height / 10,
                      )
                    ],
                  ),
            showButton(),
            payButton()
          ],
        ),
      ),
    );
  }

  Future sendingData() async {
    await obtainData();
    try {
      Dio dio = Dio();
      print('$checkedAll');
      var formdata2 = FormData.fromMap({
        'params': json.encode({
          'esAnual': checkedAll,
          'idCom': idCom,
          'idResidente': userId,
          'idAdeudos': idAdeudos.toList()
        }),
      });

      Response response = await dio.post(
          'http://187.189.53.8:8080/AdcomBackend/backend/web/index.php?r=adcom/generar-referencia-maestra',
          data: formdata2, onSendProgress: (received, total) {
        if (total != 1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      });

      if (response.statusCode == 200) {
        print('aqui $response');
      }
    } on DioError catch (e) {
      if (e.response!.data == true) {
        print('aqui1:${e.response!.data.toString()}');
        Fluttertoast.showToast(
            msg: "Error al generar la referencia",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        return;
      } else {
        print('aqui2:${e.response!.data.toString()}');
        Fluttertoast.showToast(
            msg: "Error al generar la referencia",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
    }
  }

  showButton() {
    return (checked || checkedAll) == false
        ? Text('')
        : Container(
            padding: EdgeInsets.only(bottom: 25, left: 10, right: 10),
            child: GradientButton(
                child: Text('Generar referencia de pago'),
                callback: () {
                  if (pa == true) {
                    alerta2();
                  } else {
                    sendingData().then((value) => alerta());
                  }
                },
                gradient: LinearGradient(colors: [
                  Colors.lightGreen[500]!,
                  Colors.lightGreen[600]!,
                  Colors.lightGreen[700]!
                ]),
                elevation: 5.0,
                increaseHeightBy: 28,
                increaseWidthBy: double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          );
  }

  payButton() {
    return (checked || checkedAll) == false
        ? Text('')
        : Container(
            padding: EdgeInsets.only(bottom: 25, left: 10, right: 10),
            child: GradientButton(
                child: Text('Pagar ahora'),
                callback: () {
                  Fluttertoast.showToast(
                      msg: "Proximamente",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 17.0);
                },
                gradient: LinearGradient(colors: [
                  Colors.lightGreen[500]!,
                  Colors.lightGreen[600]!,
                  Colors.lightGreen[700]!
                ]),
                elevation: 5.0,
                increaseHeightBy: 28,
                increaseWidthBy: double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          );
  }

  /// Funcion que se utiliza para pagar todo
  pagarTodo() {
    double? cuota;
    double? cuotaDeudora;
    int? meses;
    double deuda;
    bool flag = false;
    bool pagoPendiente = false;
    double pagoP = 0.0;

    ///el checked all se obtiene en el check de pagar todo
    if (checkedAll == true) {
      ///
      for (int i = 0; i < widget.list!.length; i++) {
        /// se saca la cuota
        meses = widget.list![i].fechaGenerada!.month;
        cuota = double.parse(widget.list![i].montoCuota!);

        /// la deuda que se cobra
        deuda = double.parse(widget.list![i].montoTardio!);

        ///Sentencia que realiza la suma si existen pagos pendientes
        ///apesar de los meses que faltan para pagar el año
        ///
        if (widget.list![i].pago == 0) {
          if (widget.list![i].pagoTardio == 1) {
            setState(() {
              pagoPendiente = true;
            });
            pagoP += cuota + deuda;
            print('aqui $pagoP');
          } else {
            print('aqui123');
            setState(() {
              pagoPendiente = true;
            });
            pagoP += cuota;
            print(pagoP);
          }

          cuotaDeudora = cuota;
        }
      }

      /// asigno el mes en numero
      print(meses);

      ///despues de sumar los meses, adeudar los pagos pendientes
      ///Recorro el me hasta el mes 12
      /// ejem  mes = 8 entonces lo que falte para llegar a 12
      for (meses; meses! < 12; meses++) {
        contadorTotal += cuota!;

        print('contador: $contadorTotal');
      }

      if (pagoPendiente == true) {
        print('flag');
        contadorTotal += pagoP;
      }

      print(contadorTotal);
      setState(() {
        contadorTotal;
      });
    } else {
      print(contadorTotal);
      setState(() {
        contadorTotal = 0.0;
      });

      return contadorTotal;
    }
  }

  /// la vista a los checked list
  mesesView(size) {
    return (checkedAll) == true
        ? Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 13),
                child: Text(
                  'Su generará su referencia anual, su referencia vencera en 24hrs.',
                  style: TextStyle(fontSize: size / 20),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          )
        : Flexible(
            flex: 3,
            child: GridView.builder(
                padding: EdgeInsets.only(left: 10, right: 10),
                itemCount: mesFormat.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 4.8,
                  crossAxisSpacing: 22,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (_, int data) {
                  return Container(
                    decoration: BoxDecoration(
                        color: pa == true ? Colors.grey[350] : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 7,
                              offset: Offset(0, 5))
                        ]),
                    child: CheckboxListTile(
                      value: check.contains(data),
                      onChanged: (bool? v) {
                        if (pa == true) {
                        } else {
                          if (checkedAll == false) {
                            if (v!) {
                              setState(() {
                                ///contadors que va sumando el adeudo
                                contador += debt[data];

                                idAdeudos.add(widget.list![data].idAdeudo!);

                                ///funcion que los añade a una lista de adeudos
                                check.add(data);
                              });
                            } else {
                              setState(() {
                                ///hace lo opuesto a añadir y sumar
                                contador -= debt[data];
                                check.remove(data);
                              });
                            }

                            ///si la lista contiene datos muestra el boton
                            if (check.contains(data)) {
                              setState(() {
                                checked = v;
                                showButton();
                              });
                            } else {
                              setState(() {
                                checked = v;
                              });
                            }
                          } else {
                            checked = false;
                          }
                        }
                      },
                      controlAffinity: ListTileControlAffinity.platform,
                      activeColor: Colors.lightGreen[700],
                      checkColor: Colors.black,
                      title: Container(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 20.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Concepto',
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold)),
                                Text('Monto',
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('${conceptos[data]}: ${mesFormat[data]}',
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 14.0)),
                                Text('${numberFormat.format(debt[data])}.00',
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 14.0))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }));
  }

  sacarConcepto() {
    String? estado;
    String concepto;
    // cortado le quita los espacios que llevan los conceptos desde el web service
    var cortado;
    for (int i = 0; i < widget.list!.length; i++) {
      concepto = widget.list![i].idConcepto!.trimRight();
      switch (concepto) {
        case "MMTO":
          cortado = "Mant";
          conceptos.add(cortado);
          break;
        case "EXT":
          cortado = "Extra";
          conceptos.add(cortado);
          break;
        case "PGT":
          cortado = "Pago Tardio";
          conceptos.add(cortado);
          break;
        case "CONST":
          cortado = "Constr";
          conceptos.add(cortado);
          break;
        case "TERR":
          cortado = "Terreno";
          conceptos.add(cortado);
          break;
        case "TAGACC":
          cortado = "Tag Acceso";
          conceptos.add(cortado);
          break;
        case "ACCTEL":
          cortado = "Acceso Tel";
          conceptos.add(cortado);
          break;
        case "MULT":
          cortado = "Multa";
          conceptos.add(cortado);
          break;
        case "MMTO 2019":
          cortado = "Adeudo 2019";
          conceptos.add(cortado);
          break;
        case "MMTO 2020":
          cortado = "Adeudo 2020";
          conceptos.add(cortado);
          break;
        case "CTA-ACCESO":
          cortado = "Sistema Acceso";
          conceptos.add(cortado);
          break;
        case "EXT-TEL":
          cortado = "Extra Tel";
          conceptos.add(cortado);
          break;
        case "PREM":
          cortado = "Pago Permanente";
          conceptos.add(cortado);
          break;
      }
    }

    return estado;
  }

  alerta() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context)..pop()..pop();
          //sendingData();
        },
        child: Text(
          'Si, continuar',
          style: TextStyle(color: Colors.lightGreen[700]),
        ));
    Widget backButton = TextButton(
        onPressed: () {
          Navigator.of(context)..pop();
        },
        child: Text(
          'Regresar',
          style: TextStyle(color: Colors.lightGreen[700]),
        ));
    AlertDialog alert = AlertDialog(
      actions: [okButton, backButton],
      title: Text(
        '¡Atención!',
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
              'Su referencia ha sido generada con exito!, Actualice y revise el apartado de referencias en +',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
  }

  ///alerta  que sale cuando se ha generado una referencia de pago y se intenta otra
  alerta2() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context)..pop()..pop();
          //sendingData();
        },
        child: Text(
          'Okay',
          style: TextStyle(color: Colors.lightGreen[700]),
        ));
    Widget backButton = TextButton(
        onPressed: () {
          Navigator.of(context)..pop();
        },
        child: Text(
          'Regresar',
          style: TextStyle(color: Colors.lightGreen[700]),
        ));
    AlertDialog alert = AlertDialog(
      actions: [okButton, backButton],
      title: Text(
        '¡Atención!',
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
              'Ya se ha generado una referencia, para generar otra, realize su pago o espere la fecha de vencimiento',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
  }

  sacarMesDeAtrazo() async {
    int? mesesAtrazo;
    String? mes;

    for (int i = 0; i < widget.list!.length; i++) {
      if (widget.list![i].pago == 1) {
      } else {
        mesesAtrazo = widget.list![i].fechaGenerada!.month;

        switch (mesesAtrazo) {
          case 1:
            mes = "Enero";
            mesFormat.add(mes);
            break;
          case 2:
            mes = "Febrero";
            mesFormat.add(mes);
            break;
          case 3:
            mes = "Marzo";
            mesFormat.add(mes);
            break;
          case 4:
            mes = "Abril";
            mesFormat.add(mes);
            break;
          case 5:
            mes = "Mayo";
            mesFormat.add(mes);
            break;

          case 6:
            mes = "Junio";
            mesFormat.add(mes);
            break;
          case 7:
            mes = "Julio";
            mesFormat.add(mes);
            break;
          case 8:
            mes = "Agosto";
            mesFormat.add(mes);
            break;
          case 9:
            mes = "Septiembre";
            mesFormat.add(mes);
            break;
          case 10:
            mes = "Octubre";
            mesFormat.add(mes);
            break;
          case 11:
            mes = "Noviembre";
            mesFormat.add(mes);
            break;
          case 12:
            mes = "Diciembre";
            mesFormat.add(mes);
            break;
        }

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
      deuda = double.parse(widget.list![i].montoCuota!);
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
