import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ircell/backend/fetch_user_data.dart';
import 'package:ircell/backend/shared_pref.dart';

class WriteBlogScreen extends StatefulWidget {
  const WriteBlogScreen({super.key});

  @override
  State<WriteBlogScreen> createState() => _WriteBlogScreenState();
}

class _WriteBlogScreenState extends State<WriteBlogScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitBlog() async {
     final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Get UID from SharedPreferences
    final uid = await LocalStorage.getUID();

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final userInfo = await fetchUserInfo('alumni', uid);

    // Prepare data to save
    final blogData = {
      'uid' : uid,
      'first_name' : userInfo?['first_name'] ?? [],
      'last_name' : userInfo?['last_name'] ?? [],
      'email' : userInfo?['email'] ?? [],
      'title': title,
      'content': content,
      'isVerified' : false,
      'timestamp': FieldValue.serverTimestamp(), // Firestore server timestamp
    };

    try {
      // Save data to Firestore under "blogs" collection with doc ID as uid
      await FirebaseFirestore.instance.collection('alumni_blogs').add(blogData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blog published successfully!')),
      );

      // Optionally clear the text fields
      _titleController.clear();
      _contentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to publish blog: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Blog'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Blog Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Blog Content',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitBlog,
              child: const Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }
}
