
import 'package:flutter/material.dart';
import '../model/event_model.dart';

class EventsProvider extends ChangeNotifier {
  final List<EventModel> _events = [];


  List<EventModel> get events => List.unmodifiable(_events);

  void addEvent(EventModel event) {
    _events.add(event);
    notifyListeners();
  }
  void deleteEvent(EventModel event) {
    _events.remove(event);
    notifyListeners();
  }

  void updateEvent(EventModel oldEvent, EventModel newEvent) {
    final index = _events.indexOf(oldEvent);
    if (index == -1) return;
    _events[index] = newEvent;
    notifyListeners();
  }
}
