import 'package:flutter/material.dart';
import 'package:ircell/admin/event/event_actions.dart';
import 'package:ircell/admin/event/middle_screen.dart';
import 'package:ircell/providers/event_provider.dart';

class ViewEvents extends StatefulWidget {
  const ViewEvents({super.key, required this.function});

  final String function;

  @override
  State<ViewEvents> createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {
  late Future<List<Event>> _eventsFuture;
  late String function;

  @override
  void initState() {
    super.initState();
    function = widget.function;
    _eventsFuture = fetchAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading events'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found'));
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return GestureDetector(
                  onTap: () {
                    if (function == 'publish') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MiddleScreen(eventId: event.id),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventActions(eventId: event.id),
                        ),
                      );
                    }
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.event, color: Colors.indigo),
                      title: Text(
                        event.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
