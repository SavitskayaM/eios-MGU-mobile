import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String authBaseUrl = 'https://p.mrsu.ru';
  static const String apiBaseUrl = 'https://papi.mrsu.ru';
  static const String clientId = '8';
  static const String clientSecret = 'qweasd';
  static const int timeoutSeconds = 60;

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _headers() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    print('🔑 API: Начинаем вход...');
    print('🔑 URL: $authBaseUrl/OAuth/Token');
    
    try {
      final response = await http.post(
        Uri.parse('$authBaseUrl/OAuth/Token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'password',
          'username': username,
          'password': password,
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      ).timeout(const Duration(seconds: timeoutSeconds));

      print('🔑 Получен ответ! Код: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['access_token']);
        print('✅ Токен сохранён!');
        return {'success': true, 'data': data};
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'error': error['error_description'] ?? 'Ошибка входа'};
      }
    } catch (e) {
      print('❌ ИСКЛЮЧЕНИЕ: $e');
      return {'success': false, 'error': 'Нет подключения к серверу'};
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    print('👤 getUser: Начинаем...');
    try {
      final headers = await _headers();
      final response = await http
          .get(Uri.parse('$apiBaseUrl/v1/User'), headers: headers)
          .timeout(const Duration(seconds: timeoutSeconds));
      
      print('👤 Код ответа: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'error': 'Ошибка загрузки данных'};
      }
    } catch (e) {
      print('❌ getUser error: $e');
      return {'success': false, 'error': 'Нет подключения'};
    }
  }

  Future<Map<String, dynamic>> getStudentSemester(String year, int period) async {
    try {
      final headers = await _headers();
      // ВАЖНО: API требует пробелы вокруг дефиса!
      final yearParam = year.replaceAll('-', ' - '); // "2024-2025" -> "2024 - 2025"
      final uri = Uri.parse('$apiBaseUrl/v1/StudentSemester').replace(
        queryParameters: {'year': yearParam, 'period': period.toString()},
      );
      print('📥 URL: $uri');
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: timeoutSeconds));
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'error': 'Ошибка загрузки семестра'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Нет подключения'};
    }
  }

  Future<Map<String, dynamic>> getStudentRatingPlan(int disciplineId) async {
    try {
      final headers = await _headers();
      // ВАЖНО: В оригинале используется v2!
      final uri = Uri.parse('$apiBaseUrl/v2/StudentRatingPlan/$disciplineId');
      print('📥 RatingPlan URL: $uri');
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: timeoutSeconds));
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'error': 'Ошибка загрузки баллов'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Нет подключения'};
    }
  }

  Future<Map<String, dynamic>> getStudentTimeTable(String date) async {
    try {
      final headers = await _headers();
      final uri = Uri.parse('$apiBaseUrl/v1/StudentTimeTable').replace(
        queryParameters: {'date': date},
      );
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: timeoutSeconds));
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'error': 'Ошибка загрузки расписания'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Нет подключения'};
    }
  }

  Future<Map<String, dynamic>> getCurrentSemester() async {
    try {
      final headers = await _headers();
      // ВАЖНО: Добавляем selector=current как в оригинале!
      final uri = Uri.parse('$apiBaseUrl/v1/StudentSemester').replace(
        queryParameters: {'selector': 'current'},
      );
      print('📥 URL: $uri');
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: timeoutSeconds));
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'error': 'Ошибка загрузки семестра'};
      }
    } catch (e) {
      print('❌ getCurrentSemester error: $e');
      return {'success': false, 'error': 'Нет подключения'};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
