import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../models/attendance.dart';
import '../models/quiz_score.dart';

class ExcelService {
  List<Attendance> attendanceList = [];
  List<QuizDegree> quizScoresList = [];

  Future<void> saveAttendance(Attendance attendance) async {
    attendanceList.add(attendance);
    await generateAttendanceReport();
  }

  Future<void> saveQuizScore(QuizDegree quizScore) async {
    quizScoresList.add(quizScore);
    await generateQuizScoresReport();
  }

  Future<String> _getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName.xlsx';
  }


  Future<void> generateAttendanceReport() async {
    final path = await _getFilePath('attendance_report');
    final file = File(path);

    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];

    sheet.getRangeByName('A1').setText('Student Code');
    sheet.getRangeByName('B1').setText('Name');
    sheet.getRangeByName('C1').setText('Section');
    sheet.getRangeByName('D1').setText('Lecture ID');
    sheet.getRangeByName('E1').setText('Attendance Date');

    for (int i = 0; i < attendanceList.length; i++) {
      final att = attendanceList[i];
      int row = i + 2;
      sheet.getRangeByIndex(row, 1).setNumber(att.studentCode.toDouble());
      sheet.getRangeByIndex(row, 2).setText(att.name);
      sheet.getRangeByIndex(row, 3).setNumber(att.section.toDouble());
      sheet.getRangeByIndex(row, 4).setNumber(att.lectureId.toDouble());
      sheet.getRangeByIndex(row, 5).setText(att.attendanceDate);
    }

    final bytes = workbook.saveAsStream();
    await file.writeAsBytes(bytes, flush: true);
    workbook.dispose();
  }


  Future<void> generateQuizScoresReport() async {
    final path = await _getFilePath('quiz_scores_report');
    final file = File(path);

    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];

    sheet.getRangeByName('A1').setText('Student Code');
    sheet.getRangeByName('B1').setText('Student Name');
    sheet.getRangeByName('C1').setText('Quiz Code');
    sheet.getRangeByName('D1').setText('Degree');

    for (int i = 0; i < quizScoresList.length; i++) {
      final score = quizScoresList[i];
      int row = i + 2;
      sheet.getRangeByIndex(row, 1).setNumber(score.studentCode.toDouble());
      sheet.getRangeByIndex(row, 2).setText(score.studentName);
      sheet.getRangeByIndex(row, 3).setNumber(score.quizCode.toDouble());
      sheet.getRangeByIndex(row, 4).setNumber(score.degree);
    }

    final bytes = workbook.saveAsStream();
    await file.writeAsBytes(bytes, flush: true);
    workbook.dispose();
  }

  // فتح ملف الحضور
  Future<void> openAttendanceFile() async {
    final path = await _getFilePath('attendance_report');
    if (await File(path).exists()) {
      await OpenFile.open(path);
    } else {
      throw Exception('Attendance report file not found');
    }
  }


  Future<void> openQuizScoresFile() async {
    final path = await _getFilePath('quiz_scores_report');
    if (await File(path).exists()) {
      await OpenFile.open(path);
    } else {
      throw Exception('Quiz scores report file not found');
    }
  }
}