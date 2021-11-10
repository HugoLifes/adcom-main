import 'dart:io';
import 'package:adcom/json/jsonSiguiemntos.dart';
import 'package:adcom/src/extra/add_reporte.dart';
import 'package:adcom/src/extra/reporte.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:async/src/delegate/stream.dart';

SharedPreferences? prefs;

// ignore: must_be_immutable
class ReportEditPage extends StatefulWidget {
  final int? id;
  final DataReporte report;
  final List<Progreso> data;
  final Progreso? idProgreso;

  /// variable que indiga el progreso actual del estatus.
  Map<dynamic, Map>? progreso;

  ///  variable que muestra los comentarios por progreso.
  Map<dynamic, Map>? datos;

  /// variables que muestra las fechas de los comentarios.
  Map<dynamic, Map>? fechas;

  Map? superMap = <dynamic, Map>{};

  ReportEditPage(
      {Key? key,
      required this.report,
      required this.data,
      this.datos,
      this.progreso,
      this.fechas,
      this.idProgreso,
      this.id})
      : super(key: key);

  @override
  _ReportEditPageState createState() => _ReportEditPageState();
}

class _ReportEditPageState extends State<ReportEditPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();
  var activestep = 0;
  List<dynamic> progreso = [];
  var data;
  List<ProgressIndicator> progres = [];
  List<DatosProgreso> datosp = [];
  bool finalizado = false;
  List<FechaReporte> f = [];
  bool mostrarCampoDescripcion = false;
  List<String>? newsPath = [];
  List<File> images = [];
  final _picker = ImagePicker();
  List<Text> nameFile = [];
  List<String> seguimientos = [];
  String? chosenValue;
  List<int> idS = [];
  int? id;
  int? idCom;
  int? usertype;

  userType() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      idCom = prefs?.getInt('idCom');
      usertype = prefs?.getInt('userType');
    });

    print(usertype);
    idSeguimiento().getIdSeguimiento().then((value) {
      for (int i = 0; i < value!.data!.length; i++) {
        seguimientos.add(value.data![i].descProgreso!);
        idS.add(value.data![i].idProgreso!);
      }
    });
  }

  /// funcion que retorna el estatus y lo asigna en arreglo
  /// recorre el mapeado de dos niveles
  estatus() {
    /// recorre el mapeado
    widget.progreso!.forEach((key, value) {
      if (widget.id == key) {
        /// recorre el segundo mapeado
        value.forEach((key, value) {
          if (key == 'Progreso') {
            setState(() {
              for (int i = 0; i < value.length; i++) {
                value.sort();
                progres.add(new ProgressIndicator(id: value[i]));
              }
            });
          }
        });
      } else {
        return;
      }
    });
  }

  ///mismo metodo que el mapeado del estatus
  /// chechar [estatus]
  datos() {
    widget.datos!.forEach((key, value) {
      if (widget.id == key) {
        value.forEach((key, value) {
          if (key == 'Datos') {
            setState(() {
              for (int i = 0; i < value.length; i++) {
                datosp.add(new DatosProgreso(coment: value[i]));
              }
            });
          }
        });
      } else {
        return;
      }
    });
  }

  ///Funcion para mapeado de fecha
  /// checar estatus
  fechasR() {
    widget.fechas!.forEach((key, value) {
      if (widget.id == key) {
        value.forEach((key, value) {
          if (key == 'Fechas') {
            setState(() {
              for (int i = 0; i < value.length; i++) {
                f.add(new FechaReporte(f: value[i]));
              }
            });
          }
        });
      }
    });
  }

  @override
  void initState() {
    /// carga los datos para poder procesarlos
    /// en lo que abre la pantalla
    userType();
    estatus();
    datos();
    fechasR();

    super.initState();
  }

  /// validacion que indica el exito de un proceso
  isFinalizado() {
    if (progres.isNotEmpty) {
      if (progres.last.id == 4) {
        setState(() {
          /// enciende estados como el click en el stepper
          finalizado = true;
        });
      } else {
        finalizado = false;
      }
    }
    return finalizado;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    //var size2 = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Seguimiento de reporte'),
            backgroundColor: Colors.blue,
            leading: CloseButton(),
          ),
          floatingActionButton: usertype == 4
              ? FloatingActionButton(
                  onPressed: () {
                    if (mostrarCampoDescripcion == false) {
                      setState(() {
                        mostrarCampoDescripcion = !mostrarCampoDescripcion;
                      });
                    }

                    if (mostrarCampoDescripcion == true) {
                      if (_formKey.currentState!.validate()) {
                        context.loaderOverlay.show();
                        sendingData2(textController.text, widget.id.toString(),
                                images, newsPath!)
                            .then((value) {
                          context.loaderOverlay.hide();
                          Navigator.of(context).pop();
                        });
                      }
                    } else {}
                  },
                  child: mostrarCampoDescripcion == false
                      ? Icon(Icons.edit)
                      : Icon(Icons.keyboard_arrow_right),
                  backgroundColor: Colors.blue,
                )
              : null,
          body: LoaderOverlay(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Stack(
                children: [
                  ListView(
                    children: [
                      IconStepper(
                        enableStepTapping: isFinalizado(),
                        icons: [
                          Icon(Icons.supervised_user_circle),
                          Icon(Icons.check),
                          Icon(Icons.flag),
                          Icon(Icons.access_alarm),
                          Icon(Icons.check)
                        ],
                        activeStep: progres.isEmpty ? 0 : progres.last.id,
                        onStepReached: (index) {
                          setState(() {
                            if (progres.isEmpty) {
                              activestep = index;
                            } else {
                              progres.last.id = index;
                            }
                          });
                        },
                      ),
                      header(),
                      help(),
                      plainText(size),
                      SizedBox(
                        height: size * 0.1,
                      ),
                      mostrarCampoDescripcion
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textBoxResponse(),
                                SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    _optionsCamera();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Row(
                                        children: [
                                          Icon(Glyphicon.file_plus_fill),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Sube un archivo',
                                            style: TextStyle(),
                                          ),
                                        ],
                                      )),
                                ),
                                elejirSeguiminto(),
                                SizedBox(
                                  height: 5,
                                ),
                                newFiles(),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  newFiles() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        children: nameFile,
      ),
    );
  }

  /// funcion que muesta el encabezado del proceso
  /// [setpColor] sirve para cambiar el color segun el proceso
  Widget header() {
    return Container(
      decoration: BoxDecoration(
          color: stepColor(), borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(9.0),
            child: Text(
              'Status: ${headerText()!}',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  /// Switch case que muestra el estatus del reporte
  /// cada case es un caso del proceso del 1 al 4
  Widget plainText(size) {
    switch (progres.isEmpty ? 0 : progres.last.id) {
      case 1:
        return datosp.isEmpty
            ? Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Administrador:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Tu reporte se encuentra en revision',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                    )
                  ],
                ),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text('Comentarios Admin:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),
                    respuestaView(size),
                  ],
                ),
              );
      case 2:
        return datosp.isEmpty
            ? Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Asesor:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Tu reporte esta siendo procesado',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                    )
                  ],
                ),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text('Comentarios Admin:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),
                    respuestaView(size),
                  ],
                ),
              );
      case 3:
        return datosp.isEmpty
            ? Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Asesor:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'No hay comentarios',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                    )
                  ],
                ),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text('Respuesta de Asesor:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),
                    respuestaView(size),
                  ],
                ),
              );
      case 4:
        return datosp.isEmpty
            ? Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Asesor:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Tu reporte se ha atendido y ha finalizado con éxito',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                    )
                  ],
                ),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text('Respuestas:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          )),
                    ),
                    respuestaView(size),
                  ],
                ),
              );
      default:
        return Container();
    }
  }

  /// es la vista de la respuesta
  respuestaView(size) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(datosp.length, (index) {
          return Container(
            padding: EdgeInsets.only(left: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${f[index].f!.day}/${f[index].f!.month}/${f[index].f!.year}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: size / 2,
                  child: Text(
                    '${datosp[index].coment}',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  textBoxResponse() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 80),
      height: 60,
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: textController,
          maxLines: 200,
          validator: (title) => title != null && title.isEmpty
              ? 'Este campo no puede estar vacio'
              : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: 'Escribe tu respuesta',
          ),
        ),
      ),
    );
  }

  ///  funcion que cambia de color segun en el estatus
  Color? stepColor() {
    switch (progres.isEmpty ? 0 : progres.last.id) {
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.lightGreen[200];
      case 3:
        return Colors.lightGreen[300];
      case 4:
        return Colors.lightGreen;

      default:
        return Colors.grey;
    }
  }

  ///muesta el nombre segun el estatus
  String? headerText() {
    switch (progres.isEmpty ? 0 : progres.last.id) {
      case 1:
        return 'Revisión';
      case 2:
        return 'En proceso';
      case 3:
        return 'Respuesta';
      case 4:
        return 'Finalizado';
      default:
        return 'Enviado';
    }
  }

  /// funcion que constuye la imagen o la cantidad de imagenes
  buildImage() => Row(
        children: List.generate(
          widget.report.uri!.length,
          (index) {
            return Container(
              child: FadeInImage.memoryNetwork(
                  width: 120,
                  height: 120,
                  placeholder: kTransparentImage,
                  image: widget.report.uri![index]),
            );
          },
        ),
      );

  ///muestra el titulo del reporte y las imagenes del reporte
  /// chechar buildImage para cualquier detalle de imagenes
  help() {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.report.descripCorta!,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(right: 200),
              child: Text(
                widget.report.desperfecto!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            ),
            buildImage(),
          ],
        ),
      ),
    );
  }

  openCamera() async {
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
          String newPath = path.join(dir, 'respuestaAdcom.jpg');
          print(newPath);
          newsPath!.add(newPath);
          images.add(File(image.path));
        }
      } else {
        print('No se ha seleccionado una imagen');
      }
    });
    return images;
  }

  Future<List<File?>?> filePick() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      images = result.paths.map((path) => File(path!)).toList();
      newsPath = result.paths.map((path) => path!).toList();
      return images;
    } else {
      Fluttertoast.showToast(
          msg: "No selecciono archivos",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 17.0);
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

  /// funcion que muesrtra los botones de la camara y la galeria
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
                      onTap: () {
                        openCamera().then((value) => {
                              if (value != null)
                                {
                                  for (var item in value)
                                    {
                                      nameFile.add(
                                          Text('${item!.path.split('/').last}'))
                                    }
                                }
                              else
                                {print('no selecciono nada')}
                            });
                        setState(() {
                          nameFile;
                        });
                      }),
                  Divider(),
                  GestureDetector(
                      child: Text(
                        'Seleccionar varios archivos',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        filePick().then((value) => {
                              if (value != null)
                                {
                                  for (var item in value)
                                    {
                                      nameFile
                                          .add(Text(item!.path.split('/').last))
                                    }
                                }
                              else
                                {print('No selecciono archivos')}
                            });
                        setState(() {
                          nameFile;
                        });
                      })
                ],
              ),
            ),
          );
        });
  }

  /// funcion que envia el reporte
  sendingData2(String titulo, String descrip, List<File> files,
      List<String> newpath) async {
    prefs = await SharedPreferences.getInstance();

    var userId = prefs!.getInt('userId');
    // string to uri
    var uri = Uri.parse(
        "http://187.189.53.8:8081/backend/web/index.php?r=adcom/registrar-seguimiento");
    print("image upload URL - $uri");
// create multipart request
    var request = new http.MultipartRequest("POST", uri);
    for (var file in files) {
      String fileName = newsPath!.last;
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));

      // get file length

      var length = await file.length(); //imageFile is your image file
      print("File lenght - $length");
      print("fileName - $fileName");
      // multipart that takes file
      var multipartFileSign = new http.MultipartFile(
          'archivos[]', stream, length,
          filename: fileName);

      request.files.add(multipartFileSign);
    }

    print(widget.id);
    print(textController.text);
    print(userId);
    print(id);
    print(widget.idProgreso);

//adding params
    request.fields['data'] = json.encode({
      // Falta mandar idCaso, IdSeguimiento
      'IdCaso': widget.id,
      'coment': textController.text,
      'usuarioId': userId,
      'idSeguimiento': id,
    });

    //Send
    var response = await request.send();

    print(response.statusCode);

    var res = await http.Response.fromStream(response);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Item form is statuscode 200");
      print(res.body);
      var responseDecode = json.decode(res.body);

      print(responseDecode);
    } else {
      print(res.body);
    }
  }

  elejirSeguiminto() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: DropdownButton<String>(
        elevation: 6,
        value: chosenValue,
        style: TextStyle(color: Colors.black),
        items: seguimientos.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (val) {
          print(val);
          print(chosenValue);
          if (chosenValue == null) {
            setState(() {
              chosenValue = val;
            });
            next();
          } else {
            if (val != chosenValue) {
              setState(() {
                chosenValue = val;
              });

              next();
            } else {
              if (val == chosenValue) {
              } else {
                next();
              }
            }
          }
        },
        hint: Text("Elige el seguimiento",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  next() {
    for (int i = 0; i < seguimientos.length; i++) {
      if (chosenValue == seguimientos[i]) {
        setState(() {
          id = idS[i];
        });
        print(id);
      }
    }
  }
}

/// obtiene los seguimientos de un caso
class idSeguimiento {
  int? id;

  idSeguimiento({this.id});

  Future<Seguimiento?> getIdSeguimiento() async {
    Uri uri = Uri.parse(
        'http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-status-progreso');
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      return seguimientoFromJson(response.body);
    } else {
      print(response.body);
    }
  }
}

class ProgressIndicator {
  var id;

  ProgressIndicator({this.id});
}

class FechaReporte {
  DateTime? f;

  FechaReporte({this.f});
}

class DatosProgreso {
  var coment;

  DatosProgreso({this.coment});
}
