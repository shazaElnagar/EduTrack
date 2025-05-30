import 'package:dio/dio.dart';
import '../models/attendance.dart';

class AttendanceRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://systemuniversity.runasp.net',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmYzViNzllOC1hODdmLTRiOGQtODM5My0zNmNiOGE0YjBhMDYiLCJlbWFpbCI6IlRBQGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJUQUBnbWFpbC5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBZG1pbiIsImV4cCI6MTc0NzY3MjE3MSwiaXNzIjoidml0YWxfdHJhY2tlcl9hcGkiLCJhdWQiOiJ2aXRhbF90cmFja2VyX2NsaWVudCJ9.-zaxbNLXojJ8jchrsKP9JRpkuSx25MGGOit5fPYMKiE',
      },
    ),
  );

  Future<bool> sendAttendance(Attendance attendance) async {
    print('Sending attendance: ${attendance.toString()}');
    try {
      final response = await _dio.post(
        '/api/Instructor/save-scan-attend',
        data: attendance.toJson(),
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
              print("Attendance sent successfully");
              return true;
            } else if (responseString.contains('error') || responseString.contains('failed') || responseString.contains('duplicate')) {
              print("Attendance failed: ${response.data}");
              return false;
            }
          }
          // If response is a map/object, check for success field
          else if (response.data is Map<String, dynamic>) {
            Map<String, dynamic> data = response.data;
            if (data.containsKey('success')) {
              bool success = data['success'] == true;
              print(success ? "Attendance sent successfully" : "Attendance failed: ${data['message'] ?? 'Unknown error'}");
              return success;
            }
          }
        }
        
        // If we reach here and status is 200/201, consider it successful
        print("Attendance sent successfully (status code: ${response.statusCode})");
        return true;
      } else if (response.statusCode == 400) {
        print("Bad request - Invalid attendance data: ${response.data}");
        return false;
      } else if (response.statusCode == 409) {
        print("Conflict - Attendance already exists: ${response.data}");
        return false;
      } else if (response.statusCode == 401) {
        print("Unauthorized - Authentication failed");
        return false;
      } else {
        print("Failed to send attendance: ${response.statusCode} - ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      print('Dio error sending attendance: ${e.type} - ${e.message}');
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        print('Error response status: ${e.response?.statusCode}');
      }
      return false;
    } catch (e) {
      print('Unknown error sending attendance: $e');
      return false;
    }
  }

  Future<Attendance?> getAttendance(int lectureId) async {
    try {
      final response = await _dio.get('/api/Instructor/save-scan-attend/$lectureId');

      if (response.statusCode == 200) {
        return Attendance.fromJson(response.data);
      } else {
        print('Failed to get attendance: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting attendance: $e');
      return null;
    }
  }
}