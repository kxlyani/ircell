import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadChatbotLinkScreen extends StatefulWidget {
  const UploadChatbotLinkScreen({Key? key}) : super(key: key);

  @override
  State<UploadChatbotLinkScreen> createState() => _UploadChatbotLinkScreenState();
}

class _UploadChatbotLinkScreenState extends State<UploadChatbotLinkScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();
  bool _isUploading = false;

  Future<void> uploadUrl(String url) async {
    try {
      setState(() => _isUploading = true);

      await FirebaseFirestore.instance
          .collection('links')
          .doc('chatbotapi')
          .set({'apiUrl': url}, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('URL uploaded successfully')),
      );

      _urlController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading URL: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Chatbot API URL')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'Enter Chatbot API URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUploading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          uploadUrl(_urlController.text.trim());
                        }
                      },
                child: _isUploading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}