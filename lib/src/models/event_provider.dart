import 'package:adcom/src/extra/add_reporte.dart';
import 'package:adcom/src/extra/filter_section.dart';
import 'package:adcom/src/extra/reporte.dart';
import 'package:adcom/src/methods/emailDashboard.dart';
import 'package:adcom/src/methods/eventDashboard.dart';
import 'package:adcom/src/methods/event_editing_page.dart';
import 'package:adcom/src/models/event.dart';
import 'package:adcom/src/pantallas/amenidades.dart';
import 'package:adcom/src/pantallas/finanzas.dart';
import 'package:adcom/src/pantallas/loginPage.dart';
import 'package:adcom/src/pantallas/mainMenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];
  final List<Report> _reports = [];
  final List<Items> _items = [];
  final List<Comu> _comu = [];
  final List<DatosCuenta> _deudas = [];
  final List<Amenidad> _amenidad = [];
  final List<DataReporte> _dataRep = [];
  late SharedPreferences pref;
  late SharedPreferences prefs;

  String _status = '';
  int? idU;
  bool _islogged = false;
  bool _loading = true;

  List<Event> get events => _events;
  List<Report> get reports => _reports;
  List<Items> get items => _items;
  List<Comu> get comu => _comu;
  List<DataReporte> get dataRep => _dataRep;
  List<DatosCuenta> get deudas => _deudas;
  List<Amenidad> get amenidad => _amenidad;
  String get status => _status;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventOfSelectedDate => _events;

  bool isloggedIn() => _islogged;
  bool isLoading() => _loading;

  EventProvider() {
    loginState();
  }

  void addStatus(String status) {
    _status = status;
    notifyListeners();
  }

  var userd;
  void login(user, pass, ctx) async {
    _loading = false;
    notifyListeners();

    _loading = true;
    await loginAcces(user, pass).then((value) {
      var userId;
      var post = value;
      if (post!.value == 1) {
        var idPrimario = post.id;
        userId = post.idResidente;
        var comId = post.idCom;
        userd = post.nombreResidente;
        var userType = post.idPerfil;
        somData(userd, userType);
        obtainId(userType);
        accesData(comId, userId);
        dataOff2(idPrimario, userType);
        dataOff4(idPrimario);
        someData(comId, userId);
        //Adeudos
        dataOff3(userId);
        //amenidades

        dataOff5(userId);

        Navigator.pushReplacementNamed(ctx, '/');
      }
    });

    _loading = true;
    if (userd != null) {
      _islogged = true;
      pref.setBool('isLoggedIn', true);
      notifyListeners();
    } else {
      _islogged = false;
      notifyListeners();
    }
  }

  void loginState() async {
    pref = await SharedPreferences.getInstance();
    var id = pref.getString('user');
    if (pref.containsKey('isLoggedIn')) {
      _islogged = id != null;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }

  void addDataRep(DataReporte datarep) {
    _dataRep.add(datarep);
  }

  void addAmenidad(Amenidad amenidad) {
    _amenidad.add(amenidad);
    notifyListeners();
  }

  void addDeudas(DatosCuenta cuenta) {
    _deudas.add(cuenta);
    notifyListeners();
  }

  void addiD(id) {
    idU = id;

    notifyListeners();
  }

  void addContacts(Items items) {
    _items.add(items);

    notifyListeners();
  }

  void addEvent(
    Event event,
  ) {
    _events.add(event);

    notifyListeners();
  }

  logOut(BuildContext ctx) {
    pref.clear();

    _islogged = false;
    _deudas.clear();
    _items.clear();
    _amenidad.clear();
    if (_deudas.length == 0) {
      Navigator.of(ctx).popAndPushNamed('/');
    }
    notifyListeners();
  }

  void addReport(Report report) {
    _reports.add(report);
    notifyListeners();
  }

  void deleteReport(Report report) {
    _reports.remove(report);

    notifyListeners();
  }

  void editReport(Report newReport, Report oldReport) {
    final index = _reports.indexOf(oldReport);
    _reports[index] = newReport;

    notifyListeners();
  }

  void deleteEvent(Event event) {
    _events.remove(event);
    notifyListeners();
  }

  void editEvent(Event newEvent, Event oldEvent) {
    final index = _events.indexOf(oldEvent);

    _events[index] = newEvent;
    notifyListeners();
  }
}
