import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InternationalStudentsInfoPage extends StatelessWidget {
  const InternationalStudentsInfoPage({super.key});

  Stream<QuerySnapshot> _studentsStream() {
    return FirebaseFirestore.instance.collection('international_students').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('International Students Info'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _studentsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No international students found.'));
          }

          final students = snapshot.data!.docs;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final data = students[index].data() as Map<String, dynamic>;
              final firstName = data['first_name'] ?? 'N/A';
              final lastName = data['last_name'] ?? '';
              final email = data['email'] ?? 'No email provided';
              // final phone = data['phone'] ?? 'No phone';
              final country = data['nationality'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(
                    '$firstName $lastName',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text('Email: $email'),
                      // Text('Phone: $phone'),
                      Text('Nationality: $country'),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
