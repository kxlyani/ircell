import 'package:flutter/material.dart';
import 'package:ircell/providers/internship_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OutboundDetailPage extends StatelessWidget {
  final OutboundInternship internship;

  const OutboundDetailPage({super.key, required this.internship});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(internship.title)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildDetailRow("University", internship.university),
                    _buildDetailRow("Country", internship.country),
                    _buildDetailRow("Topic", internship.topic),
                    _buildDetailRow("Duration", internship.duration),
                    _buildDetailRow("Cost", internship.cost),
                    _buildDetailRow("Benefits", internship.benefit),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _handleRegister(context),
                child: const Text('Register'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Future<void> _handleRegister(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _showDialog(context, 'Error', 'User not logged in.');
      return;
    }

    try {
      final userDocRef = await _findUserDocRef(uid);

      if (userDocRef == null) {
        _showDialog(context, 'Error', 'User document not found.');
        return;
      }

      final userDoc = await userDocRef.get();
      List<dynamic> outboundList = userDoc.data()?['outbound'] ?? [];

      if (outboundList.contains(internship.title)) {
        _showDialog(context, 'Already Registered',
            'You have already registered for this internship.');
        return;
      }

      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Confirm Registration'),
              content: Text(
                  'Do you want to register for the internship "${internship.title}"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ) ??
          false;

      if (!confirmed) return;

      // Add title to outbound list atomically
      await userDocRef.update({
        'outbound': FieldValue.arrayUnion([internship.title])
      });

      _showDialog(context, 'Success',
          'You have successfully registered for "${internship.title}".');
    } catch (e) {
      _showDialog(context, 'Error', 'Failed to register: $e');
    }
  }

  Future<DocumentReference<Map<String, dynamic>>?> _findUserDocRef(
      String uid) async {
    final firestore = FirebaseFirestore.instance;
    final collections = [
      'pccoe_students',
      'external_college_students',
      'international_students',
      'alumni'
    ];

    for (var collection in collections) {
      final docRef = firestore.collection(collection).doc(uid);
      final docSnap = await docRef.get();
      if (docSnap.exists) {
        return docRef;
      }
    }
    return null;
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'))
              ],
            ));
  }
}
