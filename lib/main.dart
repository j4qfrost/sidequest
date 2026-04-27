import 'package:atproto/core.dart';
// import 'package:atproto/firehose.dart';
// import 'package:atproto/com_atproto_sync_subscriberepos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sidequest/screens/home.dart';
import 'package:sidequest/screens/login.dart';
import 'package:sidequest/utills/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initApp('sidequest');
}

Future<void> initApp(String name) async {
  await EasyLocalization.ensureInitialized();
  await init();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final box = await Hive.openBox(packageInfo.appName);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ja', 'JP')],
      path: 'assets/langs', // <-- change the path of the translation files
      fallbackLocale: const Locale('ja', 'JP'),
      child: MainApp(box: box),
    ),
  );
}

Future<void> init() async {
  await initHive();
  await dotenv.load(fileName: ".env");
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SessionAdapter());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.box});

  final Box box;

  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void dispose() async {
    super.dispose();
    await Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    final Session? session = widget.box.get('session');
    return MaterialApp(
      // https://zenn.dev/kafumi/scraps/d7aeed260985cc
      // title: tr('title'),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigoAccent,
        brightness: Brightness.light,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
          titleSmall: TextStyle(fontSize: 16),
        ),
      ),
      initialRoute: session == null ? LoginScreen.route : HomeScreen.route,
      routes: {
        LoginScreen.route: (context) => LoginScreen(box: widget.box),
        HomeScreen.route: (context) => HomeScreen(box: widget.box),
      },
    );
  }
}
