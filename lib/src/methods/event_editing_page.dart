import 'dart:convert';
import 'dart:io';
import 'package:adcom/src/methods/exeptions.dart';
import 'package:http/http.dart' as http;
import 'package:adcom/json/jsonAmenidadReserva.dart';
import 'package:adcom/src/extra/reporte.dart';
import 'package:adcom/src/models/event.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? preferences;

class EventEditingPage extends StatefulWidget {
  final Event? event;
  final int? id;
  EventEditingPage({Key? key, this.event, this.id}) : super(key: key);

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

//intentar llamar id Amenidad de otra manera

class _EventEditingPageState extends State<EventEditingPage> {
  late DateTime fromDate;
  late DateTime toDate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  int? idCom;
  int? idUser;
  int? idAm;
  bool apartado = false;
  bool maxHoras = false;
  bool error = false;

  Future<ReservaData?> getReserva() async {
    try {
      prefs = await SharedPreferences.getInstance();

      Uri uri = Uri.parse(
          'http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-amenidad-reserva');

      final response = await http
          .post(uri, body: {"idAmenidad": "${widget.id}"}).timeout(
              Duration(seconds: 8), onTimeout: () {
        return http.Response('Timeout', 408);
      });

      var data = returnResponse(response);

      return reservaDataFromJson(data);
    } on SocketException {
      throw FetchDataException('Error server conection');
    }
  }

  addata() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      idCom = prefs!.getInt('idCom');
      idUser = prefs!.getInt('userId');
    });
  }

  id() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      idAm = prefs!.getInt('idAmenidad');
    });
  }

  @override
  void initState() {
    super.initState();
    print('here${widget.id}');
    addata();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    } else {
      final event = widget.event!;
      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: buildEditingActions(),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              SizedBox(
                height: 12,
              ),
              buildDateTimePickers()
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent, shadowColor: Colors.transparent),
            onPressed: saveForm,
            icon: Icon(Icons.done),
            label: Text('Guardar'))
      ];

  buildTitle() => TextFormField(
        onFieldSubmitted: (_) => saveForm(),
        controller: titleController,
        style: TextStyle(fontSize: 20),
        validator: (title) => title != null && title.isEmpty
            ? 'Este campo no puede estar vacio'
            : null,
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Nombre del evento'),
      );

  buildDateTimePickers() => Column(
        children: [
          buildForm(),
          buildTo(),
        ],
      );

  buildForm() => buildHeader(
        header: 'DE',
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: buildDropdownField(
                  text: Utils.toDate(fromDate),
                  onClicked: () => pickFromDateTime(pickDate: true),
                )),
            Expanded(
                child: buildDropdownField(
              text: Utils.toTime(fromDate),
              onClicked: () => pickFromDateTime(pickDate: false),
            ))
          ],
        ),
      );

  buildDropdownField({required String text, required VoidCallback onClicked}) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({required String header, required Widget child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          child
        ],
      );

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      print('si es valido');
      final event = Event(
          title: titleController.text,
          from: fromDate,
          to: toDate,
          description: 'Description',
          isAllDay: false);

      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      await getReserva().then((value) {
        var dateFormat = DateFormat("yyy-MM-dd hh:mm");
        var newFromDate = dateFormat.format(fromDate);
        var newToDate = dateFormat.format(toDate);

        for (int i = 0; i < value!.data!.reservas!.length; i++) {
          /// formato a la fecha inicial que tomo del service
          var newFechaReserva =
              dateFormat.format(value.data!.reservas![i].fechaIni!);

          /// formato de la fecha final que tomo del service
          var fechaFinal =
              dateFormat.format(value.data!.reservas![i].fechafinEvent!);

          if (fromDate.difference(toDate).inHours < 6 || widget.id != 2) {
            //checa si no esta sobre puesta una agenda

            if (fromDate.isAtSameMomentAs(value.data!.reservas![i].fechaIni!) ||
                toDate.isAtSameMomentAs(
                    value.data!.reservas![i].fechafinEvent!)) {
              print('here');
              setState(() {
                apartado = true;
                maxHoras = false;
              });
            } else {
              if (fromDate.isAfter(value.data!.reservas![i].fechaIni!) &&
                  fromDate.isBefore(value.data!.reservas![i].fechafinEvent!)) {
                print("porque");
                setState(() {
                  apartado = true;
                  maxHoras = false;
                });
                return apartado;
              } else {
                if (toDate.isAfter(value.data!.reservas![i].fechaIni!) &&
                    toDate.isBefore(value.data!.reservas![i].fechafinEvent!)) {
                  setState(() {
                    apartado = true;
                    maxHoras = false;
                  });
                  return apartado;
                } else {
                  if (value.data!.reservas![i].fechaIni!.isAfter(fromDate) &&
                      value.data!.reservas![i].fechafinEvent!
                          .isBefore(toDate)) {
                    setState(() {
                      apartado = true;
                      maxHoras = false;
                    });
                  } else {
                    setState(() {
                      apartado = false;
                      apartado = false;
                    });
                  }
                }
              }
            }

            //falta validar sobre una fecha

          } else {
            print('Limite de apartado son 6 horas, en palapas');
            setState(() {
              apartado = true;
              maxHoras = true;
            });
          }
        }
      }).catchError((e) {
        errors();
      });

      if (apartado == true) {
        alerta5();
      } else {
        final Response? response = await sendingData(
          titleController.text,
          fromDate,
          toDate,
        ).then((value) {
          /* if (isEditing) {
          provider.editEvent(event, widget.event!);
        } */
          ///navegar hacia atras y actualizar
          Navigator.pop(context);
        }).catchError((e) {
          errors();
        });
        return response;
      }
    } else {
      print('no es valido');
    }
  }

  Future sendingData(
    String titulo,
    DateTime fromDate,
    DateTime to,
  ) async {
    try {
      Dio dio = Dio();
      String formatFromDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(fromDate);
      print(formatFromDate);

      String formatToDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(to);
      //final data = Provider.of<EventProvider>(context, listen: false).amenidad;
      //print('${data.length}');
      //print('${data[0].id}');

      var formData = FormData.fromMap({
        'params': json.encode({
          'idCom': idCom,
          'idAmenidad': widget.id,
          'idResidente': idUser,
          'fechaIni': formatFromDate,
          'fechaFin': formatToDate,
          'comentario': titulo,
        })
      });

      Response response = await dio.post(
          'http://187.189.53.8:8081/backend/web/index.php?r=adcom/reserva-amenidad',
          data: formData, onSendProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      });

      if (response.statusCode == 200) {
        print('aqui $response');
      }
    } on DioError catch (e) {
      if (e.response!.data == true) {
        print('aqui:${e.response!.data.toString()}');
        return;
      } else {
        print('aqui2:${e.response!.data.toString()}');
      }
    }
  }

  buildTo() => buildHeader(
        header: 'A',
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: buildDropdownField(
                  text: Utils.toDate(toDate),
                  onClicked: () => pickToDateTime(pickDate: true),
                )),
            Expanded(
                child: buildDropdownField(
              text: Utils.toTime(toDate),
              onClicked: () => pickToDateTime(pickDate: false),
            ))
          ],
        ),
      );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);

    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, date.hour, date.minute);
    }
    setState(() => fromDate = date);
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime.now(),
          lastDate: DateTime(2101));

      if (date == null) return null;
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);

    if (date == null) return null;

    setState(() => toDate = date);
  }

  alerta5() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'Si, continuar',
          style: TextStyle(color: Colors.red[900]),
        ));
    Widget backButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'Regresar',
          style: TextStyle(color: Colors.orange),
        ));
    AlertDialog alert = AlertDialog(
      actions: [backButton],
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
              'Adcom informa',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            maxHoras == true
                ? Text('El maximo de apartado de esta amenidad es de 6 horas')
                : Text(
                    'Esta amenidad ya se encuentra apartada, favor de seleccionar otra fecha, gracias')
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
  }

  errors() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'Si, continuar',
          style: TextStyle(color: Colors.red[900]),
        ));
    Widget backButton = TextButton(
        onPressed: () {
          Navigator.of(context)..pop()..pop();
        },
        child: Text(
          'Regresar',
          style: TextStyle(color: Colors.orange),
        ));
    AlertDialog alert = AlertDialog(
      actions: [backButton],
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
              'Atencion!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            Text('Existio un error o la espera fue larga')
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
  }
}

class Utils {
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return '$time';
  }

  static DateTime removeTime(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);
}
