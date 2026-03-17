import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool isScanComplete = false;
  bool torchOn = false; // manually track torch state

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void toggleTorch() {
    cameraController.toggleTorch();
    setState(() {
      torchOn = !torchOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Warden QR Code'),
        actions: [
          IconButton(
            icon: Icon(
              torchOn ? Icons.flash_on : Icons.flash_off,
              color: torchOn ? Colors.yellow : Colors.grey,
            ),
            onPressed: toggleTorch,
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          if (!isScanComplete) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              final String? value = barcode.rawValue;
              if (value != null) {
                isScanComplete = true;
                Navigator.pop(context, value);
              }
            }
          }
        },
      ),
    );
  }
}
