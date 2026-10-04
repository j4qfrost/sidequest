import 'package:atproto/atproto.dart';
import 'package:atproto/core.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_duckdb/dart_duckdb.dart';

class HomeScreen extends StatefulWidget {
  static const route = 'home';

  const HomeScreen({super.key, required this.box});
  final Box box;

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Session session;
  late ATProto atproto;
  final String fsqKey = dotenv.env['FSQ_KEY']!;
  final String fsqIcebergEndpoint =
      dotenv.env['FSQ_ICEBERG_ENDPOINT'] ??
      'https://catalog.h3-hub.foursquare.com/iceberg';
  bool _isLoading = false;

  String? _errorMessage;

  void _plot() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    // flutter builds bundle duckdb binaries, but this can be overriden
    // open.overrideFor(OperatingSystem.macOS, 'path/to/libduckdb.dylib');

    try {
      final db = await duckdb.open(':memory:');
      final conn = await duckdb.connect(db);

      try {
        await conn.execute(
          'CREATE SECRET iceberg_secret (TYPE ICEBERG,TOKEN "$fsqKey");',
        );
        await conn.execute('''ATTACH 'places' AS places (
    TYPE iceberg,
    SECRET iceberg_secret,
    ENDPOINT '$fsqIcebergEndpoint'
);''');

        final result = await conn.query(
          "SELECT * FROM places.datasets.places_os LIMIT 1;",
        );
        debugPrint('${result.columnNames}');
        for (final row in result.fetchAll()) {
          debugPrint('$row');
        }
      } finally {
        await conn.dispose();
        await db.dispose();
      }

      try {
        final record = await atproto.repo.createRecord(
          repo: session.did,
          collection: 'community.lexicon.location.fsq',
          record: {
            'text': 'Hello from AT Protocol!',
            'createdAt': DateTime.now().toUtc().toIso8601String(),
          },
        );

        debugPrint('Created record: ${record.data.uri}');
      } catch (e) {
        debugPrint('Failed to create AT Protocol record: $e');
        if (mounted) {
          setState(() {
            _errorMessage = 'Failed to publish record: $e';
          });
        }
      }
    } catch (e) {
      debugPrint('DuckDB query failed: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Query failed: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    session = widget.box.get('session');
    atproto = ATProto.fromSession(session);
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.map)),
                Tab(icon: Icon(Icons.directions_transit)),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _plot, // Disable button while loading
                    child: _isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize:
                                MainAxisSize.min, // Keep the button size small
                            children: [
                              Text('Loading...', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 10),
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              ),
                            ],
                          )
                        : const Text('Load Data'),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
              const Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}
