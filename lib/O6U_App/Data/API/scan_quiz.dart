import 'package:dio/dio.dart';
import 'package:untitled4/O6U_App/Data/models/quiz_score.dart';

class QuizDegreeRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://systemuniversity.runasp.net',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmYzViNzllOC1hODdmLTRiOGQtODM5My0zNmNiOGE0YjBhMDYiLCJlbWFpbCI6IlRBQGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJUQUBnbWFpbC5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBZG1pbiIsImV4cCI6MTc0NzY3MjE3MSwiaXNzIjoidml0YWxfdHJhY2tlcl9hcGkiLCJhdWQiOiJ2aXRhbF90cmFja2VyX2NsaWVudCJ9.-zaxbNLXojJ8jchrsKP9JRpkuSx25MGGOit5fPYMKiE',
      },
    ),
  );

  Future<String> sendQuizDegree(QuizDegree quizDegree) async {
    try {
      print('Sending data: ${quizDegree.toJson()}');

      final response = await _dio.post(
        '/api/Instructor/save-scan-Quiz',

        data: quizDegree.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Success sending quiz degree');
        return ('Success sending quiz degree');
      } else {
        print('Failed to send quiz degree: ${response.statusCode}');
        return ('Failed to send quiz degree');
      }
    }on DioException catch (e) {
      print('Error sending quiz degree: $e');
      return ('Error sending quiz degree,  ${e.response?.data["message"]}');
    }
  }
}