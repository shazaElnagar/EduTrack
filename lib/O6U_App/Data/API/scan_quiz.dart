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

  Future<bool> sendQuizDegree(QuizDegree quizDegree) async {
    print('Sending quiz degree: ${quizDegree.toJson()}');
    try {
      final response = await _dio.post(
        '/api/Instructor/save-scan-Quiz',
        queryParameters: {
          'id': 'fc5b79e8-a87f-4b8d-8393-36cb8a4b0a06',
        },
        data: quizDegree.toJson(),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response contains success indicator
        if (response.data != null) {
          // If response is a string and contains success indicators
          if (response.data is String) {
            String responseString = response.data.toString().toLowerCase();
            if (responseString.contains('success') || responseString.contains('saved') || responseString.contains('recorded')) {
              print("Quiz degree sent successfully");
              return true;
            } else if (responseString.contains('error') || responseString.contains('failed') || responseString.contains('duplicate')) {
              print("Quiz degree failed: ${response.data}");
              return false;
            }
          }
          // If response is a map/object, check for success field
          else if (response.data is Map<String, dynamic>) {
            Map<String, dynamic> data = response.data;
            if (data.containsKey('success')) {
              bool success = data['success'] == true;
              print(success ? "Quiz degree sent successfully" : "Quiz degree failed: ${data['message'] ?? 'Unknown error'}");
              return success;
            }
          }
        }
        
        // If we reach here and status is 200/201, consider it successful
        print("Quiz degree sent successfully (status code: ${response.statusCode})");
        return true;
      } else if (response.statusCode == 400) {
        print("Bad request - Invalid quiz data: ${response.data}");
        return false;
      } else if (response.statusCode == 409) {
        print("Conflict - Quiz score already exists: ${response.data}");
        return false;
      } else if (response.statusCode == 401) {
        print("Unauthorized - Authentication failed");
        return false;
      } else {
        print("Failed to send quiz degree: ${response.statusCode} - ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      print('Dio error sending quiz degree: ${e.type} - ${e.message}');
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        print('Error response status: ${e.response?.statusCode}');
      }
      return false;
    } catch (e) {
      print('Unknown error sending quiz degree: $e');
      return false;
    }
  }
}