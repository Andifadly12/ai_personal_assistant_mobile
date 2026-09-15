import 'package:ai_personal_assistant_mobile/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Bottom bar switches tabs and emphasizes the center action', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();
    final center = find.byKey(const ValueKey('home-tab-2'));
    final side = find.byKey(const ValueKey('home-tab-1'));
    expect(
      tester.getSize(center).height,
      greaterThan(tester.getSize(side).height),
    );
    for (final index in [1, 2, 3, 4]) {
      await tester.tap(find.byKey(ValueKey('home-tab-$index')));
      await tester.pumpAndSettle();
      expect(
        find.text('Fitur ini sedang disiapkan. Nantikan di sini, ya!'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    }
    await tester.tap(find.byKey(const ValueKey('home-tab-0')));
    await tester.pumpAndSettle();
    expect(find.text('Selamat Datang'), findsOneWidget);
  });

  testWidgets('Home menu remains reachable on a small screen with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.5)),
          child: child!,
        ),
        home: const HomePage(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('AI Assistant'));
    expect(find.text('AI Assistant').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
