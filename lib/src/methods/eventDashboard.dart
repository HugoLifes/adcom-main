import 'dart:convert';
import 'package:adcom/json/jsonAmenidades.dart';
import 'package:adcom/src/extra/eventos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

class EventDashboard extends StatefulWidget {
  final int? idA;
  final size;
  EventDashboard({this.idA, this.size});
  @override
  _EventDashboardState createState() => _EventDashboardState();
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }
}

//funcion para cargar en memoria
dataOff2(id2, perfil) async {
  await EventDashboard.init();
  prefs!.setInt('id2', id2);

  prefs!.setInt('UserType', perfil);
}

Future<Places?> amenidades() async {
  prefs = await SharedPreferences.getInstance();
  var id = prefs!.getInt('idCom');
  print('?$id');

  final Uri url = Uri.parse(
      'http://187.189.53.8:8080/AdcomBackend/backend/web/index.php?r=adcom/get-amenidades');
  final response = await http.post(url, body: {
    "params": json.encode({"usuarioId": id})
  });
  if (response.statusCode == 200) {
    var data = response.body;

    print(data);

    return placesFromJson(data);
  }
}

class _EventDashboardState extends State<EventDashboard> {
  List<Amenidad> myList = [];
  late Places places;
  bool itsTrue = true;

  Amenidad item1 = new Amenidad(
      route: '/screen12',
      title: "Mis Reservas",
      subtitle: 'Administra tus reservas',
      icon: Icon(
        Icons.event,
        size: 30,
        color: Colors.lightGreen,
      ));

  Amenidad item2 = new Amenidad(
      title: 'Reglamento',
      subtitle: 'Reglas de las instalaciones',
      icon: Icon(Icons.rule, size: 30, color: Colors.blueGrey[700]));

  gtData() async {
    await EventDashboard.init();

    try{
    places = (await amenidades())!;
    var userType = prefs!.getInt('UserType');

    switch (userType) {
      case 1:
        myList.add(
          item2,
        );
        break;
      case 2:
        myList.add(
          item1,
        );
        break;
      default:
    }

    for (int i = 0; i < places.data!.length; i++) {
      myList.add(new Amenidad(
          //route: '/screen12',
          id: places.data![i].id,
          idComu: places.data![i].idCom,
          title: places.data![i].amenidadDesc,
          route: '/screen12',
          subtitle: 'Only residentes',
          icon: Icon(
            Icons.pool,
            size: 30,
            color: Colors.deepPurple,
          )));
    }
    }catch(e){
      myList.add(new Amenidad(error: 'No tiene amenidades', icon: Icon(Icons.sms_failed, color: Colors.red,)));
      setState(() {
        itsTrue = false;
      });    
    }
  }

  @override
  void initState() {
    super.initState();
    gtData();
    Future.delayed(Duration(milliseconds: 988), () => {refresh()});
  }

  refresh() {
    setState(() {
      var size = MediaQuery.of(context).size.width;
      var size2 = MediaQuery.of(context).size.height;
      viewAmenidades( width:size, heigth: size2);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var size2 = MediaQuery.of(context).size.height;
    return myList.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          )
        :  viewAmenidades(width: size, heigth: size2);
  }

  viewAmenidades({width, heigth}){
    
    return Flexible(
          child: GridView.builder(
        padding: EdgeInsets.only(left: 10, right: 10, top: 15) ,
        itemCount: myList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3.3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, int data) {
          return InkWell(
            onTap: () {

              if(itsTrue == false){
              
              }else{
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => EventWeekly(id: myList[data].id)));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        offset: Offset(0, 5))
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
                      child: myList[data].icon == null
                          ? SizedBox()
                          : myList[data].icon,
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        myList[data].title == null
                            ? Container()
                            : Text(
                                myList[data].title!,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                        SizedBox(
                          height: heigth/100,
                        ),
                        myList[data].subtitle == null
                            ? Container()
                            : Text(myList[data].subtitle!, style: TextStyle(fontSize: 12),),
                      ],
                    ),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        myList[data].error == null
                            ? Container()
                            : Text(
                                myList[data].error!,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                        SizedBox(
                          height: width /40,
                        ),
                        itsTrue== false ? Text('Lo sentimos :('): Text(''),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ));
  }

  
}

class Amenidad {
  String? error;
  String? route;
  String? title;
  String? numero;
  int? id;
  int? idComu;
  String? subtitle;
  //el evento puede ayudar a las notificaciones, checar despues
  String? event;
  Icon? icon;
  Amenidad(
      {
      this.error,  
      this.title,
      this.icon,
      this.subtitle,
      this.route,
      this.id,
      this.numero,
      this.idComu});
}
