import 'dart:convert';

import 'package:adcom/json/json.dart';
import 'package:adcom/src/extra/filter_section.dart';
import 'package:adcom/src/extra/vistaContactos.dart';
import 'package:adcom/src/methods/emailDashboard.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Contactos extends StatefulWidget {
  Contactos({Key? key}) : super(key: key);

  @override
  _ContactosState createState() => _ContactosState();
}

Future<Welcome?> getData() async {
  print('Se esta ejecutando');

  prefs = await SharedPreferences.getInstance();
  var id = prefs!.getInt('id');

  print(id.toString());

  Uri uri = Uri.parse(
      'http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-directorio');
  final response = await http.post(uri, body: {
    "params": json.encode({"usuarioId": id})
  });

  if (response.statusCode == 200) {
    var data = response.body;

    return welcomeFromJson(data);
  }
}

class _ContactosState extends State<Contactos> {
  List<Items>? itemSeleccion = [];
  List<String>? newArr = [];
  TextEditingController? _controller = TextEditingController();
  late Welcome? dt;
  List<Items> myList = [];
  @override
  void initState() {
    super.initState();
    holi();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var size2 = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      /* floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent[700],
        onPressed: () => _openFilterDialog(myList),
        child: Icon(
          Icons.filter_list,
        ),
      ), */
      appBar: AppBar(
        title: Text(
          "Directorio",
          style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700),
        ),
        leading: BackButton(
          onPressed: () {
            itemSeleccion!.clear();

            if (itemSeleccion!.length == 0) {
              Navigator.of(context).pop();
            }
          },
        ),
        elevation: 5,
        backgroundColor: Colors.greenAccent[700],
      ),
      body: Stack(
        children: [
          Container(
            height: size.height * .30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 6, offset: Offset(0, 1))
                ],
                color: Colors.greenAccent[700]),
          ),
          Container(
            padding: EdgeInsets.only(top: 56, right: size.width / 28),
            alignment: Alignment.topRight,
            child: Icon(
              Icons.contacts,
              color: Colors.white,
              size: size.width / 3,
            ),
          ),
          SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: size.width / 2,
                  child: Text(
                    'Contacta a tus personas de confianza',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width / 2,
                  height: size.height / 8,
                  child: Text(
                    'Mantente conectado con tu comunidad o asesores de tu comunidad',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: size.width / 2,
                  child: searchBar(myList),
                ),
                itemSeleccion == null || itemSeleccion!.length == 0
                    ? myList.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : contactsView()
                    : filterView(size2),
              ],
            ),
          )),
        ],
      ),
    );
  }

  ContactDashboard contactsView() {
    return ContactDashboard(
      contactos: myList,
    );
  }

  searchBar(List<Items> residentes) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(29.5)),
      child: TextField(
        //solucionar borrar el texto y regresar al principio
        onChanged: (text) {
          if (text.isNotEmpty) {
            search(residentes, text);
          }
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Buscar',
            icon: Icon(Icons.search)),
      ),
    );
  }

  search(residentes, String text) {
    if (residentes.any((element) =>
        element.toString().toLowerCase().contains(text.toLowerCase()))) {
      setState(() {
        if (mounted) {
          itemSeleccion = residentes
              .where((element) =>
                  element.toString().toLowerCase().contains(text.toLowerCase()))
              .toList();
        }
      });
    }
  }

  filterView(size2) => Flexible(
          child: GridView.builder(
        shrinkWrap: false,
        itemCount: itemSeleccion!.length,
        padding: EdgeInsets.only(left: 4, right: 4, top: 17),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 4.0,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (context, int index) {
          return InkWell(
            onTap: () {
              ///navigator a vista contactos
              HapticFeedback.mediumImpact();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => VistaContactos(
                            contactos: itemSeleccion![index],
                          )));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, blurRadius: 6, offset: Offset(0, 1))
                  ]),
              child: Container(
                //margin: EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[300], shape: BoxShape.circle),
                      child: itemSeleccion![index].icon == null
                          ? SizedBox()
                          : itemSeleccion![index].icon!,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: size2 / 2,
                        ),
                        itemSeleccion![index].title == null
                            ? Container()
                            : Container(
                                padding: EdgeInsets.only(top: size2 / 50),
                                child: SizedBox(
                                  width: size2 / 2,
                                  child: Text(
                                    itemSeleccion![index].title!.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size2 / 29,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ));

  holi() async {
    dt = await getData();

    for (int i = 0; i < dt!.residente!.length; i++) {
      myList.add(new Items(
          idResidente: dt!.residente![i].idResidente,
          title: dt!.residente![i].nombreResidente,
          numero: dt!.residente![i].numero,
          idComunidad: dt!.residente![i].idCom,
          calle: dt!.residente![i].calle,
          cp: dt!.residente![i].cp,
          email: dt!.residente![i].email,
          interior: dt!.residente![i].interior,
          telCel: dt!.residente![i].telefonoCel,
          telEme: dt!.residente![i].telefonoEmergencia,
          telFijo: dt!.residente![i].telefonoFijo,
          comNombre: dt!.residente![i].comNombre,
          icon: Icon(
            Icons.person,
            size: 30,
            color: Colors.lightGreen,
          )));
    }
    setState(() {
      myList;
    });
  }
}
