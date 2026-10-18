import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

import 'package:sidequest/main.dart';

void main() {
  late Directory tempDir;
  late Box box;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // easy_localization persists the locale via shared_preferences; stub the
    // platform channel with an empty store so no plugin is needed in tests.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/shared_preferences'),
          (MethodCall call) async =>
              call.method == 'getAll' ? <String, Object>{} : true,
        );
    await EasyLocalization.ensureInitialized();
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('sidequest_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox('sidequest_test');
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('shows the login screen when no session is stored', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('en', 'US'), Locale('ja', 'JP')],
          path: 'assets/langs',
          fallbackLocale: const Locale('ja', 'JP'),
          child: MainApp(box: box),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pumpAndSettle();

    expect(find.text('Bluesky Login'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
