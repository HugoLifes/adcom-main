import 'dart:convert';
import 'package:adcom/json/tipoAvisot.dart';
import 'package:adcom/src/extra/nuevo_post.dart';
import 'package:adcom/src/pantallas/avisos.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:adcom/src/methods/slide.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

SharedPreferences? prefs;
var cameras;
var firstCamera;

// ignore: must_be_immutable
class AddReporte extends StatefulWidget {
  List<AvisosCall>? comunities = [];
  final Report? report;
  List<String>? idComu;
  static init() async {
    cameras = await availableCameras();
    firstCamera = cameras.first;
  }

  AddReporte({Key? key, this.report, this.comunities, this.idComu})
      : super(key: key);

  @override
  _AddReporteState createState() => _AddReporteState();
}

someData(comId, userId) async {
  await AddReporte.init();

  prefs!.setInt('idCom', comId);
  prefs!.setInt('idUser', userId);
}

class _AddReporteState extends State<AddReporte> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _picker = ImagePicker();
  List<File> images = [];
  int? pages = 0;
  List<Slide>? _slides = [];
  List<String> newsPath = [];
  String? chosenValue;
  int _currentStep = 0;
  int? idCom;
  int? idCom2;
  int? idUser;
  List<String> type = [];
  List<TipoAvisoS>? avisos = [];
  List<String>? idComName = [];
  int? _current;
  List<StepState> _listState = [];
  List<dynamic> placeHoldersAdds = [];
  

  Future sendId() async {
    for (int i = 0; i < widget.comunities!.length; i++) {
      if (chosenValue == widget.comunities![i].nombreComu) {
        setState(() {
          idCom = widget.comunities![i].id;
        });
      }
    }

    await getTipoAviso().then((value) => {
          for (int i = 0; i < value!.data!.length; i++)
            {
              type.add(value.data![i].tipoAviso!),
            }
        });
  }

  addata() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      idCom = prefs!.getInt('idCom');
      idUser = prefs!.getInt('userId');
    });

    AvisosCall().getComunidades().then((value) => {
          for (int i = 0; i < value!.data!.length; i++)
            {
              idComName!.add(value.data![i].nombreComu!),
            }
        });
  }

  @override
  void initState() {
    addata();
    _current = 0;

    /// Lista que maneja estados de los pasos
    _listState = [
      StepState.indexed,
      StepState.editing,
      StepState.complete,
      StepState.disabled,
    ];
    
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Añade un reporte'),
          backgroundColor: Colors.blue,
          leading: CloseButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          //actions: buildEditingActions(),
        ),
        resizeToAvoidBottomInset: true,
        //stepper, propiedades y acciones
        body: LoaderOverlay(child: Theme(
          data: ThemeData(
            primarySwatch: Colors.green,
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blue,
            ),
            splashFactory: InkRipple.splashFactory,
          ),
          child: stepper()
        ) ),

        //
        // Boton que abre la camara

       /*  floatingActionButton: _currentStep != 2
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.blue,
                child: Icon(Icons.send),
                onPressed: () => {alerta()}), */
      ),
    );
  }

  Stepper stepper() {
    return Stepper(
      steps: _stepper()!,
      physics: ClampingScrollPhysics(),
      currentStep: this._currentStep,
      onStepTapped: (step) {
        setState(() {
          this._currentStep = step;
        });
      },
      onStepContinue: () {
        setState(() {
          if (this._currentStep < this._stepper()!.length - 1) {
            if (this._currentStep == 0) {
              if (_formKey.currentState!.validate()) {
                this._currentStep = this._currentStep + 1;
                FocusScope.of(context).unfocus();
              }
            } else {
              if (idUser == 0) {
                if (chosenValue == null) {
                  Fluttertoast.showToast(
                      msg: "Elija comunidad",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 17.0);
                } else {
                  this._currentStep = this._currentStep + 1;
                  FocusScope.of(context).unfocus();
                }
              } else {
                this._currentStep = this._currentStep + 1;
                FocusScope.of(context).unfocus();
              }
            }
          } else {
           
              alerta();
            
          }
        });
      },
      onStepCancel: () {
        setState(() {
          if (this._currentStep > 0) {
            this._currentStep = this._currentStep - 1;
          } else {
            this._currentStep = 0;
          }
        });
      },

      controlsBuilder: (context, {onStepContinue, onStepCancel}){
        return Row(
          children : [
            _currentStep == 2 ? Expanded(child:Container(
              padding : EdgeInsets.only(left:10,top:10),
              child: RaisedButton(
                color: Colors.green,
                child: images.isEmpty ? Text('Omitir y Enviar', style: TextStyle(color: Colors.white),
                
                ): Text('Enviar', style: TextStyle(color: Colors.white),
                
                ),
                onPressed: onStepContinue,
              )
            )) : Expanded(child:Container(
              padding : EdgeInsets.only(left:10,top:10),
              child: RaisedButton(
                color: Colors.blue,
                child: Text('Siguiente', style: TextStyle(color: Colors.white),
                
                ),
                onPressed: onStepContinue,
              )
            )), 

            _currentStep >0 ? Expanded(child:Container(
              padding : EdgeInsets.only(left:10,top:10),
              child: RaisedButton(
                color: Colors.redAccent[700],
                child: Text('Atras', style: TextStyle(color: Colors.white),
                
                ),
                onPressed: onStepCancel,
              )
            )) : Container(),
          ]
        );
      }
    );
  }

//caracteristica  de cada step
  List<Step>? _stepper() {
    List<Step> _steps = <Step>[
      Step(
          title: Text('Nombre del reporte'),
          isActive: _currentStep >= 0,
          state: _currentStep == 0
              ? titleController.text.isEmpty
                  ? _listState[3]
                  : _listState[2]
              : _currentStep > 0
                  ? _listState[2]
                  : _listState[0],
          content: Column(
            children: [
              Form(
                key: _formKey,
                child: buildTitle(),
              ),
            ],
          ),
          subtitle : _currentStep == 0 ? Text('Este es el nombre que aparecera en la seccion de reportes') : null,
          ),
      Step(
          title: Text('Descripcion del incidente'),
          isActive: _currentStep >= 1,
          state: _currentStep == 1
              ? _listState[1]
              : _currentStep > 1
                  ? _listState[2]
                  : _listState[3],
          content: Column(
            children: [
              Form(
                key: _formKey2,
                child: buildComents(),
              ),
              idUser == 0
                  ? Container(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        elevation: 6,
                        value: chosenValue,
                        style: TextStyle(color: Colors.black),
                        items: idComName!
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (val) {
                          print(val);
                          print(chosenValue);
                          if (chosenValue == null) {
                            setState(() {
                              chosenValue = val;
                            });
                            sendId();
                          } else {
                            if (val != chosenValue) {
                              type.clear();
                              setState(() {
                                chosenValue = val;
                              });
                              sendId();
                            } else {
                              if (val == chosenValue) {
                              } else {
                                type.clear();
                                sendId();
                              }
                            }
                          }
                        },
                        hint: Text("Elige una comunidad",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                    )
                  : Container()
            ],
          ),
          subtitle : _currentStep == 1 ? Text('Este es el texto que aparecera en la seccion de reportes') : null,
          ),
      Step(
          title: Text('Sube algunas fotos'),
          content: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                images.isEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 100,
                        height: 100,
                        padding: EdgeInsets.all(5),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _optionsCamera();
                          },
                        ),
                      )
                    : Flexible(
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[300],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  images[0],
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 150,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    images.removeAt(0);
                                    newsPath.removeAt(0);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                images.length < 2
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 100,
                        height: 100,
                        padding: EdgeInsets.all(5),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _optionsCamera();
                          },
                        ),
                      )
                    : Flexible(
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[300],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  images[1],
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 150,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    images.removeAt(1);
                                    newsPath.removeAt(1);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                images.length < 3
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 100,
                        height: 100,
                        padding: EdgeInsets.all(5),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _optionsCamera();
                          },
                        ),
                      )
                    : Flexible(
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[300],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  images[2],
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 150,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    images.removeAt(2);
                                    newsPath.removeAt(2);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          subtitle : _currentStep == 2 ? Text('Las fotos ayudaran a detallar mejor su reporte') : null,
          state: _currentStep == 2
              ? _listState[1]
              : _currentStep > 2
                  ? _listState[2]
                  : _listState[3],
          isActive: _currentStep >= 2)
    ];
    return _steps;
  }

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent, shadowColor: Colors.transparent),
            onPressed: saveForm,
            icon: Icon(Icons.done),
            label: Text('Guardar'))
      ];
  //funcion que construye el titulo
  buildTitle() => TextFormField(
        cursorColor: Colors.black,

        onFieldSubmitted: (_) => saveForm(),
        //el controlles accede a propiedades como el texto
        controller: titleController,
        style: TextStyle(fontSize: 20),
        validator: (title) => title != null && title.isEmpty
            ? 'Este campo no puede estar vacio'
            : null,
        decoration: InputDecoration(
            icon: Icon(Icons.receipt),
            border: UnderlineInputBorder(),
            hintText: 'Nombre del incidente'),
      );
// funcion que construye los comentarios
  buildComents() => TextFormField(
        cursorColor: Colors.black,
        onFieldSubmitted: (_) => saveForm(),
        controller: descriptionController,
        style: TextStyle(fontSize: 20),
        validator: (title) => title != null && title.isEmpty
            ? 'Este campo no puede estar vacio'
            : null,
        decoration: InputDecoration(
            icon: Icon(Icons.receipt),
            //suffixIcon: Icon(Icons.check_circle_outline_sharp),
            helperText: 'Comente lo sucedido',
            border: UnderlineInputBorder(),
            hintText: 'Descripcion'),
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        inputFormatters: [new LengthLimitingTextInputFormatter(50)],
      );

  //funcion que abre la camara y muestra
  void openCamera() async {
    var image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 40);

    setState(() {
      if (image != null) {
        if (images.length == 3) {
          // muestra el mensaje de archivo excedido
          mensaje();
          Navigator.of(context).pop();
        } else {
          String dir = path.dirname(image.path);
          String newPath = path.join(dir, 'reportesAdcom.jpg');
          print(newPath);
          newsPath.add(newPath);
          images.add(File(image.path));
          addPlaceHolder();
        }
      } else {
        print('No se ha seleccionado una imagen');
      }
    });
  }

  addPlaceHolder() {
    for (int i = 0; i < 3; i++) {
      placeHoldersAdds.add(
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          width: 100,
          height: 100,
          padding: EdgeInsets.all(5),
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _optionsCamera();
            },
          ),
        ),
      );
    }
  }

  mensaje() => Fluttertoast.showToast(
      msg: "Maximo excedido",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 17.0);
  // funcion que abre la galeria para las fotos
  void openGallery() async {
    var image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 40);
    var i = 0;
    setState(() {
      if (image != null) {
        i++;
        String dir = path.dirname(image.path);
        String newPath = path.join(dir, 'reportesAdcom.jpg');
        print(newPath);
        newsPath.add(newPath);
        images.add(File(image.path));
      } else {
        print('No se ha seleccionado una imagen');
      }
    });
  }

  // mensaje alerta que advierte al usuario sobre los cambios
  alerta() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          context.loaderOverlay.show();
          saveForm().then((value) => {context.loaderOverlay.hide()});
        },
        child: Text(
          'Si, continuar',
          style: TextStyle(color: Colors.blue),
        ));
    Widget backButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'Regresar',
          style: TextStyle(color: Colors.blue),
        ));
    AlertDialog alert = AlertDialog(
      actions: [okButton, backButton],
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
              'Tus datos son correctos?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
                'Una vez realizado el reporte, no se podra editar y sera mandado a revisión')
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert);
  }

  // envia las fotos al serv mas toda su informacion que reqiere como los params

  sendingData2(String titulo, String descrip, List<File> files,
      List<String> newpath) async {
    // string to uri
    var uri = Uri.parse(
        "http://187.189.53.8:8081/backend/web/index.php?r=adcom/reportes");
    print("image upload URL - $uri");
// create multipart request
    var request = new http.MultipartRequest("POST", uri);
    for (var file in files) {
      String fileName = newsPath.last;
      var stream = new http.ByteStream(Stream.castFrom(file.openRead()));

      // get file length

      var length = await file.length(); //imageFile is your image file
      print("File lenght - $length");
      print("fileName - $fileName");
      // multipart that takes file
      var multipartFileSign =
          new http.MultipartFile('img[]', stream, length, filename: fileName);

      request.files.add(multipartFileSign);
    }

    print(titulo);
    print(descrip);
    print(idCom);
    print(idUser);

    print("params - ${json.encode({
          'descripcionCorta': titulo,
          'descripcionLarga': descrip,
          'idCom': idCom,
          'idUsusarioResidente': idUser
        })}");
//adding params
    request.fields['params'] = json.encode({
      'descripcionCorta': titulo,
      'descripcionLarga': descrip,
      'idCom': idCom,
      'idUsusarioResidente': idUser
    });

// send
    var response = await request.send();

    print(response.statusCode);

    var res = await http.Response.fromStream(response);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Item form is statuscode 200");
      print(res.body);
      var responseDecode = json.decode(res.body);

      return responseDecode;
    } else {
      if (response.statusCode == 400) {
        print("Item form is statuscode 400");
        print(res.body);
        return Fluttertoast.showToast(
            msg: "Error en el servidor, intente mas tarde",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print("Item form is statuscode 500");
        print(res.body);

        return Fluttertoast.showToast(
            msg: "Error en el servidor, intente mas tarde",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  /// Funcion que abre la camara
  Future<void> _optionsCamera() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [CloseButton()],
            title: Text('Seleccione una opción'),
            content: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: Column(
                      children: [
                        Icon(Icons.camera, size: 35),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Tomar foto')
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      openCamera();
                    },
                  ),
                  GestureDetector(
                    child: Column(
                      children: [
                        Icon(Icons.photo_rounded, size: 35),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Seleccionar foto')
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      openGallery();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  /// funcion que construye las fotos
  buildImage() => GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 150,
          crossAxisSpacing: 20,
        ),
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    images[index],
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      images.removeAt(index);
                      newsPath.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          );
        },
      );

  /// el save form hace la validacion de que todo este bien antes de enviar los datos
  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    final isValid2 = _formKey2.currentState!.validate();
    if (isValid && isValid2) {
      print('Si es valido');
      final report = Report(
          titulo: titleController.text,
          description: descriptionController.text,
          image: images,
          time: DateTime.now());
      final provider = Provider.of<EventProvider>(context, listen: false);
      final Response? response = await sendingData2(titleController.text,
              descriptionController.text, images, newsPath)
          .then((value) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Su reporte se ha realizado con exito!',
          style: TextStyle(fontSize: 19),
        )));
      });

      return response;
    }
  }

  /// obtiene el tipo de aviso en el caso de ser administrador o supervisor
  Future<TipoAviso?> getTipoAviso() async {
    print(idCom);
    print(idUser);
    final Uri url = Uri.parse(
        'http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-tipo-aviso');
    final response = await http.post(url, body: {"idCom": idCom.toString()});

    if (response.statusCode == 200) {
      var data = response.body;
      print(data);
      return tipoAvisoFromJson(data);
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
  }

  // ignore: unused_element
  _buildPageIndicator() {
    Row row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
    for (int i = 0; i < _slides!.length; i++) {
      row.children.add(_buildPageIndicatorItem(i));
      if (i != _slides!.length - 1)
        row.children.add(SizedBox(
          width: 12,
        ));
    }
    return row;
  }

  Widget _buildPageIndicatorItem(int index) {
    return Container(
      width: index == pages ? 8 : 5,
      height: index == pages ? 8 : 5,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == pages
              ? Color.fromRGBO(136, 144, 178, 1)
              : Color.fromRGBO(206, 209, 223, 1)),
    );
  }

  helpFunc() {
    Column(
      children: [
        Form(
          key: _formKey,
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reporte su incidente',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  buildTitle(),
                  SizedBox(
                    height: 20,
                  ),
                  buildComents(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ),
        images.isEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Presiona en',
                      style: TextStyle(
                        fontSize: 17,
                      )),
                  SizedBox(
                    width: 2,
                  ),
                  Icon(Icons.camera, size: 21),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    'para añadir fotos',
                    style: TextStyle(fontSize: 17),
                  )
                ],
              )
            : buildImage()
      ],
    );
  }
}

//
class Report {
  final String titulo;
  final String? nombre;
  final String description;
  final List<File>? image;
  final DateTime? time;

  const Report(
      {required this.titulo,
      this.nombre,
      this.time,
      required this.description,
      this.image});
}
