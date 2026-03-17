import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/providers/event_provider.dart';
import 'package:ircell/screens/events/event_details.dart';
import 'package:ircell/screens/profile%20page/profile_page.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  String _searchQuery = '';
  int _selectedTabIndex = 0;

  // Enhanced filter options
  bool _filterByDate = false;
  String? _filterBySession; // 'morning' or 'afternoon'
  String? _filterByLocation; // Filter by specific location
  String? _filterBySpeaker; // Filter by speaker name
  bool _filterByLikes = false; // Show only popular events
  int _minLikesThreshold = 5; // Minimum likes for popular events
  
  List<String> _availableLocations = [];
  List<String> _availableSpeakers = [];

  late Future<List<Event>> upcomingEventsFuture;
  late Future<List<Event>> pastEventsFuture;

  @override
  void initState() {
    super.initState();
    upcomingEventsFuture = fetchAllEvents();
    pastEventsFuture = fetchPastEvents();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _searchController = TextEditingController();
    _loadFilterOptions();
  }

  // Load unique locations and speakers for filter options
  Future<void> _loadFilterOptions() async {
    try {
      final allEvents = await fetchAllEvents();
      final pastEvents = await fetchPastEvents();
      final combinedEvents = [...allEvents, ...pastEvents];
      
      setState(() {
        _availableLocations = combinedEvents
            .map((e) => e.location)
            .where((location) => location.isNotEmpty)
            .toSet()
            .toList()
            ..sort();
        
        _availableSpeakers = combinedEvents
            .map((e) => e.speaker)
            .where((speaker) => speaker.isNotEmpty)
            .toSet()
            .toList()
            ..sort();
      });
    } catch (e) {
      print('Error loading filter options: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Enhanced filter logic
  List<Event> _applyFilters(List<Event> events) {
    return events.where((event) {
      // Search query filter
      final matchesTitle = event.title
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      
      // Location filter
      final matchesLocation = _filterByLocation == null || 
          event.location == _filterByLocation;
      
      // Speaker filter
      final matchesSpeaker = _filterBySpeaker == null || 
          (event.speaker) == _filterBySpeaker;
      
      // Date filter (within 1 week)
      bool matchesDateFilter = true;
      if (_filterByDate) {
        try {
          final eventDate = DateFormat("yyyy-MM-dd").parse(event.date);
          final now = DateTime.now();
          final inOneWeek = now.add(const Duration(days: 7));
          matchesDateFilter = eventDate.isAfter(now) && eventDate.isBefore(inOneWeek);
        } catch (e) {
          matchesDateFilter = true; // If date parsing fails, don't filter out
        }
      }
      
      // Time/Session filter
      bool matchesTimeFilter = true;
      if (_filterBySession != null) {
        try {
          final eventTime = DateFormat("hh:mm a").parse(event.time);
          final isMorning = eventTime.hour < 12;
          matchesTimeFilter = (_filterBySession == 'morning' && isMorning) ||
                            (_filterBySession == 'afternoon' && !isMorning);
        } catch (e) {
          matchesTimeFilter = true; // If time parsing fails, don't filter out
        }
      }
      
      // Likes filter (popular events)
      final matchesLikes = !_filterByLikes || 
          ((event.likes) >= _minLikesThreshold);
      
      return matchesTitle && 
             matchesLocation && 
             matchesSpeaker && 
             matchesDateFilter && 
             matchesTimeFilter && 
             matchesLikes;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentFuture =
        _selectedTabIndex == 0 ? upcomingEventsFuture : pastEventsFuture;

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
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppTheme.textPrimary(context),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text('Events', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(width: 60),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: AppTheme.glassDecoration(context),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: AppTheme.textPrimary(context),
                        ),
                        onPressed: _showFilterBottomSheet,
                      ),
                      // Show indicator dot if any filters are active
                      if (_hasActiveFilters())
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.accentBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
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
      backgroundColor: AppTheme.backgroundColor(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildTabSelector(),
                const SizedBox(height: 16),
                FutureBuilder<List<Event>>(
                  future: currentFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingView();
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildEmptyView();
                    }

                    return _buildEventsList(snapshot.data!);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Check if any filters are active
  bool _hasActiveFilters() {
    return _filterByDate ||
           _filterBySession != null ||
           _filterByLocation != null ||
           _filterBySpeaker != null ||
           _filterByLikes;
  }

  // Build events list with enhanced filtering
  Widget _buildEventsList(List<Event> events) {
    final filteredEvents = _applyFilters(events);
    
    if (filteredEvents.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.filter_list_off,
                size: 64,
                color: AppTheme.accentBlue.withOpacity(0.7),
              ),
              const SizedBox(height: 16),
              Text(
                'No events match your filters',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your filter criteria.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _filterByDate = false;
                    _filterBySession = null;
                    _filterByLocation = null;
                    _filterBySpeaker = null;
                    _filterByLikes = false;
                    _searchQuery = '';
                    _searchController.clear();
                  });
                },
                child: const Text('Clear All Filters'),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
        itemCount: filteredEvents.length,
        itemBuilder: (context, index) {
          final event = filteredEvents[index];
          return _buildEventCard(event);
        },
      ),
    );
  }

  // Enhanced event card
  Widget _buildEventCard(Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(12),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                event.imageURL,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey[500],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildEventDetailRow(
                    Icons.access_time, 
                    "${event.date} | ${event.time}",
                  ),
                  const SizedBox(height: 8),
                  _buildEventDetailRow(
                    Icons.location_on, 
                    event.location,
                  ),
                  if (event.speaker.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildEventDetailRow(
                      Icons.person, 
                      "Speaker: ${event.speaker}",
                    ),
                  ],
                  if ((event.likes) > 0) ...[
                    const SizedBox(height: 8),
                    _buildEventDetailRow(
                      Icons.favorite, 
                      "${event.likes} likes",
                      iconColor: Colors.red[400],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetailRow(IconData icon, String text, {Color? iconColor}) {
    return Row(
      children: [
        Icon(
          icon, 
          size: 16, 
          color: iconColor ?? Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppTheme.textSecondary(context),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyView() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_note,
              size: 64,
              color: AppTheme.accentBlue.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedTabIndex == 0 ? 'No upcoming events found' : 'No past events found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedTabIndex == 0 
                ? 'Check back later for new events.'
                : 'Completed events will appear here.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary(context),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced filter bottom sheet
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppTheme.cardColor(context),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Events',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary(context),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _filterByDate = false;
                            _filterBySession = null;
                            _filterByLocation = null;
                            _filterBySpeaker = null;
                            _filterByLikes = false;
                          });
                        },
                        child: Text(
                          'Clear All',
                          style: TextStyle(color: AppTheme.accentBlue),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Filter
                          _buildFilterSection(
                            'Date Range',
                            CheckboxListTile(
                              title: const Text("Within next 7 days"),
                              value: _filterByDate,
                              onChanged: (val) {
                                setModalState(() => _filterByDate = val!);
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          
                          // Session Filter
                          _buildFilterSection(
                            'Session Time',
                            Wrap(
                              spacing: 8,
                              children: [
                                FilterChip(
                                  label: const Text("Morning"),
                                  selected: _filterBySession == 'morning',
                                  onSelected: (selected) {
                                    setModalState(() {
                                      _filterBySession = selected ? 'morning' : null;
                                    });
                                  },
                                  selectedColor: AppTheme.accentBlue.withOpacity(0.3),
                                ),
                                FilterChip(
                                  label: const Text("Afternoon"),
                                  selected: _filterBySession == 'afternoon',
                                  onSelected: (selected) {
                                    setModalState(() {
                                      _filterBySession = selected ? 'afternoon' : null;
                                    });
                                  },
                                  selectedColor: AppTheme.accentBlue.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                          
                          // Location Filter
                          _buildFilterSection(
                            'Location',
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: _filterByLocation,
                                hint: const Text('All Locations'),
                                isExpanded: true,
                                underline: const SizedBox(),
                                onChanged: (value) {
                                  setModalState(() {
                                    _filterByLocation = value;
                                  });
                                },
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text('All Locations'),
                                  ),
                                  ..._availableLocations.map((location) =>
                                    DropdownMenuItem<String>(
                                      value: location,
                                      child: Text(location),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Speaker Filter
                          _buildFilterSection(
                            'Speaker',
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: _filterBySpeaker,
                                hint: const Text('All Speakers'),
                                isExpanded: true,
                                underline: const SizedBox(),
                                onChanged: (value) {
                                  setModalState(() {
                                    _filterBySpeaker = value;
                                  });
                                },
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text('All Speakers'),
                                  ),
                                  ..._availableSpeakers.map((speaker) =>
                                    DropdownMenuItem<String>(
                                      value: speaker,
                                      child: Text(speaker),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Popular Events Filter
                          _buildFilterSection(
                            'Popularity',
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CheckboxListTile(
                                  title: Text("Popular events (${_minLikesThreshold}+ likes)"),
                                  value: _filterByLikes,
                                  onChanged: (val) {
                                    setModalState(() => _filterByLikes = val!);
                                  },
                                  controlAffinity: ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                
                                // Likes threshold slider
                                if (_filterByLikes) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Minimum likes: $_minLikesThreshold',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textSecondary(context),
                                    ),
                                  ),
                                  Slider(
                                    value: _minLikesThreshold.toDouble(),
                                    min: 1,
                                    max: 50,
                                    divisions: 49,
                                    activeColor: AppTheme.accentBlue,
                                    onChanged: (value) {
                                      setModalState(() {
                                        _minLikesThreshold = value.round();
                                      });
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Apply Button
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {}); // Refresh the main screen
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary(context),
          ),
        ),
        const SizedBox(height: 8),
        content,
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: AppTheme.glassDecoration(context).copyWith(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: AppTheme.textPrimary(context)),
        decoration: InputDecoration(
          hintText: 'Search events...',
          hintStyle: TextStyle(color: AppTheme.textSecondary(context)),
          prefixIcon: Icon(
            Icons.search,
            color: AppTheme.textSecondary(context),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppTheme.textSecondary(context),
                  ),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab('Upcoming', 0, Icons.event_available),
          _buildTab('Past Events', 1, Icons.history),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
            _tabController.animateTo(index);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.accentBlue.withOpacity(0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? AppTheme.textPrimary(context)
                    : AppTheme.textSecondary(context),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? AppTheme.textPrimary(context)
                          : AppTheme.textSecondary(context),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentBlue),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading events...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary(context),
                ),
          ),
        ],
      ),
    );
  }
}