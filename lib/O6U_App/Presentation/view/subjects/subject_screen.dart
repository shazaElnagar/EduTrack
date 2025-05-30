import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../ScanQr/scan_screen.dart';

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
      appBar: AppBar(
        backgroundColor: Color(0xFF005B7F),
        title: Text('Select Action', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: 80,
                color: Color(0xFF005B7F),
              ),
              SizedBox(height: 32),
              Text(
                'Choose an action:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005B7F),
                ),
              ),
              SizedBox(height: 32),
              ScanButton(
                text: 'Scan Attendance',
                icon: Icons.person_pin_circle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRViewExample(scanType: 'attendance'),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              ScanButton(
                text: 'Download Attendance Excel',
                icon: Icons.download,
                onPressed: () async {
                  _showLoadingDialog(context, 'Downloading attendance file...');
                  try {
                    await downloader.downloadAndOpenExcel(
                      'http://systemuniversity.runasp.net/api/Instructor/export-attendance?section=875',
                      'attend_section.xlsx',
                    );
                    Navigator.pop(context); // Close loading dialog
                    _showSuccessDialog(context, 'Attendance file downloaded successfully!');
                  } catch (e) {
                    Navigator.pop(context); // Close loading dialog
                    _showErrorDialog(context, 'Failed to download attendance file: $e');
                  }
                },
              ),
              SizedBox(height: 32),
              Divider(color: Colors.grey),
              SizedBox(height: 16),
              ScanButton(
                text: 'Scan Quiz Score',
                icon: Icons.quiz,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRViewExample(scanType: 'quiz'),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              ScanButton(
                text: 'Download Quiz Scores Excel',
                icon: Icons.download,
                onPressed: () async {
                  _showLoadingDialog(context, 'Downloading quiz scores file...');
                  try {
                    await downloader.downloadAndOpenExcel(
                      'http://systemuniversity.runasp.net/api/Instructor/export-DegreeOfQuizes?QuizCode=688',
                      'Quiz688.xlsx',
                    );
                    Navigator.pop(context); // Close loading dialog
                    _showSuccessDialog(context, 'Quiz scores file downloaded successfully!');
                  } catch (e) {
                    Navigator.pop(context); // Close loading dialog
                    _showErrorDialog(context, 'Failed to download quiz scores file: $e');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Expanded(child: Text(message)),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Success'),
            ],
          ),
          content: Text(message),
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

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Error'),
            ],
          ),
          content: Text(message),
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

class ScanButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;

  const ScanButton({
    required this.text, 
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Color(0xFF005B7F),
          backgroundColor: Colors.white,
          side: BorderSide(color: Color(0xFF005B7F), width: 2),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24),
              SizedBox(width: 12),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 