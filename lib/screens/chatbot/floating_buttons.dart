import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/models/alumni_button.dart';
import 'package:ircell/screens/activities/scan_connect.dart';
import 'package:ircell/screens/chatbot/chatbot_screen.dart';
import 'package:ircell/screens/community/write_blog.dart';

class ChatbotIcon extends StatelessWidget {
  final VoidCallback? onPressed;

  const ChatbotIcon({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onPressed ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatbotScreen()),
            );
          },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.accentBlue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

class ScanIcon extends StatelessWidget {
  final VoidCallback? onPressed;

  const ScanIcon({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onPressed ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScanConnect()),
            );
          },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.accentBlue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

class FloatingButtonsStack extends StatelessWidget {
  const FloatingButtonsStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        alumniFloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WriteBlogScreen(),
              ),
            );
          },
          icon: const Icon(Icons.create_rounded),
        ),
        const SizedBox(height: 16),
        const ChatbotIcon(),
        
      ],
    );
  }
}
