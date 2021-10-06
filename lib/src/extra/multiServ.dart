import 'package:adcom/src/extra/pedirServicio.dart';
import 'package:adcom/src/extra/servicios.dart';
import 'package:flutter/material.dart';

class MultiServicios extends StatefulWidget {
  int? service;
  MultiServicios({Key? key, this.service}) : super(key: key);

  @override
  _MultiServiciosState createState() => _MultiServiciosState();
}

class _MultiServiciosState extends State<MultiServicios> {
  List<ServiceStore> servicios = [];

  @override
  void initState() {
    super.initState();
    typeService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PedirServicio(
                              service: index,
                            )));
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
