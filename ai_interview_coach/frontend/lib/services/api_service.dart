import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/feedback_model.dart';

class ApiService {
  static const Duration _timeout = Duration(
      seconds:
          30); // here we are setting timout for   us only tp get the answer in atleast 30 seconds it is not keep waiting

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // On web, explicitly send Origin to help backend CORS
    if (kIsWeb) {
      headers['Origin'] = AppConfig.frontendBase;
    }

    return headers;
  }

  Future<FeedbackModel> analyzeResponse(String question, String answer) async {
    try {
      final url = Uri.parse('${AppConfig.apiBase}${AppConfig.analyzeEndpoint}');

      final body = jsonEncode({
        'question': question,
        'answer': answer,
      });

      final response = await http
          .post(
            url,
            headers: _headers,
            body: body,
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return FeedbackModel.fromJson(jsonData);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Analysis failed');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout, please check your connection');
      } else if (e.toString().contains('SocketException')) {
        throw Exception('Network error,  please check your connection');
      } else {
        throw Exception('Analysis failed: ${e.toString()}');
      }
    }
  }

  // persists the analyzed result  to the backend
  Future<bool> saveResult({
    required String userId,
    required String question,
    required String answer,
    required FeedbackModel feedback,
  }) async {
    try {
      final url =
          Uri.parse('${AppConfig.apiBase}${AppConfig.saveResultEndpoint}');

      final body = jsonEncode({
        'userId': userId,
        'question': question,
        'answer': answer,
        'feedback': feedback.toJson(),
      });

      final response = await http
          .post(
            url,
            headers: _headers,
            body: body,
          )
          .timeout(_timeout);

      return response.statusCode == 200;
    } catch (e) {
      // Saving to backend is optional, so we don't throw errors
      print('Failed to save to backend: $e');
      return false;
    }
  }

  // thiis is just checking the backend is runnning and reachable or not
  Future<Map<String, dynamic>> checkHealth() async {
    try {
      final url = Uri.parse('${AppConfig.apiBase}${AppConfig.healthEndpoint}');

      final response = await http
          .get(
            url,
            headers: _headers,
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Health check failed');
      }
    } catch (e) {
      throw Exception('Health check failed: ${e.toString()}');
    }
  }
}
