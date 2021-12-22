import 'package:adcom/src/models/event_provider.dart';
import 'package:adcom/src/pantallas/finanzas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

class RefView extends StatefulWidget {
  late List<DatosCuenta>? list = [];
  late List<DatosCuenta>? refP = [];
  PagoAnualR? pagoAnualR;
  final ref;
  RefView({Key? key, this.list, this.refP, this.ref, this.pagoAnualR})
      : super(key: key);
  @override
  _RefViewState createState() => _RefViewState();
}

class _RefViewState extends State<RefView> {
  String? tipoReferencia;

  @override
  void initState() {
    super.initState();
    referenciaApagar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[700],
        title: Text('Tu Referencia de Pago'),
      ),
      body: SafeArea(
        child: Container(
          //margin: EdgeInsets.all(16.0),
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.ref != null
                  ? Text(
                      'Tipo Ref: Pago agrupado',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      'Tipo Ref: $tipoReferencia',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Clipboard.setData(new ClipboardData(
                                text: widget.ref != null
                                    ? widget.ref
                                    : referenciaApagar()))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            "La referencia se ha copiado exitosamente!",
                            style: TextStyle(fontSize: 20),
                          )));
                        });
                      },
                      child: widget.ref != null
                          ? Text(
                              '${widget.ref}',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  decoration: TextDecoration.underline),
                            )
                          : Text(
                              '${referenciaApagar()}',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  decoration: TextDecoration.underline),
                            )),
                  InkWell(
                      onTap: () {
                        Clipboard.setData(
                                new ClipboardData(text: referenciaApagar()))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            "La referencia se ha copiado exitosamente!",
                            style: TextStyle(fontSize: 20),
                          )));
                        });
                      },
                      child: Icon(Icons.copy))
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'IMPORTANTE!',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Esta es tu referencia para realizar tu pago correctamente. Cualquier duda, favor de contactar a su administrador. Gracias!',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 25),
                ),
              ),
              payButton()
            ],
          ),
        ),
      ),
    );
  }

  referenciaApagar() {
    String? ref;
    for (int i = 0; i < widget.list!.length; i++) {
      //no hay referencia padre
      if (widget.refP!.isEmpty) {
        //no hay referencia padre
        print('aqui1');
        // checa si esta pagado
        if (widget.list![i].pago == 1) {
          print('aqui1.1');
          setState(() {
            tipoReferencia = "";
          });
          ref = 'Pagado';
        } else {
          //si no esta pagado ve si hay referencia padre
          if (widget.list![i].referenciaP == "0" ||
              widget.list![i].referenciaP == null) {
            print('aqui 2');
            // si no hay la muestra la referencia normal
            setState(() {
              tipoReferencia = "Normal";
            });
            ref = widget.list![i].referencia;
          } else {
            // si hay muestra la referencia padre no anual
            print('aqui 2.2');
            setState(() {
              tipoReferencia = "Agrupada";
            });
            ref = widget.list![i].referenciaP;
          }
        }
        //hay referencia padre
      } else {
        print('aqui 3');
        //checa si la referencia padre anual esta pagada
        if (widget.refP!.last.pago == 1) {
          ref = 'Pagado';
        } else {
          if (widget.refP!.last.referenciaP != '0' ||
              widget.refP!.last.referenciaP != null) {
            setState(() {
              tipoReferencia = "Pago Anual";
            });
            ref = widget.refP!.last.referenciaP;
          } else {
            setState(() {
              tipoReferencia = "Agrupada";
            });
            ref = widget.list![i].referenciaP;
          }
        }
      }
    }
    return ref;
  }

  payButton() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 20),
      width: 300,
      child: GradientButton(
          child: Text('Pagar ahora'),
          callback: () {
            HapticFeedback.lightImpact();
            alerta5();
          },
          gradient: LinearGradient(colors: [
            Colors.lightGreen[500]!,
            Colors.lightGreen[600]!,
            Colors.lightGreen[700]!
          ]),
          elevation: 5.0,
          increaseHeightBy: 28,
          increaseWidthBy: double.infinity,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    );
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
          Navigator.of(context)..pop();
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
              'Adcom informa',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
                'Esta funcion estará próximamente disponible, gracias por su paciencia.'),
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert);
  }
}
