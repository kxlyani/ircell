import 'package:flutter/material.dart';
import 'package:ircell/admin/event/attend_list.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScannerScreen extends StatefulWidget {
  const AttendanceScannerScreen({super.key, required this.eventId});

  final String eventId;

  @override
  State<AttendanceScannerScreen> createState() => _AttendanceScannerScreenState();
}

class _AttendanceScannerScreenState extends State<AttendanceScannerScreen> {

  final List<String> scannedRollNumbers = [];
  bool isScanning = true;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    loadAttendanceList();
  }

  Future<void> loadAttendanceList() async {
  final prefs = await SharedPreferences.getInstance();
  final savedList = prefs.getStringList('attendance_${widget.eventId}') ?? [];
  setState(() {
    scannedRollNumbers.addAll(savedList);
  });
}


  void _onDetect(BarcodeCapture capture) async {
    if (isProcessing) return;

    final code = capture.barcodes.first.rawValue;

    if (code != null && !scannedRollNumbers.contains(code)) {
      setState(() {
        isProcessing = true;
        scannedRollNumbers.add(code);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('attendance_${widget.eventId}', scannedRollNumbers);

      // Show Snackbar confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('UID: $code scanned and added'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Prevent immediate rescan
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        isProcessing = false;
      });
    }

    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("UID already scanned"), backgroundColor: Colors.orange, duration: const Duration(seconds: 2)));
    }
  }

  void _exitScanning() {
    setState(() {
      isScanning = false;
    });
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AttendanceListScreen(eventId: widget.eventId,);
    },));
  }

  void _viewAttendanceList() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AttendanceListScreen(eventId: widget.eventId,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Attendance Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'View Attendance List',
            onPressed: _viewAttendanceList,
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Exit',
            onPressed: _exitScanning,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (isScanning)
            MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
              ),
              onDetect: _onDetect,
            )
          else
            const Center(child: Text("Scanning stopped")),
          _buildScannerOverlay(),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.05),
          ),
          child: const Center(
            child: Text(
              'Align QR within box',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}