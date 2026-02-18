import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spelling_hero/core/theme/app_theme.dart';
import 'package:spelling_hero/features/dictation/domain/dictation_state.dart';
import 'package:spelling_hero/features/home/presentation/home_controller.dart';

class SummaryScreen extends ConsumerWidget {
  final int score;
  final int total;
  final List<DictationMistake> mistakes;
  final int listId;

  const SummaryScreen({
    super.key,
    required this.score,
    required this.total,
    required this.mistakes,
    required this.listId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final percentage = (score / total * 100).round();
    final isGreatJob = percentage >= 80;

    return Scaffold(
      backgroundColor: AppTheme.softBlue,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              isGreatJob ? 'Amazing Job!' : 'Keep Practicing!',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '$score / $total',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: isGreatJob
                          ? AppTheme.vibrantGreen
                          : AppTheme.oopsColor,
                    ),
                  ),
                  const Text(
                    'Correct Words',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (mistakes.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Mistakes to Review:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: mistakes.length,
                  itemBuilder: (context, index) {
                    final mistake = mistakes[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.close_rounded,
                            color: AppTheme.oopsColor,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mistake.correctSpelling,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'You typed: ${mistake.userInput}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.oopsColor,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ] else
              const Expanded(
                child: Center(
                  child: Icon(
                    Icons.star_rounded,
                    size: 100,
                    color: Colors.yellow,
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (mistakes.isNotEmpty) ...[
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: FilledButton.icon(
                          onPressed: () async {
                            // Create a new list with mistakes
                            final wrongWords = mistakes
                                .map((m) => m.correctSpelling)
                                .toSet()
                                .toList();
                            final newListId = await ref
                                .read(homeListControllerProvider.notifier)
                                .createListWithItems(
                                  'Review ${DateFormat('MMM d, h:mm a').format(DateTime.now())}',
                                  AppTheme.candyPink.toARGB32(),
                                  wrongWords,
                                );
                            if (context.mounted) {
                              context.pushReplacement('/dictation/$newListId');
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.candyPink,
                            padding: EdgeInsets.zero,
                          ),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Retry'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () => context.go('/'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                          padding: EdgeInsets.zero,
                        ),
                        icon: const Icon(Icons.home_rounded),
                        label: const Text('Home'),
                      ),
                    ),
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
