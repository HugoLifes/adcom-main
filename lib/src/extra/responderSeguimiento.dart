import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

// ignore: must_be_immutable
class ResponseSeguimiento extends StatefulWidget {
  List<String>? seguimiento;
  List<int>? idS = [];
  int? id;
  ResponseSeguimiento({Key? key, this.seguimiento, this.idS, this.id})
      : super(key: key);

  @override
  _ResponseSeguimientoState createState() => _ResponseSeguimientoState();
}

class _ResponseSeguimientoState extends State<ResponseSeguimiento> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();
  List<Text> nameFile = [];
  List<String>? newsPath = [];
  List<File> images = [];
  String? chosenValue;
  int? id;

  var _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responder Seguimiento'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (chosenValue != null) {
              context.loaderOverlay.show();
              sendingData2(textController.text, widget.id.toString(), images,
                      newsPath!)
                  .then((value) {
                context.loaderOverlay.hide();
                Navigator.of(context).pop();
              });
            } else {
              Fluttertoast.showToast(
                  msg: 'Elija un seguimiento',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        },
      ),
      body: LoaderOverlay(
        child: Container(
          padding: EdgeInsets.only(top: 30),
          child: Column(
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
              printImages(),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text('Instrucciones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , ),textAlign: TextAlign.justify,),
                    ),
                   
                      SizedBox(
                        height: 10,
                      ),
                       Padding(
                         padding: const EdgeInsets.only(left: 10),
                         child: Text('Es importante elegir primero los archivos que quiere usar y después las fotos, no olvide asignar un seguimiento de lo contrario no podra\ncontinuar con el mismo.', style: TextStyle(fontSize: 18),),
                       ),
                  
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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

  elejirSeguiminto() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: DropdownButton<String>(
        elevation: 6,
        value: chosenValue,
        style: TextStyle(color: Colors.black),
        items:
            widget.seguimiento!.map<DropdownMenuItem<String>>((String value) {
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
    for (int i = 0; i < widget.seguimiento!.length; i++) {
      if (chosenValue == widget.seguimiento![i]) {
        setState(() {
          id = widget.idS![i];
        });
        print(id);
      }
    }
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
                                      nameFile.add(
                                          Text('${item!.path.split('/').last}'))
                                    }
                                }
                              else
                                {print('No selecciono archivos')}
                            });
                      })
                ],
              ),
            ),
          );
        });
  }

  Future<List<File?>?> openCamera() async {
    var image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 40);

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
        setState(() {
          images.add(File(image.path));
        });

        return images;
      }
    } else {
      print('No se ha seleccionado una imagen');
    }
  }

  Future<List<File?>?> filePick() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true  type: FileType.any  );

    if (result != null) {
      images.addAll(result.paths.map((path) => File(path!)));
      newsPath = result.paths.map((path) => path!.split('/').last).toList();
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

  printImages() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        children: images.map((file) {
          return Text(file.path.split('/').last);
        }).toList(),
      ),
    );
  }

  mensaje() => Fluttertoast.showToast(
      msg: "Maximo excedido",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 17.0);

  Future sendingData2(String titulo, String descrip, List<File> files,
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
      String fileName = file.path.split('/').last;
      var stream = new http.ByteStream(Stream.castFrom(file.openRead()));

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
}