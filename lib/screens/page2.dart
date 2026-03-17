import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/screens/page2/activities.dart';
import 'package:ircell/screens/activities/alumni.dart';
import 'package:ircell/screens/chatbot/floating_buttons.dart';
import 'package:ircell/screens/events/events_screen.dart';
import 'package:ircell/screens/page2/higher_studies.dart';
import 'package:ircell/screens/page2/international_students.dart';
import 'package:ircell/screens/internships/internships_screen.dart';
import 'package:ircell/screens/about_us.dart';
import 'package:ircell/screens/page2/international_students_info.dart';
import 'package:ircell/screens/profile%20page/profile_page.dart';
import 'package:ircell/screens/info.dart';
import 'package:ircell/screens/notification.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Page2> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildSection1(BuildContext context, Size screenSize) {
    double horizontalPadding = screenSize.width * 0.04;
    double verticalPadding = screenSize.height * 0.01;
    double buttonSpacing = screenSize.width * 0.001;

    // Increased from 0.18 to 0.24 to enlarge buttons
    double imageSize = screenSize.width * 0.19;

    // Increased from 0.035 to 0.045 to enlarge labels
    double textFontSize = screenSize.width * 0.040;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    String getImagePath(String imageName) {
      return isDark
          ? 'assets/images/dark/$imageName'
          : 'assets/images/light/$imageName';
    }

    Widget buildImageButton({
      required String label,
      required String imageName,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: CircleAvatar(
                radius: imageSize / 2,
                backgroundImage: AssetImage(getImagePath('$imageName.png')),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.01,
            ), // slightly increased spacing
            Text(
              label,
              style: TextStyle(
                fontSize: textFontSize.clamp(14.0, 18.0),
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding.clamp(12.0, 20.0),
        vertical: verticalPadding.clamp(6.0, 12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenSize.height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildImageButton(
                label: 'Events',
                imageName: 'event',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventsScreen(),
                      ),
                    ),
              ),
              SizedBox(width: buttonSpacing.clamp(2.0, 16.0)),
              buildImageButton(
                label: 'Internships',
                imageName: 'intern',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InternshipsScreen(),
                      ),
                    ),
              ),
              SizedBox(width: buttonSpacing.clamp(2.0, 16.0)),
              buildImageButton(
                label: 'My Activity',
                imageName: 'activity',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ActivitiesPage(),
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String subtitle,
    String imagePath,
    double heightRatio,
    Size screenSize, {
    VoidCallback? onTap,
    bool isLarge = false,
    bool useFlexibleHeight = false, // Add this parameter
  }) {
    double cardHeight = screenSize.height * heightRatio;
    double titleFontSize =
        isLarge ? screenSize.width * 0.045 : screenSize.width * 0.04;
    double subtitleFontSize =
        isLarge ? screenSize.width * 0.035 : screenSize.width * 0.03;
    double borderRadius = screenSize.width * 0.04;
    double bottomPadding = screenSize.width * 0.04;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Determine image path based on theme
    String getImagePath(String imageName) {
      return isDark
          ? 'assets/images/dark/$imageName'
          : 'assets/images/light/$imageName';
    }

    if (imagePath.contains('higher_studies')) {
      imagePath = getImagePath('higher_studies.png');
    } else if (imagePath.contains('international_alumni')) {
      imagePath = getImagePath('international_alumni.png');
    } else if (imagePath.contains('international_students')) {
      imagePath = getImagePath('international_students.png');
    } else if (imagePath.contains('about_us')) {
      imagePath = getImagePath('about_us.png');
    } else {
      imagePath = imagePath; // fallback to original path
    }

    Widget cardContent = Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppTheme.accentBlue.withOpacity(0.3),
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              bottom: bottomPadding.clamp(12.0, 20.0),
              left: bottomPadding.clamp(12.0, 20.0),
              right: bottomPadding.clamp(12.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize.clamp(14.0, 20.0),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: screenSize.height * 0.005),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: subtitleFontSize.clamp(11.0, 16.0),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // If using flexible height (inside Expanded), don't set a fixed height
    if (useFlexibleHeight) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: cardContent,
      );
    }

    // Use fixed height for non-flexible cards
    return Container(
      height: cardHeight.clamp(100.0, 200.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 8,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: cardContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;
    final double headerPadding = screenSize.height * 0.02;
    final double titleFontSize =
        isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.055;
    final double cardSpacing = screenSize.width * 0.03;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: AppTheme.glassDecoration(context),
              child: IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: AppTheme.textPrimary(context),
                ),
                onPressed: () => PageInfo.showInfoDialog(context, 'Page2'),
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: AppTheme.glassDecoration(context),
                  child: IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed:
                        () => PageNotification.showNotificationDialog(
                          context,
                          'Page2',
                        ),
                    // onPressed: () => PageNotification.showSameNotification(context);
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: AppTheme.accentBlue,
                      child: Text(
                        createEmailShortForm(),
                        style: TextStyle(
                          color: AppTheme.textPrimary(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Enhanced header
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accentBlue,
                          AppTheme.accentBlue.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: headerPadding.clamp(12.0, 20.0),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "International Relations Cell",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: titleFontSize.clamp(18.0, 24.0),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: screenSize.height * 0.02),
                          _buildSection1(context, screenSize),

                          const SizedBox(height: 15),
                          Divider(),
                          const SizedBox(height: 15),
                          // Feature cards section
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 12, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Main row with Higher Studies on left and stacked cards on right
                                IntrinsicHeight(
                                  // This ensures both sides have the same height
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .stretch, // Stretch to fill available height
                                    children: [
                                      // Left side - Higher Studies (larger card)
                                      Expanded(
                                        flex: 1, // Changed from 3 to 1
                                        child: _buildFeatureCard(
                                          "",
                                          "",
                                          'higher_studies',
                                          0.35, // This height will be overridden by IntrinsicHeight
                                          screenSize,
                                          isLarge: true,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return HigherStudiesPage();
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: cardSpacing.clamp(1.0, 2.0),
                                      ),
                                      // Right side - Stacked cards
                                      Expanded(
                                        flex: 1, // Changed from 2 to 1
                                        child: Column(
                                          children: [
                                            // Alumni Network
                                            Expanded(
                                              // Use Expanded to fill available space
                                              child: _buildFeatureCard(
                                                "",
                                                "",
                                                'international_alumni',
                                                0.16, // This will be overridden by Expanded
                                                screenSize,
                                                onTap:
                                                    () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                const AlumniScreen(),
                                                      ),
                                                    ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: cardSpacing.clamp(
                                                0.5,
                                                1.0,
                                              ),
                                            ),
                                            // International Community
                                            // Expanded(
                                            //   // Expanded to fill available space
                                            //   child: _buildFeatureCard(
                                            //     "",
                                            //     "",
                                            //     'international_students',
                                            //     0.16, // overridden by Expanded
                                            //     screenSize,
                                            //     onTap: () {
                                            //       Navigator.push(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //           builder:
                                            //               (context) =>
                                            //                   const InternationalStudentsPage(),
                                            //         ),
                                            //       );
                                            //     },
                                            //   ),
                                            // ),
                                            Expanded(
                                              child: _buildFeatureCard(
                                                "",
                                                "",
                                                'international_students',
                                                0.16,
                                                screenSize,
                                                onTap: () async {
                                                  final currentUser = FirebaseAuth.instance.currentUser;
                                                  if (currentUser == null) return;

                                                  final uid = currentUser.uid;

                                                  final doc = await FirebaseFirestore.instance
                                                      .collection('international_students')
                                                      .doc(uid)
                                                      .get();

                                                  if (doc.exists) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => const InternationalStudentsPage(),
                                                      ),
                                                    );
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => const InternationalStudentsInfoPage(),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: cardSpacing.clamp(1.0, 2.0)),
                                // Bottom row - About Us (full width)
                                _buildFeatureCard(
                                  "",
                                  "",
                                  'about_us',
                                  0.15,
                                  screenSize,
                                  isLarge: true,
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const AboutUsPage(),
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.1,
                          ), // Space for floating action button
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: screenSize.height * 0.025,
              right: screenSize.width * 0.05,
              child: FloatingButtonsStack(),
            ),
          ],
        ),
      ),
    );
  }
}
