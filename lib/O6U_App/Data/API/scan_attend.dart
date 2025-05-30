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
    print('=== SENDING ATTENDANCE ===');
    print('Attendance object: ${attendance.toString()}');
    print('JSON data: ${attendance.toJson()}');
    
    try {
      final response = await _dio.post(
        '/api/Instructor/save-scan-attend',
        data: attendance.toJson(),
      );

      print('=== API RESPONSE ===');
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      print('Response headers: ${response.headers}');
      
      // Check if it's a successful status code first
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Status code indicates success');
        
        // If response data exists, check for specific success/failure indicators
        if (response.data != null) {
          String responseStr = response.data.toString().toLowerCase();
          print('Response string (lowercase): $responseStr');
          
          // Check for failure indicators first
          if (responseStr.contains('error') || 
              responseStr.contains('failed') || 
              responseStr.contains('duplicate') ||
              responseStr.contains('already exists') ||
              responseStr.contains('invalid')) {
            print('❌ Response contains failure indicator');
            return false;
          }
          
          // Check for success indicators
          if (responseStr.contains('success') || 
              responseStr.contains('saved') || 
              responseStr.contains('recorded') ||
              responseStr.contains('created') ||
              responseStr.contains('added')) {
            print('✅ Response contains success indicator');
            return true;
          }
          
          // If response is a map/object, check for success field
          if (response.data is Map<String, dynamic>) {
            Map<String, dynamic> data = response.data;
            print('Response is a map with keys: ${data.keys}');
            
            if (data.containsKey('success')) {
              bool success = data['success'] == true;
              print('Success field found: $success');
              if (!success && data.containsKey('message')) {
                print('Error message: ${data['message']}');
              }
              return success;
            }
            
            // Check for common response patterns
            if (data.containsKey('status')) {
              String status = data['status'].toString().toLowerCase();
              print('Status field: $status');
              return status == 'success' || status == 'ok';
            }
            
            if (data.containsKey('result')) {
              bool result = data['result'] == true;
              print('Result field: $result');
              return result;
            }
          }
        }
        
        // If we reach here and status is 200/201 without explicit failure indicators,
        // assume it's successful
        print('✅ Assuming success based on status code');
        return true;
        
      } else if (response.statusCode == 400) {
        print('❌ Bad request - Invalid attendance data');
        print('Response: ${response.data}');
        return false;
      } else if (response.statusCode == 409) {
        print('❌ Conflict - Attendance already exists');
        print('Response: ${response.data}');
        return false;
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - Authentication failed');
        return false;
      } else if (response.statusCode == 422) {
        print('❌ Unprocessable Entity - Validation failed');
        print('Response: ${response.data}');
        return false;
      } else {
        print('❌ Unexpected status code: ${response.statusCode}');
        print('Response: ${response.data}');
        return false;
      }
    } on DioException catch (e) {
      print('=== DIO EXCEPTION ===');
      print('Error type: ${e.type}');
      print('Error message: ${e.message}');
      
      if (e.response != null) {
        print('Error response status: ${e.response?.statusCode}');
        print('Error response data: ${e.response?.data}');
        print('Error response headers: ${e.response?.headers}');
      }
      
      // Check if it's a network/timeout issue
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        print('❌ Network connectivity issue');
      }
      
      return false;
    } catch (e) {
      print('=== UNKNOWN ERROR ===');
      print('Error: $e');
      print('Error type: ${e.runtimeType}');
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