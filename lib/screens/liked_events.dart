import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/providers/event_provider.dart'; // Event model
import 'package:ircell/screens/events/event_details.dart';
import 'package:ircell/screens/events/past_event_details.dart'; // <-- Import this

class LikedEventsPage extends StatefulWidget {
  const LikedEventsPage({super.key});

  @override
  State<LikedEventsPage> createState() => _LikedEventsPageState();
}

class _LikedEventsPageState extends State<LikedEventsPage> {
  Stream<List<Event>> _likedEventsStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return FirebaseFirestore.instance
        .collection('events')
        .where('likedBy', arrayContains: uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                return Event(
                  id: doc.id,
                  title: data['title'] ?? '',
                  date: data['date'] ?? '',
                  time: data['time'] ?? '',
                  location: data['location'] ?? '',
                  speaker: data['speaker'] ?? '',
                  description: data['description'] ?? '',
                  imageURL: data['imageURL'] ?? '',
                  likes: data['likes'],
                  attendanceList:
                      (data['attendanceList'] as List<dynamic>?)
                          ?.map((e) => e.toString())
                          .toList() ??
                      [],
                );
              }).toList(),
        );
  }

  Stream<List<Event>> _likedPastEventsStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return FirebaseFirestore.instance
        .collection('past_events')
        .where('likedBy', arrayContains: uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                return Event(
                  id: doc.id,
                  title: data['title'] ?? '',
                  date: data['date'] ?? '',
                  time: data['time'] ?? '',
                  location: data['location'] ?? '',
                  speaker: data['speaker'] ?? '',
                  description: data['description'] ?? '',
                  imageURL: data['imageURL'] ?? '',
                  likes: data['likes'],
                  attendanceList:
                      (data['attendanceList'] as List<dynamic>?)
                          ?.map((e) => e.toString())
                          .toList() ??
                      [],
                );
              }).toList(),
        );
  }

  Widget _buildEventCard(Event event, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.imageURL.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.network(
                  event.imageURL,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 6),
                      Text('${event.date} at ${event.time}'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 6),
                      Text(event.location),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16),
                      const SizedBox(width: 6),
                      Text('Speaker: ${event.speaker}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20,
          bottom: 30,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Upcoming Liked Events",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<List<Event>>(
                stream: _likedEventsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final likedEvents = snapshot.data;

                  if (likedEvents == null || likedEvents.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor(context).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: AppTheme.accentBlue,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No upcoming liked events",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Tap the heart icon on events you like!",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children:
                        likedEvents.map((event) {
                          return _buildEventCard(event, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailScreen(event: event),
                              ),
                            );
                          });
                        }).toList(),
                  );
                },
              ),
              const SizedBox(height: 30),
              const Text(
                "Past Liked Events",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<List<Event>>(
                stream: _likedPastEventsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final pastEvents = snapshot.data;

                  if (pastEvents == null || pastEvents.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor(context).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.history,
                            color: AppTheme.accentBlue,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No past liked events",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Liked past events will appear here.",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children:
                        pastEvents.map((event) {
                          return _buildEventCard(event, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => PastEventDetailScreen(event: event),
                              ),
                            );
                          });
                        }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
