import 'dart:convert';
import 'dart:io';

import 'package:adcom/json/jsonProveedores.dart';
import 'package:adcom/src/extra/pedirServicio.dart';
import 'package:adcom/src/extra/servicios.dart';
import 'package:adcom/src/methods/exeptions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ya cargue los datos
///
class MultiServicios extends StatefulWidget {
  final int? service;
  List<DatosProveedor>? datosP = [];
  List<dynamic>? unidad = [];
  List<dynamic>? name = [];
  List<dynamic>? seleccionado = [];
  List<dynamic>? precios = [];
  MultiServicios(
      {Key? key,
      this.service,
      this.datosP,
      this.unidad,
      this.name,
      this.precios,
      this.seleccionado})
      : super(key: key);

  @override
  _MultiServiciosState createState() => _MultiServiciosState();
}

SharedPreferences? prefs;
Future<Proveedores?> getProv() async {
  try {
    Uri url = Uri.parse(
        "http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-proveedores");

    final response = await http.get(url);
    var data = returnResponse(response);
    return proveedoresFromJson(data);
  } on SocketException {
    throw FetchDataException('Hubo un problema');
  }
}

class _MultiServiciosState extends State<MultiServicios> {
  List<ServiceStore> servicios = [];
  List<Servicios> serv = [];
  Proveedores? prov;
  bool loading = true;
  String? fi;
  String? ff;

  Future data() async {
    prefs = await SharedPreferences.getInstance();

    prov = await getProv().catchError((e) {
      alerta5();
    });

    if (prov!.data!.isNotEmpty) {
      for (int i = 0; i < prov!.data!.length; i++) {
        serv.add(new Servicios(
            idTipoProveedor: prov!.data![i].idTipoProveedor,
            idproveedor: prov!.data![i].idProveedor,
            domicilio: prov!.data![i].domicilio,
            diaAtencion: prov!.data![i].diaAtencion,
            contacto: prov!.data![i].contacto,
            telCont1: prov!.data![i].telContacto1,
            telCont2: prov!.data![i].telContacto2,
            telGuard: prov!.data![i].telGuardia,
            compania: prov!.data![i].compaia));
      }
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    typeService();
    data();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Seleccione su servicio',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: loading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                /// hace el refresh de la pagina completa y recarga lo servicios
                return Future.delayed(Duration(seconds: 1), () {
                  setState(() {
                    if (serv.isNotEmpty) {
                      serv.clear();

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
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 3,
                      color: Colors.grey[350],
                    );
                  },
                  itemCount: widget.datosP!.length,
                  itemBuilder: (_, int index) {
                    return InkWell(
                      onTap: () {
                        
                          /// Aqui se llama a la funcion que se encarga de pedir el servicio
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PedirServicio(
                                        servicio: serv[index],
                                        service: index,
                                        //datosProveedor: widget.datosP![index],
                                        url: widget.unidad![index],
                                        name: widget.name![index],
                                        precios: widget.precios![index],
                                        seleccionado:
                                            widget.seleccionado![index],
                                      )));
                        
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 15, left: 10),
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                  widget.datosP![index].rutaLogo!),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '${widget.datosP![index].compania!.trimRight()}',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                        width: size.width / 1.5,
                                        height: 30,
                                        child: Text(
                                          '${widget.datosP![index].diasAtencion!.trimRight()}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        )),
                                    Text(
                                      '${timeFormater(widget.datosP![index].horarioInicio!, widget.datosP![index].horarioFin!)}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    );
  }

  timeFormater(String ini, String fin) {
    DateFormat fInit = DateFormat("hh:mm");
    var inputDate = fInit.parse(ini);

    DateFormat fFin = DateFormat("HH:mm");
    var inputDate2 = fFin.parse(fin);

    ff = DateFormat("hh:mm").format(inputDate2);
    fi = DateFormat("hh:mm").format(inputDate);

    return '$fi am - $ff pm';
  }

  tipodeFoto(index) {
    switch (index) {
      case 0:
        return Container(
          height: 100,
          width: 100,
          child: Image.asset(
            'assets/images/k19.jpeg',
          ),
        );
      case 1:
        return Container(
          height: 100,
          width: 100,
          child: Image.asset(
            'assets/images/vevewata.jpeg',
          ),
        );
      case 2:
        return Container(
          child: Icon(
            Icons.supervisor_account_outlined,
            size: 50,
          ),
        );
      default:
        return Container(
          child: Icon(
            Icons.supervisor_account_outlined,
            size: 50,
          ),
        );
    }
  }

  typeService() {
    switch (widget.service) {
      case 1:
        servicios = [
          ServiceStore(
              nombre: 'K19',
              image: Image.asset(
                'assets/images/k19.jpeg',
              )),
          /*  ServiceStore(
              nombre: 'Zgas',
              image: Image.asset(
                'assets/images/zgas.png',
                fit: BoxFit.contain,
              )) */
        ];
        break;
      case 2:
        servicios = [
          ServiceStore(nombre: 'Plomeria panchito'),
          ServiceStore(nombre: 'Plomeros bros')
        ];
        break;
      case 3:
        break;
      case 4:
        break;
      default:
    }
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

class Servicios {
  int? idproveedor;
  String? compania;
  String? domicilio;
  String? contacto;
  String? telCont1;
  String? telCont2;
  String? telGuard;
  int? idTipoProveedor;
  String? diaAtencion;

  Servicios(
      {this.idproveedor,
      this.compania,
      this.contacto,
      this.diaAtencion,
      this.domicilio,
      this.idTipoProveedor,
      this.telCont1,
      this.telCont2,
      this.telGuard});
}
