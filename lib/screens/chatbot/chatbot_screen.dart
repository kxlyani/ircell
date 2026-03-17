import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  bool _showGif = true;
  final List<Map<String, String>> _messages = [];
  String apiUrl = '';
  bool _isLoading = true;
  String? _error;

  final String apiKey = "f0ZgN8zwBecpmI0PmLBH3ZcQWADi6MNc"; // Your API key

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeFirebaseAndLoadUrl();

    _controller.addListener(() {
      if (_controller.text.trim().isNotEmpty && _showGif) {
        setState(() {
          _showGif = false;
        });
      } else if (_controller.text.trim().isEmpty &&
          MediaQuery.of(context).viewInsets.bottom == 0) {
        setState(() {
          _showGif = true;
        });
      }
    });
  }

  Future<void> _initializeFirebaseAndLoadUrl() async {
    try {
      // Initialize Firebase if not already initialized
      try {
        await Firebase.initializeApp();
      } catch (e) {
        print("Firebase might already be initialized: $e");
      }

      // Get the document
      DocumentSnapshot doc;
      try {
        doc =
            await FirebaseFirestore.instance
                .collection('links')
                .doc('chatbotapi')
                .get();
      } catch (e) {
        setState(() {
          _error = 'Firestore access error: $e';
          _isLoading = false;
        });
        return;
      }

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('apiUrl') && data['apiUrl'] is String) {
          setState(() {
            apiUrl = data['apiUrl']!;
            _isLoading = false;
          });
          return;
        }
      }

      setState(() {
        _error =
            'API URL configuration not found in Firestore. '
            'Please ensure the document links/chatbotapi exists with an apiUrl field.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize: $e';
        _isLoading = false;
      });
    }
  }

  // In your build method, show appropriate error messages:
  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeFirebaseAndLoadUrl,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset == 0 && _controller.text.trim().isEmpty) {
      setState(() {
        _showGif = true;
      });
    } else if (bottomInset > 0) {
      if (_showGif) {
        setState(() {
          _showGif = false;
        });
      }
    }
  }

  void _sendMessage() async {
    if (_isLoading || apiUrl.isEmpty) {
      setState(() {
        _messages.add({
          'sender': 'bot',
          'text':
              _error ?? 'API is not configured yet. Please try again later.',
        });
      });
      return;
    }

    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _showGif = false;
    });

    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json', 'X-API-Key': apiKey},
        body: jsonEncode({'query': text, 'language': 'en'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botReply = data['message'] ?? 'No response';
        setState(() {
          _messages.add({'sender': 'bot', 'text': botReply});
        });
      } else {
        setState(() {
          _messages.add({
            'sender': 'bot',
            'text': 'Error (${response.statusCode}): Could not get response.',
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'bot', 'text': 'Connection error: $e'});
      });
    }
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['sender'] == 'user';
    final text = message['text'] ?? '';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.accentBlue : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child:
            isUser
                ? Text(text, style: const TextStyle(color: Colors.white))
                : ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: MarkdownBody(
                    data: text,
                    styleSheet: MarkdownStyleSheet.fromTheme(
                      Theme.of(context),
                    ).copyWith(p: const TextStyle(color: Colors.black)),
                  ),
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String getImagePath(String imageName) {
      return isDark
          ? 'assets/images/dark/$imageName.jpeg'
          : 'assets/images/light/$imageName.png';
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Black background for status bar area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).padding.top,
            child: Container(color: Colors.black),
          ),

          // Background Image covering screen below status bar
          Positioned.fill(
            top: MediaQuery.of(context).padding.top,
            child: Image.asset(getImagePath('chatbot_bg'), fit: BoxFit.cover),
          ),

          // GIF overlay when enabled
          if (_showGif)
            Positioned(
              right: 16,
              bottom: 80,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/images/chatbot.gif',
                  fit: BoxFit.contain,
                ),
              ),
            ),

          // Main content with SafeArea for status bar padding
          SafeArea(
            child: Column(
              children: [
                // Chatbot strip (app bar style)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDarkBlue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Back button with circular background
                      CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.white,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Chatbot',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Chat messages area
                // Expanded(
                //   child: ListView.builder(
                //     padding: const EdgeInsets.only(top: 8, bottom: 8),
                //     reverse: true,
                //     itemCount: _messages.length,
                //     itemBuilder: (context, index) {
                //       return _buildMessage(
                //           _messages[_messages.length - 1 - index]);
                //     },
                //   ),
                // ),
                Expanded(
                  child:
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _error != null
                          ? _buildErrorWidget()
                          : ListView.builder(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            reverse: true,
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              return _buildMessage(
                                _messages[_messages.length - 1 - index],
                              );
                            },
                          ),
                ),

                // Input bar at bottom with fully curved container
                Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        MediaQuery.of(context).viewInsets.bottom > 0
                            ? MediaQuery.of(context).viewInsets.bottom
                            : 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDarkBlue,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Expanded TextField inside the curved container
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: AppTheme.lightTeal,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                hintText: "Type your message...",
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.transparent,
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                        ),

                        // Send button inside the same curved container
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                            onPressed: _sendMessage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentBlue.withOpacity(
                                0.3,
                              ),
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(
                              Icons.send,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
