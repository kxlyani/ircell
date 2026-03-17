import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> fetchAlumniData() async {
  try {
    CollectionReference alumniCollection = FirebaseFirestore.instance.collection('alumni');

    QuerySnapshot snapshot = await alumniCollection.get();

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      print('Full Name: ${data['first_name']} ${data['last_name']}');
      print('Email: ${data['email']}');
      print('Contact: ${data['contact']}');
      print('Interests: ${data['interests']?.join(', ')}');
      print('Designation: ${data['designation']}');
      print('LinkedIn: ${data['linkedin']}');
      print('Country: ${data['country']}');
      print('Passout Year: ${data['passout_year']}');
      print('PG Name: ${data['pg_name']}');
      print('Qualification: ${data['qualification']}');
      print('Industry: ${data['industry']}');
      print('Outbound: ${data['outbound']?.join(', ')}');
      print('State: ${data['state']}');
      print('---');
    }
  } catch (e) {
    print('Error fetching alumni data: $e');
  }
}


class Alumni {
  final String firstName;
  final String lastName;
  final String email;
  final String contact;
  final String designation;
  final String industry;
  final String pgName;
  final String country;
  final String state;
  final String passoutYear;
  final String qualification;
  final String linkedin;
  final List<String> interests;
  final List<String> outbound;

  Alumni({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contact,
    required this.designation,
    required this.industry,
    required this.pgName,
    required this.country,
    required this.state,
    required this.passoutYear,
    required this.qualification,
    required this.linkedin,
    required this.interests,
    required this.outbound,
  });

  factory Alumni.fromMap(Map<String, dynamic> data) {
    return Alumni(
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['email'] ?? '',
      contact: data['contact'] ?? '',
      designation: data['designation'] ?? '',
      industry: data['industry'] ?? '',
      pgName: data['pg_name'] ?? '',
      country: data['country'] ?? '',
      state: data['state'] ?? '',
      passoutYear: data['passout_year'] ?? '',
      qualification: data['qualification'] ?? '',
      linkedin: data['linkedin'] ?? '',
      interests: List<String>.from(data['interests'] ?? []),
      outbound: List<String>.from(data['outbound'] ?? []),
    );
  }
}

