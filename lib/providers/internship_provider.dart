import 'package:cloud_firestore/cloud_firestore.dart';

class OutboundInternship {
  final String id;
  final String title;
  final String university;
  final String country;
  final String topic;
  final String duration;
  final String cost;
  final String benefit;

  OutboundInternship({
    required this.id,
    required this.title,
    required this.university,
    required this.country,
    required this.topic,
    required this.duration,
    required this.cost,
    required this.benefit,
  });

  factory OutboundInternship.fromMap(Map<String, dynamic> data, String id) {
    return OutboundInternship(
      id: id,
      title: data['title']?.toString() ?? '',
      university: data['university']?.toString() ?? '',
      country: data['country']?.toString() ?? '',
      topic: data['topic']?.toString() ?? '',
      duration: data['duration']?.toString() ?? '',
      cost: data['cost']?.toString() ?? '',
      benefit: data['benefit']?.toString() ?? '',
    );
  }
}

Future<List<OutboundInternship>> fetchAllOutboundInternships() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('outbound_internships').get();

    return querySnapshot.docs
        .map((doc) => OutboundInternship.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  } catch (e) {
    print('Error fetching outbound internships: $e');
    return [];
  }
}

class InboundInternship {
  final String id;
  final String title;
  final String university;
  final String country;
  final String topic;
  final String duration;
  final String status;
  final String coordinator;
  final String description;
  final List<String> announcements;

  InboundInternship({
    required this.id,
    required this.title,
    required this.university,
    required this.country,
    required this.topic,
    required this.duration,
    required this.status,
    required this.coordinator,
    required this.description,
    required this.announcements,
  });

  factory InboundInternship.fromMap(Map<String, dynamic> data, String id) {
    return InboundInternship(
      id: id,
      title: data['title']?.toString() ?? '',
      university: data['university']?.toString() ?? '',
      country: data['country']?.toString() ?? '',
      topic: data['topic']?.toString() ?? '',
      duration: data['duration']?.toString() ?? '',
      status: data['status']?.toString() ?? '',
      coordinator: data['coordinator']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      announcements: data['announcements'] != null 
          ? List<String>.from(data['announcements'].map((x) => x.toString()))
          : [],
    );
  }
}

Future<List<InboundInternship>> fetchAllInboundInternships() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('inbound_internships').get();

    return querySnapshot.docs
        .map((doc) => InboundInternship.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  } catch (e) {
    print('Error fetching inbound internships: $e');
    return [];
  }
}
