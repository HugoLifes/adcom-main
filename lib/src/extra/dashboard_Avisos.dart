import 'dart:io';

import 'package:adcom/src/pantallas/avisos.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:external_path/external_path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class AvisosDashboard extends StatefulWidget {
  List<AvisosUsuario>? avisos = [];
  List? links;
  List? name;
  AvisosDashboard({
    Key? key,
    this.links,
    this.name,
    this.avisos,
  }) : super(key: key);

  @override
  _AvisosDashboardState createState() => _AvisosDashboardState();
}

class _AvisosDashboardState extends State<AvisosDashboard> {
  List<Avisos> list = [];
  List<dynamic> names = [];
  List<dynamic> links = [];
  VoidCallback? _showPersBottomSheetCallBack;
  bool downloading = false;
  String progress = '0';
  bool isDownloaded = false;

  @override
  void initState() {
    _showPersBottomSheetCallBack = _showPersBottomSheetCallBack;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return widget.avisos!.isEmpty ? Container() : viewAvisos(size: size);
  }

  viewAvisos({size}) {
    return Flexible(
        child: GridView.builder(
            padding: EdgeInsets.only(),
            itemCount: widget.avisos!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.65,
              crossAxisSpacing: 25,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (_, int data) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: Color(0xFF455A64).withOpacity(0.3))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    whoPublish(size),
                    Divider(
                      color: Color(0xFF455A64).withOpacity(0.3),
                    ),
                    postMessage(data, size),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Color(0xFF455A64).withOpacity(0.3),
                    ),
                  ],
                ),
              );
            }));
  }

  Container postMessage(int data, size) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: size / 50),
            child: Text(
              'Comunicado! ${widget.avisos![data].avisos}',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              _showModalSheet(data);
            },
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Icon(Glyphicon.download),
                SizedBox(
                  width: size / 24,
                ),
                Text(
                  'Archivo adjunto...',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showModalSheet(int data) {
    if (names.length == widget.name![data].length) {
    } else {
      for (int i = 0; i < widget.name![data].length; i++) {
        names.add(widget.name![data][i]);
      }
    }

    if (links.length == widget.links![data].length) {
      print('here${links.length}');
      print(' ya no cabe');
    } else {
      for (int i = 0; i < widget.links![data].length; i++) {
        links.add(widget.links![data][i]);

        print(links[i]);
      }
    }

    showModalBottomSheet(
        elevation: 5,
        isDismissible: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) => Container(
              height: 300,
              alignment: Alignment.center,
              child: DraggableScrollableSheet(
                  maxChildSize: 0.9,
                  initialChildSize: 0.9,
                  expand: true,
                  builder: (_, controller) => Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Descarga Archivos',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Flexible(
                              child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      color: Colors.black,
                                    );
                                  },
                                  itemCount: names.length,
                                  itemBuilder: (_, int index) {
                                    return TextButton(
                                      onPressed: () async {
                                        download2(links[index], names[index])
                                            .then((value) {
                                          Fluttertoast.showToast(
                                              msg: "Archivo en Descargas",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.white,
                                              textColor: Colors.black,
                                              fontSize: 17.0);
                                        });
                                        /* downloadLink(
                                            links[index], names[index]); */
                                      },
                                      child: Text('${names[index]}'),
                                    );
                                  }))
                        ],
                      )),
            )).then((value) => {names.clear()});
  }

  Future<void>? downloadLink(link, names) async {
    setState(() {
      downloading = true;
    });
    Dio dio = Dio();
    String savePath = await getPath(names);

    print('${savePath}');
    print('aquui');
    String urlPath = link;
    dio.download(
      urlPath,
      savePath,
      onReceiveProgress: (rcv, total) {
        print(
            'received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');

        setState(() {
          progress = ((rcv / total) * 100).toStringAsFixed(0);
        });

        if (progress == '100') {
          setState(() {
            isDownloaded = true;
          });
        } else if (double.parse(progress) < 100) {
          print('aqui');
        }
      },
      deleteOnError: true,
    ).then((_) {
      setState(() {
        if (progress == '100') {
          isDownloaded = true;
        }

        downloading = false;
      });
    }).onError((error, stackTrace) {
      print('$error');
    });
  }

  Future download2(String url, String names) async {
    Dio dio = Dio();

    String savePath = await getPath(names);
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Future<String> getPath(names) async {
    String path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);

    print(path);
    var filePath = path + '/$names';

    return filePath;
  }

  Container whoPublish(size) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10),
      child: Row(
        children: [
          Container(
            height: 51,
            width: size / 9,
            decoration:
                BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
            child: Image.asset('assets/images/logo.png'),
          ),
          SizedBox(
            width: size / 45,
          ),
          Text(
            'Administrador',
            style: (TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }
}

class Links {
  var links;

  Links({this.links});
}

class NameLinks {
  var names;
  NameLinks({this.names});
}
