import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart'; // Make sure you have this import
import 'package:ircell/screens/internships/outbound_details.dart';
import 'package:url_launcher/url_launcher.dart';

class InternshipsScreen extends StatefulWidget {
  const InternshipsScreen({super.key});

  @override
  State<InternshipsScreen> createState() => _InternshipsState();
}

class _InternshipsState extends State<InternshipsScreen> {
  bool showOutbound = true;

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor(context),
        appBar: AppBar(
          title: Text(
            'Student Mobility',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppTheme.textPrimary(context),
            ),
          ),
          centerTitle: true,
          // elevation: 4,
          // backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFF6200EE),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.zero,
            ),
          ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSectionToggle(),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: showOutbound ? _buildOutboundSection() : _buildInboundSection(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionToggle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => showOutbound = true),
              child: Container(
                decoration: BoxDecoration(
                  color: showOutbound 
                      ? (isDark ? Colors.white.withOpacity(0.2) : Colors.blue.withOpacity(0.3))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'Outbound',
                    style: TextStyle(
                      color: AppTheme.textPrimary(context),
                      fontWeight: showOutbound ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => showOutbound = false),
              child: Container(
                decoration: BoxDecoration(
                  color: !showOutbound 
                      ? (isDark ? Colors.white.withOpacity(0.2) : Colors.blue.withOpacity(0.3))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'Inbound',
                    style: TextStyle(
                      color: AppTheme.textPrimary(context),
                      fontWeight: !showOutbound ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1E2A47), const Color(0xFF3D5A80)]
                  : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isDark ? Colors.white : Colors.blue[800],
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white.withOpacity(0.7) : Colors.black87.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.2) : Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Explore',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: isDark ? Colors.white : Colors.blue[800],
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = (screenWidth - 64) / 3;
    
    return InkWell(
      onTap: onTap,
      child: Container(
        width: buttonWidth,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2A47) : const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isDark ? Colors.white : Colors.blue[800],
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutboundSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainCard(
          title: 'Outbound Internships',
          subtitle: 'Explore international internship opportunities',
          icon: Icons.flight_takeoff,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const OutboundDetails(),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.5),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSmallButton(
                  title: 'International Internships Brochure',
                  icon: Icons.description_outlined,
                  onTap: () {},
                ),
                _buildSmallButton(
                  title: 'SOP - International Internships Application',
                  icon: Icons.assignment_outlined,
                  onTap: () {},
                ),
                _buildSmallButton(
                  title: 'Gallery',
                  icon: Icons.photo_library_outlined,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInboundSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainCard(
          title: 'Inbound Internships',
          subtitle: 'International students seeking internships here',
          icon: Icons.flight_land,
          onTap: () {},
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.5),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSmallButton(
                  title: 'Students\' Experience',
                  icon: Icons.people_outlined,
                  onTap: () {},
                ),
                _buildSmallButton(
                  title: 'Registration',
                  icon: Icons.app_registration_outlined,
                  onTap: () async {
                    final Uri url = Uri.parse(
                      'https://docs.google.com/forms/d/e/1FAIpQLSeCnycTFNv6EteUOEuwq6OV5G33KQPU_NUarqRlc8yb3nf4bA/viewform',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not launch the URL.'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}