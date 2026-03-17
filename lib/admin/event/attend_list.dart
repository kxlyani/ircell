import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceListScreen extends StatelessWidget {
  const AttendanceListScreen({super.key, required this.eventId});

  final String eventId;
  

  Future<List<String>> _getAttendanceList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('attendance_$eventId') ?? [];
  }

  Future<void> _publishAttendance(BuildContext context) async {
    final attendanceList = await _getAttendanceList();

    if (attendanceList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No attendance to publish."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final timestamp = DateTime.now().toIso8601String();

    try {
      await firestore.collection('event_attendance').doc(eventId).set({
        'published_at': timestamp,
        'attendees': attendanceList,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Attendance successfully published to Firebase."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to publish: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned Attendance'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            tooltip: 'Publish to Firebase',
            onPressed: () => _publishAttendance(context),
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _getAttendanceList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snapshot.data ?? [];

          if (list.isEmpty) {
            return const Center(
              child: Text(
                'No attendance records found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      'UID: ${list[index]}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}