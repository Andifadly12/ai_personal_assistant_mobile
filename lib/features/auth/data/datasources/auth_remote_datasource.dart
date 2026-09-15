
import 'package:dio/dio.dart';

class AuthRemoteDatasource {
  Final Dio dio;
    authRemoteDatasource({required this.dio});
    Future<String> login({
        required String email,
        required String password,
    })async {
        final response = await dio.post(
            '${ApiConstants.baseUrl}/auth/login',
            data: {
                'email': email,
                'password': password,
            },
        );
        if (response.statusCode == 200) {
            return response.data['accessToken'];
        } else {
            throw Exception('Failed to login');
        }
    }
}