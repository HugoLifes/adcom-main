import 'dart:convert';
import 'dart:io';
import 'package:adcom/json/jsonLogin.dart';
import 'package:adcom/src/extra/avisoPrivacidad.dart';
import 'package:adcom/src/methods/exeptions.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

SharedPreferences? prefs;

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

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  TextEditingController tk = TextEditingController();
  TextEditingController tk2 = TextEditingController();
  Posting? post;
  bool rememberMe = false;
  var userId;
  bool landScape = false;
  bool? isTablet;
  bool? isPhone;

  @override
  void initState() {
    super.initState();
     final double devicePixelRatio = ui.window.devicePixelRatio;
  final ui.Size size2 = ui.window.physicalSize;
  final double width = size2.width;
  final double height = size2.height;
    
     if(devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      setState((){
        isTablet = true;
        isPhone = false;
      });
        
      
  
    }else if(devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
     setState((){
      isTablet = true;
      isPhone = false;  
      });
    }else {
    setState((){
        isTablet = false;
  isPhone = true; 
      }); 
}
  whatDevice();
    
  }

  whatDevice() async{
    prefs = await SharedPreferences.getInstance();
    prefs!.setBool('isPhone', isPhone!);
    prefs!.setBool('isTablet', isTablet!);

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            if(orientation == Orientation.portrait){  
              return mainMenuLogin(size , isTablet!, isPhone!,landScape: false);
            }else{
              
              return mainMenuLogin(size ,isTablet!, isPhone! ,landScape: true);

            }
          },
        ),
      ),
    );
  }

  mainMenuLogin(Size s,bool isTablet,bool isPhone,{landScape = false} ){
    return LoaderOverlay(
          child: Container(
            //width : landScape == true ? 550 : s.width * 0.60,
            padding: isTablet == false ? null : EdgeInsets.only(right: landScape == true ? 350 :250, left: landScape == true ? 350 :250, top: landScape == true ? 0:55),
            child: ListView(
            
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
              Container(
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
                    width : landScape == true ? 100 : 0,
                  
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
                              autofocus: false,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2)),
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: 'Usuario',
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.red,
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 18)),
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
                              autofocus: false,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2)),
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: 'Contrase??a',
                                  prefixIcon: Icon(
                                    Icons.security,
                                    color: Colors.red,
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 18)),
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
                                onChanged: (v) {
                                  setState(() {
                                    rememberMe = v!;
                                  });
                                },
                              ),
                              Text(
                                'Recordarme',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
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
                                context.loaderOverlay.show();
                                Provider.of<EventProvider>(context,
                                        listen: false)
                                    .login(user, pass, context, tk, tk2)
                                    .whenComplete(
                                        () => {
                                          if(mounted){
                                            context.loaderOverlay.hide(),
                                          }
                                        });
                              } catch (e) {
                                HapticFeedback.heavyImpact();
                                alerta5();
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
              Center(
                  child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AvisoPrivacidad()));
                },
                child: Text(
                  'Aviso de privacidad',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                      textBaseline: TextBaseline.alphabetic),
                ),
              ))
            ],
          ),
          )
        );
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

    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
  }

  showAlertDialog() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).popAndPushNamed('/');
        },
        child: Text('OK'));

    AlertDialog alert = AlertDialog(
      title: Text('Atencion!'),
      content: Text('No ha introducido sus datos'),
      actions: [okButton],
    );

    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
  }

  alerta5() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).popAndPushNamed('/');
        },
        child: Text('OK'));

    AlertDialog alert = AlertDialog(
      title: Text('Atencion!'),
      content: Text('Hubo un error de conexion: 408'),
      actions: [okButton],
    );

    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
  }
}

Future<Posting?> loginAcces(String user, String pass) async {
  print(user);
  print(pass);
  var data;
  try {
    final Uri uri = Uri.parse(
        'http://www.adcom.mx:8081/backend/web/index.php?r=adcom/login');
    final response = await http.post(uri, body: {
      "params": jsonEncode({'username': user, 'password': pass}),
    }).timeout(Duration(seconds: 7), onTimeout: () {
      print('flag1');
      return http.Response('OutOfTime', 408);
    });

    data = returnResponse(response);
    print(postingFromJson(data).message);
    return postingFromJson(data);
  } on SocketException {
    throw FetchDataException('Error 408');
  }
}

class AvisoDePrivacidad {
  String? title;

  String? content;

  AvisoDePrivacidad(
      {this.title =
          """En cumplimiento a la Ley Federal de Protecci??n de Datos Personales en Posesi??n de los Particulares (la "Ley") vigente en M??xico, le informamos los t??rminos y condiciones del Aviso de Privacidad de Datos Personales ("Aviso de Privacidad") de AdCom ??(en lo sucesivo ???La Empresa???) con domicilio en ALMEIRA #2702, CERRADA ANDALUCIA EN ESTA CIUDAD DE CHIHUAHUA, CHIHUAHUA
Finalidad de la recopilaci??n de datos:
Los datos personales que recopilamos los destinamos ??nicamente a los siguientes prop??sitos: conocimiento e individualizaci??n del cliente dentro de la empresa, manejar su expediente para prestarle el servicio que se ofrece y en su caso se haya contratado.
En la recopilaci??n y tratamiento de datos personales que usted nos proporcione, cumplimos todos los principios mismos que son Licitud, calidad, consentimiento,informaci??n, finalidad, lealtad, proporcionalidad y responsabilidad, mismos que est??n establecidos en el art??culo 6 de la Ley Federal de Protecci??n de Datos Personales en Posesi??n de los Particulares.
Entendiendo por datos personales, tales como nombre completo, domicilio, correo electr??nico y tel??fono.
No recabamos datos personales sensibles que puedan afectar la esfera m??s ??ntima del titular, o cuya utilizaci??n indebida pueda dar origen a discriminaci??n o conlleve un riesgo grave para ??ste.
  
En particular, se consideran datos sensibles aquellos que puedan revelar aspectos como origen racial o ??tnico, estado de salud presente y futura, informaci??n gen??tica, creencias religiosas, filos??ficas y morales, afiliaci??n sindical, opiniones pol??ticas, preferencia sexual. 
Limitaci??n del uso o divulgaci??n de sus datos personales a terceros. Nosotros no divulgaremos sus datos personales a terceras personas, excepto cuando sean requeridos por orden de autoridad judicial o administrativa. 
Modificaciones al Aviso de Privacidad. Nos reservamos el derecho de cambiar este Aviso de Privacidad en cualquier momento.
En caso de que exista alg??n cambio en este Aviso de Privacidad, se comunicar?? mediante correo electr??nico personal.
Ante qui??n puede presentar sus quejas y denuncias por el tratamiento indebido de sus datos personales.
Si usted considera que su derecho de protecci??n de datos personales ha sido lesionado por alguna conducta de nuestros empleados o nuestras actuaciones o respuestas, presume que en el tratamiento de sus datos personales existe alguna violaci??n a las disposiciones previstas en la Ley Federal de Protecci??n de Datos Personales en Posesi??n de los Particulares, podr?? interponer la queja o denuncia correspondiente ante el INAI. 
""",
      this.content});
}
