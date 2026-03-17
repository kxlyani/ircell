import 'package:flutter/material.dart';

class JapanFacilitationCentre extends StatelessWidget {
  const JapanFacilitationCentre({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Japan Facilitation Centre'),
          backgroundColor: Colors.redAccent,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.school), text: 'Learn Japanese'),
              Tab(icon: Icon(Icons.chat_bubble_outline), text: 'Testimonials'),
              Tab(icon: Icon(Icons.card_membership), text: 'Membership'),
              Tab(icon: Icon(Icons.assignment), text: 'Notes & Tests'),
              Tab(icon: Icon(Icons.local_library), text: 'Library'),
              Tab(icon: Icon(Icons.group), text: 'Activities'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LearnJapaneseTab(),
            _TestimonialsTab(),
            _MembershipTab(),
            _NotesTestsTab(),
            _LibraryTab(),
            _ActivitiesTab(),
          ],
        ),
      ),
    );
  }
}

// Each tab content below — customize as needed

class _LearnJapaneseTab extends StatelessWidget {
  const _LearnJapaneseTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(title: Text('N5 - Beginner Level')),
        ListTile(title: Text('N4 - Elementary Level')),
        ListTile(title: Text('N3 - Intermediate Level')),
      ],
    );
  }
}

class _TestimonialsTab extends StatelessWidget {
  const _TestimonialsTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Student Testimonials Coming Soon!'));
  }
}

class _MembershipTab extends StatelessWidget {
  const _MembershipTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Membership Options & Benefits'));
  }
}

class _NotesTestsTab extends StatelessWidget {
  const _NotesTestsTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Access Notes and Take Japanese Tests'));
  }
}

class _LibraryTab extends StatelessWidget {
  const _LibraryTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Explore JFC Library Resources'));
  }
}

class _ActivitiesTab extends StatelessWidget {
  const _ActivitiesTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Upcoming Cultural & Learning Activities'));
  }
}