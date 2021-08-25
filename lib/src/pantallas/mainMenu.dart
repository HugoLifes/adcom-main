import 'package:adcom/json/jsonAmenidades.dart';
import 'package:adcom/src/methods/eventDashboard.dart';
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

somData(user, userType) async {
  await MainMenu.init();

  prefs!.setString('user', user);
  prefs!.setInt('userType', userType);
}

class _MainMenuState extends State<MainMenu> {
  var user;
  int? userType;
  bool entrada = true;
  Places? acceso;

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
        body: size.width >= 880
            ? Stack(
                children: [
                  Container(
                    height: size.height * .40,
                    decoration: BoxDecoration(color: Colors.red),
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          top: size.width >= 880 ? 150 : 190, right: 21),
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'assets/images/AdCom.png',
                        width: 192,
                      )),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.width >= 880 ? 34 : 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.width / 10,
                                ),
                                Text(
                                  '¡${greeting()}! \n${user == null ? '' : user}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: 35,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    height: 50,
                                    width: 150,
                                    margin: size.width >= 880
                                        ? EdgeInsets.all(25)
                                        : EdgeInsets.only(left: 10, top: 46),
                                    child: SizedBox())
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.width >= 880 ? 35 : 10,
                          ),
                          GridDashboard(
                            userId: userType,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Stack(
                children: [
                  Container(
                    height: size.height * .34,
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
                          top: size.height * .18, right: size.width * .10),
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
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.width / 19,
                                ),
                                Text(
                                  '¡${greeting()}! \n${user == null ? '' : user}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Roboto',
                                      fontSize: size.width / 11,
                                      fontWeight: FontWeight.w700),
                                ),
                                //no mover
                                SizedBox(
                                  height: size.height >= 640
                                      ? size.height / 6.5
                                      : size.height / 10,
                                ),
                              ],
                            ),
                          ),

                          //no mover
                          SizedBox(
                            height: size.width <= 640 ? 5 : size.height / 13,
                          ),

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
