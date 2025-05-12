import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScanButton(
              text: 'Scan Attendance',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRViewExample(scanType: 'attendance')),
                );
              },
            ),
            SizedBox(height: 16),
            ScanButton(
              text: 'Scan Quiz Score',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRViewExample(scanType: 'quiz')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ScanButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ScanButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[300],
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: TextStyle(fontSize: 16),
      ),
      child: Text(text),
    );
  }
}

class QRViewExample extends StatefulWidget {
  final String scanType;

  QRViewExample({required this.scanType});

  @override
  State<QRViewExample> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  String? qrText;
  bool isScanned = false;
  final MobileScannerController cameraController = MobileScannerController();

  Future<String?> _promptForAdditionalData(BuildContext context) async {
    TextEditingController textController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.scanType == 'quiz' ? 'Enter Quiz Grade' : 'Extra Info'),
          content: TextField(
            controller: textController,
            keyboardType: widget.scanType == 'quiz' ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: widget.scanType == 'quiz' ? 'Enter grade (e.g. 8.5)' : 'Enter additional info',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, textController.text.trim());
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _onDetect(BarcodeCapture capture) async {
    if (isScanned) return;
    isScanned = true;

    final code = capture.barcodes.first.rawValue ?? '';

    String? additionalData = await _promptForAdditionalData(context);

    if (additionalData != null) {
      String combinedData = '$code | ${widget.scanType}: $additionalData';
      setState(() {
        qrText = combinedData;
      });

      // Placeholder: Replace with API logic
      print('Saved: $combinedData');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Done: Data Saved')),
      );

      Future.delayed(Duration(seconds: 2), () {
        isScanned = false;
      });
    } else {
      isScanned = false;
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR Code')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: cameraController,
              onDetect: _onDetect,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (qrText != null)
                  ? Text('Result: $qrText')
                  : Text('Scan a code'),
            ),
          ),
        ],
      ),
    );
  }
}