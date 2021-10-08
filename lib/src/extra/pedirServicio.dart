import 'dart:convert';

import 'package:adcom/json/jsonCheck.dart';
import 'package:adcom/src/extra/multiServ.dart';
import 'package:adcom/src/methods/event_editing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

SharedPreferences? prefs;

// ignore: must_be_immutable
class PedirServicio extends StatefulWidget {
  final int? service;
  Servicios? servicio;
  PedirServicio({Key? key, this.service, this.servicio}) : super(key: key);

  @override
  _PedirServicioState createState() => _PedirServicioState();
}

class _PedirServicioState extends State<PedirServicio> {
  int _currentStep = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final descpController = TextEditingController();
  final descriptionController = TextEditingController();
  final cantidadController = TextEditingController();
  bool _lights = false;
  String? userName;
  String? comu;
  String? noInt;
  String? eleccion;
  bool? select;
  bool? select2;
  bool? select3;
  String? chosenValue2;
  late DateTime fromDate;
  late DateTime toDate;

  getDt() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs!.getString('comunidad') == null) {
      setState(() {
        userName = prefs!.getString('user');
      });
    } else {
      setState(() {
        userName = prefs!.getString('user');
        comu = prefs!.getString('comunidad');
        noInt = prefs!.getString('noInterno');
      });
    }

    if (userName != null) {
      descriptionController.text = comu == null
          ? ''
          : userName! + '\n' + comu! + '\n' + 'noInterior: $noInt';
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getDt();
    select = false;
    select2 = false;
    select3 = false;
    fromDate = DateTime.now();
    toDate = DateTime.now().add(Duration(hours: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Confirme su información',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Theme(
          data: ThemeData(
              primaryColor:
                  widget.service == 1 ? Colors.blue[800] : Colors.red[900],
              primarySwatch:
                  widget.service == 1 ? Colors.lightGreen : Colors.orange),
          child: stepper()),
    );
  }

  /// Funcion que muestra y carga el stepper
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
            if (this._currentStep == 3) {
              if (fromDate.weekday == DateTime.tuesday ||
                  fromDate.weekday == DateTime.thursday) {
                var currenTime =
                    DateTime(fromDate.year, fromDate.month, fromDate.day);
                DateFormat format = DateFormat('yyy-MM-dd');

                var newTime = format.format(currenTime);
                print('aqui');

                Checkeo()
                    .check(newTime, widget.servicio!.idproveedor!)
                    .then((value) => {
                          if (value!.data!.disp != "0")
                            {alerta2()}
                          else
                            {alerta()}
                        });
              } else {
                print('aqui2');
                setState(() {
                  this._currentStep = this._currentStep + 1;
                });
              }
            } else {
              setState(() {
                this._currentStep = this._currentStep + 1;
              });
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

  /// stepper que muesta al entrar a la pagina para pedir servicios
  List<Step>? _stepper() {
    List<Step> _steps = [
      Step(
          title: Text('Nombre del residente y Dirección'),
          isActive: _currentStep >= 0,
          state: StepState.complete,
          content: Column(
            children: [
              Form(
                key: _formKey2,
                child: buildComents(),
              ),
            ],
          )),
      Step(
          title: Text('Tipo de tanque'),
          isActive: _currentStep >= 1,
          state: StepState.disabled,
          content: Container(
              //padding: EdgeInsets.only(top: 10, right: 190),
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    eleccion = '30kg';
                    select = true;
                    select2 = false;
                    select3 = false;
                  });
                },
                child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: select == true
                                ? Colors.red
                                : Colors.transparent,
                            width: 2.0)),
                    child: Image.asset(
                      'assets/images/30kg.png',
                      fit: BoxFit.contain,
                    )),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    eleccion = '45kg';
                    select = false;
                    select2 = true;
                    select3 = false;
                  });
                },
                child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: select2 == true
                                ? Colors.red
                                : Colors.transparent,
                            width: 2.0)),
                    child: Image.asset('assets/images/45kg.png',
                        fit: BoxFit.contain)),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    eleccion = 'Estacionario';
                    select = false;
                    select2 = false;
                    select3 = true;
                  });
                },
                child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: select3 == true
                                ? Colors.red
                                : Colors.transparent,
                            width: 2.0)),
                    child: Image.asset('assets/images/estacionario.png',
                        fit: BoxFit.contain)),
              )
            ],
          ))),
      Step(
          title: Text('Cantidad y Tipo de pago'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey3,
                child: buildCantidad(),
              ),
              Column(
                children: [
                  _lights == true ? Text('Terminal') : Text('Efectivo'),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _lights = !_lights;
                      });
                    },
                    child: CupertinoSwitch(
                      value: _lights,
                      onChanged: (bool value) {
                        setState(() {
                          _lights = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          state: StepState.disabled,
          isActive: _currentStep >= 2),
      Step(
        title: Text('Horario de preferencia'),
        isActive: _currentStep >= 3,
        state: StepState.disabled,
        content: buildDateTimePickers(),
      ),
      Step(
          title: Text('Comentarios'),
          isActive: _currentStep >= 4,
          state: StepState.disabled,
          content: Column(
            children: [
              Form(
                key: _formKey,
                child: buildComents2(),
              ),
            ],
          )),
    ];
    return _steps;
  }

  /// inserta la cantindad de dinero que quiere el usuario
  buildCantidad() => Container(
        width: 200,
        child: TextFormField(
          keyboardType: TextInputType.number,
          cursorColor: Colors.black,

          onFieldSubmitted: (_) => {},
          //el controlles accede a propiedades como el texto
          controller: cantidadController,
          style: TextStyle(fontSize: 20),
          validator: (title) => title != null && title.isEmpty
              ? 'Este campo no puede estar vacio'
              : null,
          decoration: InputDecoration(
              icon: Icon(Glyphicon.cash),
              border: UnderlineInputBorder(),
              hintText: 'Monto en pesos'),
        ),
      );

  /// construye el nombre del usuario
  buildTitle() => TextFormField(
        cursorColor: Colors.black,
        readOnly: true,
        onFieldSubmitted: (_) => {},
        //el controlles accede a propiedades como el texto
        controller: descpController,
        style: TextStyle(fontSize: 20),
        validator: (title) => title != null && title.isEmpty
            ? 'Este campo no puede estar vacio'
            : null,
        decoration: InputDecoration(
            icon: Icon(Icons.receipt),
            border: UnderlineInputBorder(),
            hintText: 'Nombre Completo'),
      );

  /// construye el los toma tiempo y fecha
  buildDateTimePickers() => Column(
        children: [
          buildForm(),
          buildTo(),
        ],
      );

  /// funcion que construye los comentarios
  buildComents() => TextFormField(
        cursorColor: Colors.black,
        readOnly: true,
        onFieldSubmitted: (_) => {},
        controller: descriptionController,
        style: TextStyle(fontSize: 20),
        validator: (title) => title != null && title.isEmpty
            ? 'Este campo no puede estar vacio'
            : null,
        decoration: InputDecoration(
            icon: Icon(Icons.receipt),
            //suffixIcon: Icon(Icons.check_circle_outline_sharp),
            helperText: 'Nombre y Dirección',
            border: UnderlineInputBorder(),
            hintText: 'Nombre y Dirección'),
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        inputFormatters: [new LengthLimitingTextInputFormatter(200)],
      );
  buildComents2() => TextFormField(
        cursorColor: Colors.black,
        onFieldSubmitted: (_) => {},
        controller: descpController,
        style: TextStyle(fontSize: 20),
        validator: (title) => title != null && title.isEmpty
            ? 'Este campo no puede estar vacio'
            : null,
        decoration: InputDecoration(
            icon: Icon(Icons.receipt),
            //suffixIcon: Icon(Icons.check_circle_outline_sharp),
            helperText: 'Comentarios',
            border: UnderlineInputBorder(),
            hintText: 'Comentarios'),
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        inputFormatters: [new LengthLimitingTextInputFormatter(200)],
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

  /// Fecha inicial
  buildForm() => buildHeader(
        header: 'DE',
        child: Row(
          children: [
            Expanded(
                flex: 1,
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
  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);

    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, date.hour, date.minute);
    }
    setState(() => fromDate = date);
  }

  ///la fecha destino
  buildTo() => buildHeader(
        header: 'A',
        child: Row(
          children: [
            Expanded(
                flex: 1,
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
  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);

    if (date == null) return null;

    setState(() => toDate = date);
  }

  /// Toma el tiempo
  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2015, 8),
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

  ///muestra mensaje para advertir al usuario que ciertos dias no esta tan accesible el gas
  alerta() {
    Widget okButton = TextButton(
        onPressed: () {
          setState(() {
            this._currentStep = this._currentStep + 1;
          });
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
              'Adcom informa',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
                'Los dias Martes y Jueves, el gas no tiene prioridad en este fraccionamiento, esto podria hacer que demore un poco mas, le pedimos que sea paciente.')
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert);
  }

  alerta2() {
    Widget okButton = TextButton(
        onPressed: () {
          setState(() {
            this._currentStep = this._currentStep + 1;
          });
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
              'Adcom informa',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            Text('El servicio esta disponible')
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert);
  }
}

class Checkeo {
  Future<Check?> check(String tiempo, int id) async {
    print(tiempo);
    print(id);

    Uri url = Uri.parse(
        "http://187.189.53.8:8080/AdcomBackend/backend/web/index.php?r=adcom/validar-fecha-porveedor");
    final response = await http.post(url, body: {
      'params': json.encode({"fecha": "'${tiempo}'", "idProveedor": id})
    });

    if (response.statusCode == 200) {
      var data = response.body;
      print(data);
      return checkFromJson(data);
    } else {
      print(response.body);
    }
  }
}
