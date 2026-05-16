import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AiService {
  String get _baseUrl {
    final configured = dotenv.env['API_BASE_URL']?.trim();
    if (configured == null || configured.isEmpty) {
      return 'https://kariyermimari.tech';
    }

    return configured.endsWith('/')
        ? configured.substring(0, configured.length - 1)
        : configured;
  }

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  Future<Map<String, dynamic>> _postJson(
    String path,
    Map<String, dynamic> payload,
  ) async {
    final response = await http
        .post(
          _uri(path),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 45));

    final decodedBody = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final errorMessage =
          decodedBody['error']?.toString() ?? 'Bilinmeyen hata';
      throw Exception('API hatası (${response.statusCode}): $errorMessage');
    }

    return decodedBody;
  }

  Future<Map<String, dynamic>> startExperiment({
    required String studentName,
    required String school,
    required String department,
    required String currentGoal,
  }) {
    return _postJson('/api/start-experiment', {
      'student_name': studentName,
      'school': school,
      'department': department,
      'current_goal': currentGoal,
    });
  }

  Future<Map<String, dynamic>> submitTestResults({
    required String participantId,
    required List<Map<String, dynamic>> testAnswers,
  }) {
    return _postJson('/api/submit-test', {
      'participantId': participantId,
      'testAnswers': testAnswers,
    });
  }

  Future<Map<String, dynamic>> unlockAiReport({required String participantId}) {
    return _postJson('/api/unlock-ai-report', {'participantId': participantId});
  }

  Future<Map<String, dynamic>> submitFeedback({
    required String participantId,
    required int score,
  }) {
    return _postJson('/api/submit-feedback', {
      'participantId': participantId,
      'satisfaction_score': score,
    });
  }
}
