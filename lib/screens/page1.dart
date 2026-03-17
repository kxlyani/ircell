import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ircell/app_theme.dart';
import 'package:ircell/providers/event_provider.dart';
import 'package:ircell/providers/internship_provider.dart';
import 'package:ircell/screens/chatbot/floating_buttons.dart';
import 'package:ircell/screens/events/event_details.dart';
import 'package:ircell/screens/events/past_event_details.dart';
import 'package:ircell/screens/internships/outbound_detail_page.dart';
import 'package:ircell/screens/liked_events.dart';
import 'package:ircell/screens/profile%20page/profile_page.dart';
import 'package:ircell/screens/info.dart';
import 'package:ircell/screens/notification.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> with SingleTickerProviderStateMixin {
  late Future<List<Event>> _eventsFuture;
  late Future<List<OutboundInternship>> _internshipsFuture;
  late Future<List<Event>> _pastEventsFuture;
  late TabController _tabController;
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentCardIndex = 1;
  final int _originalCardCount = 5;
  final _isAutoScrolling = true;

  List<int> get _cardIndexes {
    return [
      _originalCardCount - 1,
      ...List.generate(_originalCardCount, (index) => index),
      0,
    ];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(
      initialPage: _currentCardIndex,
      viewportFraction: 0.8,
    );
    _pageController.addListener(_handlePageChange);
    _eventsFuture = fetchAllEvents();
    _internshipsFuture = fetchAllOutboundInternships();
    _pastEventsFuture = fetchPastEvents();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _handlePageChange() {
    if (!_pageController.hasClients || !_pageController.position.haveDimensions)
      return;

    final double page = _pageController.page ?? 0;

    if (page >= _cardIndexes.length - 1) {
      _pageController.jumpToPage(1);
      setState(() => _currentCardIndex = 1);
    } else if (page <= 0) {
      _pageController.jumpToPage(_originalCardCount);
      setState(() => _currentCardIndex = _originalCardCount);
    } else {
      setState(() => _currentCardIndex = page.round());
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (!_isAutoScrolling) return;
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_pageController.hasClients && _isAutoScrolling) {
        int nextPage = _currentCardIndex + 1;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => PageInfo.showInfoDialog(context, 'Page1'),
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
                          'Page1',
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

        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                'Featured',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'Liked',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
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
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [_buildFeaturedSuggestions(), _buildLikedEvents()],
          ),
          Positioned(bottom: 20, right: 20, child: FloatingButtonsStack()),
        ],
      ),
    );
  }

  Widget _buildFeaturedSuggestions() {
    final screenSize = MediaQuery.of(context).size;
    return FutureBuilder<List<Event>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event_busy, size: 48, color: AppTheme.accentBlue),
                const SizedBox(height: 12),
                Text(
                  'No featured events yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Stay tuned! New events will appear here.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary(context),
                  ),
                ),
              ],
            ),
          );
        }

        final events = snapshot.data!;
        final double screenHeight = screenSize.height;
        final double featureCardHeight = screenHeight * 0.35;
        final double maxHeight = screenHeight * 0.45;
        final double minHeight = screenHeight * 0.25;
        final double adaptiveHeight = featureCardHeight.clamp(
          minHeight,
          maxHeight,
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: adaptiveHeight,
                        child: CarouselSlider.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index, realIndex) {
                            final event = events[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: _buildFeatureCard(
                                event,
                                constraints.maxWidth * 0.8,
                                adaptiveHeight,
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: adaptiveHeight,
                            enlargeCenterPage: true,
                            autoPlay: events.length >= 3,
                            autoPlayInterval: const Duration(seconds: 6),
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            autoPlayCurve: Curves.easeInOut,
                            enableInfiniteScroll: events.length >= 3,
                            viewportFraction: 0.8,
                            initialPage: 0,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      _buildInternshipSection(screenSize),
                      SizedBox(height: screenHeight * 0.04),
                      _buildPastEventsSection(screenSize),
                      SizedBox(height: screenHeight * 0.15),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInternshipSection(Size screenSize) {
    final screenHeight = screenSize.height;
    final cardHeight = screenHeight * 0.32;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
          child: Text(
            'Internships available',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.05,
            ),
          ),
        ),
        FutureBuilder<List<OutboundInternship>>(
          future: _internshipsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: cardHeight,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: cardHeight,
                child: Center(
                  child: Text('Error loading internships: ${snapshot.error}'),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox(
                height: cardHeight,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.work_off,
                        size: 40,
                        color: AppTheme.accentBlue,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No internships available',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Check back later for new opportunities!',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final internships = snapshot.data!;
            return SizedBox(
              height: cardHeight,
              child: PageView.builder(
                itemCount: internships.length,
                controller: PageController(viewportFraction: 0.85),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: screenSize.width * 0.04),
                    child: buildInternshipCard(
                      internships[index],
                      screenSize,
                      context,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPastEventsSection(Size screenSize) {
    final screenHeight = screenSize.height;
    final cardHeight = screenHeight * 0.32;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
          child: Text(
            'Check out past events!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.05,
            ),
          ),
        ),
        FutureBuilder<List<Event>>(
          future: _pastEventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: cardHeight,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: cardHeight,
                child: Center(
                  child: Text('Error loading past events: ${snapshot.error}'),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox(
                height: cardHeight,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history_toggle_off,
                        size: 40,
                        color: AppTheme.accentBlue,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No past events yet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Past events will appear here once completed.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final pastEvents = snapshot.data!;
            return SizedBox(
              height: cardHeight,
              child: PageView.builder(
                itemCount: pastEvents.length,
                controller: PageController(viewportFraction: 0.85),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: screenSize.width * 0.04),
                    child: _buildPastEventCard(pastEvents[index], screenSize),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(Event event, double cardWidth, double cardHeight) {
    final double imageHeight = cardHeight * 0.65;

    return InkWell(
      borderRadius: BorderRadius.circular(
        16,
      ), // 1. Add rounded corners to InkWell
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: AppTheme.cardDecoration(context).copyWith(
          borderRadius: BorderRadius.circular(16),
        ), // 2. Ensure consistent rounding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: imageHeight,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(event.imageURL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryDarkBlue.withOpacity(0.7),
                      AppTheme.accentBlue.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          event.title,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary(
                              context,
                            ), // 3. Fix light theme
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: AppTheme.textPrimary(
                              context,
                            ), // 3. Fix light theme
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              event.date,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textPrimary(
                                  context,
                                ), // 3. Fix light theme
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikedEvents() {
    return const LikedEventsPage();
  }

  Widget _buildPastEventCard(Event event, Size screenSize) {
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Container(
      decoration: AppTheme.cardDecoration(context).copyWith(
        gradient: LinearGradient(
          colors: [Colors.grey.withOpacity(0.1), Colors.grey.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(event.imageURL),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(0.3),
                    BlendMode.overlay,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: screenHeight * 0.01,
                    right: screenWidth * 0.02,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Past Event',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.025,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      event.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary(context),
                        fontSize: screenWidth * 0.035,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: AppTheme.textSecondary(context),
                        size: screenWidth * 0.035,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Expanded(
                        child: Text(
                          event.date,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary(context),
                            fontSize: screenWidth * 0.028,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      PastEventDetailScreen(event: event),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'View',
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: AppTheme.accentBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildInternshipCard(
  OutboundInternship internship,
  Size screenSize,
  BuildContext context,
) {
  final screenWidth = screenSize.width;
  final screenHeight = screenSize.height;

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OutboundDetailPage(internship: internship),
        ),
      );
    },
    borderRadius: BorderRadius.circular(16),
    child: Container(
      decoration: AppTheme.cardDecoration(context).copyWith(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentBlue.withOpacity(0.1),
            AppTheme.primaryDarkBlue.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.work_outline,
                    color: AppTheme.accentBlue,
                    size: screenWidth * 0.06,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        internship.title,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${internship.university}, ${internship.country}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary(context),
                          fontSize: screenWidth * 0.03,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(
              'Topic: ${internship.topic}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: screenWidth * 0.032),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: AppTheme.textSecondary(context),
                            size: screenWidth * 0.035,
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Expanded(
                            child: Text(
                              internship.duration,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondary(context),
                                fontSize: screenWidth * 0.028,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: AppTheme.textSecondary(context),
                            size: screenWidth * 0.035,
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Expanded(
                            child: Text(
                              internship.cost,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondary(context),
                                fontSize: screenWidth * 0.028,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
