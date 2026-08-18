import 'package:drift/drift.dart';

/// Native-only helper; web builds use [db_factory_native] via conditional
/// import so `dart:ffi` never enters the web module graph.
DatabaseConnection openMemoryDb() =>
    throw UnsupportedError('In-memory databases are only available on native platforms');
