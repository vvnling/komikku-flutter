/// Native stub — drift's wasm support is web-only.
class WasmDatabaseStub {
  static Future<dynamic> open({
    required String databaseName,
    required Uri sqlite3Uri,
    required Uri driftWorkerUri,
  }) {
    throw UnsupportedError('WasmDatabase is only available on the web');
  }
}
