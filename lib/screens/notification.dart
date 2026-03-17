import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';

class NotificationDialog extends StatelessWidget {
  final String pageTitle;
  final String notificationText;

  const NotificationDialog({
    super.key,
    required this.pageTitle,
    required this.notificationText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.cardColor(context),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                // 🔹 Content Area
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight - 70,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    pageTitle,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary(context),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    notificationText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textSecondary(context),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 🔹 Close Button
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: AppTheme.textPrimary(context),
                      size: 28,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageNotification {
  static Map<String, Map<String, String>> notificationData = {
    'Page1': {
      'title': 'Featured Events Updates',
      'text': '2 new events have been added recently. Tap to explore!',
    },
    'Page2': {
      'title': 'Activities Hub Notifications',
      'text': 'New internships and exchange opportunities are live now.',
    },
    'Page3': {
      'title': 'Ticket Alerts',
      'text': 'Your upcoming event ticket has been updated. Check details.',
    },
    'Page4': {
      'title': 'Community Announcements',
      'text': 'Join our next IR Alumni Q&A webinar this weekend!',
    },
  };

  static void showNotificationDialog(BuildContext context, String pageKey) {
    final data = notificationData[pageKey];
    if (data != null) {
      showDialog(
        context: context,
        builder: (context) => NotificationDialog(
          pageTitle: data['title']!,
          notificationText: data['text']!,
        ),
      );
    }
  }
}