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
import 'package:permission_handler/permission_handler.dart';
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
  getCameras() async {
    await Permission.camera.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    await Permission.mediaLibrary.request();
  }

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
  }

  @override
  void initState() {
    super.initState();
    addata();
    getCameras();
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
        body: LoaderOverlay(child: stepper()),

        //
        // Boton que abre la camara

        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            child: Icon(Icons.camera),
            onPressed: () => {
                  HapticFeedback.lightImpact(),
                  images.length == 3 ? mensaje() : _optionsCamera(),
                }),
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
            this._currentStep = this._currentStep + 1;
          } else {
            if (images.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Seccion de fotos vacia",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 17.0);
            } else {
              alerta();
            }
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
    );
  }

//caracteristica  de cada step
  List<Step>? _stepper() {
    List<Step> _steps = [
      Step(
          title: Text('Nombre del reporte'),
          isActive: _currentStep >= 0,
          state: StepState.complete,
          content: Column(
            children: [
              Form(
                key: _formKey,
                child: buildTitle(),
              ),
            ],
          )),
      Step(
          title: Text('Descripcion del incidente'),
          isActive: _currentStep >= 1,
          state: StepState.disabled,
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
                        items: widget.idComu!
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
          )),
      Step(
          title: Text('Sube algunas fotos'),
          content: images.isEmpty
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
              : buildImage(),
          state: StepState.disabled,
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
        }
      } else {
        print('No se ha seleccionado una imagen');
      }
    });
  }

  void openCamera2() async {
    var image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 40);
    var i = 0;
    if (image != null) {
      if (images.length == 3) {
        // muestra el mensaje de archivo excedido
        mensaje();
        Navigator.of(context).pop();
      } else {
        i++;
        String dir = path.dirname(image.path);
        String newPath = path.join(dir, 'reportesAdcom$i.jpg');
        print(newPath);
        newsPath.add(newPath);
        images.add(File(image.path));
        print(images[0].path);
      }
    } else {
      print('No se ha seleccionado una imagen');
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
        String newPath = path.join(dir, 'reportesAdcom$i.jpg');
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
  sendingData(String titulo, String descrip, List<File> file,
      List<String> newpath) async {
    try {
      List<String> filesArr = [];
      Dio dio = Dio();

      print('here${idCom}');
      print(idUser.toString());

      for (var item in newsPath) {
        print('$item');
        filesArr.add(item.split('/').last);
      }

      var formdata2 = FormData.fromMap({
        'params': json.encode({
          'descripcionCorta': titulo,
          'descripcionLarga': descrip,
          'idCom': idCom,
          'idUsusarioResidente': idUser
        }),
        'img[]': [
          for (int i = 0; i < file.length; i++)
            await MultipartFile.fromFile(file[i].path,
                filename: filesArr[i], contentType: MediaType('*', '*'))
          /*   await MultipartFile.fromFileSync(newsPath[i],
                filename: filesArr[i], contentType: MediaType('*', '*')) */
        ]
      });

      Response response = await dio.post(
          'http://187.189.53.8:8081/backend/web/index.php?r=adcom/reportes',
          data: formdata2, onSendProgress: (received, total) {
        if (total != 1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      });

      if (response.statusCode == 200) {
        print('aqui $response');
      }
    } on DioError catch (e) {
      if (e.response!.data == true) {
        print('aqui1:${e.response!.data.toString()}');
        return;
      } else {
        print('aqui2:${e.response!.data.toString()}');
      }
    }
  }

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
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));

      // get file length

      var length = await file.length(); //imageFile is your image file
      print("File lenght - $length");
      print("fileName - $fileName");
      // multipart that takes file
      var multipartFileSign =
          new http.MultipartFile('img[]', stream, length, filename: fileName);

      request.files.add(multipartFileSign);
    }
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

      if (responseDecode['status'] == true) {
        return res.body;
      } else {
        print(res.body);
        return res.body;
      }
    } else {
      print(res.body);
    }
  }

  Future<void> _optionsCamera() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [CloseButton()],
            title: Text('Seleccione una opción'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text(
                      'Tomar fotografía',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () => openCamera(),
                  ),
                  Divider(),
                  GestureDetector(
                    child: Text(
                      'Seleccionar una fotografía',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () => openGallery(),
                  )
                ],
              ),
            ),
          );
        });
  }

  buildImage() => GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 150,
          crossAxisSpacing: 20,
        ),
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.file(File(images[index].path));
        },
      );

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
        provider.addReport(report);
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
      print(response.body);
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
