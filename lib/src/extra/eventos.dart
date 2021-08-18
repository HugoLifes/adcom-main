import 'package:adcom/json/jsonAmenidadReserva.dart';
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

class EventWeekly extends StatelessWidget {
  final int? id;
  EventWeekly({this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservas '),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Calendario(
        idA: id,
        context: context,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () => {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => EventEditingPage(
                    id: id,
                  )))
        },
      ),
    );
  }
}

class Calendario extends StatefulWidget {
  final int? idA;
  final BuildContext? context;
  Calendario({this.idA, this.context});
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  _CalendarioState createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  List<Event> event2 = [];
  Future<ReservaData?> getReserva() async {
    prefs = await SharedPreferences.getInstance();

    Uri uri = Uri.parse(
        'http://187.189.53.8/AdcomBackend/backend/web/index.php?r=adcom/get-amenidad-reserva');

    final response =
        await http.post(uri, body: {"idAmenidad": "${widget.idA}"});

    if (response.statusCode == 200) {
      var data = response.body;

      return reservaDataFromJson(data);
    } else {
      print('error');
    }
  }

  getData() async {
    var reserva = await getReserva();
    var provider = Provider.of<EventProvider>(context, listen: false);
    for (int i = 0; i < reserva!.data!.reservas!.length; i++) {
      event2.add(new Event(
          title: reserva.data!.reservas![i].comentario!,
          from: reserva.data!.reservas![i].fechaIni!,
          description: '',
          to: reserva.data!.reservas![i].fechafinEvent!));
      provider.addEvent(new Event(
          title: reserva.data!.reservas![i].comentario!,
          from: reserva.data!.reservas![i].fechaIni!,
          description: '',
          to: reserva.data!.reservas![i].fechafinEvent!));
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    Future.delayed(Duration(milliseconds: 988), () => {refresh()});
  }

  refresh() {
    setState(() {
      var events = Provider.of<EventProvider>(context, listen: false).events;
      calendart(widget.context!, events);
    });
  }

  @override
  Widget build(BuildContext context) {
    var events = Provider.of<EventProvider>(context, listen: false).events;
    return event2.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : calendart(context, events);
  }

  SfCalendar calendart(BuildContext context, List<Event> event) {
    return SfCalendar(
      dataSource: EventDataSource(event),
      initialDisplayDate: DateTime.now(),
      view: CalendarView.week,
      onLongPress: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.setDate(details.date!);
        showModalBottomSheet(
            context: context, builder: (context) => TaskWidget());
      },
    );
  }
}
