import 'package:adcom/src/extra/OnBoarding_Reporte.dart';
import 'package:adcom/src/extra/add_reporte.dart';
import 'package:adcom/src/extra/chat_page.dart';
import 'package:adcom/src/extra/eventos.dart';
import 'package:adcom/src/extra/reporte.dart';
import 'package:adcom/src/extra/seguimiento.dart';
import 'package:adcom/src/methods/event_editing_page.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:adcom/src/pantallas/amenidades.dart';
import 'package:adcom/src/pantallas/avisos.dart';
import 'package:adcom/src/pantallas/chat.dart';
import 'package:adcom/src/pantallas/contactos.dart';
import 'package:adcom/src/pantallas/finanzas.dart';
import 'package:adcom/src/pantallas/loginPage.dart';
import 'package:adcom/src/pantallas/mainMenu.dart';
import 'package:adcom/src/pantallas/networking.dart';
import 'package:adcom/src/pantallas/reportes.dart';
import 'package:adcom/src/pantallas/visitantes.dart';
import 'package:adcom/src/pantallas/votaciones.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  final user;
  MyApp({Key? key, this.user}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final heroController = HeroController();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  var id = 'icono';
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventProvider>(
      create: (_) => EventProvider(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        navigatorObservers: [heroController],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            brightness: Brightness.light),
        title: 'adcom',
        //initialRoute: '/',
        routes: {
          '/': (BuildContext context) {
            var state = Provider.of<EventProvider>(context);
            if (state.isloggedIn()) {
              return MainMenu();
            } else {
              return LoginPage();
            }
          },
          MainMenu.routeName: (BuildContext context) => MainMenu(),
          '/screen3': (BuildContext context) => Finanzas(),
          '/screen4': (BuildContext context) => Avisos(),
          '/screen5': (BuildContext context) => Reportes(),
          '/screen6': (BuildContext context) => Votaciones(),
          '/screen7': (BuildContext context) => Amenidades(),
          '/screen8': (BuildContext context) => Visitantes(),
          '/screen9': (BuildContext context) => Chat(),
          '/screen10': (BuildContext context) => NetWorking(),
          '/screen11': (BuildContext context) => Contactos(),
          '/screen12': (BuildContext context) => EventWeekly(),
          '/screen13': (BuildContext context) => EventEditingPage(),
          '/screen14': (BuildContext context) => LevantarReporte(),
          '/screen15': (BuildContext context) => ChatPage(),
          '/screen16': (BuildContext context) => Seguimiento(),
          '/screen17': (BuildContext context) => OnBoardReportes(),
          '/screen18': (BuildContext context) => AddReorte()
        },
      ),
    );
  }
}
