import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
class EventActions extends StatelessWidget {
  final String eventId;

  const EventActions({super.key, required this.eventId});

  Future<int> fetchInterestedCount(String eventId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .get();

      final data = doc.data() as Map<String, dynamic>;
      return data['attendees'] ?? 0;
    } catch (e) {
      print('Error fetching attendees count: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAttendanceList(String eventId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .get();

      final data = doc.data() as Map<String, dynamic>;
      List<String> uids = List<String>.from(data['attendanceList'] ?? []);

      List<Map<String, dynamic>> studentDetails = [];

      for (String uid in uids) {
        final trimmedUid = uid.trim();
        Map<String, dynamic>? foundStudent;

        List<String> collections = [
          'pccoe_students',
          'external_college_students',
          'international_students',
          'alumni',
        ];

        for (String collection in collections) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection(collection)
              .doc(trimmedUid)
              .get();

          if (userDoc.exists) {
            final userData = userDoc.data() as Map<String, dynamic>;
            foundStudent = {
              'uid': trimmedUid,
              'firstName': userData['first_name'] ?? userData['firstname'] ?? '',
              'lastName': userData['last_name'] ?? userData['lastname'] ?? '',
              'email': userData['email'] ?? '',
              'source': collection,
            };
            break;
          }
        }

        studentDetails.add(foundStudent ??
            {
              'uid': trimmedUid,
              'firstName': '[Not Found]',
              'lastName': '',
              'email': '',
              'source': 'Unknown',
            });
      }

      return studentDetails;
    } catch (e) {
      print('Error fetching attendance list: $e');
      return [];
    }
  }

  Future<void> exportToCSV(List<Map<String, dynamic>> students) async {
    final StringBuffer csvBuffer = StringBuffer();
    csvBuffer.writeln('UID,First Name,Last Name,Email,Source');

    for (var student in students) {
      csvBuffer.writeln(
        '${student['uid']},${student['firstName']},${student['lastName']},${student['email']},${student['source']}',
      );
    }

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/attendance.csv');
    await file.writeAsString(csvBuffer.toString());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Attendance'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: FutureBuilder<int>(
        future: fetchInterestedCount(eventId),
        builder: (context, countSnapshot) {
          final attendeesCount = countSnapshot.data ?? 0;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    border: Border.all(color: Colors.indigo, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Interested Attendees',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$attendeesCount student(s) have shown interest in attending this event.',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(thickness: 1),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchAttendanceList(eventId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    }

                    final students = snapshot.data ?? [];

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Total Students Marked Present: ${students.length}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 4,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: students.length,
                              itemBuilder: (context, index) {
                                final student = students[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.indigo,
                                    child: Text(
                                      student['firstName'].isNotEmpty
                                          ? student['firstName'][0]
                                          : '?',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    '${student['firstName']} ${student['lastName']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '${student['email']}\nSource: ${student['source']}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  isThreeLine: true,
                                  trailing: const Icon(Icons.check_circle,
                                      color: Colors.green),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.file_download),
                  label: const Text('Export to CSV'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    minimumSize: const Size.fromHeight(45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final students = await fetchAttendanceList(eventId);
                    if (students.isNotEmpty) {
                      await exportToCSV(students);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('No attendance to export.')),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 46,
              ),
            ],
          );
        },
      ),
    );
  }
}
