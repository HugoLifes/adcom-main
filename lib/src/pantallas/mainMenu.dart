import 'dart:async';

import 'package:adcom/json/jsonAmenidades.dart';
import 'package:adcom/src/extra/servicios.dart';

import 'package:adcom/src/methods/gridDashboard.dart';
import 'package:adcom/src/pantallas/loginPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glyphicon/glyphicon.dart';

import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

class MainMenu extends StatefulWidget {
  static const routeName = '/screen2';

  final bool isAdmin;
  MainMenu({Key? key, this.isAdmin = false}) : super(key: key);
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  _MainMenuState createState() => _MainMenuState();
}

somData(user, userType, idCom, idPrimario, userId, userM, pass,
    {comunidad, noInterior, calle}) async {
  await MainMenu.init();
  prefs!.setString('userM', userM);
  prefs!.setString('passM', pass);
  prefs!.setString('user', user);
  prefs!.setInt('userType', userType);
  prefs!.setInt('idCom', idCom);
  prefs!.setInt('idPrimario', idPrimario);
  prefs!.setInt('userId', userId);
  if (comunidad == null && noInterior == null) {
  } else {
    prefs!.setString('comunidad', comunidad);
    prefs!.setString('noInterno', noInterior);
    prefs!.setString('calle', calle);
  }
}

class _MainMenuState extends State<MainMenu> {
  var user;
  int? userType;
  int? idCom;
  bool entrada = true;
  Places? acceso;
  var size;
  int _selectedIndex = 0;
  String? userM;
  String? pass;
 
  
  userName() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs!.getString('user');
      userType = prefs!.getInt('userType');
    });
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    obtainData();
    userName();
  }

    obtainData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userM = prefs!.getString('userM');
      pass = prefs!.getString('passM');
    });

    print(userM);
    print(pass);

    loginAcces(userM!, pass!).then((value) {
      var userId;
      var post = value;
      if (post!.value == 1) {
        print('aqui');
        var idPrimario = post.id;
        userId = post.idResidente;
        var comId = post.idCom;
        var userd = post.nombreResidente;
        var userType = post.idPerfil;

        var comunidad =
            post.infoUsuario == null ? '' : post.infoUsuario!.comunidad;
        var noInterior =
            post.infoUsuario == null ? '' : post.infoUsuario!.noInterior;
        var calle = post.infoUsuario == null ? '' : post.infoUsuario!.calle;
        somData(userd, userType, comId, idPrimario, userId, userM, pass,
            comunidad: comunidad, noInterior: noInterior, calle: calle);
      }
    });
  }

  @override
  void dispose() {
   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as LoginPage;
    Size size = MediaQuery.of(context).size;
    List<Widget> _widgetOptions = [mainMenuView(size), Services()];
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'Menu',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(
                Glyphicon.list,
                size: 30,
              ),
              label: 'Servicios',
              backgroundColor: Colors.blue)
        ],
        elevation: 10,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[900],
        onTap: onItemTapped,
      ),
    );
  }

  Stack mainMenuView(Size size) {
    return Stack(
      children: [
        Container(
          height: size.height * .35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, blurRadius: 10, offset: Offset(1, 0))
            ],
          ),
        ),
        Container(
            padding:
                EdgeInsets.only(top: size.height * .18, right: size.width / 18),
            alignment: Alignment.topRight,
            child: Image.asset(
              'assets/images/AdCom3.png',
              width: size.width * .38,
            )),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: size.height / 3.5,
                            height: size.width / 2.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                user == null || user == ''
                                    ? Text('¡${greeting()}! ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Roboto',
                                            fontSize: 35,
                                            fontWeight: FontWeight.w700))
                                    : Text(
                                        '¡${greeting()}!',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Roboto',
                                            fontSize: size.width/ 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                Text(
                                  '${user == null || user == '' ? '' : user}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Roboto',
                                      fontSize: size.width / 11,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: size.width / 70,
                      ), //no mover
                    ],
                  ),
                ),

                //no mover
              ],
            ),
          ),
        ),
        GridDashboard(
          userId: userType,
        )
      ],
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buenos Dias';
    }
    if (hour < 19) {
      return 'Buenas Tardes';
    }
    return 'Buenas Noches';
  }
}