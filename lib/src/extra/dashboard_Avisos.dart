import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:adcom/src/pantallas/avisos.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:external_path/external_path.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:open_file/open_file.dart';
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
  List<AvisosUsuario>? avisosRevers = [];
  List<dynamic> namesRev = [];
  List<dynamic> linksrev = [];
  var filePath;
  ReceivePort _receivePort = ReceivePort();
  reversedList() {
    avisosRevers = widget.avisos!.reversed.toList();
    namesRev = widget.name!.reversed.toList();
    linksrev = widget.links!.reversed.toList();
  }

  @override
  void initState() {
    _showPersBottomSheetCallBack = _showPersBottomSheetCallBack;
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "Descargando");

    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
    });
    FlutterDownloader.registerCallback(downloadCallback);
    reversedList();
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
            padding: EdgeInsets.only(left: 10, right: 10, top: 20),
            itemCount: avisosRevers!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.65,
              crossAxisSpacing: 29,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (_, int data) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 7,
                          offset: Offset(0, 5))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    whoPublish(data, size),
                    Divider(
                      color: Color(0xFF455A64).withOpacity(0.3),
                    ),
                    postMessage(data, size),
                    SizedBox(
                      height: 10,
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
              '${avisosRevers![data].avisos}',
              style: TextStyle(fontSize: size / 20),
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
    if (names.length == namesRev[data].length) {
    } else {
      for (int i = 0; i < namesRev[data].length; i++) {
        names.add(namesRev[data][i]);
      }
    }

    if (links.length == linksrev[data].length) {
      print('here${links.length}');
      print(' ya no cabe');
    } else {
      for (int i = 0; i < linksrev[data].length; i++) {
        links.add(linksrev[data][i]);

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
                                        try {
                                          download2(links[index], names[index])
                                              .then((value) {
                                            Fluttertoast.showToast(
                                                msg: "Descargando",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                fontSize: 17.0);
                                          });
                                        } catch (e) {
                                          print(e);
                                        }
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
    await OpenFile.open(filePath);
  }

  download3(String url, String names) async {
    final externalDir = await getExternalStorageDirectory();
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: externalDir!.path,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );

    return taskId;
  }

  static downloadCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("Descargando");

    sendPort!.send([id, status, progress]);
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Future<String> getPath(names) async {
    Directory path = await getApplicationDocumentsDirectory();

    print(path.path);

    setState(() {
      filePath = path.path + '/$names';
    });

    return filePath;
  }

  Container whoPublish(data, size) {
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
          ),
          SizedBox(
            width: size / 35,
          ),
          Text(
              '${avisosRevers![data].fecha!.day}/${avisosRevers![data].fecha!.month}/${avisosRevers![data].fecha!.year}')
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
