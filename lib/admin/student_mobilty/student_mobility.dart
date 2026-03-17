import 'package:flutter/material.dart';
import 'package:ircell/admin/student_mobilty/outbound.dart';

class StudentMobilityAdmin extends StatelessWidget {
  const StudentMobilityAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    Widget gridButton(String text, VoidCallback onTap) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child: Text(text, textAlign: TextAlign.center),
      );
    }

    Widget largeButton(String text, VoidCallback onTap) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Student Mobility')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            largeButton('Outbound Internships', () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => Outbound()));
            }),

            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                gridButton('International Internships\nBrochure Upload', () {}),
                gridButton('SOP Upload', () {}),
                gridButton('Gallery Upload', () {}),
              ],
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1.5),
            const SizedBox(height: 30),

            largeButton('Inbound Internships', () {
              // TODO
            }),

            const SizedBox(height: 16),

            // Replace the second GridView (for bottom buttons) with this:
            LayoutBuilder(
              builder: (context, constraints) {
                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3, // Wider buttons
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Student's Experience",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Registration",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
