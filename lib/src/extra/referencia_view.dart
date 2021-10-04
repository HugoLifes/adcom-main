import 'package:adcom/src/models/event_provider.dart';
import 'package:adcom/src/pantallas/finanzas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RefView extends StatefulWidget {
  late List<DatosCuenta>? list = [];
  late List<DatosCuenta>? refP = [];
  RefView({Key? key, this.list, this.refP}) : super(key: key);
  @override
  _RefViewState createState() => _RefViewState();
}

class _RefViewState extends State<RefView> {
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
          padding: EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Clipboard.setData(new ClipboardData(
                              text: widget.refP!.isNotEmpty
                                  ? widget.refP!.last.referenciaP
                                  : 'referencia no generada'))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          "La referencia se ha copiado exitosamente!",
                          style: TextStyle(fontSize: 20),
                        )));
                      });
                    },
                    child: widget.refP!.isNotEmpty
                        ? Text(
                            '${widget.refP!.last.referenciaP}',
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                decoration: TextDecoration.underline),
                          )
                        : Text(
                            'Genere una referencia',
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                decoration: TextDecoration.underline),
                          ),
                  ),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  referenciaApagar() {
    String? ref;
    for (int i = 0; i < widget.list!.length; i++) {
      if (widget.refP![i].idConcepto == "PA        ") {
        // poner return
        ref = widget.refP![i].referenciaP;
      } else {
        if (widget.list![i].referenciaP == "0" ||
            widget.list![i].referenciaP == null) {
          ref = "referencia no generada";
        } else {
          ref = widget.list![i].referencia;
        }
      }
    }
    return ref;
  }
}
