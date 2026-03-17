import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/screens/community/alumni_blogs.dart';
import 'package:ircell/screens/community/articles_page.dart';
import 'package:ircell/screens/community/blog_details.dart';
import 'package:ircell/screens/community/japan_facilitation_centre/jfc.dart';
import 'package:ircell/screens/profile%20page/profile_page.dart';
import 'package:ircell/screens/chatbot/floating_buttons.dart';
import 'package:ircell/screens/info.dart';
import 'package:ircell/screens/notification.dart';
import 'package:ircell/providers/articles_provider.dart';

class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> with SingleTickerProviderStateMixin {
  List<AlumniBlog> recentBlogs = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: () => PageInfo.showInfoDialog(context, 'Page4'),
              ),
            ),
            Text(
              'IR Community',
              style: TextStyle(
                color: AppTheme.textPrimary(context),
                fontWeight: FontWeight.bold,
                fontSize: 20,
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
                          'Page4',
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

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Resources'),
                  Tab(text: 'Articles'),
                  Tab(text: 'Videos'),
                ],
                labelColor: AppTheme.textPrimary(
                  context,
                ), // Changed from hardcoded white
                unselectedLabelColor: AppTheme.textPrimary(
                  context,
                ).withOpacity(0.7), // Changed
                indicatorColor:
                    AppTheme.accentBlue, // Changed from white to accent color
                indicatorWeight: 4,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _buildResourcesTab(),
              _buildArticlesTab(),
              _buildVideosTab(),
            ],
          ),
          // Chatbot icon positioned in the bottom right corner
          Positioned(bottom: 20, right: 20, child: FloatingButtonsStack()),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentPadding = screenWidth > 600 ? 24.0 : 16.0;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Japan Facilitation Centre',
              style: TextStyle(
                color: AppTheme.textPrimary(context),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JapanFacilitationCentre(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image from assets
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/jfc.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 150,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        'Get support for your study and career in Japan.',
                        style: TextStyle(
                          color: AppTheme.textSecondary(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const JapanFacilitationCentre(),
                            ),
                          );
                        },
                        child: const Text('Learn More'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text('Higher Studies Archive'),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildArchiveItem(
                    title: 'Colleges in Germany',
                    icon: Icons.school,
                  ),
                  const SizedBox(width: 16),
                  _buildArchiveItem(
                    title: 'US Scholarships',
                    icon: Icons.attach_money,
                  ),
                  const SizedBox(width: 16),
                  _buildArchiveItem(
                    title: 'UK Universities',
                    icon: Icons.account_balance,
                  ),
                  const SizedBox(width: 16),
                  _buildArchiveItem(
                    title: 'Australia Education',
                    icon: Icons.menu_book,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentPadding = screenWidth > 600 ? 24.0 : 16.0;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // Navigate to new dynamic Alumni Blog List page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const AlumniBlogListPage(), // ✅ NEW PAGE
                  ),
                );
              },
              child: Row(
                children: [
                  const Text('Alumni Blogs', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<QuerySnapshot>(
              future:
                  FirebaseFirestore.instance
                      .collection('alumni_blogs')
                      .orderBy('timestamp', descending: true)
                      .limit(3)
                      .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No blogs available.');
                }

                final blogs =
                    snapshot.data!.docs
                        .map(
                          (doc) => AlumniBlog.fromMap(
                            doc.data() as Map<String, dynamic>,
                          ),
                        )
                        .toList();

                return SizedBox(
                  height: 160, // Adjust height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: blogs.length,
                    itemBuilder: (context, index) {
                      final blog = blogs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AlumniBlogDetailPage(blog: blog),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            width: 250, // Adjust width as needed
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  blog.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'By ${blog.firstName} ${blog.lastName}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const Spacer(),
                                Text(
                                  "${blog.timestamp.day}/${blog.timestamp.month}/${blog.timestamp.year}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            Divider(color: AppTheme.textSecondary(context), thickness: 1),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ArticlesPage()),
                );
              },
              child: Row(
                children: [
                  const Text('Articles', style: TextStyle(fontSize: 16)),

                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Show only 3 articles here as preview
            buildArticlesList(context, limit: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
  final screenWidth = MediaQuery.of(context).size.width;
  final contentPadding = screenWidth > 600 ? 24.0 : 16.0;

  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.all(contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Testimonials by IR students',
            style: TextStyle(
              color: AppTheme.textPrimary(context),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: AppTheme.cardDecoration(context).copyWith(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentBlue.withOpacity(0.2),
                  AppTheme.darkTeal.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.video_library_outlined,
                  size: 48,
                  color: AppTheme.accentBlue,
                ),
                const SizedBox(height: 12),
                Text(
                  "Videos Coming Soon",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "We're gathering inspiring stories from IR students. Stay tuned!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildArchiveItem({required String title, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: Colors.blue),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}
