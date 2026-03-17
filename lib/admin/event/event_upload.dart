import 'package:flutter/material.dart';
import 'package:ircell/admin/event/eventform.dart';
import 'package:ircell/admin/event/view_event.dart';

class EventUpload extends StatelessWidget {
  const EventUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Management'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _EventOptionCard(
              title: 'Upload New Event',
              icon: Icons.cloud_upload,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => EventForm()),
                );
              },
            ),
            const SizedBox(height: 20),
            _EventOptionCard(
              title: 'View All Events',
              icon: Icons.event_note,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (ctx) => ViewEvents(function: 'view')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EventOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _EventOptionCard({
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
              Icon(icon, size: 28, color: Colors.indigo),
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
