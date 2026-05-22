// Smoke test: the login screen builds.
//
// The original stub test called `MainApp()` with no arguments and asserted
// on stock "Running on:" template text. `MainApp` has since required a Hive
// `box` and become a Bluesky client, so that stub no longer compiled.
//
// `MainApp` itself is not widget-tested directly: it depends on an
// `EasyLocalization` ancestor, and EasyLocalization's async init hangs under
// the fake-async test clock. Instead this pumps the screen `MainApp` routes
// to for a fresh (sessionless) box — `LoginScreen` — under a bare
// `MaterialApp`, the same approach kindling's `test/helpers.dart` uses.
// `.tr()` falls back to the key string, sufficient for a structural check.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:sidequest/screens/login.dart';

void main() {
  late Directory tempDir;
  late Box box;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('sidequest_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox('sidequest_test');
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  testWidgets('LoginScreen builds without error', (tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen(box: box)));
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.takeException(), isNull);
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
