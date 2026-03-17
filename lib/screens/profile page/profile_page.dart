import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/backend/fetch_user_data.dart';
import 'package:ircell/backend/shared_pref.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/login/splash_screen.dart';
import 'package:ircell/screens/about_us.dart';
import 'package:ircell/screens/profile%20page/add_interests.dart';
import 'package:ircell/screens/profile%20page/edit_profile_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userDetails; // Make it a class-level variable

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  void _loadUserDetails() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final collection = await getUserCollectionForStream();
    if (uid != null && collection != null) {
      final snapshot =
          await FirebaseFirestore.instance
              .collection(collection)
              .doc(uid)
              .get();
      if (snapshot.exists) {
        setState(() {
          userDetails = snapshot.data()!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double horizontalPadding = screenSize.width * 0.04;
    final double verticalPadding = screenSize.height * 0.02;
    final double iconSize = screenSize.width * 0.06;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 1),
            Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  color:
                      Theme.of(
                        context,
                      ).colorScheme.onSurface, // For primary text color,
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize.width * 0.05,
                ),
              ),
            ),
            Container(
              decoration: AppTheme.glassDecoration(context),
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: iconSize,
                ),
                onPressed: () async {
                  final userDetails = await fetchUserDetailsForEditing();

                  if (userDetails != null) {
                    // Wait for the user to come back from edit page
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                EditProfilePage(userDetails: userDetails),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User details not found')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppTheme.backgroundColor(context),
      // Wrap the main body in a SafeArea to avoid system intrusions
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),
          // Make the entire content scrollable
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header section
                _buildProfileHeader(context),

                SizedBox(height: verticalPadding * 1.5),

                // Personal Info content
                _buildPersonalInfoContent(),

                SizedBox(height: verticalPadding),

                // Preferences content
                _buildPreferencesContent(),

                SizedBox(height: verticalPadding),

                // Account actions section at bottom
                _buildAccountActionsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double profilePicSize = screenSize.width * 0.22;
    final double fontSize = screenSize.width * 0.045;
    final double smallFontSize = screenSize.width * 0.035;
    final double spacing = screenSize.height * 0.01;

    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return FutureBuilder<String?>(
      future: getUserCollectionForStream(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return buildShimmerRow(
            profilePicSize,
            fontSize,
            smallFontSize,
            spacing,
            screenSize,
          );
        }

        if (!futureSnapshot.hasData || futureSnapshot.data == null) {
          return Text(
            "User not found in any collection",
            style: TextStyle(color: Colors.red),
          );
        }

        final collection = futureSnapshot.data!;

        return StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection(collection)
                  .doc(uid)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.data == null ||
                !snapshot.data!.exists) {
              return buildShimmerRow(
                profilePicSize,
                fontSize,
                smallFontSize,
                spacing,
                screenSize,
              );
            }

            final userDetails = snapshot.data!.data() as Map<String, dynamic>;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: profilePicSize,
                  height: profilePicSize,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      createEmailShortForm(),
                      style: TextStyle(
                        fontSize: profilePicSize * 0.5,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenSize.width * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${userDetails['first_name'] ?? ''}${userDetails['last_name'] ?? ''}',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing / 2),
                      Text(
                        userDetails['email'] ?? '',
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildShimmerRow(
    double profilePicSize,
    double fontSize,
    double smallFontSize,
    double spacing,
    Size screenSize,
  ) {
    return Row(
      children: [
        buildShimmer(width: profilePicSize, height: profilePicSize),
        SizedBox(width: screenSize.width * 0.04),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildShimmer(width: 160, height: fontSize + 8),
              SizedBox(height: spacing / 2),
              buildShimmer(width: 160, height: smallFontSize + 4),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildShimmer({double width = 150, double height = 16}) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.grey,
      child: Container(width: width, height: height, color: Colors.white),
    );
  }

  Future<void> deleteUserData() async {
    await FirebaseFirestore.instance
        .collection(userDetails?['source_collection'] ?? '')
        .doc(userDetails?['uid'] ?? "")
        .delete();
  }

  Future<void> deleteUserAuth() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.delete(); // This deletes from Firebase Authentication
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      if (uid != null) {
        // First, delete from Firestore
        await deleteUserData();

        // Then, delete from Firebase Auth
        await deleteUserAuth();

        // Optional: Clear SharedPreferences
        await LocalStorage.clearUID();

        // Navigate to login or landing screen
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // Show message to re-login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please re-login to delete your account.")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
      }
    }
  }

  Widget _buildPersonalInfoContent() {
    final Size screenSize = MediaQuery.of(context).size;
    final double padding = screenSize.width * 0.04;
    final double spacing = screenSize.height * 0.015;
    final double titleSize = screenSize.width * 0.05;
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return FutureBuilder<String?>(
      future: getUserCollectionForStream(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!futureSnapshot.hasData || futureSnapshot.data == null) {
          return Text("User collection not found.");
        }

        final collection = futureSnapshot.data!;

        return StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection(collection)
                  .doc(uid)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text("User data not found.");
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            return Container(
              width: double.infinity,
              decoration: AppTheme.glassDecoration(context).copyWith(
                borderRadius: BorderRadius.circular(screenSize.width * 0.04),
              ),
              padding: EdgeInsets.all(padding),
              // Fixed height constraint removed to prevent overflow
              child: Column(
                mainAxisSize: MainAxisSize.min, // Take only needed space
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: spacing),

                  // Personal info fields
                  _buildInfoItem('Email', data['email'] ?? '', Icons.email),
                  SizedBox(height: spacing * 0.8),
                  _buildInfoItem(
                    'Phone',
                    '+91 ${data['contact'] ?? ''}',
                    Icons.phone,
                  ),
                  SizedBox(height: spacing * 0.8),
                  _buildInfoItem(
                    'Department',
                    data['department'] ?? '',
                    Icons.school,
                  ),
                  SizedBox(height: spacing * 0.8),
                  _buildInfoItem(
                    'Year',
                    data['year'] ?? '',
                    Icons.calendar_today,
                  ),
                  SizedBox(height: spacing * 1.5),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    final Size screenSize = MediaQuery.of(context).size;
    final double iconContainerSize = screenSize.width * 0.1;
    final double iconSize = screenSize.width * 0.05;
    final double labelSize = screenSize.width * 0.035;
    final double valueSize = screenSize.width * 0.04;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Align vertically
      children: [
        Container(
          width: iconContainerSize,
          height: iconContainerSize,
          decoration: BoxDecoration(
            color: AppTheme.accentBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(screenSize.width * 0.02),
          ),
          child: Center(
            child: Icon(icon, color: AppTheme.accentBlue, size: iconSize),
          ),
        ),
        SizedBox(width: screenSize.width * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Take only necessary space
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: labelSize,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              userDetails == null
                  ? buildShimmer(width: 160, height: valueSize + 8)
                  : Text(
                    value,
                    style: TextStyle(
                      fontSize: valueSize,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle text overflow
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeToggleTile(double fontSize) {
    final Size screenSize = MediaQuery.of(context).size;

    final double iconContainerSize = screenSize.width * 0.1;
    final double iconSize = screenSize.width * 0.05;
    final double titleSize = screenSize.width * 0.04;
    final double dropdownFontSize = screenSize.width * 0.035;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: iconContainerSize,
          height: iconContainerSize,
          decoration: BoxDecoration(
            color: AppTheme.accentBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(screenSize.width * 0.02),
          ),
          child: Center(
            child: Icon(
              Icons.brightness_6,
              color: AppTheme.accentBlue,
              size: iconSize,
            ),
          ),
        ),
        SizedBox(width: screenSize.width * 0.03),
        Expanded(
          child: Text(
            'Theme',
            style: TextStyle(
              fontSize: titleSize,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        // Wrap DropdownButton with ValueListenableBuilder to rebuild on theme change
        ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeController.themeModeNotifier,
          builder: (context, currentMode, _) {
            return DropdownButton<ThemeMode>(
              value: currentMode,
              underline: const SizedBox(),
              style: TextStyle(
                fontSize: dropdownFontSize,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              dropdownColor: Theme.of(context).colorScheme.surface,
              onChanged: (ThemeMode? newMode) async {
                if (newMode != null) {
                  await ThemeController.setThemeMode(newMode);
                  // Force rebuild of the entire app by updating the notifier
                  ThemeController.themeModeNotifier.value = newMode;
                }
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesContent() {
    final Size screenSize = MediaQuery.of(context).size;
    final double padding = screenSize.width * 0.04;
    final double spacing = screenSize.height * 0.015;
    final double titleSize = screenSize.width * 0.05;
    final double chipSpacing = screenSize.width * 0.02;
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    final List<String> interestKeywords = [
      'Higher Studies',
      'IELTS',
      'GRE',
      'GMAT',
      'Internships',
      'IR Events',
      'Germany',
      'Japan',
      'USA',
      'Singapore',
      'Language Study',
      'German Language',
      'Japanese Language',
      'Career Guidance',
      'Scholarships',
      'Exchange Programs',
      'Research',
      'UK',
      'Australia',
      'Canada',
      'Technical Skills',
      'Cultural Exchange',
      'Networking',
      'Mentorship',
    ];

    return FutureBuilder(
      future:
          getUserCollectionForStream(), // Replace with your actual async function
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!futureSnapshot.hasData || futureSnapshot.data == null) {
          return Text("User collection not found.");
        }

        final collection = futureSnapshot.data!;

        return StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection(collection)
                  .doc(uid)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text("User data not found.");
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            List interests = [];

            if (data['interests'] is List) {
              interests = data['interests'];
            } else if (data['interests'] is String) {
              try {
                interests = (data['interests']);
              } catch (_) {
                interests = [];
              }
            }
            return Container(
              width: double.infinity,
              decoration: AppTheme.glassDecoration(context).copyWith(
                borderRadius: BorderRadius.circular(screenSize.width * 0.04),
              ),
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferences',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  _buildThemeToggleTile(titleSize),
                  SizedBox(height: spacing * 0.8),
                  _buildSettingItem(
                    'Notifications',
                    'Receive app notifications for latest updates soon!',
                    Icons.notifications_none,
                    true,
                  ),
                  SizedBox(height: spacing * 0.8),
                  _buildSettingItem(
                    'Email updates',
                    'Receive latest updates via email shortly!',
                    Icons.mark_email_unread_outlined,
                    true,
                  ),
                  SizedBox(height: spacing),
                  Text(
                    'Interests',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: spacing * 0.8),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: screenSize.width - (2 * padding),
                    ),
                    child: Wrap(
                      spacing: chipSpacing,
                      runSpacing: chipSpacing,
                      children:
                          interests.isEmpty
                              ? [Text("No interests found")]
                              : interests
                                  .map<Widget>(
                                    (interest) =>
                                        _buildInterestChip(interest, interests),
                                  )
                                  .toList(),
                    ),
                  ),
                  SizedBox(height: spacing),
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AddInterestScreen(
                                existingInterests: interests,
                                interestKeywords:
                                    interestKeywords, // <-- this comes from your list
                              ),
                        ),
                      );

                      if (result != null && result is List<String>) {
                        final uid = FirebaseAuth.instance.currentUser?.uid;
                        if (uid == null) return;

                        setState(() {
                          interests = result;
                        });

                        await FirebaseFirestore.instance
                            .collection('pccoe_students')
                            .doc(uid)
                            .update({'interests': interests});
                      }
                    },

                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.008,
                        horizontal: screenSize.width * 0.03,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.accentBlue.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(
                          screenSize.width * 0.05,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: AppTheme.accentBlue,
                            size: screenSize.width * 0.04,
                          ),
                          SizedBox(width: screenSize.width * 0.01),
                          Text(
                            'Add Interest',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.035,
                              color: AppTheme.accentBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    IconData icon,
    bool value,
  ) {
    final Size screenSize = MediaQuery.of(context).size;
    final double iconContainerSize = screenSize.width * 0.1;
    final double iconSize = screenSize.width * 0.05;
    final double titleSize = screenSize.width * 0.04;
    final double subtitleSize = screenSize.width * 0.035;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Align items properly
      children: [
        Container(
          width: iconContainerSize,
          height: iconContainerSize,
          decoration: BoxDecoration(
            color: AppTheme.accentBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(screenSize.width * 0.02),
          ),
          child: Center(
            child: Icon(icon, color: AppTheme.accentBlue, size: iconSize),
          ),
        ),
        SizedBox(width: screenSize.width * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Take only needed space
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: titleSize,
                  color: AppTheme.textPrimary(context),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: AppTheme.textSecondary(context),
                ),
                overflow: TextOverflow.ellipsis, // Handle text overflow
              ),
            ],
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            activeColor: AppTheme.accentBlue,
            onChanged: (newValue) {
              // Handle toggle
            },
          ),
        ),
      ],
    );
  }

  // Replace your _buildInterestChip method with this optimized version
  Widget _buildInterestChip(String interest, List<dynamic> interests) {
    final Size screenSize = MediaQuery.of(context).size;
    final double fontSize = screenSize.width * 0.035;
    final double iconSize = screenSize.width * 0.04;

    return Container(
      margin: EdgeInsets.only(bottom: 4),
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.03,
        vertical: screenSize.height * 0.006,
      ),
      decoration: BoxDecoration(
        color: AppTheme.accentBlue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(screenSize.width * 0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            interest,
            style: TextStyle(
              fontSize: fontSize,
              color: AppTheme.textPrimary(context),
            ),
          ),
          SizedBox(width: screenSize.width * 0.01),
          GestureDetector(
            onTap: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid == null) return;

              // Remove setState() - let StreamBuilder handle the update
              interests.remove(interest);

              // Update Firestore directly - StreamBuilder will automatically rebuild
              await FirebaseFirestore.instance
                  .collection('pccoe_students')
                  .doc(uid)
                  .update({'interests': interests});
            },
            child: Icon(
              Icons.close,
              color: AppTheme.textSecondary(context),
              size: iconSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActionsSection() {
    final Size screenSize = MediaQuery.of(context).size;
    final double padding = screenSize.width * 0.04;
    final double spacing = screenSize.height * 0.015;
    final double titleSize = screenSize.width * 0.05;
    final double smallSpacing = screenSize.height * 0.01;
    final double buttonSpacing = screenSize.width * 0.04;
    final double actionButtonHeight = screenSize.height * 0.05;
    final double iconSize = screenSize.width * 0.045;
    final double buttonTextSize = screenSize.width * 0.04;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Take only required space
        children: [
          // Account actions header
          Container(
            padding: EdgeInsets.symmetric(vertical: smallSpacing),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.textSecondary(context).withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary(context),
              ),
            ),
          ),

          SizedBox(height: spacing),

          // Account actions
          Row(
            children: [
              Expanded(
                child: _buildAccountActionItem(
                  'Sign Out',
                  Icons.logout,
                  AppTheme.accentBlue.withOpacity(0.1),
                  AppTheme.accentBlue,
                  actionButtonHeight,
                  iconSize,
                  buttonTextSize,
                ),
              ),
              // SizedBox(width: buttonSpacing),
              // Expanded(
              //   child: _buildAccountActionItem(
              //     'Delete Account',
              //     Icons.delete_outline,
              //     Colors.red.withOpacity(0.1),
              //     Colors.red,
              //     actionButtonHeight,
              //     iconSize,
              //     buttonTextSize,
              //   ),
              // ),
            ],
          ),

          SizedBox(height: spacing),

          // App info & socials
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(padding),
            decoration: AppTheme.glassDecoration(context).copyWith(
              borderRadius: BorderRadius.circular(screenSize.width * 0.03),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Take only required space
              children: [
                Text(
                  'IR Cell App v1.0.0',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.035,
                    color: AppTheme.textSecondary(context),
                  ),
                ),
                SizedBox(height: smallSpacing),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutUsPage()),
                    );
                  },
                  child: Text(
                    'About Us',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.035,
                      color: AppTheme.accentBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: smallSpacing),
                // Make the social icons row scrollable on small screens
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(
                        Icons.language,
                        'College Website',
                        screenSize,
                        'https://www.pccoepune.com/ir/ir-coordinators.php',
                      ),
                      SizedBox(width: buttonSpacing),
                      _buildSocialIcon(
                        FontAwesomeIcons.linkedin,
                        'LinkedIn',
                        screenSize,
                        'https://www.linkedin.com/company/pccoe-ir-cell/',
                      ),
                      SizedBox(width: buttonSpacing),
                      _buildSocialIcon(
                        Icons.facebook,
                        'Facebook',
                        screenSize,
                        'https://www.facebook.com/share/1BPXjQ81E7/',
                      ),
                      SizedBox(width: buttonSpacing),
                      _buildSocialIcon(
                        FontAwesomeIcons.instagram,
                        'Instagram',
                        screenSize,
                        'https://www.instagram.com/pccoe_ircell?igsh=MWVybGVyZTE2aXVtbQ==',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActionItem(
    String text,
    IconData icon,
    Color bgColor,
    Color iconColor,
    double height,
    double iconSize,
    double textSize,
  ) {
    final Size screenSize = MediaQuery.of(context).size;

    return TextButton(
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(text),
                content: Text('Are you sure you want to $text?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('No'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Yes'),
                  ),
                ],
              ),
        );

        if (confirmed == true) {
          if (text == 'Sign Out') {
            try {
              await Auth().signOut();
              // Use context.mounted to check if the widget is still in the tree
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                  (route) => false,
                );
              }
            } on FirebaseAuthException catch (e) {
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text('Error'),
                        content: Text(e.message ?? 'An error occurred'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Got it!'),
                          ),
                        ],
                      ),
                );
              }
            }
          } else {
            deleteAccount(context);
          }
        }
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // Remove padding from TextButton
        minimumSize: Size.zero, // Remove minimum size constraint
      ),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(screenSize.width * 0.03),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: iconSize),
            SizedBox(width: screenSize.width * 0.02),
            Text(
              text,
              style: TextStyle(
                fontSize: textSize,
                color: iconColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(
    IconData icon,
    String tooltip,
    Size screenSize,
    String redirectLink,
  ) {
    final double iconContainerSize = screenSize.width * 0.09;
    final double iconSize = screenSize.width * 0.045;

    return InkWell(
      onTap: () {
        final Uri url = Uri.parse(redirectLink);
        launchUrl(url);
      },
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: iconContainerSize,
          height: iconContainerSize,
          decoration: BoxDecoration(
            color: AppTheme.accentBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, color: AppTheme.accentBlue, size: iconSize),
          ),
        ),
      ),
    );
  }
}

String createEmailShortForm() {
  final user = Auth().currentUser;
  final email = user?.email;
  if (email == null || email.length < 2) return '-';

  // Get first character
  String firstChar = email[0].toUpperCase();

  // Find second valid letter
  String secondChar = '';
  for (int i = 1; i < email.length; i++) {
    String char = email[i].toUpperCase();
    // Check if character is a letter (A-Z)
    if (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90) {
      secondChar = char;
      break;
    }
  }

  // If no second letter found, use first letter twice or add 'X'
  if (secondChar.isEmpty) {
    secondChar = 'X';
  }

  return firstChar + secondChar;
}
