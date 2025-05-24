import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled4/O6U_App/Data/models/login_models.dart';

class AuthRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://systemuniversity.runasp.net',
    ),
  );

  Future<void> _saveLoginData(Login login) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', login.token);
    await prefs.setString('user_email', login.email);
    await prefs.setString('user_role', login.role);
    await prefs.setString('user_id', login.id);
  }

  Future<Login?> login(String email, String password) async {
    try {
      final Map<String, dynamic> requestData = {
        'email': email,
        'password': password,
      };

      Response response = await _dio.post(
        '/api/Auth/login',
        data: jsonEncode(requestData),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Response: ${response.data}");

        final login = Login.fromJson(response.data);

        if (login.token.isNotEmpty) {
          await _saveLoginData(login);
          print("User's token: ${login.token}");
          return login;
        } else {
          throw Exception('Token not found in response');
        }
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }

    } catch (e) {
      print('Login error: $e');
      throw Exception('Login failed: $e');
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }


}
