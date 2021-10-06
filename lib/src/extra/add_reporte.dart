import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:adcom/src/methods/slide.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';


SharedPreferences? prefs;
var cameras;
var firstCamera;

class AddReporte extends StatefulWidget {
  final Report? report;

  static init() async {
    cameras = await availableCameras();
    firstCamera = cameras.first;
  }

  AddReporte({Key? key, this.report}) : super(key: key);

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
  bool isLoading = false;
  int _currentStep = 0;
  int? idCom;
  int? idUser;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  

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

    
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: CloseButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
      //stepper, propiedades y acciones
      body: stepper(),

      //
      // Boton que abre la camara

      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: isLoading == true
              ? CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )
              : Icon(Icons.camera),
          onPressed: () => {
                HapticFeedback.lightImpact(),
                images.length == 3 ? mensaje() : _optionsCamera(),
              }),
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
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 30);

    setState(() {
      if (image != null) {
        if (images.length == 3) {
          // muestra el mensaje de archivo excedido
          mensaje();
          Navigator.of(context).pop();
        } else {
          images.add(File(image.path));
          print(images[0].path);
        }
      } else {
        print('No se ha seleccionado una imagen');
      }
    });
  }

  void openCamera2() async {
    var image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (image != null) {
      if (images.length == 3) {
        // muestra el mensaje de archivo excedido
        mensaje();
        Navigator.of(context).pop();
      } else {
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
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (image != null) {
        images.add(File(image.path));
        print('${images[0].path}');
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
          saveForm();
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
  sendingData(String titulo, String descrip, List<File> file) async {
    await addata();

    setState(() {
      isLoading = true;
    });

    try {
      List<String> filesArr = [];
      Dio dio = Dio();

      print(idCom.toString());
      print(idUser.toString());

      for (var item in file) {
        filesArr.add(item.path.split('/').last);
        print(filesArr[0]);
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
            MultipartFile.fromFileSync(file[i].path,
                filename: filesArr[i], contentType: MediaType('media', '*'))
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

  cargando() {
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : null;
  }

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

      final Response? response = await sendingData(
              titleController.text, descriptionController.text, images)
          .then((value) {
        setState(() {
          isLoading = false;
        });
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