import 'package:ai_personal_assistant_mobile/core/storage/token_storage.dart';
import 'package:ai_personal_assistant_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ai_personal_assistant_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ai_personal_assistant_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:ai_personal_assistant_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:ai_personal_assistant_mobile/features/home/presentation/pages/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuccessfulAuthSource extends AuthRemoteDataSource {
  SuccessfulAuthSource() : super(dio: Dio());

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async => 'test-token';

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {}
}

void main() {
  late AuthCubit cubit;
  late SuccessfulAuthSource source;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    source = SuccessfulAuthSource();
    cubit = AuthCubit(
      authRemoteDataSource: source,
      tokenStorage: TokenStorage(),
    );
  });
  tearDown(() async {
    await cubit.close();
    source.dio.close();
  });

  Future<void> openLogin(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: const MaterialApp(home: LoginPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Successful login replaces login route with HomePage', (
    tester,
  ) async {
    await openLogin(tester);
    await tester.enterText(find.byType(TextField).first, 'user@example.com');
    await tester.enterText(find.byType(TextField).last, 'password');
    final button = find.widgetWithText(ElevatedButton, 'Login');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
    expect(
      Navigator.of(tester.element(find.byType(HomePage))).canPop(),
      isFalse,
    );
    expect(await TokenStorage().getToken(), 'test-token');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Successful register returns to login without opening HomePage', (
    tester,
  ) async {
    await openLogin(tester);
    final link = find.text('Belum punya akun? Register');
    await tester.ensureVisible(link);
    await tester.tap(link);
    await tester.pumpAndSettle();
    expect(find.byType(RegisterPage), findsOneWidget);
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'User');
    await tester.enterText(fields.at(1), 'user@example.com');
    await tester.enterText(fields.at(2), 'password');
    final button = find.widgetWithText(ElevatedButton, 'Register');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(RegisterPage), findsNothing);
    expect(find.byType(HomePage), findsNothing);
    expect(await TokenStorage().getToken(), isNull);
    expect(tester.takeException(), isNull);
  });
}
