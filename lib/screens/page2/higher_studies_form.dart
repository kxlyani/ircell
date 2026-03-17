import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ircell/backend/shared_pref.dart';

class HigherStudiesFormPage extends StatefulWidget {
  const HigherStudiesFormPage({Key? key}) : super(key: key);

  @override
  State<HigherStudiesFormPage> createState() => _HigherStudiesFormPageState();
}

class _HigherStudiesFormPageState extends State<HigherStudiesFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _fieldOfStudyController = TextEditingController();
  final TextEditingController _examNameController = TextEditingController();
  final TextEditingController _examScoreController = TextEditingController();
  final TextEditingController _scholarshipController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _graduationDateController = TextEditingController();

  String _admissionStatus = 'Applied';
  final List<String> _admissionStatusOptions = ['Applied', 'Admitted', 'Rejected'];

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final uid = await LocalStorage.getUID();
      final data = {
        'uid': uid,
        'country': _countryController.text.trim(),
        'university': _universityController.text.trim(),
        'course': _courseController.text.trim(),
        'field_of_study': _fieldOfStudyController.text.trim(),
        'exam_name': _examNameController.text.trim(),
        'exam_score': _examScoreController.text.trim(),
        'admission_status': _admissionStatus,
        'start_date': _startDateController.text.trim(),
        'expected_graduation': _graduationDateController.text.trim(),
        'scholarship_info': _scholarshipController.text.trim(),
        'timestamp': Timestamp.now(),
      };

      await FirebaseFirestore.instance.collection('higher_studies_info').add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Information submitted successfully!')),
      );

      _formKey.currentState?.reset();
      _clearControllers();
    }
  }

  void _clearControllers() {
    _countryController.clear();
    _universityController.clear();
    _courseController.clear();
    _fieldOfStudyController.clear();
    _examNameController.clear();
    _examScoreController.clear();
    _startDateController.clear();
    _graduationDateController.clear();
    _scholarshipController.clear();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Higher Studies Form'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Higher Studies Information',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(_countryController, 'Target Country'),
                  _buildTextField(_universityController, 'University Name'),
                  _buildTextField(_courseController, 'Course / Program'),
                  _buildTextField(_fieldOfStudyController, 'Field of Study'),
                  _buildTextField(_examNameController, 'Exam Name (e.g., GRE, IELTS)'),
                  _buildTextField(_examScoreController, 'Exam Score'),
                  _buildDropdown(),
                  _buildDatePicker(_startDateController, 'Start Date'),
                  _buildDatePicker(_graduationDateController, 'Expected Graduation Date'),
                  _buildTextField(_scholarshipController, 'Scholarship Info'),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submitForm,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('Submit Information'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
      ),
    );
  }

  Widget _buildDatePicker(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () => _selectDate(controller),
        validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Admission Status',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        value: _admissionStatus,
        items: _admissionStatusOptions.map((status) {
          return DropdownMenuItem(
            value: status,
            child: Text(status),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _admissionStatus = value;
            });
          }
        },
        validator: (value) => value == null ? 'Please select a status' : null,
      ),
    );
  }
}
