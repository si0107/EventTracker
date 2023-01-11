import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final DateTime date;
  final String userID;
  final String title;
  final String description;
  final String time;

  Event({required this.date, required this.userID, required this.title, required this.description, required this.time});

  Map<String, dynamic> toJson() => {
    'userID':userID,
    'date':date,
    'title':title,
    'description':description,
    'time':time,
  };
  static Event fromJson(Map<String, dynamic> json) => Event(
    userID: json['userID'],
    date:(json['date'] as Timestamp).toDate(),
    title:json['title'],
    description: json['description'],
    time: json['time'],
  );
}
