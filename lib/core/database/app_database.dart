import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

class DictationLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get themeColor => integer()();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
}

class DictationItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get listId =>
      integer().references(DictationLists, #id, onDelete: KeyAction.cascade)();
  TextColumn get content => text()();
  TextColumn get audioUrl => text().nullable()();
  BoolColumn get isSentence => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [DictationLists, DictationItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
