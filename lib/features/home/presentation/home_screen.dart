import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spelling_hero/core/database/app_database.dart';
import 'package:spelling_hero/features/home/presentation/home_controller.dart';
import 'package:spelling_hero/core/theme/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(homeListControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlue,
      appBar: AppBar(
        title: Text(
          'My Workbooks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.light.textTheme.displayLarge?.fontFamily,
            color: AppTheme.deepNavy,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: AppTheme.deepNavy),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (value) {
              if (value == 'import') {
                _showImportDialog(context, ref);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(
                      Icons.upload_file_rounded,
                      color: AppTheme.playfulOrange,
                    ),
                    SizedBox(width: 8),
                    Text('Import Workbook'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: listsAsync.when(
        data: (lists) {
          if (lists.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No workbooks yet!\nTap + to create one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisExtent: 240, // Fixed height for consistency
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final list = lists[index];
              return _WorkbookCard(
                list: list as DictationList,
                onTap: () => context.push('/edit-list/${list.id}'),
                onEdit: () => context.push('/edit-list/${list.id}'),
                onDelete: () => ref
                    .read(homeListControllerProvider.notifier)
                    .deleteList(list.id),
                onExport: () => _showExportDialog(context, ref, list.id),
                onPractice: () =>
                    context.push('/dictation/${list.id}?mode=practice'),
                onQuiz: () => context.push('/dictation/${list.id}?mode=quiz'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Create New Workbook',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _OptionButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Scan',
                  color: AppTheme.softBlue,
                  onTap: () {
                    context.pop();
                    context.push('/scanner');
                  },
                ),
                _OptionButton(
                  icon: Icons.edit_rounded,
                  label: 'Type',
                  color: AppTheme.brightOrange,
                  onTap: () {
                    context.pop();
                    _showCreateDialog(context, ref);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showImportDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Import Workbook',
          style: TextStyle(
            color: AppTheme.deepNavy,
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.light.textTheme.titleLarge?.fontFamily,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Paste the workbook JSON code below:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                hintText: '{"name": "...", ...}',
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            onPressed: () async {
              try {
                if (controller.text.isEmpty) return;

                final jsonStr = controller.text.trim();
                final data = jsonDecode(jsonStr) as Map<String, dynamic>;

                final id = await ref
                    .read(homeListControllerProvider.notifier)
                    .importWorkbook(data);

                if (context.mounted) {
                  Navigator.pop(context); // Close import dialog
                  // Navigator.pop(context); // Close menu if open (Wait, popup menu doesn't need pop if we used onSelected)

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Workbook imported successfully!'),
                      backgroundColor: AppTheme.vibrantGreen,
                    ),
                  );

                  // Optional: navigate to the new list
                  context.push('/edit-list/$id');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Import failed: Invalid format or data'),
                      backgroundColor: AppTheme.oopsColor,
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.playfulOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(
    BuildContext context,
    WidgetRef ref,
    int listId,
  ) async {
    try {
      final data = await ref
          .read(homeListControllerProvider.notifier)
          .exportWorkbook(listId);
      final jsonStr = jsonEncode(data);
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Export Workbook',
            style: TextStyle(
              color: AppTheme.deepNavy,
              fontWeight: FontWeight.bold,
              fontFamily: AppTheme.light.textTheme.titleLarge?.fontFamily,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Copy the code below to save or share your workbook:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primaryIndigo.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryIndigo.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SelectableText(
                  jsonStr,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: AppTheme.deepNavy,
                  ),
                  maxLines: 8,
                ),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonStr));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to clipboard!'),
                    backgroundColor: AppTheme.vibrantGreen,
                  ),
                );
              },
              icon: const Icon(
                Icons.copy_rounded,
                color: AppTheme.primaryIndigo,
              ),
              label: const Text(
                'Copy',
                style: TextStyle(color: AppTheme.primaryIndigo),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppTheme.oopsColor,
          ),
        );
      }
    }
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'New Workbook',
          style: TextStyle(
            color: AppTheme.deepNavy,
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.light.textTheme.titleLarge?.fontFamily,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., Week 1 Spelling',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          autofocus: true,
          style: const TextStyle(color: AppTheme.deepNavy),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                // Pick a random vibrant color for the new list
                final randomColor = AppTheme.getRandomColor(
                  Random().nextInt(8),
                ).toARGB32();
                final id = await ref
                    .read(homeListControllerProvider.notifier)
                    .createList(controller.text, randomColor);
                if (context.mounted) {
                  Navigator.pop(context);
                  context.push('/edit-list/$id');
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryIndigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _WorkbookCard extends StatelessWidget {
  final DictationList list;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onExport;
  final VoidCallback onPractice;
  final VoidCallback onQuiz;

  const _WorkbookCard({
    required this.list,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    required this.onExport,
    required this.onPractice,
    required this.onQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(list.themeColor);
    final cardBackground = Colors.white;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              'Workbook Options',
              style: TextStyle(
                color: AppTheme.deepNavy,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text('Manage "${list.name}"'),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onEdit();
                },
                icon: const Icon(
                  Icons.edit_rounded,
                  color: AppTheme.primaryIndigo,
                ),
                label: const Text(
                  'Edit List',
                  style: TextStyle(color: AppTheme.primaryIndigo),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onExport();
                },
                icon: const Icon(
                  Icons.upload_file_rounded,
                  color: AppTheme.playfulOrange,
                ),
                label: const Text(
                  'Export',
                  style: TextStyle(color: AppTheme.playfulOrange),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.candyPink,
                ),
                icon: const Icon(Icons.delete_rounded),
                label: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppTheme.deepNavy.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withValues(alpha: 0.8)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -20,
                      right: -20,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: -10,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    Center(
                      child: Hero(
                        tag: 'workbook_${list.id}',
                        child: Icon(
                          Icons.auto_stories_rounded,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepNavy,
                      fontFamily:
                          AppTheme.light.textTheme.titleLarge?.fontFamily,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat.yMMMd().format(list.dateCreated),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onPractice,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: color,
                            elevation: 0,
                            side: BorderSide(
                              color: color.withValues(alpha: 0.3),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text('Practice'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onQuiz,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text('Quiz'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OptionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
