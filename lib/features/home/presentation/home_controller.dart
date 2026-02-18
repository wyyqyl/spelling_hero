import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spelling_hero/core/database/app_database.dart';
import 'package:spelling_hero/core/database/database_provider.dart';

part 'home_controller.g.dart';

@riverpod
class HomeListController extends _$HomeListController {
  @override
  // Using List<dynamic> as a workaround for Riverpod generator InvalidTypeException with Drift classes
  Stream<List<dynamic>> build() {
    final database = ref.watch(databaseProvider);
    return database
        .select(database.dictationLists)
        .watch()
        .map((items) => items.cast<dynamic>());
  }

  Future<Map<String, dynamic>> exportWorkbook(int listId) async {
    final database = ref.read(databaseProvider);
    final list = await (database.select(
      database.dictationLists,
    )..where((tbl) => tbl.id.equals(listId))).getSingle();

    final items = await (database.select(
      database.dictationItems,
    )..where((tbl) => tbl.listId.equals(listId))).get();

    return {
      'name': list.name,
      'themeColor': list.themeColor,
      'items': items.map((i) => i.content).toList(),
    };
  }

  Future<int> importWorkbook(Map<String, dynamic> data) async {
    if (!data.containsKey('name') ||
        !data.containsKey('themeColor') ||
        !data.containsKey('items')) {
      throw const FormatException('Invalid workbook format');
    }

    final name = data['name'] as String;
    final themeColor = data['themeColor'] as int;
    final items = (data['items'] as List).cast<String>();

    return createListWithItems(name, themeColor, items);
  }

  Future<int> createList(String name, int themeColor) async {
    final database = ref.read(databaseProvider);
    return await database
        .into(database.dictationLists)
        .insert(
          DictationListsCompanion.insert(name: name, themeColor: themeColor),
        );
  }

  Future<int> createListWithItems(
    String name,
    int themeColor,
    List<String> items,
  ) async {
    final database = ref.read(databaseProvider);
    return await database.transaction(() async {
      final listId = await database
          .into(database.dictationLists)
          .insert(
            DictationListsCompanion.insert(name: name, themeColor: themeColor),
          );

      for (final item in items) {
        await database
            .into(database.dictationItems)
            .insert(
              DictationItemsCompanion.insert(
                listId: listId,
                content: item,
                isSentence: Value(item.contains(' ')),
              ),
            );
      }
      return listId;
    });
  }

  Future<void> deleteList(int id) async {
    final database = ref.read(databaseProvider);
    await (database.delete(
      database.dictationLists,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> addItem(int listId, String content) async {
    final database = ref.read(databaseProvider);
    await database
        .into(database.dictationItems)
        .insert(
          DictationItemsCompanion.insert(
            listId: listId,
            content: content,
            isSentence: Value(content.contains(' ')),
          ),
        );
  }

  Future<void> updateItem(int itemId, String content) async {
    final database = ref.read(databaseProvider);
    await (database.update(
      database.dictationItems,
    )..where((tbl) => tbl.id.equals(itemId))).write(
      DictationItemsCompanion(
        content: Value(content),
        isSentence: Value(content.contains(' ')),
      ),
    );
  }

  Future<void> deleteItem(int itemId) async {
    final database = ref.read(databaseProvider);
    await (database.delete(
      database.dictationItems,
    )..where((tbl) => tbl.id.equals(itemId))).go();
  }
}
