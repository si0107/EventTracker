//Implemented by Melissa Jesmin
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Model/event.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);
  @override
  AddEventState createState() => AddEventState();
}

class AddEventState extends State<AddEvent> {
  final myDate = TextEditingController();
  final myEvent = TextEditingController();
  final myDescription = TextEditingController();
  final myTime = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child:Column(
            children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: AddDate(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: AddEvent(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: AddDescription(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: AddTime(),
          ),
          const SizedBox(
            height: 15,
          ),
          Button(),
        ],
          ),
        ),
      ),
    );
  }

  Widget AddDate() {
    return SizedBox(
        width: 375,
        child: TextFormField(
            controller: myDate,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today,
                        color: Color.fromARGB(255, 180, 165, 211))),
                hintText: formatDate(selectedDate)),
            readOnly: true,
            style: TextStyle(fontSize: 16)));
  }

  Widget AddEvent() {
    return SizedBox(
        width: 375,
        child: TextFormField(
            controller: myEvent,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Event',
              prefixIcon: Column(
                  //children: [Text("Event: ")],
                  mainAxisAlignment: MainAxisAlignment.center),
              border: OutlineInputBorder(),
              // hintText: 'Enter the event'
            ),
            style: TextStyle(fontSize: 16)));
  }

  Widget AddDescription() {
    return SizedBox(
        width: 375,
        child: TextFormField(
            controller: myDescription,
            decoration: InputDecoration(
              labelText: 'Event Description',
              border: OutlineInputBorder(),
              prefixIcon: Column(
                  //children: [Text("Description: ")],
                  mainAxisAlignment: MainAxisAlignment.center),
              // hintText: 'Enter the event description'
            ),
            style: TextStyle(fontSize: 16)));
  }

  Widget AddTime() {
    return SizedBox(
        width: 375,
        child: TextFormField(
            controller: myTime,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () => _selectTime(context),
                    icon: const Icon(Icons.access_time_outlined,color: Color.fromARGB(255, 180, 165, 211))),
                hintText: selectedTime.format(context)),
            readOnly: true,
            style: TextStyle(fontSize: 16)));
  }

  Widget Button() => ElevatedButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        child: Text(
          'Add Event',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          if (!myEvent.text.isEmpty && !myDescription.text.isEmpty) {
            DateTime dateholder = selectedDate;
            String eventholder = myEvent.text;
            String descriptionholder = myDescription.text;
            String timeHolder = selectedTime.format(context);

            print(dateholder);
            print(eventholder);
            print(descriptionholder);
            print(timeHolder);
            String id = userID();
            createEvent(id: id, date:dateholder, title:eventholder, description:descriptionholder, time:timeHolder);
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // Retrieve the text that the user has entered by using the
                  // TextEditingController.
                  content: Text(formatDate(dateholder) +
                      "\n" +
                      eventholder +
                      "\n" +
                      descriptionholder +
                      "\n" +
                      timeHolder),
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // Retrieve the text that the user has entered by using the
                  // TextEditingController.
                  content: Text("Please enter all information."),
                );
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 235, 151, 179),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      );

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030),
        initialEntryMode: DatePickerEntryMode.input);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print(formatDate(selectedDate));
      });
    }
  }

  String formatDate(DateTime date) => formatter.format(date);

  _selectTime(BuildContext context) async {
    final Future<TimeOfDay?> pickedTime = showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial);
    pickedTime.then((value) => setState(() {
          selectedTime = value!;
        }));
  }
  
  Future createEvent({required String id, required DateTime date, required String title, required String description, required String time}) async{
    
    final docUser = FirebaseFirestore.instance.collection('events').doc();
    final event = Event(
        userID:id,
        date:date,
        title:title,
        description:description,
        time:time,
    );
    final json = event.toJson();
    await docUser.set(json);
  } 
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userID() {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
  }
}
