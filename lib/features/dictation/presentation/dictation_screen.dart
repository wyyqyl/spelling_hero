import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spelling_hero/core/theme/app_theme.dart';
import 'package:spelling_hero/features/dictation/domain/dictation_state.dart';
import 'package:spelling_hero/features/dictation/presentation/dictation_controller.dart';
import 'package:spelling_hero/features/dictation/presentation/widgets/custom_keyboard.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class DictationScreen extends ConsumerStatefulWidget {
  final int listId;
  final DictationMode mode;

  const DictationScreen({
    super.key,
    required this.listId,
    this.mode = DictationMode.practice,
  });

  @override
  ConsumerState<DictationScreen> createState() => _DictationScreenState();
}

class _DictationScreenState extends ConsumerState<DictationScreen> {
  @override
  void initState() {
    super.initState();
    // Set the mode immediately
    ref
        .read(dictationControllerProvider(widget.listId).notifier)
        .setMode(widget.mode);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        ref
            .read(dictationControllerProvider(widget.listId).notifier)
            .speakCurrent();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(dictationControllerProvider(widget.listId));

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppTheme.backgroundBlue,
          appBar: AppBar(
            title: Text(
              'Spelling Hero',
              style: TextStyle(
                fontFamily: AppTheme.light.textTheme.displayLarge?.fontFamily,
                fontWeight: FontWeight.bold,
                color: AppTheme.deepNavy,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppTheme.deepNavy),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.volume_up_rounded,
                  color: AppTheme.deepNavy,
                ),
                onPressed: () => ref
                    .read(dictationControllerProvider(widget.listId).notifier)
                    .speakCurrent(),
              ),
            ],
          ),
          body: stateAsync.when(
            data: (state) {
              if (state.isFinished) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.pushReplacement(
                    '/summary',
                    extra: {
                      'score': state.correctCount,
                      'total': state.items.length,
                      'mistakes': state.mistakes,
                      'listId': widget.listId,
                    },
                  );
                });
                return const Center(child: CircularProgressIndicator());
              }

              if (state.items.isEmpty) {
                return const Center(child: Text('This workbook is empty!'));
              }

              final currentItem = state.items[state.currentIndex];
              final wordLength = currentItem.content.length;

              final displayLength = state.currentInput.length > wordLength
                  ? state.currentInput.length
                  : wordLength;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryIndigo.withValues(
                                    alpha: 0.1,
                                  ),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value:
                                    (state.currentIndex) / state.items.length,
                                minHeight: 12,
                                color: AppTheme.playfulOrange,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Word ${state.currentIndex + 1} of ${state.items.length}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryIndigo,
                            ),
                          ),
                          const SizedBox(height: 48),

                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(
                                    dictationControllerProvider(
                                      widget.listId,
                                    ).notifier,
                                  )
                                  .speakCurrent();
                            },
                            behavior: HitTestBehavior.opaque,
                            child:
                                Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryIndigo,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.primaryIndigo
                                                .withValues(alpha: 0.4),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.volume_up_rounded,
                                        size: 48,
                                        color: Colors.white,
                                      ),
                                    )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(reverse: true),
                                    )
                                    .scale(
                                      duration: 1000.ms,
                                      begin: const Offset(1, 1),
                                      end: const Offset(1.05, 1.05),
                                      curve: Curves.easeInOut,
                                    ),
                          ),
                          const SizedBox(height: 48),

                          // Letter Boxes
                          Builder(
                            builder: (context) {
                              final boxes = Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(displayLength, (index) {
                                  final char = index < state.currentInput.length
                                      ? state.currentInput[index]
                                      : '';
                                  final isCorrect =
                                      state.feedbackStatus ==
                                      FeedbackStatus.correct;
                                  final isIncorrect =
                                      state.feedbackStatus ==
                                      FeedbackStatus.incorrect;
                                  final isRevealed =
                                      state.feedbackStatus ==
                                      FeedbackStatus.revealed;

                                  Color bgColor = Colors.white;
                                  Color borderColor = Colors.grey[300]!;
                                  Color textColor = AppTheme.deepNavy;

                                  if (isCorrect) {
                                    bgColor = AppTheme.vibrantGreen.withValues(
                                      alpha: 0.1,
                                    );
                                    borderColor = AppTheme.vibrantGreen;
                                    textColor = AppTheme.vibrantGreen;
                                  } else if (isIncorrect) {
                                    bgColor = AppTheme.oopsColor.withValues(
                                      alpha: 0.1,
                                    );
                                    borderColor = AppTheme.oopsColor;
                                    textColor = AppTheme.oopsColor;
                                  } else if (isRevealed) {
                                    bgColor = AppTheme.playfulOrange.withValues(
                                      alpha: 0.1,
                                    );
                                    borderColor = AppTheme.playfulOrange;
                                    textColor = AppTheme.playfulOrange;
                                  } else if (char.isNotEmpty) {
                                    borderColor = AppTheme.primaryIndigo;
                                    textColor = AppTheme.primaryIndigo;
                                  }

                                  return Container(
                                    width: 48,
                                    height: 56,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      border: Border.all(
                                        color: borderColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: borderColor.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 4,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      char.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                        fontFamily: AppTheme
                                            .light
                                            .textTheme
                                            .displayLarge
                                            ?.fontFamily,
                                      ),
                                    ),
                                  );
                                }),
                              );

                              return state.feedbackStatus ==
                                      FeedbackStatus.incorrect
                                  ? boxes
                                        .animate(
                                          key: ValueKey(
                                            'shake_${state.currentIndex}_${state.shakeCount}',
                                          ),
                                        )
                                        .shake(duration: 500.ms)
                                  : boxes;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Feedback Area
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child:
                                state.feedbackStatus == FeedbackStatus.incorrect
                                ? Text(
                                    'Try Again!',
                                    key: const ValueKey('incorrect'),
                                    style: TextStyle(
                                      color: AppTheme.oopsColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppTheme
                                          .light
                                          .textTheme
                                          .displayLarge
                                          ?.fontFamily,
                                    ),
                                  ).animate().fadeIn().shake()
                                : const SizedBox(
                                    key: ValueKey('empty'),
                                    height: 32,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Action Buttons Area (Show Answer / Next)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1.0,
                        child: child,
                      ),
                    ),
                    child:
                        (state.mode == DictationMode.practice &&
                            state.feedbackStatus == FeedbackStatus.incorrect)
                        ? Padding(
                            key: const ValueKey('show_answer_btn'),
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                            child: SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: OutlinedButton.icon(
                                onPressed: () => ref
                                    .read(
                                      dictationControllerProvider(
                                        widget.listId,
                                      ).notifier,
                                    )
                                    .showAnswer(),
                                icon: const Icon(Icons.visibility_rounded),
                                label: const Text('Show Answer'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.primaryIndigo,
                                  side: const BorderSide(
                                    color: AppTheme.primaryIndigo,
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppTheme
                                        .light
                                        .textTheme
                                        .displayLarge
                                        ?.fontFamily,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : (state.feedbackStatus == FeedbackStatus.revealed)
                        ? Padding(
                            key: const ValueKey('next_btn'),
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: SizedBox(
                              width: double.infinity,
                              height: 64,
                              child: FilledButton.icon(
                                onPressed: () => ref
                                    .read(
                                      dictationControllerProvider(
                                        widget.listId,
                                      ).notifier,
                                    )
                                    .nextItem(isCorrect: false),
                                icon: const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 28,
                                ),
                                label: const Text('Next Word'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppTheme.vibrantGreen,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 4,
                                  shadowColor: AppTheme.vibrantGreen.withValues(
                                    alpha: 0.4,
                                  ),
                                  textStyle: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppTheme
                                        .light
                                        .textTheme
                                        .displayLarge
                                        ?.fontFamily,
                                  ),
                                ),
                              ),
                            ),
                          ).animate().scale(
                            duration: 300.ms,
                            curve: Curves.easeOutBack,
                          )
                        : const SizedBox(key: ValueKey('no_btn')),
                  ),

                  // Custom Keyboard
                  SafeArea(
                    child: CustomKeyboard(
                      onKeyPressed: (key) {
                        if (state.feedbackStatus == FeedbackStatus.correct) {
                          return;
                        }
                        final newInput = state.currentInput + key;
                        ref
                            .read(
                              dictationControllerProvider(
                                widget.listId,
                              ).notifier,
                            )
                            .updateInput(newInput);
                      },
                      onBackspace: () {
                        if (state.feedbackStatus == FeedbackStatus.correct) {
                          return;
                        }
                        if (state.currentInput.isNotEmpty) {
                          final newInput = state.currentInput.substring(
                            0,
                            state.currentInput.length - 1,
                          );
                          ref
                              .read(
                                dictationControllerProvider(
                                  widget.listId,
                                ).notifier,
                              )
                              .updateInput(newInput);
                        }
                      },
                      onSubmit: () {
                        if (state.feedbackStatus == FeedbackStatus.correct) {
                          return;
                        }
                        ref
                            .read(
                              dictationControllerProvider(
                                widget.listId,
                              ).notifier,
                            )
                            .submitAnswer();
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),

        // Confetti Overlay
        if (stateAsync.asData?.value.feedbackStatus == FeedbackStatus.correct)
          Positioned.fill(
            child: IgnorePointer(
              child: Lottie.asset(
                'assets/animations/confetti.json',
                repeat: false,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if asset is missing
                  return Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 100),
                    child: const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 100,
                    ).animate().scale(duration: 500.ms).then().fadeOut(),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
