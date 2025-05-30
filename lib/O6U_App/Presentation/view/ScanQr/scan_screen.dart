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
    
    // Immediately set scanning flag and stop camera detection
    setState(() {
      isScanned = true;
    });

    final code = capture.barcodes.first.rawValue ?? '';
    print('QR Code scanned: $code');
    
    // Validate QR code format first
    List<String> parts = code.split(',');
    if (parts.length < 3) {
      print('Invalid QR Code format: expected 3 parts, got ${parts.length}');
      _showMessage('Error: Invalid QR Code format (expected: studentCode,name,section)', isError: true);
      _resetScanner();
      return;
    }

    // Validate each part
    if (parts[0].trim().isEmpty || parts[1].trim().isEmpty || parts[2].trim().isEmpty) {
      print('Invalid QR Code data: one or more parts are empty');
      _showMessage('Error: QR Code contains empty data', isError: true);
      _resetScanner();
      return;
    }

    final additionalData = await _promptForAdditionalData(context);

    if (additionalData == null || additionalData.trim().isEmpty) {
      print('No additional data provided');
      _resetScanner();
      return;
    }

    setState(() {
      qrText = 'Processing...';
    });

    if (widget.scanType == 'attendance') {
      await _processAttendance(parts, additionalData.trim());
    } else if (widget.scanType == 'quiz') {
      await _processQuiz(parts, additionalData.trim());
    }

    // Reset scanner after processing with longer delay
    Future.delayed(Duration(seconds: 5), () {
      _resetScanner();
    });
  }

  void _resetScanner() {
    setState(() {
      isScanned = false;
      qrText = null;
    });
    print('Scanner reset for next scan');
  }

  Future<void> _processAttendance(List<String> parts, String lectureId) async {
    try {
      print('Processing attendance for: ${parts[1]} with lecture ID: $lectureId');
      
      // Validate data before creating attendance object
      int? studentCode = int.tryParse(parts[0].trim());
      int? section = int.tryParse(parts[2].trim());
      int? lectureIdInt = int.tryParse(lectureId);
      
      if (studentCode == null || studentCode <= 0) {
        _showMessage('Error: Invalid student code', isError: true);
        setState(() {
          qrText = 'Error: Invalid student code';
        });
        return;
      }
      
      if (section == null || section <= 0) {
        _showMessage('Error: Invalid section number', isError: true);
        setState(() {
          qrText = 'Error: Invalid section number';
        });
        return;
      }
      
      if (lectureIdInt == null || lectureIdInt <= 0) {
        _showMessage('Error: Invalid lecture ID', isError: true);
        setState(() {
          qrText = 'Error: Invalid lecture ID';
        });
        return;
      }

      final attendance = Attendance(
        studentCode: studentCode,
        name: parts[1].trim(),
        section: section,
        lectureId: lectureIdInt,
        attendanceDate: DateTime.now().toIso8601String(),
      );

      print('Sending attendance: ${attendance.toString()}');
      final repo = AttendanceRepository();
      bool success = await repo.sendAttendance(attendance);

      print('Attendance result: $success');
      
      String message = success 
          ? 'Success: Attendance recorded for ${parts[1].trim()}' 
          : 'Failed: Could not record attendance for ${parts[1].trim()}';
      
      setState(() {
        qrText = message;
      });

      _showMessage(message, isError: !success);
      
    } catch (e) {
      print('Error processing attendance: $e');
      setState(() {
        qrText = 'Error: Failed to process attendance';
      });
      _showMessage('Error: Failed to process attendance - $e', isError: true);
    }
  }

  Future<void> _processQuiz(List<String> parts, String grade) async {
    try {
      print('Processing quiz for: ${parts[1]} with grade: $grade');
      
      // Validate data before creating quiz object
      int? studentCode = int.tryParse(parts[0].trim());
      int? quizCode = int.tryParse(parts[2].trim());
      double? gradeDouble = double.tryParse(grade);
      
      if (studentCode == null || studentCode <= 0) {
        _showMessage('Error: Invalid student code', isError: true);
        setState(() {
          qrText = 'Error: Invalid student code';
        });
        return;
      }
      
      if (quizCode == null || quizCode <= 0) {
        _showMessage('Error: Invalid quiz code', isError: true);
        setState(() {
          qrText = 'Error: Invalid quiz code';
        });
        return;
      }
      
      if (gradeDouble == null || gradeDouble < 0) {
        _showMessage('Error: Invalid grade value', isError: true);
        setState(() {
          qrText = 'Error: Invalid grade value';
        });
        return;
      }

      final quizDegree = QuizDegree(
        studentCode: studentCode,
        studentName: parts[1].trim(),
        quizCode: quizCode,
        degree: gradeDouble,
      );

      print('Sending quiz degree: ${quizDegree.toString()}');
      final repo = QuizDegreeRepository();
      bool success = await repo.sendQuizDegree(quizDegree);

      print('Quiz result: $success');
      
      String message = success 
          ? 'Success: Quiz score recorded for ${parts[1].trim()}' 
          : 'Failed: Could not record quiz score for ${parts[1].trim()}';
      
      setState(() {
        qrText = message;
      });

      _showMessage(message, isError: !success);
      
    } catch (e) {
      print('Error processing quiz: $e');
      setState(() {
        qrText = 'Error: Failed to process quiz score';
      });
      _showMessage('Error: Failed to process quiz score - $e', isError: true);
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
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: _showDebugInfo,
          ),
        ],
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

  void _showDebugInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Debug Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Scan Type: ${widget.scanType ?? "Not specified"}'),
                SizedBox(height: 8),
                Text('Scanner State: ${isScanned ? "Locked" : "Ready"}'),
                SizedBox(height: 8),
                Text('Expected QR Format: studentCode,studentName,section'),
                SizedBox(height: 8),
                Text('Example: 12345,John Doe,101'),
                SizedBox(height: 16),
                Text('Troubleshooting:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('• Make sure QR code has 3 parts separated by commas'),
                Text('• Student code and section must be numbers'),
                Text('• Lecture ID/Grade must be valid numbers'),
                Text('• Check console output for detailed errors'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}