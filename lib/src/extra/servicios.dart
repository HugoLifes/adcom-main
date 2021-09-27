import 'package:adcom/src/extra/pedirServicio.dart';

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
        nombre: 'K19',
        descripcion: 'Surtido de gas estacionario',
        horario: '8:00 am - 6:00 pm')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 7,
        backgroundColor: Colors.white,
        title: Text(
          'Servicios para la comunidad',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: servicios.length,
          itemBuilder: (_, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => PedirServicio()));
              },
              child: Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Image.asset('assets/images/k19.png', width: 110),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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

  ServiceStore({this.descripcion, this.horario, this.image, this.nombre});
}
