import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:untitled4/O6U_App/Data/API/scan_attend.dart';
import 'package:untitled4/O6U_App/Data/models/attendance.dart';
import 'package:untitled4/O6U_App/Data/API/scan_quiz.dart';
import 'package:untitled4/O6U_App/Data/models/quiz_score.dart';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';



class ExcelDownloader {
  final Dio _dio = Dio();

  Future<void> downloadAndOpenExcel(String url, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName';

      await _dio.download(url, filePath);

      print('File saved to $filePath');

      final result = await OpenFile.open(filePath);
      print('Open file result: ${result.message}');
    } catch (e) {
      print('Error downloading/opening file: $e');
    }
  }
}

class ScanOptionsScreen extends StatelessWidget {
  final ExcelDownloader downloader = ExcelDownloader();

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
                  MaterialPageRoute(
                    builder: (context) => QRViewExample(scanType: 'attendance'),
                  ),
                );
              },
            ),
            SizedBox(height: 8),
            ScanButton(
              text: 'Download Attendance Excel',
              onPressed: () async {
                await downloader.downloadAndOpenExcel(
                  'http://systemuniversity.runasp.net/api/Instructor/export-attendance?section=875',
                  'attend_section.xlsx',
                );
              },
            ),
            SizedBox(height: 16),
            ScanButton(
              text: 'Scan Quiz Score',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRViewExample(scanType: 'quiz'),
                  ),
                );
              },
            ),
            SizedBox(height: 8),
            ScanButton(
              text: 'Download Quiz Scores Excel',
              onPressed: () async {
                await downloader.downloadAndOpenExcel(
                  'http://systemuniversity.runasp.net/api/Instructor/export-DegreeOfQuizes?QuizCode=688',
                  'Quiz688.xlsx',
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
    final additionalData = await _promptForAdditionalData(context);

    if (additionalData != null) {
      setState(() {
        qrText = '$code | ${widget.scanType}: $additionalData';
      });

      if (widget.scanType == 'attendance') {
        List<String> parts = code.split(',');
        if (parts.length >= 3) {
          try {
            final attendance = Attendance(
              studentCode: int.tryParse(parts[0]) ?? 0,
              name: parts[1],
              section: int.tryParse(parts[2]) ?? 0,
              lectureId: int.tryParse(additionalData) ?? 0,
              attendanceDate: DateTime.now().toIso8601String(),
            );

            final repo = AttendanceRepository();
            bool success = await repo.sendAttendance(attendance);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success
                    ? 'Attendance sent successfully'
                    : 'Attendance sent successfully'),
              ),
            );
          } catch (e) {
            print('Error parsing/scanning attendance: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: Invalid attendance data')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('QR Code format not valid')),
          );
        }
      } else if (widget.scanType == 'quiz') {
        List<String> parts = code.split(',');
        if (parts.length >= 3) {
          try {
            final quizDegree = QuizDegree(
              studentCode: int.tryParse(parts[0]) ?? 0,
              studentName: parts[1],
              quizCode: int.tryParse(parts[2]) ?? 0,
              degree: double.tryParse(additionalData) ?? 0.0,
            );

            final repo = QuizDegreeRepository();
            bool success = await repo.sendQuizDegree(quizDegree);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success
                    ? 'Quiz degree sent successfully'
                    : 'Quiz degree sent successfully'),
              ),
            );
          } catch (e) {
            print('Error parsing/scanning quiz degree: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: Invalid quiz data')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('QR Code format not valid for quiz')),
          );
        }
      }

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
              child: (qrText != null) ? Text('Result: $qrText') : Text('Scan a code'),
            ),
          ),
        ],
      ),
    );
  }
}