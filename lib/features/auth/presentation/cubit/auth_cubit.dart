import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/token_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource authRemoteDataSource;
  final TokenStorage tokenStorage;

  AuthCubit({
    required this.authRemoteDataSource,
    required this.tokenStorage,
  }) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final token = await authRemoteDataSource.login(
        email: email,
        password: password,
      );

      await tokenStorage.saveToken(token);

      emit(AuthSuccess());
    } on DioException catch (e) {
      emit(
        AuthFailure(
          e.response?.data['message']?.toString() ?? 'Login gagal',
        ),
      );
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
      emit(
        AuthFailure(
          e.response?.data['message']?.toString() ?? 'Register gagal',
        ),
      );
    } catch (_) {
      emit(AuthFailure('Terjadi kesalahan'));
    }
  }

  Future<void> logout() async {
    await tokenStorage.clearToken();
    emit(AuthInitial());
  }
}