import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// QR Scan Screen (Using MobileScanner)
class QRViewExample extends StatefulWidget {
  @override
  State<QRViewExample> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  String? qrText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005B7F),
        title: Text('Scan QR Code',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  setState(() {
                    qrText = barcode.rawValue;
                  });
                }
              },
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