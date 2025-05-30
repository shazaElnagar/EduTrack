import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:untitled4/O6U_App/Data/API/scan_attend.dart';
import 'package:untitled4/O6U_App/Data/models/attendance.dart';
import 'package:untitled4/O6U_App/Data/API/scan_quiz.dart';
import 'package:untitled4/O6U_App/Data/models/quiz_score.dart';

// QR Scan Screen (Using MobileScanner)
class QRViewExample extends StatefulWidget {
  final String? scanType;

  QRViewExample({this.scanType});

  @override
  State<QRViewExample> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  String? qrText;
  bool isScanned = false;
  final MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    // If no scan type is provided, show selection dialog
    if (widget.scanType == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showScanTypeSelection();
      });
    }
  }

  void _showScanTypeSelection() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Scan Type'),
          content: Text('What would you like to scan?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRViewExample(scanType: 'attendance'),
                  ),
                );
              },
              child: Text('Attendance'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRViewExample(scanType: 'quiz'),
                  ),
                );
              },
              child: Text('Quiz Score'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to previous screen
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _promptForAdditionalData(BuildContext context) async {
    TextEditingController textController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.scanType == 'quiz' ? 'Enter Quiz Grade' : 'Enter Lecture ID'),
          content: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: widget.scanType == 'quiz' ? 'Enter grade (e.g. 8.5)' : 'Enter lecture ID (e.g. 101)',
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
    
    // Validate QR code format first
    List<String> parts = code.split(',');
    if (parts.length < 3) {
      _showMessage('Error: Invalid QR Code format', isError: true);
      isScanned = false;
      return;
    }

    final additionalData = await _promptForAdditionalData(context);

    if (additionalData == null || additionalData.isEmpty) {
      isScanned = false;
      return;
    }

    setState(() {
      qrText = 'Processing...';
    });

    if (widget.scanType == 'attendance') {
      await _processAttendance(parts, additionalData);
    } else if (widget.scanType == 'quiz') {
      await _processQuiz(parts, additionalData);
    }

    // Reset scanner after processing
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isScanned = false;
        qrText = null;
      });
    });
  }

  Future<void> _processAttendance(List<String> parts, String lectureId) async {
    try {
      final attendance = Attendance(
        studentCode: int.tryParse(parts[0]) ?? 0,
        name: parts[1],
        section: int.tryParse(parts[2]) ?? 0,
        lectureId: int.tryParse(lectureId) ?? 0,
        attendanceDate: DateTime.now().toIso8601String(),
      );

      final repo = AttendanceRepository();
      bool success = await repo.sendAttendance(attendance);

      setState(() {
        qrText = success ? 'Success: Attendance recorded for ${parts[1]}' : 'Failed: Could not record attendance';
      });

      _showMessage(
        success ? 'Success: Attendance recorded for ${parts[1]}' : 'Failed: Could not record attendance',
        isError: !success,
      );
    } catch (e) {
      setState(() {
        qrText = 'Error: Failed to process attendance';
      });
      _showMessage('Error: Failed to process attendance', isError: true);
    }
  }

  Future<void> _processQuiz(List<String> parts, String grade) async {
    try {
      final quizDegree = QuizDegree(
        studentCode: int.tryParse(parts[0]) ?? 0,
        studentName: parts[1],
        quizCode: int.tryParse(parts[2]) ?? 0,
        degree: double.tryParse(grade) ?? 0.0,
      );

      final repo = QuizDegreeRepository();
      bool success = await repo.sendQuizDegree(quizDegree);

      setState(() {
        qrText = success ? 'Success: Quiz score recorded for ${parts[1]}' : 'Failed: Could not record quiz score';
      });

      _showMessage(
        success ? 'Success: Quiz score recorded for ${parts[1]}' : 'Failed: Could not record quiz score',
        isError: !success,
      );
    } catch (e) {
      setState(() {
        qrText = 'Error: Failed to process quiz score';
      });
      _showMessage('Error: Failed to process quiz score', isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Scan QR Code';
    if (widget.scanType == 'attendance') {
      title = 'Scan Student QR for Attendance';
    } else if (widget.scanType == 'quiz') {
      title = 'Scan Student QR for Quiz Score';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005B7F),
        title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          if (widget.scanType != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Color(0xFF005B7F).withOpacity(0.1),
              child: Text(
                widget.scanType == 'attendance' 
                    ? 'Point the camera at the student\'s QR code to record attendance'
                    : 'Point the camera at the student\'s QR code to record quiz score',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF005B7F),
                ),
              ),
            ),
          ],
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: cameraController,
              onDetect: _onDetect,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  qrText ?? 'Position QR code within the frame',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}