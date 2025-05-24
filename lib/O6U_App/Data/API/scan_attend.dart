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

      print(response.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Attendance sent successfully");
        return true;
      } else {
        print("Failed to send attendance: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print('Error sending attendance: $e');
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