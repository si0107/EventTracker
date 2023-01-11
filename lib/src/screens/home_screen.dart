import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/src/screens/calendar_screen.dart';
import 'package:flutter_complete_guide/src/widgets/add_event.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Deadline Tracker"),
          backgroundColor: const Color.fromARGB(255, 147, 195, 206),
          bottom: const TabBar(
            tabs: [
              //Tab(icon: Icon(Icons.directions_car)),
              //Tab(text: "List View"),
              Tab(text: "Calendar View"),
              Tab(text: "Add Item"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: CalendarScreen()),
            Center(child: AddEvent()),
          ],
        ),
      ),
    );
  }
}
