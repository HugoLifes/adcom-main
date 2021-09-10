import 'package:adcom/src/methods/gridDashboard.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

somData(user, userType, idCom, idPrimario, userId) async {
  await MainMenu.init();

  prefs!.setString('user', user);
  prefs!.setInt('userType', userType);
  prefs!.setInt('idCom', idCom);
  prefs!.setInt('idPrimario', idPrimario);
  prefs!.setInt('userId', userId);
}

class _MainMenuState extends State<MainMenu> {
  var user;
  int? userType;

  userName() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs!.getString('user');
      userType = prefs!.getInt('userType');
    });
  }

  @override
  void initState() {
    super.initState();
    userName();
  }

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as LoginPage;
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
                children: [
                  Container(
                    height: size.height * .36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(1, 0))
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          top: size.height * .18, right: size.width / 15,  ),
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
                            padding: const EdgeInsets.only(
                              left: 12,
                              top:10
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.height/3.5,
                                  height: size.width/2.0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('¡${greeting()}!', style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Roboto',
                                            fontSize:  17,
                                            fontWeight: FontWeight.w700),),
                                        
                                      Text(
                                        '${user == null ? '' : user}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Roboto',
                                            fontSize: size.width / 10,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                //no mover
                              
                              ],
                            ),
                          ),

                          //no mover
                          

                          GridDashboard(
                            userId: userType,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buenos Dias';
    }
    if (hour < 19) {
      return 'Buenas tardes';
    }
    return 'Buenas noches';
  }
}
