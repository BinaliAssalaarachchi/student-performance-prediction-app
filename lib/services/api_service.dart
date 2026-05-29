import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import '../models/performance_model.dart';
import '../models/schedule_model.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:5000';
      }
    } catch (_) {}
    return 'http://localhost:5000';
  }

  static final Map<String, String> _cookies = {};

  static Map<String, String> _buildHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (_cookies.isNotEmpty) {
      headers['Cookie'] = _cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
    }
    return headers;
  }

  static void _storeCookies(http.Response response) {
    final rawCookie = response.headers['set-cookie'];
    if (rawCookie == null) return;
    for (final cookie in rawCookie.split(',')) {
      final parts = cookie.split(';');
      if (parts.isEmpty) continue;
      final cookiePair = parts[0].split('=');
      if (cookiePair.length >= 2) {
        _cookies[cookiePair[0].trim()] = cookiePair.sublist(1).join('=').trim();
      }
    }
  }

  // Authentication endpoints
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: _buildHeaders(),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      _storeCookies(response);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'message': 'Registration successful'};
      } else {
        final body = jsonDecode(response.body);
        return {'success': false, 'message': body['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _buildHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      _storeCookies(response);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['user'] != null) {
          return {
            'success': true,
            'message': body['message'],
            'user': User.fromJson(body['user']),
          };
        }
      }
      
      final body = jsonDecode(response.body);
      return {'success': false, 'message': body['message'] ?? 'Login failed'};
    } catch (e) {
      return {'success': false, 'message': 'Cannot reach server: $e'};
    }
  }

  static Future<bool> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: _buildHeaders(),
      );
      _cookies.clear();
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Performance endpoints
  static Future<PerformancePrediction?> predictPerformance(
    StudentPerformanceData data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/predict-performance'),
        headers: _buildHeaders(),
        body: jsonEncode(data.toJson()),
      );

      _storeCookies(response);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return PerformancePrediction.fromJson(body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Schedule endpoints
  static Future<List<ScheduleTask>?> generateSchedule(
    List<ScheduleTask> schedule, {
    String? goalType,
    double? availableHours,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/generate-schedule'),
        headers: _buildHeaders(),
        body: jsonEncode({
          'schedule': schedule.map((s) => s.toJson()).toList(),
          if (goalType != null) 'goal_type': goalType,
          if (availableHours != null) 'available_hours': availableHours,
        }),
      );

      _storeCookies(response);

      if (response.statusCode != 200) return null;
      final body = jsonDecode(response.body);
      if (body['schedule'] is List) {
        return (body['schedule'] as List)
            .map((entry) => ScheduleTask.fromJson(entry as Map<String, dynamic>))
            .toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Fetch saved schedule
  static Future<List<ScheduleTask>?> fetchSavedSchedule() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get-schedule'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['schedule'] is List) {
          return (body['schedule'] as List)
              .map((entry) => ScheduleTask.fromJson(entry as Map<String, dynamic>))
              .toList();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
