import 'package:ai_personal_assistant_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App displays login form and obscures password', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('AI Personal Assistant'), findsOneWidget);
    expect(find.text('Masuk ke akun kamu'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(fields.first, 'user@example.com');
    await tester.enterText(fields.last, ' password ');
    final password = tester.widget<TextField>(fields.last);
    expect(password.obscureText, isTrue);
    expect(password.controller!.text, ' password ');
    expect(tester.takeException(), isNull);
  });
}
