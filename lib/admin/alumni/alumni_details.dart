import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerifyAlumniDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  const VerifyAlumniDetailPage({required this.data, required this.docId, Key? key}) : super(key: key);

  Future<void> _verifyAlumni(BuildContext context) async {
    await FirebaseFirestore.instance.collection('alumni').doc(docId).update({'isVerified': true});
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alumni verified successfully')),
    );
  }

  Future<void> _deleteAlumni(BuildContext context) async {
    await FirebaseFirestore.instance.collection('alumni').doc(docId).delete();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alumni account deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = Map.fromEntries(
      data.entries.where((entry) => entry.key != 'timestamp'),
    );
    return Scaffold(
      // backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Alumni Details'),
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
                    onPressed: () => _verifyAlumni(context),
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
                    onPressed: () => _deleteAlumni(context),
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
