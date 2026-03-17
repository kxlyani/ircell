import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  const EditProfilePage({super.key, required this.userDetails});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final List<String> excludedFields = ['timestamp', 'interests'];
  late Map<String, TextEditingController> controllers = {};
  late String collection;
  late String uid;

  @override
  void initState() {
    super.initState();
    final data = widget.userDetails['data'] as Map<String, dynamic>;
    uid = widget.userDetails['uid'];
    collection = widget.userDetails['collection'];

    data.forEach((key, value) {
      if (!excludedFields.contains(key)) {
        controllers[key] = TextEditingController(text: value.toString());
      }
    });
  }

  @override
  void dispose() {
    controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  Future<void> updateUserData() async {
    final updatedData = {
      for (final entry in controllers.entries) entry.key: entry.value.text
    };

    await FirebaseFirestore.instance.collection(collection).doc(uid).update(updatedData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated successfully")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                for (final entry in controllers.entries) ...[
                  TextField(
                    controller: entry.value,
                    decoration: InputDecoration(
                      labelText: _beautifyLabel(entry.key),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    backgroundColor: AppTheme.accentBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: updateUserData,
                  icon: Icon(Icons.save),
                  label: Text("Save", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Optional: Format field labels nicely (e.g. "fullName" -> "Full Name")
  String _beautifyLabel(String key) {
    return key.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    }).replaceFirst(key[0], key[0].toUpperCase());
  }
}
