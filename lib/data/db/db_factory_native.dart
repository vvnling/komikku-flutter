import 'package:drift/drift.dart';
import 'package:drift/native.dart' show NativeDatabase;

DatabaseConnection openMemoryDb() => DatabaseConnection(NativeDatabase.memory());
