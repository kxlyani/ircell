import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/screens/community/article_webview.dart';

Widget buildArticlesList(BuildContext context, {int? limit, String? searchQuery}) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('articles').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('No articles found.'));
      }

      final articles = snapshot.data!.docs;

      // Filter by search query if provided
      final filteredArticles = (searchQuery != null && searchQuery.isNotEmpty)
          ? articles.where((doc) {
              final title = (doc['title'] ?? '').toString().toLowerCase();
              return title.contains(searchQuery.toLowerCase());
            }).toList()
          : articles;

      final displayedArticles = (limit != null && filteredArticles.length > limit)
          ? filteredArticles.take(limit).toList()
          : filteredArticles;

      if (displayedArticles.isEmpty) {
        return const Center(child: Text('No articles match your search.'));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayedArticles.length,
        itemBuilder: (context, index) {
          final article = displayedArticles[index];
          final title = article['title'] ?? 'No Title';
          final link = article['link'];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticleWebViewPage(title: title, url: link),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              padding: const EdgeInsets.all(16.0),
              decoration: AppTheme.glassDecoration(context),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.article, size: 30, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary(context),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.textSecondary(context),
                    size: 16,
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
