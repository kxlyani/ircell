import 'package:flutter/material.dart';
import 'package:ircell/admin/student_mobilty/outbound_form.dart';

class Outbound extends StatelessWidget {
  const Outbound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Outbound Internships')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton(
              context,
              icon: Icons.add,
              label: 'New Outbound Internship',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const OutboundForm()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              context,
              icon: Icons.visibility,
              label: 'View Internships',
              onPressed: () {
                // TODO: Add navigation for View
              },
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              context,
              icon: Icons.delete,
              label: 'Delete Internships',
              onPressed: () {
                // TODO: Add navigation for Delete
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 16)),
        onPressed: onPressed,
      ),
    );
  }
}
