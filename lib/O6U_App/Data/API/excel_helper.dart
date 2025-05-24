import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

final Dio dio = Dio();

Future<File> downloadExcel(int quizCode) async {
  final url = "http://systemuniversity.runasp.net/api/Instructor/export-DegreeOfQuizes?QuizCode=688"
      'quiz.xlsx';

  final response = await dio.get<List<int>>(
    url,
    options: Options(
      responseType: ResponseType.bytes,
    ),
  );

  if (response.statusCode == 200) {
    final bytes = Uint8List.fromList(response.data!);


    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/quiz_$quizCode.xlsx');
    await file.writeAsBytes(bytes);
    return file;
  } else {
    throw Exception('  Excel');
  }
}

Future<void> updateExcelWithStudentData(File file, Map<String, dynamic> data) async {
  final bytes = await file.readAsBytes();
  final excel = Excel.decodeBytes(bytes);

  final sheet = excel.sheets.values.first;


  sheet.appendRow([
    data['StudentCode'],
    data['StudentName'],
    data['QuizCode'],
    data['Quiz']
  ]);

  final updatedBytes = excel.encode();
  if (updatedBytes == null) throw Exception(' Excel');

  await file.writeAsBytes(updatedBytes, flush: true);


  await OpenFile.open(file.path);
}