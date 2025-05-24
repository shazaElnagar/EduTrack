import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin_model.dart';

class AdminRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://systemuniversity.runasp.net',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<bool> registerAdmin(Admin admin) async {
    try {

      final response = await _dio.post(
        '/api/Auth/login',
        data: admin.toJson(),
      );

      print("Response: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;


        final token = data['token'] ?? data['data']?['token'];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('admin_token', token);
          await prefs.setString('admin_email', admin.email);
          return true;
        } else {
          print("Token not found in response.");
          return false;
        }
      } else {
        print("Login failed with status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Admin login failed: $e");
      return false;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('admin_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_token');
    await prefs.remove('admin_email');
  }
}