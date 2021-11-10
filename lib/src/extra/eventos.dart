import 'dart:async';

import 'package:adcom/json/jsonAmenidadReserva.dart';
import 'package:adcom/src/extra/reglamento.dart';
import 'package:adcom/src/methods/eventDashboard.dart';
import 'package:adcom/src/methods/event_editing_page.dart';
import 'package:adcom/src/methods/task_widget.dart';
import 'package:adcom/src/models/event.dart';
import 'package:adcom/src/models/event_data_source.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';

SharedPreferences? prefs;

// ignore: must_be_immutable
class EventWeekly extends StatefulWidget {
  final int? id;
  final int? needReserva;
  Amenidad? amen;
  EventWeekly({this.id, this.amen, this.needReserva});

  @override
  _EventWeeklyState createState() => _EventWeeklyState();
}

class _EventWeeklyState extends State<EventWeekly> {
  List<Event> event2 = [];
  VoidCallback? _showPersBottomSheetCallBack;
  bool noHayResevas = false;
  int? idCom;

  /// obtiene los datos del service y los pone en un arreglo
  getData() async {
    var reserva = await getReserva(id: widget.id);
    prefs = await SharedPreferences.getInstance();
    setState(() {
      idCom = prefs!.getInt('idCom');
    });

    for (int i = 0; i < reserva!.data!.reservas!.length; i++) {
      event2.add(new Event(
          title: reserva.data!.reservas![i].comentario!,
          from: reserva.data!.reservas![i].fechaIni!,
          description: '',
          to: reserva.data!.reservas![i].fechafinEvent!));
    }
    if (event2.isEmpty) {
      if (mounted) {
        setState(() {
          noHayResevas = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          noHayResevas = false;
        });
      }
    }

    if (mounted) {
      setState(() {
        event2;
      });
    }

    if (idCom == 99) {
    } else {
      if (widget.id == 2 || widget.id == 5) {
        Future.delayed(
            Duration(milliseconds: 999),
            () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Reglamento(
                                idAmen: widget.id,
                                idCom: idCom,
                              )))
                });
      }
    }
  }

  ///refresh actualiza los datos
  ///recive un llamado en [onGoBack]
  refresh() {
    setState(() {
      if (event2.isNotEmpty) {
        event2.clear();
        getData();
      } else {
        if (event2.isEmpty) {
          getData();
        } else {}
      }
    });
  }

  /// funcion que actualiza al regresar
  FutureOr onGoBack(dynamic value) {
    setState(() {
      refresh();
    });
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  pushAlertaReglas() {
    switch (idCom) {
      case 1:
        break;
      case 2:
        if (widget.id == 5) {
          Future.delayed(
              Duration(milliseconds: 999),
              () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Reglamento(
                                  idAmen: widget.id,
                                  idCom: idCom,
                                )))
                  });
        }
        break;
      case 3:
        break;
      case 4:
        if (widget.id == 2 || widget.id == 5) {
          Future.delayed(
              Duration(milliseconds: 999),
              () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Reglamento(
                                  idAmen: widget.id,
                                  idCom: idCom,
                                )))
                  });
        }
        break;
      case 5:
        break;
      case 6:
        break;
      case 10:
        break;
      case 99:
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservas '),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: widget.needReserva == 0
          ? Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      '${widget.amen!.title}',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('${widget.amen!.comReserva}',
                      style: TextStyle(fontSize: 26),
                      textAlign: TextAlign.center),
                  SizedBox(
                    width: 250,
                    child: Text(
                      '${widget.amen!.subtitle}',
                      style: TextStyle(fontSize: 26),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )
          : event2.isEmpty
              ? Container(
                  child: noHayResevas == true
                      ? Calendario(
                          idA: widget.id,
                          context: context,
                          event2: event2,
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                )
              : Calendario(
                  idA: widget.id,
                  context: context,
                  event2: event2,
                ),
      floatingActionButton: widget.needReserva == 0
          ? null
          : FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.deepPurpleAccent,
              onPressed: () => {
                /// navegacion que te lleva a la toma de datos para agendar
                /// Ro
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (_) => EventEditingPage(
                              id: widget.id,
                            )))
                    .then(onGoBack)
              },
            ),
    );
  }

  void _showModalSheet() {
    showModalBottomSheet(
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (builder) {
          return new Container(
            height: 250,
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Saldo a favor',
                    style: TextStyle(fontSize: 21),
                  ),
                  SizedBox(
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.lightGreen[700],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Proximamente',
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                        /* Container(
                          padding: EdgeInsets.only(right: 110),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/mastercard.png',
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'assets/images/visa.png',
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'assets/images/google-wallet.png',
                                height: 20,
                                width: 20,
                              )
                            ],
                          ),
                        ) */
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
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
              'Adcom informa',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
                'Esta amenidad no requiere reserva, puede asistir en el horario que desee')
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert);
  }
}

// ignore: must_be_immutable
class Calendario extends StatefulWidget {
  final int? idA;
  final BuildContext? context;
  List<Event>? event2 = [];
  Calendario({this.idA, this.context, this.event2});
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  _CalendarioState createState() => _CalendarioState();
}

Future<ReservaData?> getReserva({id}) async {
  prefs = await SharedPreferences.getInstance();

  Uri uri = Uri.parse(
      'http://187.189.53.8:8081/backend/web/index.php?r=adcom/get-amenidad-reserva');

  final response = await http.post(uri, body: {"idAmenidad": "${id}"});

  if (response.statusCode == 200) {
    var data = response.body;

    return reservaDataFromJson(data);
  } else {
    print('error');
  }
}

class _CalendarioState extends State<Calendario> {
  List<Event> event2 = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return calendart(context, widget.event2!);
  }

  SfCalendar calendart(BuildContext context, List<Event> event) {
    return SfCalendar(
      dataSource: EventDataSource(event),
      initialDisplayDate: DateTime.now(),
      view: CalendarView.week,
      timeSlotViewSettings: TimeSlotViewSettings(
          startHour: 9, endHour: 22, timeIntervalHeight: 80),
      /*  onLongPress: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);
        provider.setDate(details.date!);
        showModalBottomSheet(
            context: context, builder: (context) => TaskWidget());
      },*/
    );
  }
}
