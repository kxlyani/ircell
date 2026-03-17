import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';

class InfoDialog extends StatelessWidget {
  final String pageTitle;
  final String pageDescription;

  const InfoDialog({
    super.key,
    required this.pageTitle,
    required this.pageDescription,
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
                                    pageDescription,
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

class PageInfo {
  static Map<String, Map<String, String>> infoData = {
    'Page1': {
      'title': 'Welcome to the Featured Events Page!',
      'description':
          'Here you can browse top events, view suggestions, and navigate to full event details. Swipe to explore or tap on a card to learn more.',
    },
    'Page2': {
      'title': 'Activities Hub',
      'description':
          'Access various international activities including internships, student exchanges, and alumni connections. Navigate through different categories.',
    },
    'Page3': {
      'title': 'My Tickets',
      'description':
          'View your currently booked event tickets and past attendance history. Generate QR codes for event check-ins.',
    },
    'Page4': {
      'title': 'IR Community',
      'description':
          'Explore resources, articles, and videos about international relations. Connect with alumni and access study abroad materials.',
    },
  };

  static void showInfoDialog(BuildContext context, String pageKey) {
    final info = infoData[pageKey];
    if (info != null) {
      showDialog(
        context: context,
        builder: (context) => InfoDialog(
          pageTitle: info['title']!,
          pageDescription: info['description']!,
        ),
      );
    }
  }
}