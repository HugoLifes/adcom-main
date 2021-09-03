import 'package:adcom/src/methods/emailDashboard.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Contactos extends StatefulWidget {
  Contactos({Key? key}) : super(key: key);

  @override
  _ContactosState createState() => _ContactosState();
}

class _ContactosState extends State<Contactos> {
  List<Items>? itemSeleccion = [];
  List<String>? newArr = [];
  TextEditingController? _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final residentes = Provider.of<EventProvider>(context).items;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent[700],
        onPressed: () => _openFilterDialog(residentes),
        child: Icon(
          Icons.filter_list,
        ),
      ),
      appBar: AppBar(
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
            height: size.height * .31,
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
            padding: EdgeInsets.only(top: 56),
            alignment: Alignment.topRight,
            child: Icon(
              Icons.contacts,
              color: Colors.white,
              size: 165,
            ),
          ),
          SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Directorio",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Contacta a tus personas de confianza',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width * .5,
                  child: Text(
                    'Mantente conectado con tu comunidad o asesores de tu comunidad',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: size.width * .55,
                  child: searchBar(residentes),
                ),
                itemSeleccion == null || itemSeleccion!.length == 0
                    ? ContactDashboard()
                    : filterView(),
              ],
            ),
          )),
        ],
      ),
    );
  }

  searchBar(List<Items> residentes) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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

  filterView() => Flexible(
      child: GridView.builder(
          shrinkWrap: false,
          itemCount: itemSeleccion!.length,
          padding: EdgeInsets.only(left: 4, right: 4, top: 17),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2.9,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, int index) {
            return InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 6,
                          offset: Offset(0, 1))
                    ]),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey[300], shape: BoxShape.circle),
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.lightGreen,
                        ),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          itemSeleccion![index].title == null
                              ? Container()
                              : Text(itemSeleccion![index].title!.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text('Comunidad',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: 3,
                              ),
                              itemSeleccion![index].comNombre == null
                                  ? Container()
                                  : Text(itemSeleccion![index].comNombre!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text('Numero',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: 3,
                              ),
                              itemSeleccion![index].telCel == null
                                  ? Container()
                                  : Text(itemSeleccion![index].telCel!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }));

  void _openFilterDialog(res) async {
    await FilterListDialog.display<Items>(context,
        listData: res,
        selectedListData: itemSeleccion,
        height: 480,
        headlineText: "Que comunidad buscas?",
        searchFieldHintText: "Buscar...", choiceChipLabel: (item) {
      return item.toString();
    }, validateSelectedItem: (list, val) {
      return list!.contains(val.idComunidad);
    }, onItemSearch: (list, text) {
      if (list!.any((element) => element.idComunidad
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase()))) {
        return list
            .where((element) => element.comNombre
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase()))
            .toList();
      }
      return [];
    }, onApplyButtonClick: (list) {
      if (list != null) {
        setState(() {
          itemSeleccion = List.from(list);
        });
      }
      Navigator.pop(context);
    });
  }
}
