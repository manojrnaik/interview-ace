import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://YOUR_BACKEND_URL',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<String> getInterviewQuestion(String role) async {
    final token =
        await FirebaseAuth.instance.currentUser!.getIdToken();

    final response = await _dio.get(
      '/interviews/question',
      queryParameters: {'role': role},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return response.data['question'];
  }

  Future<Map<String, dynamic>> evaluateAnswer({
    required String role,
    required String question,
    required String answer,
  }) async {
    final token =
        await FirebaseAuth.instance.currentUser!.getIdToken();

    final response = await _dio.post(
      '/interviews/evaluate',
      data: {
        'role': role,
        'question': question,
        'answer': answer,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return Map<String, dynamic>.from(response.data);
  }
}
