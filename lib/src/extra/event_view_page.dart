import 'package:adcom/src/methods/event_editing_page.dart';
import 'package:adcom/src/models/event.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventViewinPage extends StatelessWidget {
  final Event event;

  const EventViewinPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: CloseButton(),
        actions: buildViewActions(context, event),
        
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: [
          buildDateTime(event),
          SizedBox(
            height: 32,
          ),
          Text(
            event.title,
            style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 25),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            event.description,
            style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 18),
          )
        ],
      ),
    );
  }

  List<Widget> buildViewActions(BuildContext context, Event event) {
    return [
      IconButton(
          icon: Icon(Icons.edit),
          onPressed: () =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => EventEditingPage(
                        event: event,
                      )))),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            final provider = Provider.of<EventProvider>(context, listen: false);
            provider.deleteEvent(event);

            Navigator.of(context).pop();
          })
    ];
  }

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? 'Todo el dia' : 'De', event.from),
        if (!event.isAllDay) buildDate('To', event.to)
      ],
    );
  }

  Widget buildDate(String s, DateTime from) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$s',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
            '${from.month}/${from.day}/${from.year} ${from.hour}:${from.minute}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))
      ],
    );
  }
}
