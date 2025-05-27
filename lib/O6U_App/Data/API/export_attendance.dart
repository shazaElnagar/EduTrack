import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

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