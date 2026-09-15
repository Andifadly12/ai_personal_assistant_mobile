import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/token_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource authRemoteDataSource;
  final TokenStorage tokenStorage;

  AuthCubit({required this.authRemoteDataSource, required this.tokenStorage})
    : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      final token = await authRemoteDataSource.login(
        email: email,
        password: password,
      );

      await tokenStorage.saveToken(token);

      emit(AuthSuccess());
    } on DioException catch (e) {
      emit(AuthFailure(_errorMessage(e, 'Login gagal')));
    } catch (_) {
      emit(AuthFailure('Terjadi kesalahan'));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      await authRemoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );

      emit(AuthSuccess());
    } on DioException catch (e) {
      emit(AuthFailure(_errorMessage(e, 'Register gagal')));
    } catch (_) {
      emit(AuthFailure('Terjadi kesalahan'));
    }
  }

  String _errorMessage(DioException error, String fallback) {
    if ((error.response?.statusCode ?? 0) >= 500) {
      return 'Server sedang bermasalah. Silakan coba lagi nanti.';
    }
    final data = error.response?.data;
    final message = data is Map ? data['message'] : null;
    if (message is List) {
      final messages = message.whereType<String>().where(
        (text) => text.trim().isNotEmpty,
      );
      if (messages.isNotEmpty) return messages.join('\n');
    }
    return message is String && message.trim().isNotEmpty ? message : fallback;
  }

  Future<void> logout() async {
    try {
      await tokenStorage.deleteToken();
      emit(AuthInitial());
    } catch (_) {
      emit(AuthFailure('Logout gagal'));
    }
  }
}
