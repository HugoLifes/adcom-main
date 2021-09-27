import 'package:adcom/src/pantallas/finanzas.dart';
import 'package:flutter/material.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
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
  bool checked = false;
  List<dynamic> check = [];
  double contador = 0.0;
  double contadorTotal = 0.0;
  bool checkedAll = false;

  @override
  void initState() {
    super.initState();
    sacarMesDeAtrazo();
    totalApagars();
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
              'Seleccioné lo que desee pagar',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    'Pagar uno por uno',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, top: 10),
                  child: Text(
                    'ó',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: CheckboxListTile(
                      tileColor: Colors.grey.withOpacity(0.2),
                      value: checkedAll,
                      title: Text('Pagar el año'),
                      onChanged: (v) {
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

                        if (contadorTotal != 0.0) {
                          showButton();
                        }
                      },
                      controlAffinity: ListTileControlAffinity.platform,
                      activeColor: Colors.lightGreen[700],
                      checkColor: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: size.width / 19,
            ),
            mesesView(size2),
            Divider(
              color: Colors.grey,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 180, top: 0),
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
                          ? Text('${pagarTodo()} MXN',
                              style: TextStyle(fontSize: 19))
                          : Text(
                              //contador
                              '\$ ${contador} MXN',
                              style: TextStyle(fontSize: 19),
                            ),
                      SizedBox(
                        height: size.height / 10,
                      )
                    ],
                  ),
                )
              ],
            ),
            showButton(),
          ],
        ),
      ),
    );
  }

  showButton() {
    return (checked || checkedAll) == false
        ? Text('')
        : Container(
            padding: EdgeInsets.only(bottom: 25, left: 10, right: 10),
            child: GradientButton(
                child: Text('Generar referencia de pago'),
                callback: () {
                  print('Boton push');
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

  /// FUNCION QUE SE USA PARA PAGAR TODO
  pagarTodo() {
    double? cuota;
    double? cuotaDeudora;
    int meses;
    double deuda;
    bool flag = false;

    ///el checked all se obtiene en el check de pagar todo
    if (checkedAll == true) {
      ///
      for (int i = 0; i < widget.list!.length; i++) {
        /// se saca la cuota
        cuota = double.parse(widget.list![i].montoCuota!);

        /// la deuda que se cobra
        deuda = double.parse(widget.list![i].montoTardio!);

        /// si es tardio suma la deuda a la cuota
        if (widget.list![i].pagoTardio == 1) {
          setState(() {
            flag = true;
          });
          cuotaDeudora = cuota + deuda;
        } else {
          /// solo es la cuota
          setState(() {
            flag = false;
          });
          cuotaDeudora = cuota;
        }
      }

      /// asigno el mes en numero
      meses = widget.list!.first.fechaLimite!.month;

      ///Recorro el me hasta el mes 12
      /// ejem  mes = 8 entonces lo que falte para llegar a 12
      for (meses; meses <= 12; meses++) {
        if (flag == true) {
          contadorTotal += cuotaDeudora!;
        } else {
          contadorTotal += cuota!;
        }
      }

      return contadorTotal;
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
    return checkedAll == true
        ? SizedBox()
        : Flexible(
            child: GridView.builder(
                padding: EdgeInsets.only(left: 10, right: 10),
                itemCount: mesFormat.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 5.0,
                  crossAxisSpacing: 22,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (_, int data) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                        if (checkedAll == false) {
                          if (v!) {
                            setState(() {
                              ///contadors que va sumando el adeudo
                              contador += debt[data];

                              ///funciona que los añade a una lista de adeudos
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
                                Text(
                                    '${sacarConcepto()} de Mant: ${mesFormat[data]}',
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 14.0)),
                                Text('${debt[data]}',
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
    for (int i = 0; i < widget.list!.length; i++) {
      if (widget.list![i].pago == 0) {
        if (widget.list![i].pagoTardio == 1) {
          estado = 'Multa + Cuota';
        } else {
          estado = 'Cuota';
        }
      }
    }

    return estado;
  }

  sacarMesDeAtrazo() async {
    DateTime? mesesAtrazo;

    for (int i = 0; i < widget.list!.length; i++) {
      if (widget.list![i].pago == 1) {
      } else {
        setState(() {
          mesesAtrazo = widget.list![i].fechaGenerada;
        });

        mesFormat
            .add(DateFormat('MMM').format(DateTime(0, mesesAtrazo!.month)));
        //print(DateFormat('MMM').format(DateTime(0, mesesAtrazo!.month)));
      }
    }
  }

  totalApagars() {
    late double total;
    double deuda;

    for (int i = 0; i < widget.list!.length; i++) {
      total = double.parse(widget.list![i].montoCuota!);
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
