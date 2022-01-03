import 'dart:convert';
import 'dart:math';
import 'package:adcom/json/jsonCheck.dart';
import 'package:adcom/json/jsonCorre.dart';
import 'package:adcom/src/extra/multiServ.dart';
import 'package:adcom/src/extra/servicios.dart';
import 'package:adcom/src/methods/event_editing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
SharedPreferences? prefs;

// ignore: must_be_immutable
class PedirServicio extends StatefulWidget {
  final int? service;
  DatosProveedor? datosProveedor;
  List<dynamic>? url;
  Servicios? servicio;
  List<dynamic>? name;
  List<dynamic>? precios;

  List<dynamic>? seleccionado = [];
  PedirServicio(
      {Key? key,
      this.service,
      this.servicio,
      this.datosProveedor,
      this.url,
      this.precios,
      this.seleccionado,
      this.name})
      : super(key: key);

  @override
  _PedirServicioState createState() => _PedirServicioState();
}

class _PedirServicioState extends State<PedirServicio> {
  int _currentStep = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  final descpController = TextEditingController();
  final descriptionController = TextEditingController();
  final cantidadController = TextEditingController();
  final descripCompra = TextEditingController();
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
  int? idRe;
  String tipoDePago = "Efectivo";
  var calle;
  bool isChecked = false;
  bool isChecked2 = false;
  int? selectindex;
  bool tanqueLleno = false;

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
        idRe = prefs!.getInt('userId');
        calle = prefs!.getString('calle');
      });
      print('comu:${comu}');
      print('idResidente:${idRe}');
      print('id proveeror${widget.servicio!.idproveedor!}');
      print(calle);
    }

    if (userName != null) {
      descriptionController.text = comu == null
          ? ''
          : userName! + '\n' + comu! + '\n' + '$calle' + ' $noInt';
    } else {}
  }

  printUrl() {
    for (int i = 0; i < widget.url!.length; i++) {
      print(widget.url![i]);
    }
  }

  @override
  void initState() {
    super.initState();
    getDt();
    imprimir();
    select = false;
    select2 = false;
    select3 = false;
    printUrl();
    fromDate = DateTime.now();
    toDate = DateTime.now().add(Duration(hours: 2));
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
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            'Confirme su información',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: LoaderOverlay(
          child: Theme(
              data: ThemeData(
                  primaryColor:
                      widget.service == 1 ? Colors.blue[800] : Colors.red[900],
                  primarySwatch:
                      widget.service == 1 ? Colors.lightGreen : Colors.orange),
              child: stepper()),
        ),
      ),
    );
  }

  /// Funcion que muestra y carga el stepper
  Stepper stepper() {
    return Stepper(
      steps: _stepper()!,
      currentStep: this._currentStep,
      onStepTapped: (step) {
        setState(() {
          this._currentStep = step;
        });
      },
      onStepContinue: () {
        setState(() {
          if (this._currentStep < this._stepper()!.length - 1) {
            /// chequea la posicion del dateTime para hacer la llamada de disponibilidad
            ///
            ///
            if (this._currentStep == 3) {
              var currenTime =
                  DateTime(fromDate.year, fromDate.month, fromDate.day);
              DateFormat format = DateFormat('yyy-MM-dd');

              var newTime = format.format(currenTime);
              print('aqui');
              context.loaderOverlay.show();
              Checkeo()
                  .check(newTime, widget.servicio!.idproveedor!)
                  .then((value) => {
                        if (value!.data!.disp != "0")
                          {context.loaderOverlay.hide(), alerta2()}
                        else
                          {context.loaderOverlay.hide(), alerta()}
                      });
            } else {
              /// chequea si hay un metodo de pago
              if (this._currentStep == 2) {
                if ((isChecked || isChecked2) == false) {
                  alerta4('Seleccione un metodo de pago');
                } else {
                  if (tanqueLleno != true) {
                    if (_formKey3.currentState!.validate()) {
                      setState(() {
                        this._currentStep = this._currentStep + 1;
                      });
                      FocusScope.of(context).unfocus();
                    } else {
                      alerta4('Complete los campos');
                    }
                  } else {
                    setState(() {
                      this._currentStep = this._currentStep + 1;
                    });
                    FocusScope.of(context).unfocus();
                  }
                }
              } else {
                /// chequea si hay imagenes seleccionadas
                if (this._currentStep == 1) {
                  if (eleccion == null && descripCompra.text.isEmpty) {
                    alerta5();
                  } else {
                    setState(() {
                      this._currentStep = this._currentStep + 1;
                    });
                  }
                } else {
                  if (this._currentStep == 0) {
                    if (_formKey2.currentState!.validate()) {
                      setState(() {
                        this._currentStep = this._currentStep + 1;
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "Campo vacio",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          fontSize: 17.0);
                    }
                  }
                }
              }
            }
          } else {
            context.loaderOverlay.show();

            if (cantidadController.text == null ||
                cantidadController.text == "h") {
              setState(() {
                cantidadController.text = eleccion!;
              });
            }

            print(widget.servicio!.idproveedor!);
            EnviarCorreo()
                .sendCorreo(
                    idRe!,
                    widget.servicio!.idproveedor!,
                    eleccion!,
                    tipoDePago,
                    cantidadController.text,
                    fromDate,
                    toDate,
                    descpController.text,
                    context)
                .then((value) => {
                      if (value!.value == 1)
                        {
                          context.loaderOverlay.hide(),
                          alerta3(),
                        }
                      else
                        {print('${value.value}')}
                    })
                .catchError((e) {
              context.loaderOverlay.hide();
            });
          }
        });
      },
      onStepCancel: () {
        setState(() {
          if (this._currentStep > 0) {
            if (this._currentStep == 2) {
              setState(() {
                isChecked = false;
                isChecked2 = false;
                cantidadController.text = "";
              });
              FocusScope.of(context).unfocus();
              this._currentStep = this._currentStep - 1;
            } else {
              this._currentStep = this._currentStep - 1;
            }
          } else {
            this._currentStep = 0;
          }
        });
      },
    );
  }

  imprimir() {
    print(widget.url![0]);
  }

  /// stepper que muesta al entrar a la pagina para pedir servicios
  List<Step>? _stepper() {
    List<Step> _steps = [
      Step(
          title: Text('Nombre del residente y dirección'),
          isActive: _currentStep >= 0,
          state: StepState.complete,
          content: Column(
            children: [
              Form(
                key: _formKey2,
                child: buildComents(
                    descriptionController, 'Nombre y Dirección', _currentStep),
              ),
            ],
          )),
      tipoDeServicio()!,
      caracteristicasTipoPago()!,
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
                child:
                    buildComents(descpController, 'Comentarios', _currentStep),
              ),
            ],
          )),
    ];
    return _steps;
  }

  
   Step? tipoDeServicio() {
    print(' idTipoProvedor ${widget.servicio!.idTipoProveedor}');
    print('here ${widget.servicio!.idproveedor}');
    switch (widget.servicio!.idTipoProveedor) {
      case 1:
        return Step(
            title: Text('Tipo de producto'),
            isActive: _currentStep >= 1,
            state: StepState.disabled,
            content: Container(
                height: 400,
                margin: EdgeInsets.only(left: 15, right: 15),
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: widget.url!.length,
                    addAutomaticKeepAlives: true,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectindex = index;
                            eleccion =
                                widget.name![index].toString().toLowerCase();
                            cantidadController.text = widget.precios![index];
                          });

                          if (eleccion == 'tanque 30') {
                            setState(() {
                              tanqueLleno = true;
                            });
                          } else if (eleccion == 'tanque 45') {
                            setState(() {
                              tanqueLleno = true;
                            });
                          } else if (eleccion == 'tanque estacionario' ||
                              eleccion == 'estacionario') {
                            setState(() {
                              tanqueLleno = false;
                            });
                          } else {}
                          print(eleccion);
                          print(' precio ${cantidadController.text}');
                        },
                        child: widget.servicio!.idproveedor! > 20
                            ? ListTile(
                                title: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: selectindex == index
                                                ? Colors.red
                                                : Colors.transparent,
                                            width: 2.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 150,
                                          height: 300,
                                          child: PhotoView(
                                              imageProvider: NetworkImage(
                                                  widget.url![index],
                                                  scale: 1.5)),
                                        ),
                                      ],
                                    )),
                              )
                            : ListTile(
                                title: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: selectindex == index
                                                ? Colors.red
                                                : Colors.transparent,
                                            width: 2.0)),
                                    child: Image.network(widget.url![index])),
                              ),
                      );
                    })));

      case 2:
        return Step(
            title: Text('Tipo de producto'),
            isActive: _currentStep >= 1,
            state: StepState.disabled,
            content: Container(
                height: 400,
                margin: EdgeInsets.only(left: 15, right: 15),
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: widget.url!.length,
                    addAutomaticKeepAlives: true,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectindex = index;
                            eleccion =
                                widget.name![index].toString().toLowerCase();
                            cantidadController.text = widget.precios![index];
                          });

                          if (eleccion == 'tanque 30') {
                            setState(() {
                              tanqueLleno = true;
                            });
                          } else if (eleccion == 'tanque 45') {
                            setState(() {
                              tanqueLleno = true;
                            });
                          } else if (eleccion == 'tanque estacionario' ||
                              eleccion == 'estacionario') {
                            setState(() {
                              tanqueLleno = false;
                            });
                          } else {}
                          print(eleccion);
                        },
                        child: widget.servicio!.idproveedor! > 20
                            ? ListTile(
                                title: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: selectindex == index
                                                ? Colors.red
                                                : Colors.transparent,
                                            width: 2.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        PhotoView(
                                            imageProvider: NetworkImage(
                                                widget.url![index])),
                                      ],
                                    )),
                              )
                            : ListTile(
                                title: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: selectindex == index
                                                ? Colors.red
                                                : Colors.transparent,
                                            width: 2.0)),
                                    child: Image.network(widget.url![index])),
                              ),
                      );
                    })));
    }
  }

  /// step que muestra los tipos de pago
   Step? caracteristicasTipoPago() {
    switch (widget.servicio!.idTipoProveedor) {
      case 1:
        return Step(
            title: Text('Tipo de pago'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                tanqueLleno != true
                    ? Form(
                        key: _formKey3,
                        child: buildCantidad(),
                      )
                    : Row(
                        ///tipoDePago = "Efectivo";
                        children: [
                          Row(
                            children: [
                              Text('Efectivo'),
                              Checkbox(
                                checkColor: Colors.white,
                                tristate: true,
                                value: isChecked,
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    setState(() {
                                      isChecked = value!;
                                      tipoDePago = "Efectivo";
                                    });
                                  }

                                  if (isChecked2 == true) {
                                    setState(() {
                                      isChecked2 = false;
                                      isChecked = value!;
                                      tipoDePago = "Efectivo";
                                    });
                                  }
                                  print('$tipoDePago');
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Tarjeta  '),
                              Checkbox(
                                checkColor: Colors.white,
                                value: isChecked2,
                                tristate: true,
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    setState(() {
                                      isChecked2 = value!;
                                      tipoDePago = "Tarjeta";
                                    });
                                  }

                                  if (isChecked == true) {
                                    setState(() {
                                      isChecked = false;
                                      isChecked2 = value!;
                                      tipoDePago = "Tarjeta";
                                    });
                                    print('$tipoDePago');
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                tanqueLleno != true ? camposTipoPago() : Container(),
              ],
            ),
            state: StepState.disabled,
            isActive: _currentStep >= 2);
      case 2:
        return Step(
            title: Text('Tipo de pago'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  ///tipoDePago = "Efectivo";
                  children: [
                    Row(
                      children: [
                        Text('Efectivo'),
                        Checkbox(
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (value) {
                            print('$value');
                            setState(() {
                              isChecked = value!;
                            });
                            if (isChecked == true) {
                              setState(() {
                                tipoDePago = "Efectivo";
                              });
                            } else {
                              setState(() {
                                tipoDePago = "";
                              });
                            }
                            print(isChecked.toString());
                            print('$tipoDePago');
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Tarjeta  '),
                        Checkbox(
                          checkColor: Colors.white,
                          value: isChecked2,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked2 = value!;
                            });
                            if (isChecked2 == true) {
                              setState(() {
                                tipoDePago = "Tarjeta";
                              });
                            } else {
                              setState(() {
                                tipoDePago = "";
                              });
                            }
                            print('$tipoDePago');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            state: StepState.disabled,
            isActive: _currentStep >= 2);
      case 3:
        return Step(
            title: Text('Tipo de pago'),
            state: StepState.disabled,
            isActive: _currentStep >= 2,
            content: Row(
              children: [camposTipoPago()],
            ));
      case 4:
        return Step(
            title: Text('Tipo de pago'),
            state: StepState.disabled,
            isActive: _currentStep >= 2,
            content: Row(
              children: [camposTipoPago()],
            ));
      default:
    }
  }


  /// step que muestra los campos de pago
  Column camposTipoPago() {
    return Column(
      ///tipoDePago = "Efectivo";
      children: [
        Row(
          children: [
            Text('Efectivo'),
            Checkbox(
              checkColor: Colors.white,
              tristate: true,
              value: isChecked,
              onChanged: (bool? value) {
                if (value == true) {
                  setState(() {
                    isChecked = value!;
                    tipoDePago = "Efectivo";
                  });
                }

                if (isChecked2 == true) {
                  setState(() {
                    isChecked2 = false;
                    isChecked = value!;
                    tipoDePago = "Efectivo";
                  });
                }
                print('$tipoDePago');
              },
            ),
          ],
        ),
        Row(
          children: [
            Text('Tarjeta  '),
            Checkbox(
              checkColor: Colors.white,
              value: isChecked2,
              tristate: true,
              onChanged: (bool? value) {
                if (value == true) {
                  setState(() {
                    isChecked2 = value!;
                    tipoDePago = "Tarjeta";
                  });
                }

                if (isChecked == true) {
                  setState(() {
                    isChecked = false;
                    isChecked2 = value!;
                    tipoDePago = "Tarjeta";
                  });
                  print('$tipoDePago');
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('en').format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: 'en').currencySymbol;

  /// inserta la cantindad de dinero que quiere el usuario
  buildCantidad() => Container(
        width: 200,
        child: TextFormField(
          keyboardType: TextInputType.number,
          cursorColor: Colors.black,

          onFieldSubmitted: (_) => {},
          //el controlles accede a propiedades como el texto
          controller: cantidadController,
          readOnly: cantidadController.text.isEmpty ? false : true,
          style: TextStyle(fontSize: 20),
          validator: (title) => title != null && title.isEmpty
              ? 'Este campo no puede estar vacio'
              : null,
          decoration: InputDecoration(
              prefixText: _currency,
              icon: Icon(Glyphicon.cash),
              border: UnderlineInputBorder(),
              hintText: 'Monto en pesos'),
          onChanged: (v) {
            v = '${_formatNumber(v.replaceAll(',', ''))}';
            cantidadController.value = TextEditingValue(
              text: v,
              selection: TextSelection.collapsed(offset: v.length),
            );
          },
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
  buildComents(TextEditingController controller, String text, int step) =>
      TextFormField(
        cursorColor: Colors.black,
        readOnly: step == 0 ? true : false,
        onFieldSubmitted: (_) => {},
        controller: controller,
        style: TextStyle(fontSize: 20),
        validator: (title) => title != null && title.isEmpty
            ? 'Este campo no puede estar vacio'
            : null,
        decoration: InputDecoration(
            icon: Icon(Icons.receipt),
            //suffixIcon: Icon(Icons.check_circle_outline_sharp),
            helperText: text,
            border: UnderlineInputBorder(),
            hintText: text),
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        inputFormatters: [new LengthLimitingTextInputFormatter(500)],
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
                'Este día, el gas no tiene prioridad en este fraccionamiento, esto podría hacer que demore un poco más, le pedimos que sea paciente.')
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
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

    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
  }

  alerta3() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context)..pop()..pop();
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
      actions: [okButton],
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
            Text('Su solicitud se ha mandado con exito')
          ],
        ),
      ),
    );
    

    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
  }

  alerta4(String mensaje) {
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
            Text('$mensaje')
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
  }

  alerta5() {
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
            Text('Este campo no puede ir vacio')
          ],
        ),
      ),
    );
    
    showDialog(context: context, builder: (_) => alert, barrierDismissible: false);
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
      if (response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: "Error al generar la referencia",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        if (response.statusCode == 500) {
          Fluttertoast.showToast(
              msg: "Error en el servidor",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Error desconocido",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
  }
}

class EnviarCorreo {
  Future<Correo?> sendCorreo(
      int idRe,
      int id,
      String eleccion,
      String tipoPago,
      String cantidad,
      DateTime fromDate,
      DateTime toDate,
      String coments,
      BuildContext contex) async {
    var dateFormat = DateFormat("yyy-MM-dd");
    var formarhr = DateFormat("hh:mma"); // you can change the format here
    var newDate = dateFormat.format(fromDate);
    var goDate = formarhr.format(toDate);
    var fromhr = formarhr.format(fromDate);

    // pass the UTC time here

    print(eleccion);
    print(idRe);
    print(id);
    print('here $cantidad');
    print(goDate);
    print(newDate);
    print(tipoPago);
    print(coments);
    Uri url = Uri.parse(
        "http://187.189.53.8:8080/AdcomBackend/backend/web/index.php?r=adcom/envio-correo-servicio");

    final response = await http.post(url, body: {
      "params": json.encode({
        "idResidente": idRe,
        "idProveedor": id,
        "medidasTanque": eleccion,
        "formaPago": tipoPago,
        "cantidadARecargar": "\$ ${cantidad}",
        "horarioDePreferencia":
            "Fecha: ${newDate}  Hora: ${fromhr} a ${goDate} ",
        "comentarios": coments
      })
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('Error', 408);
    });
    if (response.statusCode == 200) {
      var data = response.body;
      print(data);

      return correoFromJson(data);
    } else {
      if (response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: "Error al generar la referencia",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        if (response.statusCode == 500) {
          Fluttertoast.showToast(
              msg: "Error en el servidor",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Error desconocido",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
  }
}
