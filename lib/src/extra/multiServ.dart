import 'package:adcom/json/jsonProveedores.dart';
import 'package:adcom/src/extra/pedirServicio.dart';
import 'package:adcom/src/extra/servicios.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// ya cargue los datos
///

class MultiServicios extends StatefulWidget {
  final int? service;
  MultiServicios({Key? key, this.service}) : super(key: key);

  @override
  _MultiServiciosState createState() => _MultiServiciosState();
}

Future<Proveedores?> getProv() async {
  Uri url = Uri.parse(
      "http://187.189.53.8:8080/AdcomBackend/backend/web/index.php?r=adcom/get-proveedores");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    var data = response.body;
    print(data);
    return proveedoresFromJson(data);
  }
}

class _MultiServiciosState extends State<MultiServicios> {
  List<ServiceStore> servicios = [];
  List<Servicios> serv = [];
  Proveedores? prov;

  data() async {
    prov = await getProv();

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
  }

  @override
  void initState() {
    super.initState();
    typeService();
    data();
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 3,
              color: Colors.grey[350],
            );
          },
          itemCount: servicios.length,
          itemBuilder: (_, int index) {
            return InkWell(
              onTap: () {
                if (serv.isEmpty) {
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PedirServicio(
                                servicio: serv[index],
                                service: index,
                              )));
                }
              },
              child: Container(
                padding: EdgeInsets.only(top: 15, left: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: servicios[index].image!,
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
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
