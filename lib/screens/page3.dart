import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/backend/shared_pref.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/providers/internship_provider.dart';
import 'package:ircell/screens/events/generate_ticket.dart';
import 'package:ircell/screens/page1.dart';
import 'package:ircell/screens/profile%20page/profile_page.dart';
import 'package:ircell/screens/chatbot/floating_buttons.dart';
import 'package:ircell/screens/info.dart';
import 'package:ircell/screens/notification.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  int _selectedTab = 0;

  List<String> eventTitles = [];

  final User? user = Auth().currentUser;

  Future<void> _loadEvents() async {
    try {
      if (user?.uid == null) return;

      final uid = user!.uid;
      final collections = [
        'pccoe_students',
        'external_college_students',
        'international_students',
        'alumni',
      ];

      DocumentSnapshot<Map<String, dynamic>>? foundSnapshot;

      for (final collection in collections) {
        final docRef = FirebaseFirestore.instance
            .collection(collection)
            .doc(uid);
        final snapshot = await docRef.get();

        if (snapshot.exists) {
          foundSnapshot = snapshot;
          break;
        }
      }

      if (foundSnapshot == null) {
        throw Exception('User document not found in any collection');
      }

      final data = foundSnapshot.data();
      final attending = List<String>.from(data?['attending'] ?? []);

      attending.sort((a, b) => b.compareTo(a)); // sort by latest

      await EventCache.cacheEvents(uid, attending);

      setState(() {
        eventTitles = attending;
      });
    } catch (e) {
      // If offline or error, load from cache
      final cached = await EventCache.getCachedEvents();
      setState(() {
        eventTitles = cached;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ), // Reduced padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: AppTheme.glassDecoration(context),
                child: IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: AppTheme.textPrimary(context),
                  ),
                  onPressed: () => PageInfo.showInfoDialog(context, 'Page3'),
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
                            'Page3',
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
      ),
      backgroundColor: AppTheme.backgroundColor(context),
      body: Stack(
        children: [
          // Using SingleChildScrollView to prevent overflow
          SingleChildScrollView(
            child: Container(
              width: double.infinity, // Ensure full width
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 16.0,
              ), // Reduced horizontal padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section with IR image and "Book a ticket" text
                  _buildHeaderSection(),

                  const SizedBox(height: 20),

                  // Currently Booked & Past Tickets tabs
                  _buildTabSelector(),

                  const SizedBox(height: 16),

                  // Main content area based on selected tab - Fixed height container
                  SizedBox(
                    height: 180, // Consistent with _buildCurrentlyBookedContent
                    child:
                        _selectedTab == 0
                            ? _buildCurrentlyBookedContent()
                            : _buildPastTicketsContent(),
                  ),

                  // Internships section at bottom
                  _buildInternshipsSection(),

                  // Add bottom padding to prevent content from being hidden by ChatbotIcon
                  const SizedBox(
                    height: 120,
                  ), // Increased padding to account for both floating buttons
                ],
              ),
            ),
          ),
        ],
      ),
      // Move floating buttons outside of body to make them always visible
      floatingActionButton: Stack(
        children: [
          // Chatbot icon positioned in the bottom right corner
          Positioned(bottom: 20, right: 20, child: ChatbotIcon()),
          Positioned(bottom: 90, right: 20, child: const ScanIcon()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeaderSection() {
    final Size screenSize = MediaQuery.of(context).size;
    final double imageSize =
        screenSize.width * 0.35; // Slightly reduced to give more space to text

    return Container(
      width: double.infinity, // Ensure full width
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // IR Logo Image with glass decoration
          Container(
            width: imageSize,
            height: imageSize,
            decoration: AppTheme.glassDecoration(
              context,
            ).copyWith(borderRadius: BorderRadius.circular(imageSize / 2)),
            child: ClipOval(
              child: Image.asset(
                'assets/images/ircircle.png',
                fit: BoxFit.fill,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Header Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Book a',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  'ticket for',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  'any event',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      width: double.infinity, // Ensure full width
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Currently Booked Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = 0;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      _selectedTab == 0
                          ? AppTheme.accentBlue.withOpacity(0.3)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Currently Booked',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        _selectedTab == 0
                            ? AppTheme.textPrimary(context)
                            : AppTheme.textSecondary(context),
                    fontWeight:
                        _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),

          // Past Tickets Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      _selectedTab == 1
                          ? AppTheme.accentBlue.withOpacity(0.3)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Past Tickets',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        _selectedTab == 1
                            ? AppTheme.textPrimary(context)
                            : AppTheme.textSecondary(context),
                    fontWeight:
                        _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentlyBookedContent() {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.9),
      itemCount: eventTitles.isEmpty ? 1 : eventTitles.length,
      itemBuilder: (context, index) {
        if (eventTitles.isEmpty) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: AppTheme.glassDecoration(
                context,
              ).copyWith(borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: Text(
                  'No booked events yet',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary(context),
                  ),
                ),
              ),
            ),
          );
        }

        final event = eventTitles[index];

        return GestureDetector(
          onTap: () async {
            final uid = await EventCache.getCachedUid();
            if (uid != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GenerateTicket(eventTitle: event, uid: uid),
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accentBlue.withOpacity(0.3)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "🎟 Ticket",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentBlue,
                      ),
                    ),
                    Icon(
                      Icons.qr_code_2_rounded,
                      color: AppTheme.textPrimary(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 50,
                  child: Text(
                    event,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary(context),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.event_available_outlined,
                      color: AppTheme.textSecondary(context),
                    ),
                    Text(
                      'Valid Ticket',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPastTicketsContent() {
    return Container(
      width: double.infinity,
      decoration: AppTheme.glassDecoration(
        context,
      ).copyWith(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, color: AppTheme.textSecondary(context), size: 48),
          const SizedBox(height: 16),
          Text(
            'Past event tickets will appear here',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInternshipsSection() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return _buildPlaceholder();

    return FutureBuilder<List<OutboundInternship>>(
      future: _loadUserOutboundInternships(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildPlaceholder();
        }

        final userInternships = snapshot.data!;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.textSecondary(context).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  'Registered Internships',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              SizedBox(
                height:
                    240, // Adjusted height to better fit the new card layout
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 4, // Reduced padding
                  ),
                  itemCount: userInternships.length,
                  itemBuilder: (context, index) {
                    final internship = userInternships[index];
                    final screenSize = MediaQuery.of(context).size;
                    return Padding(
                      padding: const EdgeInsets.only(
                        right: 8,
                      ), // Reduced padding
                      child: SizedBox(
                        width: 320,
                        child: buildInternshipCard(
                          internship,
                          screenSize,
                          context,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper to load user outbound internships with full data
  Future<List<OutboundInternship>> _loadUserOutboundInternships(
    String uid,
  ) async {
    // Step 1: get user document from possible collections
    DocumentSnapshot? userDoc;

    final collections = [
      'pccoe_students',
      'external_college_students',
      'international_students',
      'alumni',
    ];

    for (var coll in collections) {
      final doc =
          await FirebaseFirestore.instance.collection(coll).doc(uid).get();
      if (doc.exists) {
        userDoc = doc;
        break;
      }
    }

    if (userDoc == null) return [];

    // Step 2: get outbound titles list from user doc
    final data = userDoc.data() as Map<String, dynamic>?;

    final outboundTitles =
        (data?['outbound'] as List<dynamic>?)?.cast<String>() ?? [];

    if (outboundTitles.isEmpty) return [];

    // Step 3: fetch all outbound internships (full list)
    final allInternships = await fetchAllOutboundInternships();

    // Step 4: filter only internships whose title is in user's outbound list
    return allInternships
        .where((i) => outboundTitles.contains(i.title))
        .toList();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Internships header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.textSecondary(context).withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Internships',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          // Internship content placeholder
          Container(
            height: 80,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12),
            decoration: AppTheme.glassDecoration(
              context,
            ).copyWith(borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text(
                'Internship opportunities will appear here',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
