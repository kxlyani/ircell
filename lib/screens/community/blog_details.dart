// lib/screens/activities/alumni_blog_detail.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ircell/screens/community/alumni_blogs.dart';

class AlumniBlogDetailPage extends StatelessWidget {
  final AlumniBlog blog;

  const AlumniBlogDetailPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMMM yyyy, hh:mm a').format(blog.timestamp);
    return Scaffold(
      appBar: AppBar(title: const Text("Blog Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(blog.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("By ${blog.firstName} ${blog.lastName} (${blog.email})",
                      style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 5),
                  Text("Posted on $formattedDate",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  const Divider(height: 30),
                  Text(
                    blog.content,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
