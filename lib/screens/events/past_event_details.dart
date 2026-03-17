import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/providers/event_provider.dart';

class PastEventDetailScreen extends StatefulWidget {
  final Event event;

  const PastEventDetailScreen({super.key, required this.event});

  @override
  State<PastEventDetailScreen> createState() => _PastEventDetailScreenState();
}

class _PastEventDetailScreenState extends State<PastEventDetailScreen> {
  
  bool isLiked = false;
  int likesCount = 0;
  late String uid;

  @override
  void initState() {
    super.initState();
    _initializeLikeData();
  }

  Future<void> _initializeLikeData() async {
    final User? user = Auth().currentUser;
    uid = user?.uid ?? "";

    final doc = await FirebaseFirestore.instance
        .collection('past_events')
        .doc(widget.event.id)
        .get();

    final data = doc.data();
    if (data != null) {
      List likedBy = data['likedBy'] ?? [];
      setState(() {
        likesCount = data['likes'] ?? 0;
        isLiked = likedBy.contains(uid);
      });
    }
  }

  Future<void> _toggleLike() async {
    final docRef = FirebaseFirestore.instance.collection('past_events').doc(widget.event.id);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      List likedBy = List<String>.from(data['likedBy'] ?? []);
      int currentLikes = data['likes'] ?? 0;

      if (likedBy.contains(uid)) {
        likedBy.remove(uid);
        currentLikes--;
      } else {
        likedBy.add(uid);
        currentLikes++;
      }

      transaction.update(docRef, {
        'likedBy': likedBy,
        'likes': currentLikes,
      });

      setState(() {
        isLiked = likedBy.contains(uid);
        likesCount = currentLikes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.event.imageURL,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow("📅 Date", widget.event.date),
                    _buildDetailRow("⏰ Time", widget.event.time),
                    _buildDetailRow("📍 Location", widget.event.location),
                    _buildDetailRow("🎤 Speaker", widget.event.speaker),
                    const SizedBox(height: 16),
                    Text(
                      "About the Event",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.event.description,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          IconButton(
                            iconSize: 36,
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                            onPressed: _toggleLike,
                          ),
                          Text(
                            '$likesCount Likes',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 78),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }

//   Future<void> _handleRSVP(BuildContext context, Event event) async {
//   final User? user = Auth().currentUser;
//   final String uid = user?.uid ?? "";

//   if (uid.isEmpty) return;

//   final List<String> collections = [
//     'pccoe_students',
//     'external_college_students',
//     'international_students',
//     'alumni',
//   ];

//   final eventDocRef =
//       FirebaseFirestore.instance.collection('events').doc(event.id);

//   DocumentSnapshot? userSnapshot;
//   DocumentReference? userDocRef;

//   for (final collection in collections) {
//     final docRef = FirebaseFirestore.instance.collection(collection).doc(uid);
//     final snapshot = await docRef.get();
//     if (snapshot.exists) {
//       userSnapshot = snapshot;
//       userDocRef = docRef;
//       break;
//     }
//   }

//   if (userSnapshot == null || userDocRef == null) {
//     _showDialog(
//       context,
//       title: "User Not Found",
//       content: "You are not registered in any user category.",
//     );
//     return;
//   }

//   final List<dynamic> attending = List.from(
//     (userSnapshot.data() as Map<String, dynamic>?)?['attending'] ?? [],
//   );

//   if (attending.contains(event.title)) {
//     _showDialog(
//       context,
//       title: "Already Registered",
//       content: "You have already registered for this event.",
//     );
//     return;
//   }

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Do you wish to register for "${event.title}"?',
//               style: Theme.of(context).textTheme.titleMedium,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: const Text('No'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     try {
//                       await FirebaseFirestore.instance.runTransaction(
//                         (transaction) async {
//                           final eventSnapshot =
//                               await transaction.get(eventDocRef);

//                           final currentAttendees =
//                               eventSnapshot.data()?['attendees'] ?? 0;
//                           final List<String> attendanceList = List<String>.from(
//                             eventSnapshot.data()?['attendanceList'] ?? [],
//                           );

//                           if (!attendanceList.contains(uid)) {
//                             attendanceList.add(uid);
//                             transaction.update(eventDocRef, {
//                               'attendees': currentAttendees + 1,
//                               'attendanceList': attendanceList,
//                             });
//                           }

//                           attending.add(event.title);
//                           transaction.set(
//                             userDocRef!,
//                             {'attending': attending},
//                             SetOptions(merge: true),
//                           );
//                         },
//                       );

//                       Navigator.of(context).pop(); // close confirm dialog
//                       _showDialog(
//                         context,
//                         title: "Registered Successfully",
//                         content:
//                             "You have successfully registered for the event.\n\nNote: Ticket can be found in the Tickets section.",
//                       );
//                     } catch (e) {
//                       Navigator.of(context).pop(); // close confirm dialog
//                       _showDialog(
//                         context,
//                         title: "Registration Failed",
//                         content: "Something went wrong: $e",
//                       );
//                     }
//                   },
//                   child: const Text('Yes'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

  // void _showDialog(BuildContext context,
  //     {required String title, required String content}) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text(title),
  //       content: Text(content),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text("OK"),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
