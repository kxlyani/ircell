import 'package:flutter/material.dart';
import 'package:ircell/admin/alumni/verify_alumni_blog_list.dart';
import 'package:ircell/admin/alumni/verify_alumni_list.dart';

class AlumniOptions extends StatelessWidget {
  const AlumniOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alumni Options'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _OptionCard(
              title: 'Verify Alumni',
              icon: Icons.verified_user,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerifyAlumniListPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            _OptionCard(
              title: 'Verify Alumni Blog',
              icon: Icons.edit_document,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => VerifyAlumniBlogListPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _OptionCard({
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, size: 28, color: Colors.deepPurple),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
