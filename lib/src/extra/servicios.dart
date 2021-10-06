import 'package:adcom/src/extra/multiServ.dart';
import 'package:adcom/src/extra/pedirServicio.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:grouped_list/grouped_list.dart';

/// este apartado es para el servicio de las comunidades como el gas, entre otros que se pueden implementar

import 'package:flutter/material.dart';

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
        icon: Icon(
          Icons.fireplace,
          size: 52,
          color: Colors.red[700],
        )),
    /*  new ServiceStore(
        tipoDeServ: 2,
        nombre: 'Plomeria',
        descripcion: 'Servicios para el hogar',
        horario: '8:00 am - 6:00 pm',
        icon: Icon(
          Icons.handyman,
          size: 50,
        )),
    new ServiceStore(
        tipoDeServ: 3,
        nombre: 'Agua',
        descripcion: 'Agua a domicilio',
        horario: '8:00 am - 6:00 pm',
        icon: Icon(
          Icons.water_damage,
          size: 50,
        )),
    new ServiceStore(
        tipoDeServ: 4,
        nombre: 'Otros',
        descripcion: 'Otros servicios',
        horario: '8:00 am - 6:00 pm',
        icon: Icon(
          Icons.work_outline_outlined,
          size: 50,
        )) */
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 7,
        backgroundColor: Colors.white,
        title: Text(
          'Servicios de la comunidad',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: servicios.length,
          itemBuilder: (_, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MultiServicios(
                          service: servicios[index].tipoDeServ,
                        )));
              },
              child: Container(
                  padding: EdgeInsets.only(left: 10, top: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        ///Image.asset('assets/images/k19.png', width: 110)
                        child: servicios[index].icon,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            servicios[index].descripcion!,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            servicios[index].horario!,
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      )
                    ],
                  )),
            );
          },
        ),
      ),
    );
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
