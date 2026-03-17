import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyAlumniBlogDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  const VerifyAlumniBlogDetailPage({
    required this.data,
    required this.docId,
    Key? key,
  }) : super(key: key);

  Future<void> _verifyBlog(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('alumni_blogs')
        .doc(docId)
        .update({'isVerified': true});
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Blog verified successfully.')),
    );
  }

  Future<void> _deleteBlog(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('alumni_blogs')
        .doc(docId)
        .delete();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Blog deleted.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = Map.fromEntries(
      data.entries.where((entry) =>
          entry.key != 'timestamp' && entry.key != 'uid'),
    );

    // final formattedDate = data['timestamp'] != null
    //     ? DateFormat('yyyy-MM-dd - kk:mm').format((data['timestamp'] as Timestamp).toDate())
    //     : 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Details'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: filteredData.entries.map((entry) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key}: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${entry.value}',
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _verifyBlog(context),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Verify'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _deleteBlog(context),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

