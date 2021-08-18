import 'package:adcom/src/methods/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class Avisos extends StatefulWidget {
  final id;
  Avisos({Key? key, this.id}) : super(key: key);

  @override
  _AvisosState createState() => _AvisosState();
}

class _AvisosState extends State<Avisos> {
  bool _requierConsent = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void>? initStatePlatform() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requierConsent);

    OneSignal.shared.setNotificationOpenedHandler((result) {
      print('Notification ha sido abierta $result');
      this.setState(() {});
    });

    OneSignal.shared.setInAppMessageClickedHandler((action) {
      this.setState(() {});
    });

    OneSignal.shared.setSubscriptionObserver((changes) {
      print('La subscripcion ha cambiado ${changes.jsonRepresentation()}');
    });

    OneSignal.shared.setPermissionObserver((changes) {
      print('El permiso ha cambiado ${changes.jsonRepresentation()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blueGrey[700],
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: size.height * .40,
            decoration: BoxDecoration(color: Colors.blueGrey[700]),
          ),
          Container(
            padding: EdgeInsets.only(top: 75),
            alignment: Alignment.topRight,
            child: Icon(
              Icons.announcement_rounded,
              color: Colors.white,
              size: 180,
            ),
          ),
          SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Avisos",
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
                  'Comunicados de la comunidad',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width * .6,
                  child: Text(
                    'Enterate de lo que sucede en tu comunidad! Desde recordatorios, alertas, novedades y más.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: size.width * .5,
                  child: SearchBar(),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
