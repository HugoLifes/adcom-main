import 'dart:async';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';

class CheckInternet {
  StreamSubscription<DataConnectionStatus>? listener;
  var InternetStatus = "Unknown";
  var contentmessage = "Unknown";

  checkConnection(BuildContext context) async {
    print("Current status: ${await DataConnectionChecker().connectionStatus}");

    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          InternetStatus = "Uju!";
          contentmessage = "Tienes conexion, ahora puedes navegar";
          _showDialog(InternetStatus, contentmessage, context);
          break;
        case DataConnectionStatus.disconnected:
          InternetStatus = "Oh no!";
          contentmessage = "Porfavor conectate a internet para navegar";
          _showDialog(InternetStatus, contentmessage, context);
          break;
      }
    });
    await Future.delayed(Duration(seconds: 30));
    await listener!.cancel();
    return await DataConnectionChecker().connectionStatus;
  }

  void _showDialog(String title, String content, BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text(title),
              content: new Text(content),
              actions: <Widget>[
                new TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("Close"))
              ]);
        });
  }
}
