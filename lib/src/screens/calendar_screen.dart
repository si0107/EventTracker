import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:getwidget/getwidget.dart';
import '../Model/event.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CalendarScreenState();
  }
}

class CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List<Event>> allEvents = {};
  Map<DateTime, List<dynamic>> _events = {};
  //use this variable to stream in initialized events
  late List<Event> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  void addEvent(DateTime day, Event event) {
    //DateTime today = DateTime.now();
    if (allEvents[day] != null) {
      allEvents[day]?.add(event);
    } else {
      allEvents[day] = [event];
    }
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  //Get the user id of the current user
  String getUserID() {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
  }
  //Get Events For Date
  List<dynamic> _getEventsForDay(DateTime date) {
    List<dynamic> events = [];
    _events.forEach((key, value) {
      if ((date.day == key.day) &
          (date.month == key.month) &
          (date.year == key.year)) {
          events.addAll(value);
          events.sort((a, b) => a.time.compareTo(b.time));
      }
    });
    return events;
  }

  @override
  void initState(){
    super.initState();
    _events = {};
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Map the read data as an Event
  Stream<List<Event>> readEvents() => FirebaseFirestore.instance.collection('events').where('userID', isEqualTo: getUserID())
  .snapshots()
  .map((snapshot) => 
    snapshot.docs.map((doc)=> Event.fromJson(doc.data())).toList()
  );

  //Make the list of events as a Map<DateTime, List<dynamic>>
  Map<DateTime, List<dynamic>> _groupEvents(List<Event> events){
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date = DateTime(event.date.year, event.date.month, event.date.day, 12);
      if (data[date] == null) {
        data[date] = [];
      }
      data[date]!.add(event);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Event>>(
        stream: readEvents(),
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          }
          else if (snapshot.hasData){
            //Save the data as a list of Events
            List<Event> allEvents = snapshot.data!;
            if(allEvents.isNotEmpty){
              //Use the events to create a map
              _events = _groupEvents(allEvents);
            }
            else {
              _events = {};
            }
            return ListView(
              children:[
                TableCalendar(
                  focusedDay: selectedDay,
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2040),
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  daysOfWeekVisible: true,

                  //Formatting of Weekly/Monthly view
                  calendarFormat: format,
                  onFormatChanged: (CalendarFormat _format) {
                    setState(() {
                      format = _format;
                    });
                  },

                  //Select a Day
                  onDaySelected: (DateTime selectDay, DateTime focusDay) {
                    setState(() {
                      selectedDay = selectDay;
                      focusedDay = focusDay;
                    });
                    print(focusedDay);
                  },

                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(selectedDay, date);
                  },

                  //Style Calendar
                  calendarStyle: const CalendarStyle(
                    isTodayHighlighted: true,
                    selectedDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 232, 146, 175),
                        shape: BoxShape.circle),
                    selectedTextStyle: TextStyle(color: Colors.white),
                  ),

                  //Style Header and Button
                  headerStyle: HeaderStyle(
                      formatButtonShowsNext: false,
                      formatButtonDecoration: BoxDecoration(
                          color: const Color.fromARGB(255, 138, 168, 192),
                          borderRadius: BorderRadius.circular(12.0)),
                      formatButtonTextStyle: const TextStyle(color: Colors.white)),
                ),
                //List Items
                ..._getEventsForDay(selectedDay).map((event) => GFAccordion(
                  title: event.time,
                  content: "Event: ${event.title}\nDescription: ${event.description}",
                  collapsedTitleBackgroundColor:Color.fromARGB(200, 147, 195, 206),
                  expandedTitleBackgroundColor: Color.fromARGB(200, 147, 195, 206),
                  contentBackgroundColor: Color.fromARGB(200, 147, 195, 206),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ))
              ],  
            );
          }
          else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}
