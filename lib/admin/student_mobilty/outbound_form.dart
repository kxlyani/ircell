import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OutboundForm extends StatefulWidget {
  const OutboundForm({super.key});

  @override
  State<OutboundForm> createState() => _OutboundFormState();
}

class _OutboundFormState extends State<OutboundForm> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String university = "";
  String country = "";
  String topic = "";
  String duration = "";
  String cost = "";
  String benefit = "";

  Future<void> uploadData() async {
    if (title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title is required as document ID")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('outbound_internships')
          .doc(title.trim())
          .set({
        'title': title,
        'university': university,
        'country': country,
        'topic': topic,
        'duration': duration,
        'cost': cost,
        'benefit': benefit,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Uploaded successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    }
  }

  Widget _buildTextField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Outbound Internship')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(label: 'Title', onChanged: (val) => setState(() => title = val)),
              _buildTextField(label: 'University', onChanged: (val) => setState(() => university = val)),
              _buildTextField(label: 'Country', onChanged: (val) => setState(() => country = val)),
              _buildTextField(label: 'Topic', onChanged: (val) => setState(() => topic = val)),
              _buildTextField(label: 'Duration', onChanged: (val) => setState(() => duration = val)),
              _buildTextField(
                label: 'Cost',
                keyboardType: TextInputType.number,
                onChanged: (val) => setState(() => cost = val),
              ),
              _buildTextField(label: 'Benefit', onChanged: (val) => setState(() => benefit = val)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: uploadData,
                  icon: const Icon(Icons.upload),
                  label: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
