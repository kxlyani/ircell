import 'package:flutter/material.dart';
import 'package:ircell/admin/alumni/alumni_options.dart';
import 'package:ircell/admin/chatbotlink.dart';
import 'package:ircell/admin/event/event_upload.dart';
import 'package:ircell/admin/event/view_event.dart';
import 'package:ircell/admin/higher_studies/higher_studies.dart';
import 'package:ircell/admin/international_students/international_students_admin.dart';
import 'package:ircell/admin/student_mobilty/student_mobility.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _AdminOptionCard(
                  title: 'Events',
                  icon: Icons.event,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => EventUpload()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _AdminOptionCard(
                  title: 'Attendance Scanner',
                  icon: Icons.qr_code_scanner,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ViewEvents(function: 'publish'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _AdminOptionCard(
                  title: 'Student Mobility',
                  icon: Icons.group,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => StudentMobilityAdmin(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _AdminOptionCard(
                  title: 'Higher Studies',
                  icon: Icons.school,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const HigherStudiesOptions(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _AdminOptionCard(
                  title: 'International Alumni',
                  icon: Icons.public,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const AlumniOptions(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _AdminOptionCard(
                  title: 'International Students',
                  icon: Icons.airplanemode_active,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const InternationalStudentsAdmin(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 200),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const UploadChatbotLinkScreen(),
                  ));
                }, child: Text('Chatbot link'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _AdminOptionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, size: 28, color: Colors.deepPurple),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}