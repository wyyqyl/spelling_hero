import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spelling_hero/core/database/app_database.dart';
import 'package:spelling_hero/core/database/database_provider.dart';
import 'package:spelling_hero/core/theme/app_theme.dart';
import 'package:spelling_hero/features/home/presentation/home_controller.dart';

class ListEditorScreen extends ConsumerStatefulWidget {
  final int listId;
  const ListEditorScreen({super.key, required this.listId});

  @override
  ConsumerState<ListEditorScreen> createState() => _ListEditorScreenState();
}

class _ListEditorScreenState extends ConsumerState<ListEditorScreen> {
  final TextEditingController _itemController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _itemController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider);

    // Watch items for this list
    final itemsStream = (database.select(
      database.dictationItems,
    )..where((tbl) => tbl.listId.equals(widget.listId))).watch();

    // Watch list info (for title)
    final listStream = (database.select(
      database.dictationLists,
    )..where((tbl) => tbl.id.equals(widget.listId))).watchSingle();

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DictationList>(
          stream: listStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Edit "${snapshot.data!.name}"');
            }
            return const Text('Edit Workbook');
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'Add a new word or sentence',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      prefixIcon: Icon(Icons.add),
                    ),
                    onSubmitted: (_) {
                      _addItem();
                      // Keep focus for rapid entry
                      _focusNode.requestFocus();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addItem,
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<DictationItem>>(
              stream: itemsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = snapshot.data ?? [];

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list_alt_rounded,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items yet.\nAdd some words above!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: items.length,
                  padding: const EdgeInsets.only(bottom: 80),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: AppTheme.oopsColor,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) {
                        ref
                            .read(homeListControllerProvider.notifier)
                            .deleteItem(item.id);
                      },
                      child: ListTile(
                        title: Text(
                          item.content,
                          style: const TextStyle(fontSize: 18),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.softBlue.withValues(
                            alpha: 0.1,
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: AppTheme.softBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit_rounded),
                          onPressed: () => _showEditDialog(item),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addItem() {
    final input = _itemController.text.trim();
    if (input.isNotEmpty) {
      final items = input.contains(';')
          ? input.split(';').map((e) => e.trim()).where((e) => e.isNotEmpty)
          : [input];

      for (final item in items) {
        ref
            .read(homeListControllerProvider.notifier)
            .addItem(widget.listId, item);
      }
      _itemController.clear();
    }
  }

  void _showEditDialog(DictationItem item) {
    final controller = TextEditingController(text: item.content);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(homeListControllerProvider.notifier)
                    .updateItem(item.id, controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
