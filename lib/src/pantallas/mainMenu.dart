import 'dart:async';
import 'dart:convert';

import 'package:adcom/json/jsonAmenidades.dart';
import 'package:adcom/src/extra/servicios.dart';
import 'package:adcom/src/methods/checkInternet.dart';
import 'package:adcom/src/methods/eventDashboard.dart';
import 'package:adcom/src/methods/gridDashboard.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:adcom/src/pantallas/loginPage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  OSDeviceState? status;
  int? idPrim;
  bool landScape = false;
  bool? usuarioIncorrecto = false;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();

      print('${result}');
    } on PlatformException catch (e) {
      print('aqui: ${e.toString()}');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

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

  Future obtainData() async {
    prefs = await SharedPreferences.getInstance();
    status = await OneSignal.shared.getDeviceState();
    if (mounted) {
      setState(() {
        userM = prefs!.getString('userM');
        pass = prefs!.getString('passM');
        idPrim = prefs!.getInt('idPrimario');
      });
    }

    print(userM);
    print(pass);
    print(idPrim);

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
      } else {
        if (post.message == "Usuario o contraseña incorrecto" &&
            post.value == 0) {
          Fluttertoast.showToast(
              msg: "Usuario o contraseña incorrecto",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          alerta5();
        }
      }
    });
    if (prefs!.getBool('EnvioId') == true) {
    } else {
      SendIdNotification().sendId(status!.userId!, idPrim!);
    }
  }

  @override
  void initState() {
    super.initState();
    CheckInternet().checkConnection(context);
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
      print('Message: ${result.notification.body}');
    });

    initConnectivity();
    obtainData();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    userName();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as LoginPage;

    Size size = MediaQuery.of(context).size;
    List<Widget> _widgetOptions = [mainMenuView(size), Services()];
    List<Widget> _widgetOptionsLandScape = [
      mainMenuView(size, landscape: true),
      Services()
    ];
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _widgetOptions.elementAt(_selectedIndex);
          } else {
            return _widgetOptionsLandScape.elementAt(_selectedIndex);
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBarTheme(
        data: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.red.shade900,
            unselectedItemColor: Colors.black,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(color: Colors.red.shade900),
            elevation: 4),
        child: BottomNavigationBar(
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
                backgroundColor: Colors.blue),
          ],
          elevation: 10,
          currentIndex: _selectedIndex,
          onTap: onItemTapped,
        ),
      ),
    );
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
          Provider.of<EventProvider>(context, listen: false).logOut(context);
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
            Text('Su contraseña ha cambiado')
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert);
  }

  Stack mainMenuView(Size size, {bool landscape = false}) {
    return Stack(
      children: [
        Container(
          height: landScape == true ? size.height * .31 : size.height * .35,
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
            padding: EdgeInsets.only(
                top: landscape == true ? size.height * .10 : size.height * .18,
                right: size.width / 18),
            alignment: Alignment.topRight,
            child: Image.asset(
              'assets/images/AdCom3.png',
              width: landscape == true ? size.width * .14 : size.width * .38,
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
                      landscape == true
                          ? Row(
                              children: [
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      user == null || user == ''
                                          ? Text('¡${greeting()}!',
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
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${user == null || user == '' ? '' : user}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Roboto',
                                            fontSize: size.width / 30,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  width: size.height / 3.5,
                                  height: size.width / 2.0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      user == null || user == ''
                                          ? Text('¡${greeting()}!',
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
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                      Text(
                                        '${user == null || user == '' ? '' : user}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Roboto',
                                            fontSize: size.width / 10.5,
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
          landscape: landscape,
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

class SendIdNotification {
  Future sendId(String nuserId, int userIdApp) async {
    Uri uri = Uri.parse(
        'http://187.189.53.8:8081/backend/web/index.php?r=adcom/token');
    print(nuserId);
    print(userIdApp);
    var response = await http.post(uri, body: {
      "params": json.encode({
        "idUsurioApp": userIdApp,
        "uuid": nuserId,
      })
    }).timeout(Duration(seconds: 5), onTimeout: () {
      return http.Response('Timeout', 408);
    });
    print(response.body);
    if (response.statusCode == 200) {
      print('ok');
    } else {
      if (response.statusCode == 400) {
        print("Item form is statuscode 400");
        Fluttertoast.showToast(
            msg: "Error en el servidor, intente mas tarde",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print("Item form is statuscode 500");

        Fluttertoast.showToast(
            msg: "Error en el servidor, intente mas tarde",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    prefs = await SharedPreferences.getInstance();
    prefs!.setBool('EnvioId', true);
  }
}
