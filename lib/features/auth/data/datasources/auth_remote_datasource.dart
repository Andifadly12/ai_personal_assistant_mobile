import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';

class AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSource({required this.dio});
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '${ApiConstants.baseUrl}/auth/login',
      data: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      return _readToken(response.data);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await dio.post(
      '${ApiConstants.baseUrl}/auth/register',
      data: {'email': email, 'password': password, 'name': name},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to register');
    }
  }

  String _readToken(dynamic data) {
    final token = data is Map ? data['access_token'] : null;
    if (token is! String || token.trim().isEmpty) {
      throw const FormatException(
        'Respons autentikasi tidak berisi access_token yang valid',
      );
    }
    return token;
  }
}
