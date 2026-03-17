import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String speaker;
  final String description;
  final String imageURL;
  final int likes;
  final List<String> attendanceList;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.speaker,
    required this.description,
    required this.imageURL,
    required this.likes,
    required this.attendanceList,
  });

  factory Event.fromMap(Map<String, dynamic> data, String id) {
    return Event(
      id: id,
      title: data['title']?.toString() ?? '',
      date: data['date']?.toString() ?? '',
      time: data['time']?.toString() ?? '',
      location: data['location']?.toString() ?? '',
      speaker: data['speaker']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      imageURL: data['imageURL']?.toString() ?? '',
      likes: data['likes'],
      attendanceList: (data['attendanceList'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

Future<List<Event>> fetchAllEvents() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('events').get();

    return querySnapshot.docs
        .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  } catch (e) {
    print('Error fetching events: $e');
    return [];
  }
}

Future<List<Event>> fetchPastEvents() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('past_events').get();

    return querySnapshot.docs
        .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  } catch (e) {
    print('Error fetching past events: $e');
    return [];
  }
}
