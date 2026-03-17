import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:clipboard/clipboard.dart';

class ScanConnect extends StatefulWidget {
  const ScanConnect({Key? key}) : super(key: key);

  @override
  State<ScanConnect> createState() => _ScanConnectState();
}

class _ScanConnectState extends State<ScanConnect> {
  bool isScanned = false;
  Map<String, dynamic>? scannedUser;
  final List<String> collections = [
    'pccoe_students',
    'external_college_students',
    'international_students',
    'alumni',
  ];

  Future<void> _fetchUserDetails(String uid) async {
    for (final collection in collections) {
      final docRef = FirebaseFirestore.instance.collection(collection).doc(uid);
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        setState(() {
          scannedUser = snapshot.data()!;
          scannedUser!['uid'] = uid;
        });
        return;
      }
    }
    setState(() {
      scannedUser = {'error': 'User not found'};
    });
  }

  void _resetScanner() {
    setState(() {
      isScanned = false;
      scannedUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan & Connect')),
      body: scannedUser == null
          ? SafeArea(
            child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Stack(
                      children: [
                        MobileScanner(
                          onDetect: (capture) {
                            if (!isScanned && capture.barcodes.isNotEmpty) {
                              final code = capture.barcodes.first.rawValue;
                              if (code != null) {
                                setState(() {
                                  isScanned = true;
                                });
                                _fetchUserDetails(code);
                              }
                            }
                          },
                        ),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Align the QR code to scan the participant',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Scan a participant\'s QR code to connect with them.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          )
          : scannedUser!.containsKey('error')
              ? SafeArea(
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(scannedUser!['error']),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _resetScanner,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Scan New QR"),
                        )
                      ],
                    ),
                  ),
              )
              : SafeArea(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Participant Details',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...scannedUser!.entries.map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${e.key}: ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Flexible(child: Text('${e.value}')),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Tip: Take a screenshot or copy the info below.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            String content = scannedUser!.entries
                                .map((e) => "${e.key}: ${e.value}")
                                .join('\n');
                            FlutterClipboard.copy(content).then((_) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Copied"),
                                  content: const Text(
                                    "Participant details copied to clipboard.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            });
                          },
                          icon: const Icon(Icons.copy),
                          label: const Text("Copy Info"),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _resetScanner,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Scan New QR"),
                        ),
                      ],
                    ),
                  ),
              ),
    );
  }
}
