import 'dart:ui';

import 'package:adcom/src/models/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// gets que obtienen caracteristicas del apartado de amenidades
///  datos como el tiempo, el titulo del apartado del evento,
///  el color del guardado del evento, etc

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).title;

  /// apartar todo el dia
  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;

  /// cambiar de colores por evento... se puede implementar
  @override
  Color getColor(int index) => getEvent(index).color;
}
