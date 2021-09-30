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
        nombre: 'Gas',
        descripcion: 'Servicios de Gas LP',
        horario: '8:00 am - 6:00 pm',
        icon: Icon(
          Icons.fireplace,
          size: 50,
        )),
    new ServiceStore(
        nombre: 'Plomeria',
        descripcion: 'Servicios para el hogar',
        horario: '8:00 am - 6:00 pm',
        icon: Icon(
          Icons.handyman,
          size: 50,
        )),
    new ServiceStore(
        nombre: 'Agua',
        descripcion: 'Agua a domicilio',
        horario: '8:00 am - 6:00 pm',
        icon: Icon(
          Icons.water_damage,
          size: 50,
        )),
    new ServiceStore(
        nombre: 'Otros',
        descripcion: 'Otros servicios',
        horario: '8:00 am - 6:00 pm',
        icon: Icon(
          Icons.work_outline_outlined,
          size: 50,
        ))
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => PedirServicio()));
              },
              child: Container(
                  padding: EdgeInsets.all(12),
                  child: Row(
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

  agrupado() {
    GroupedListView<dynamic, String>(
      elements: servicios,
      groupBy: (element) => element['group'],
      groupSeparatorBuilder: (String groupByValue) => Text(groupByValue),
      itemBuilder: (context, dynamic index) {
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
      itemComparator: (item1, item2) =>
          item1['name'].compareTo(item2['name']), // optional
      useStickyGroupSeparators: true, // optional
      floatingHeader: true, // optional
      order: GroupedListOrder.ASC, // optional
    );
  }
}

class ServiceStore {
  String? nombre;
  String? descripcion;
  String? horario;
  Image? image;
  Icon? icon;

  ServiceStore(
      {this.descripcion, this.horario, this.image, this.nombre, this.icon});
}
