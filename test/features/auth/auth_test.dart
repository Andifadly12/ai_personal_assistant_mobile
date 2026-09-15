import 'dart:convert';
import 'dart:typed_data';

import 'package:ai_personal_assistant_mobile/core/storage/token_storage.dart';
import 'package:ai_personal_assistant_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ai_personal_assistant_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ai_personal_assistant_mobile/features/auth/presentation/cubit/auth_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StubAdapter implements HttpClientAdapter {
  Object? body = {'accessToken': 'test-token'};
  int status = 200;
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class FailingStorage extends TokenStorage {
  @override
  Future<void> saveToken(String token) async =>
      throw StateError('write failed');

  @override
  Future<void> deleteToken() async => throw StateError('delete failed');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late StubAdapter adapter;
  late Dio dio;
  late TokenStorage storage;
  late AuthRemoteDataSource source;
  late AuthCubit cubit;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    adapter = StubAdapter();
    dio = Dio()..httpClientAdapter = adapter;
    storage = TokenStorage();
    source = AuthRemoteDataSource(dio: dio);
    cubit = AuthCubit(authRemoteDataSource: source, tokenStorage: storage);
  });

  tearDown(() async {
    await cubit.close();
    dio.close();
  });

  test(
    'login sends credentials, emits loading and persists token before success',
    () async {
      final states = <AuthState>[];
      final subscription = cubit.stream.listen(states.add);
      await cubit.login(email: 'user@example.com', password: 'password');
      await Future<void>.delayed(Duration.zero);
      expect(states, [isA<AuthLoading>(), isA<AuthSuccess>()]);
      expect(adapter.request!.path, endsWith('/auth/login'));
      expect(adapter.request!.method, 'POST');
      expect(adapter.request!.data, {
        'email': 'user@example.com',
        'password': 'password',
      });
      expect(await storage.getToken(), 'test-token');
      await subscription.cancel();
    },
  );

  test(
    'register sends profile and succeeds without starting a session',
    () async {
      adapter.status = 201;
      await cubit.register(
        name: 'User',
        email: 'user@example.com',
        password: 'password',
      );
      expect(cubit.state, isA<AuthSuccess>());
      expect(adapter.request!.path, endsWith('/auth/register'));
      expect(adapter.request!.data, {
        'name': 'User',
        'email': 'user@example.com',
        'password': 'password',
      });
      expect(await storage.getToken(), isNull);
    },
  );

  for (final operation in ['login', 'register']) {
    for (final body in <Object?>[
      {'message': 'Kredensial ditolak'},
      'Bad gateway',
      null,
      ['error'],
      {'message': ''},
    ]) {
      test('$operation handles error body $body', () async {
        adapter.status = 401;
        adapter.body = body;
        if (operation == 'login') {
          await cubit.login(email: 'user@example.com', password: 'wrong');
        } else {
          await cubit.register(
            name: 'User',
            email: 'user@example.com',
            password: 'wrong',
          );
        }
        expect(cubit.state, isA<AuthFailure>());
        expect(
          (cubit.state as AuthFailure).message,
          body is Map && body['message'] == 'Kredensial ditolak'
              ? 'Kredensial ditolak'
              : operation == 'login'
              ? 'Login gagal'
              : 'Register gagal',
        );
        expect(await storage.getToken(), isNull);
      });
    }
  }

  for (final body in <Object?>[
    {},
    {'accessToken': ''},
    {'accessToken': '  '},
    {'accessToken': 42},
    'invalid',
    null,
  ]) {
    test('rejects invalid token response $body', () async {
      adapter.body = body;
      await cubit.login(email: 'user@example.com', password: 'password');
      expect(cubit.state, isA<AuthFailure>());
      expect(await storage.getToken(), isNull);
      adapter.status = 201;
      await expectLater(
        source.register(
          name: 'User',
          email: 'user@example.com',
          password: 'password',
        ),
        throwsFormatException,
      );
    });
  }

  test('logout removes saved token', () async {
    await storage.saveToken('test-token');
    await cubit.logout();
    expect(await storage.getToken(), isNull);
    expect(cubit.state, isA<AuthInitial>());
  });

  test('storage failures become failure states', () async {
    final failingCubit = AuthCubit(
      authRemoteDataSource: source,
      tokenStorage: FailingStorage(),
    );
    addTearDown(failingCubit.close);
    await failingCubit.login(email: 'user@example.com', password: 'password');
    expect(failingCubit.state, isA<AuthFailure>());
    await failingCubit.logout();
    expect(failingCubit.state, isA<AuthFailure>());
    expect((failingCubit.state as AuthFailure).message, 'Logout gagal');
  });
}
