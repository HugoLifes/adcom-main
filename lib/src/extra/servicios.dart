import 'dart:convert';
import 'dart:io';

import 'package:adcom/json/jsonGetProveroresIdCom.dart';
import 'package:adcom/src/extra/multiServ.dart';
import 'package:adcom/src/extra/pedirServicio.dart';
import 'package:adcom/src/methods/exeptions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:http/http.dart' as http;

/// este apartado es para el servicio de las comunidades como el gas, entre otros que se pueden implementar
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

class Services extends StatefulWidget {
  Services({Key? key}) : super(key: key);

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List<ServiceStore> servicios = [
    new ServiceStore(
        tipoDeServ: 1,
        nombre: 'Gas',
        descripcion: 'Servicios de Gas LP',
        horario: '8:00 am - 6:00 pm',
        image: Image.asset(
          'assets/images/home.png',
          fit: BoxFit.contain,
          color: Colors.red,
        ),
        icon: Icon(
          Icons.fireplace,
          size: 52,
          color: Colors.red[700],
        )),
  ];
  
  List<dynamic> unidad = [];
  List<dynamic> name = [];
  List<dynamic> seleccionado = [];
  List<DatosProveedor> datos = [];
  bool cargado = false;
  bool mostrar = false;
  var idCom;
  var userType;
  bool user = false;
  bool error = false;
  getSomeData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      idCom = prefs!.getInt('idCom');
      userType = prefs!.getInt('userType');
    });

    DatosProveedor().getDatos(idCom).then((value) {
      for (int i = 0; i < value!.data!.length; i++) {
        datos.add(new DatosProveedor(
          rutaLogo: value.data![i].rutaLogo,
          diasAtencion: value.data![i].diaAtencion,
          horarioInicio: value.data![i].horaInitAten,
          horarioFin: value.data![i].horaFinAten,
          compania: value.data![i].compania,
        ));
      }

      setState((){
        cargado = true;
      });

      unidad = List.generate(
          value.data!.length,
          (index) => List.generate(
              value.data![index].productos!.length,
              (index2) => value.data![index].productos![index2].presLogoRuta! == null ? '0' : value.data![index].productos![index2].presLogoRuta!
                  .trimRight()));
      name = List.generate(
          value.data!.length,
          (index) => List.generate(
              value.data![index].productos!.length,
              (index2) => value.data![index].productos![index2].descripcion == null ? '0' : value.data![index].productos![index2].descripcion!
                  .trimRight()));
      seleccionado = List.generate(
          value.data!.length,
          (index) => List.generate(
              value.data![index].productos!.length, (index2) => false));

      printLinks();
    }).catchError((e){
      setState((){
        mostrar = true;
      });
      alerta5();
    });
  }
    /// terminar integracion del gatito cuando hay error de conexion
    ///  ver el codigo en git kraken
  @override
  void initState() {
    super.initState();
    getSomeData();
  }

  printLinks() {
    for (int i = 0; i < unidad.length; i++) {
      print(unidad[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 7,
        backgroundColor: Colors.white,
        title: Text(
          'Servicios para tu comunidad',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: cargado == false ?
          mostrar == false ? Center(
            child: CircularProgressIndicator()
          ) : Center(
            child: Column(
              mainAxisAlignment : MainAxisAlignment.center,
              children:[
                Text(
                  'Zzz',
                  style: TextStyle(fontSize:20),
                  textAlign: TextAlign.center,
                ),
                Image.asset('assets/images/zzz.png', height: 200, width:200),
                Text(
                  'El servidor ha tardado en responder: 408',
                  style: TextStyle(fontSize:20),
                  textAlign: TextAlign.center,
                ),
              ]
            )
          )
        
         :ListView.builder(
          itemCount: servicios.length,
          itemBuilder: (_, int index) {
            return InkWell(
              onTap: () {
                if (userType == 2) {
                  Fluttertoast.showToast(
                      msg: 'Tipo de usuario no permitido',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  if (error == true) {
                    Fluttertoast.showToast(
                        msg: 'Error al cargar los datos',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => MultiServicios(
                              service: servicios[index].tipoDeServ,
                              datosP: datos,
                              unidad: unidad,
                              name: name,
                              seleccionado: seleccionado,
                            )));
                  }
                }
              },
              child: Container(
                  padding: EdgeInsets.only(left: 10, top: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(

                          ///Image.asset('assets/images/k19.png', width: 110)
                          child: servicios[index].image),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                'Servicios para el hogar',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              servicios[index].horario!,
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            );
          },
        ),
      ),
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
          setState(() {
            error = true;
          });
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

class ServiceStore {
  String? nombre;
  String? descripcion;
  String? horario;
  Image? image;
  Icon? icon;
  int? tipoDeServ;

  ServiceStore(
      {this.descripcion,
      this.horario,
      this.image,
      this.nombre,
      this.icon,
      this.tipoDeServ});
}

class DatosProveedor {
  String? rutaLogo;
  String? diasAtencion;
  String? horarioInicio;
  String? horarioFin;
  String? formaPago1;
  String? formaPago2;
  String? formaPago3;
  String? compania;

  DatosProveedor({
    this.rutaLogo,
    this.diasAtencion,
    this.horarioInicio,
    this.horarioFin,
    this.formaPago1,
    this.formaPago2,
    this.formaPago3,
    this.compania,
  });

  Future<ProvedoresId?> getDatos(int idCom) async {
    try {
      Uri uri = Uri.parse(
          'http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-datos-provedores-by-com');

      var response = await http.post(uri, body: {'idCom': '5'}).timeout(Duration(seconds: 6), onTimeout:(){
        return http.Response('Timeout', 408);
      });
      var data = returnResponse(response);
      return seguimientoFromJson(data);
    } on SocketException {
      throw FetchDataException('Error');
    }
  }
}

class Producto {
  String? unidad;
  String? descripcion;
  dynamic pressLogoRuta;

  Producto({
    this.unidad,
    this.descripcion,
    this.pressLogoRuta,
  });

  @override
  String toString() {
    return 'Producto{unidad: $unidad, descripcion: $descripcion}';
  }
}
