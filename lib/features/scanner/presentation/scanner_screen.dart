import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spelling_hero/features/scanner/presentation/scanner_controller.dart';
import 'package:spelling_hero/features/home/presentation/home_controller.dart';

class ScannerScreen extends ConsumerWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scannerControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Homework')),
      body: scanState.when(
        data: (lines) {
          if (lines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No text scanned yet.'),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => ref
                        .read(scannerControllerProvider.notifier)
                        .pickAndScanImage(),
                    icon: const Icon(Icons.camera),
                    label: const Text('Start Camera'),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lines.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: TextFormField(
                          initialValue: lines[index],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (val) => ref
                              .read(scannerControllerProvider.notifier)
                              .updateLine(index, val),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => ref
                              .read(scannerControllerProvider.notifier)
                              .removeLine(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FilledButton(
                  onPressed: () => _saveWorkbook(context, ref, lines),
                  child: const Text('Create Workbook'),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _saveWorkbook(BuildContext context, WidgetRef ref, List<String> lines) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Name your workbook'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'e.g., Scanned List 1'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final id = await ref
                    .read(homeListControllerProvider.notifier)
                    .createListWithItems(controller.text, 0xFF4FACFE, lines);
                if (context.mounted) {
                  Navigator.pop(context);
                  context.pushReplacement('/edit-list/$id');
                }
              }
            },
            child: const Text('Save & Edit'),
          ),
        ],
      ),
    );
  }
}
