import 'package:flutter/material.dart';

class HigherStudiesOptions extends StatelessWidget {
  const HigherStudiesOptions({super.key});

  void _handleOptionTap(BuildContext context, String option) {
    // For now, just show a simple snackbar or print statement.
    // Replace with navigation or logic as needed.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $option')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      {'title': 'Upload Resources', 'icon': Icons.cloud_upload},
      {'title': 'GMAT', 'icon': Icons.school},
      {'title': 'GRE', 'icon': Icons.school},
      {'title': 'IELTS', 'icon': Icons.language},
      {'title': 'TOEFL', 'icon': Icons.language},
      {'title': 'German', 'icon': Icons.language},
      {'title': 'JLPT', 'icon': Icons.language},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Higher Studies Options'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final option = options[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: ListTile(
              leading: Icon(option['icon'] as IconData, color: Colors.deepPurple),
              title: Text(
                option['title'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => _handleOptionTap(context, option['title'] as String),
            ),
          );
        },
      ),
    );
  }
}
