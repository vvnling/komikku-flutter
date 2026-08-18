import 'package:drift/wasm.dart' show WasmDatabase;

export 'package:drift/wasm.dart' show WasmDatabase;

/// Alias so database.dart uses one name on both platforms.
class WasmDatabaseStub {
  static Future<dynamic> open({
    required String databaseName,
    required Uri sqlite3Uri,
    required Uri driftWorkerUri,
  }) =>
      WasmDatabase.open(databaseName: databaseName, sqlite3Uri: sqlite3Uri, driftWorkerUri: driftWorkerUri);
}
