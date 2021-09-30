import 'dart:convert';
import 'package:adcom/json/jsonLogin.dart';

import 'package:adcom/src/models/event_provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final bool isPremium;
  final Function? onLoginProcess;
  final idUser;
  LoginPage(
      {Key? key, this.isPremium = false, this.idUser, this.onLoginProcess})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

Future<Posting?> loginAcces(String user, String pass) async {
  final Uri uri =
      Uri.parse('http://187.189.53.8:8081/backend/web/index.php?r=adcom/login');
  final response = await http.post(uri, body: {
    "params": jsonEncode({'username': user, 'password': pass}),
  });
  if (response.statusCode == 200) {
    var data = response.body;

    return postingFromJson(data);
  }
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  TextEditingController tk = TextEditingController();
  TextEditingController tk2 = TextEditingController();
  Posting? post;
  bool rememberMe = false;
  var userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(
            height: 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 230,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: Consumer<EventProvider>(
              builder: (_, a, child) {
                if (a.isLoading()) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return child!;
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Hola!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 25),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Inicia con tus datos',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                      child: Form(
                        key: _formKey2,
                        child: TextFormField(
                          controller: tk2,
                          validator: (nameValidator) {
                            if (nameValidator == null ||
                                nameValidator.isEmpty) {
                              return 'Introduce un usuario';
                            }
                            return null;
                          },
                          autofocus: true,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 2)),
                              contentPadding: EdgeInsets.all(10),
                              hintText: 'Usuario',
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.red,
                              ),
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 18)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: tk,
                          validator: (nameValidator) {
                            if (nameValidator == null ||
                                nameValidator.isEmpty) {
                              return 'Ingresa datos porfavor';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 2)),
                              contentPadding: EdgeInsets.all(10),
                              hintText: 'Contraseña',
                              prefixIcon: Icon(
                                Icons.security,
                                color: Colors.red,
                              ),
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 18)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 31, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              activeColor: Colors.red,
                              value: rememberMe,
                              onChanged: _onRemeberMeChange),
                          Text(
                            'Recordarme',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 13),
                    InkWell(
                      onTap: () async {
                        HapticFeedback.mediumImpact();
                        final String user = tk2.text;
                        final String pass = tk.text;
                        if (_formKey.currentState!.validate() &&
                            _formKey2.currentState!.validate()) {
                          try {
                            Provider.of<EventProvider>(context, listen: false)
                                .login(user, pass, context, tk, tk2);
                          } catch (e) {
                            HapticFeedback.heavyImpact();
                            showAlertDialog();
                          }
                        } else {
                          HapticFeedback.heavyImpact();
                          showAlertDialog();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Inicia Sesion ',
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onRemeberMeChange(bool? newValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      HapticFeedback.mediumImpact();
      rememberMe = newValue!;

      if (rememberMe) {
        preferences.setString('user', tk2.text);

        // implementar rememberme
      } else {
        //olvidar usuario
      }
    });
  }

  showAlertDialog2() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context)..pop();
        },
        child: Text('OK'));

    AlertDialog alert = AlertDialog(
      title: Text('Ops... algo salio mal'),
      content: Text('Vuelva a intentarlo'),
      actions: [okButton],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  showAlertDialog() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).popAndPushNamed('/');
        },
        child: Text('OK'));

    AlertDialog alert = AlertDialog(
      title: Text('Atencion!'),
      content: Text('Sus datos son incorrectos, vuelva a introducirlos'),
      actions: [okButton],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}
