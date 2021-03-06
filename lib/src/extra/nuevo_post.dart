import 'dart:convert';
import 'dart:io';
import 'package:adcom/src/methods/exeptions.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:adcom/json/tipoAvisot.dart';
import 'package:adcom/src/pantallas/avisos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:loader_overlay/loader_overlay.dart';
SharedPreferences? prefs;

// ignore: must_be_immutable
class MakeNewPost extends StatefulWidget {
  MakeNewPost({Key? key, this.idComu, this.comunities}) : super(key: key);
  List<String>? idComu;
  List<AvisosCall>? comunities = [];
  @override
  _MakeNewPostState createState() => _MakeNewPostState();
}

class _MakeNewPostState extends State<MakeNewPost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  String? chosenValue;
  String? chosenValue2;
  int? idCom;
  List<File> file = [];
  int? idA;
  List<TipoAvisoS> avisos = [];
  List<Text>? nameFile = [];
  List<String>? nameFile2 = [];
  List<String> type = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[700],
        onPressed: () async {
          FocusScope.of(context).unfocus();
          HapticFeedback.lightImpact();
          onSave(context);
        },
        child: Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text('Nuevo Post'),
        automaticallyImplyLeading: false,
        elevation: 4.0,
        backgroundColor: Colors.blueGrey[700],
        leading: CloseButton(),
      ),
      body: LoaderOverlay(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: ListView(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 15),
                        child: Container(
                          height: 51,
                          width: size.width / 9,
                          decoration: BoxDecoration(
                              color: Colors.grey[300], shape: BoxShape.circle),
                          child: Image.asset(
                            'assets/images/logo.png',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 55,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.width / 39),
                        child: Text('Administrador',
                            style: (TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500))),
                      ),
                      SizedBox(
                        width: size.width / 6,
                      ),
                      drop()
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                            controller: titleController,
                            onFieldSubmitted: (_) => onSave(context),
                            validator: (title) => title != null && title.isEmpty
                                ? 'Este campo no puede estar vacio'
                                : null,
                            autofocus: true,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              labelText: "??Algo para decir?",
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      BorderSide(color: Color(0xFF455A64))),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(200)
                            ]),
                      )),
                  SizedBox(
                    height: size.width / 20,
                  ),
                  Divider(
                    color: Color(0xFF455A64).withOpacity(0.3),
                    thickness: 1.1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: InkWell(
                      onTap: () async {
                        Fluttertoast.showToast(
                            msg: "Mantenga Presionado el archivo",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            fontSize: 17.0);

                        /// funcion que toma el archivo y despues de terminar la funcion guarda el archivo en un arreglo
                        await filePick().then((value) => {
                              if (value != null)
                                {
                                  for (var item in value)
                                    {
                                      print(
                                          'here ${item!.path.split('/').last}'),
                                      nameFile!
                                          .add(Text(item.path.split('/').last)),
                                      nameFile2!.add(item.path.split('/').last),
                                    }
                                }
                              else
                                {print('no existe')}
                            });
                        setState(() {
                          // actualiza los datos despues de terminar la funcion
                          newFiles();
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Glyphicon.paperclip,
                                color: Colors.pink,
                                size: 25,
                              ),
                              SizedBox(
                                width: size.width / 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Selecciona varios archivos',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: size.width / 20,
                                  ),

                                  /// si el arreglo de archivos no esta vacio muestra los archivos
                                  nameFile!.isEmpty ? Container() : newFiles()
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.width / 15,
                    child: Divider(
                      color: Color(0xFF455A64).withOpacity(0.3),
                      thickness: 1.1,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: DropdownButton<String>(
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
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  drop() {
    return chosenValue == null
        ? Container()
        : Container(
            padding: EdgeInsets.only(top: 10),
            child: DropdownButton<String>(
              focusColor: Colors.white,
              value: chosenValue2,
              //elevation: 5,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: type.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              hint: Text(
                "Tipo aviso",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              onChanged: (value) {
                setState(() {
                  chosenValue2 = value;
                });

                getIdAviso();
              },
            ),
          );
  }

  Column newFiles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: nameFile!,
    );
  }

  getIdAviso() {
    for (int i = 0; i < avisos.length; i++) {
      if (chosenValue2 == avisos[i].tipoAviso) {
        setState(() {
          idA = avisos[i].idCatTipoAviso!;
        });
      }
    }
  }

  Future sendId() async {
    for (int i = 0; i < widget.comunities!.length; i++) {
      if (chosenValue == widget.comunities![i].nombreComu) {
        setState(() {
          idCom = widget.comunities![i].id;
        });
      }
    }

    await getTipoAviso()
        .then((value) => {
              for (int i = 0; i < value!.data!.length; i++)
                {
                  type.add(value.data![i].tipoAviso!),
                  avisos.add(new TipoAvisoS(
                      tipoAviso: value.data![i].tipoAviso,
                      idCatTipoAviso: value.data![i].idCatTipoaviso,
                      idCom: value.data![i].idCom))
                }
            })
        .then((value) => {
              setState(() {
                drop();
              })
            });
  }

  Future<List<File?>?> filePick() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      file = result.paths.map((path) => File(path!)).toList();
      print(file.first);
      return file;
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

  Future onSave(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();
    prefs = await SharedPreferences.getInstance();
    var id = prefs!.getInt('idPrimario');
    if (isValid) {
      if (chosenValue != null && chosenValue2 != null) {
        /*  await sendingData(idCom!, titleController.text, nameFile!, id!, idA!)
            .then((value) => {
                  Navigator.of(context).pop(),
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    'Su reporte se ha realizado con exito!',
                    style: TextStyle(fontSize: 19),
                  )))
                }); */
        context.loaderOverlay.show();
        await sendingData2(
                idCom!, titleController.text, file, id!, idA!, nameFile2!)
            .then((value) => {
                  context.loaderOverlay.hide(),
                  Navigator.of(context).pop(),
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    'Su aviso se ha realizado con exito!',
                    style: TextStyle(fontSize: 19),
                  )))
                });
      } else {
        Fluttertoast.showToast(
            msg: "Seleccione comunidad",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 17.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Sus datos son incorrectos",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 17.0);
    }
  }

  Future sendingData(
    int idCom,
    String aviso,
    List<Text> nameFile,
    int id,
    int idA,
  ) async {
    try {
      List<String> filesArr = [];
      Dio dio = Dio();

      for (var item in file) {
        print(file.length);
        filesArr.add(item.path.split('/').last);
      }
      print('filesArr: $filesArr');
      var formdata2 = FormData.fromMap({
        'params': json.encode(
            {'userId': id, 'comId': idCom, 'tipoAvisoId': idA, 'aviso': aviso}),
        'archivos[]': [
          for (int i = 0; i < file.length; i++)
            MultipartFile.fromFileSync(file[i].path,
                filename: filesArr[i], contentType: MediaType('*', '*'))
        ]
      });
      Response response = await dio.post(
          'http://www.adcom.mx:8081/backend/web/index.php?r=adcom/crear-aviso',
          data: formdata2, onSendProgress: (received, total) {
        if (total != 1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      });

      if (response.statusCode == 200) {
        print('aqui $response');
      }
    } on DioError catch (e) {
      throw FetchDataException('$e');
    }
  }

  Future sendingData2(int idCom, String aviso, List<File> nameFile, int id,
      int idA, List<String> newpath) async {
    // string to uri
    var uri = Uri.parse(
        "http://www.adcom.mx:8081/backend/web/index.php?r=adcom/crear-aviso");
    print("image upload URL - $uri");
// create multipart request
    var request = new http.MultipartRequest("POST", uri);
    for (var file in nameFile) {
      String fileName = newpath.first;
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

    print(idA);
    print(aviso);
    print(idCom);
    print(id);

    print("params - ${json.encode({
          'userId': id,
          'comId': idCom,
          'tipoAvisoId': idA,
          'aviso': aviso
        })}");
//adding params
    request.fields['params'] = json.encode(
        {'userId': id, 'comId': idCom, 'tipoAvisoId': idA, 'aviso': aviso});

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

  /// funcion que obtiene el tipo de aviso
  /// "Infotmativo"
  /// "Importante"
  Future<TipoAviso?> getTipoAviso() async {
    try {
      final Uri url = Uri.parse(
          'http://www.adcom.mx:8081/backend/web/index.php?r=adcom/get-tipo-aviso');
      final response = await http.post(url, body: {"idCom": idCom.toString()});

      var data = returnResponse(response);
      print(data);
      return tipoAvisoFromJson(data);
    } on SocketException {
      throw FetchDataException('');
    }
  }
}

class TipoAvisoS {
  int? idCatTipoAviso;
  String? tipoAviso;
  int? idCom;

  TipoAvisoS({this.idCatTipoAviso, this.idCom, this.tipoAviso});
}