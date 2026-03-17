import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ircell/screens/page2/higher_studies_form.dart';

class HigherStudiesPage extends StatelessWidget {
  const HigherStudiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, String>> examsInfo = [
      {
        'title': 'GRE',
        'description': 'Graduate Record Examination - Required by many US universities. Criteria include verbal, quantitative, and analytical writing skills.',
      },
      {
        'title': 'TOEFL',
        'description': 'Test of English as a Foreign Language - Measures your English ability for academic studies abroad. Required by many universities in the USA, Canada, and more.',
      },
      {
        'title': 'IELTS',
        'description': 'International English Language Testing System - English proficiency test accepted by institutions worldwide including the UK, Canada, and Australia.',
      },
      {
        'title': 'GATE',
        'description': 'Graduate Aptitude Test in Engineering - Required for postgraduate engineering courses and PSU jobs in India.',
      },
    ];

    final List<Map<String, String>> universitiesInfo = [
      {
        'name': 'MIT - USA',
        'course': 'Computer Science, Engineering, AI',
        'details': 'World-renowned for STEM programs with cutting-edge research facilities.',
      },
      {
        'name': 'University of Toronto - Canada',
        'course': 'Data Science, Biomedical Engineering',
        'details': 'Top-ranked Canadian university with strong research output.',
      },
      {
        'name': 'ETH Zurich - Switzerland',
        'course': 'Mechanical Engineering, Robotics',
        'details': 'Offers high-quality programs in engineering and natural sciences.',
      },
      {
        'name': 'IISc Bangalore - India',
        'course': 'Advanced Science & Engineering',
        'details': 'Premier research institute for higher education in India.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Higher Studies'),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Navigable Question Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HigherStudiesFormPage()), // Replace with your HigherStudiesFormPage()
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.school, color: Colors.deepPurple),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Have you figured out a plan for higher studies? Tap to tell us where and what you plan to do.',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1.5),
            const SizedBox(height: 24),

            // Rotating Cards for Exam Info
            const Text(
              'Higher Studies Exam Options',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 16 / 9,
                autoPlayInterval: const Duration(seconds: 4),
              ),
              items: examsInfo.map((exam) {
                return Builder(
                  builder: (context) => Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            exam['title']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            exam['description']!,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 36),
            const Text(
              'Best Universities for Higher Studies',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // University Info Cards
            Column(
              children: universitiesInfo.map((uni) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          uni['name']!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Top Course: ${uni['course']}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.deepPurple),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          uni['details']!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
