import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color color;
  final bool isAllDay;

  const Event(
      {this.color = Colors.deepPurpleAccent,
      required this.description,
      required this.from,
      this.isAllDay = false,
      required this.title,
      required this.to});
}
