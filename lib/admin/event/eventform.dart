import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ircell/backend/email_sending.dart';

class EventForm extends StatefulWidget {
  const EventForm({super.key});

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  final TextEditingController _speakerController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInputField(
                controller: _titleController,
                label: 'Title',
                icon: Icons.title,
              ),
              _buildInputField(
                controller: _imageURLController,
                label: 'Image URL',
                icon: Icons.image,
              ),
              _buildInputField(
                controller: _speakerController,
                label: 'Speaker',
                icon: Icons.person,
              ),
              _buildInputField(
                controller: _locationController,
                label: 'Location',
                icon: Icons.location_on,
              ),
              _buildInputField(
                controller: _timeController,
                label: 'Time',
                icon: Icons.access_time,
              ),
              _buildInputField(
                controller: _dateController,
                label: 'Date',
                icon: Icons.calendar_today,
              ),
              _buildInputField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.send),
                label: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        maxLines: maxLines,
        validator: (value) =>
            value == null || value.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final eventDetails = {
        'title': _titleController.text,
        'imageURL': _imageURLController.text,
        'speaker': _speakerController.text,
        'location': _locationController.text,
        'time': _timeController.text,
        'date': _dateController.text,
        'description': _descriptionController.text,
        'likes' : 0,
        'attendanceList': [],
      };

      FirebaseFirestore.instance
          .collection('events')
          .doc(_titleController.text)
          .set(eventDetails)
          .then((_) async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event added successfully!')),
        );
        _formKey.currentState!.reset();
        _clearFields();

        // ✅ After success: Fetch users and send email
        await sendEmailsToAllUsers(eventDetails);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add event: $error')),
        );
      });
    }
  }

  void _clearFields() {
    _titleController.clear();
    _imageURLController.clear();
    _speakerController.clear();
    _locationController.clear();
    _timeController.clear();
    _dateController.clear();
    _descriptionController.clear();
  }
}
