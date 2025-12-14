import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://YOUR_BACKEND_URL'),
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
}
