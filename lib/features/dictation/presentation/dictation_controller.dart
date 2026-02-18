import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spelling_hero/core/database/database_provider.dart';
import 'package:spelling_hero/core/services/sound_service.dart';
import 'package:spelling_hero/features/dictation/domain/dictation_state.dart';

part 'dictation_controller.g.dart';

@riverpod
class DictationController extends _$DictationController {
  final FlutterTts _tts = FlutterTts();

  @override
  Future<DictationState> build(int listId) async {
    final database = ref.read(databaseProvider);
    final items = await (database.select(
      database.dictationItems,
    )..where((tbl) => tbl.listId.equals(listId))).get();

    // Configure TTS
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.4);

    return DictationState(
      listId: listId,
      items: items,
      mode: DictationMode.practice,
    );
  }

  void setMode(DictationMode mode) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(mode: mode));
  }

  Future<void> speakCurrent() async {
    final currentState = state.value;
    if (currentState == null || currentState.items.isEmpty) return;
    final text = currentState.items[currentState.currentIndex].content;
    await _tts.speak(text);
  }

  void updateInput(String input) {
    if (state.value == null) return;

    var newState = state.value!.copyWith(currentInput: input);
    if (newState.feedbackStatus == FeedbackStatus.incorrect) {
      newState = newState.copyWith(feedbackStatus: FeedbackStatus.none);
    }

    state = AsyncValue.data(newState);
  }

  Future<void> submitAnswer() async {
    final currentState = state.value;
    if (currentState == null) return;

    final currentItem = currentState.items[currentState.currentIndex];
    final userInput = currentState.currentInput.trim();
    final isCorrect =
        userInput.toLowerCase() == currentItem.content.trim().toLowerCase();

    final soundService = ref.read(soundServiceProvider);

    if (currentState.mode == DictationMode.practice) {
      if (isCorrect) {
        soundService.playSuccess();
        state = AsyncValue.data(
          currentState.copyWith(feedbackStatus: FeedbackStatus.correct),
        );
        await _tts.speak("Correct! Great job!");
        await Future.delayed(const Duration(seconds: 2));
        nextItem(isCorrect: true);
      } else {
        soundService.playFailure();
        state = AsyncValue.data(
          currentState.copyWith(
            feedbackStatus: FeedbackStatus.incorrect,
            shakeCount: currentState.shakeCount + 1,
          ),
        );
        await _tts.speak("Oops, try again!");
      }
    } else {
      // Quiz mode - silent submission
      soundService.playClick();
      if (!isCorrect) {
        final mistakes = List<DictationMistake>.from(currentState.mistakes);
        mistakes.add(
          DictationMistake(
            correctSpelling: currentItem.content,
            userInput: userInput,
          ),
        );
        // In quiz mode we update state immediately but don't show feedback
        // We need to update mistakes list
        // However, since we call _nextItem right after, we need to pass the updated mistakes?
        // _nextItem uses currentState.mistakes? No, it uses currentState which is from state.value.
        // So we need to update state first.
        state = AsyncValue.data(currentState.copyWith(mistakes: mistakes));
      }
      // Wait a tiny bit for state update? No need, it's synchronous (Riverpod state update).
      // But _nextItem reads state.value again.
      // So if we updated state above, _nextItem will see the new mistakes.
      nextItem(isCorrect: isCorrect);
    }
  }

  Future<void> showAnswer() async {
    final currentState = state.value;
    if (currentState == null) return;

    final currentItem = currentState.items[currentState.currentIndex];

    // Add to mistakes since they gave up
    final mistakes = List<DictationMistake>.from(currentState.mistakes);
    mistakes.add(
      DictationMistake(
        correctSpelling: currentItem.content,
        userInput: "Skipped", // or "Shown Answer"
      ),
    );

    // Show the correct answer
    state = AsyncValue.data(
      currentState.copyWith(
        currentInput: currentItem.content,
        feedbackStatus: FeedbackStatus.revealed,
        mistakes: mistakes,
      ),
    );

    await _tts.speak("The answer is ${currentItem.content}");
    // Wait for TTS to likely finish before enabling next action, but don't auto-advance
    // _nextItem(isCorrect: false);
  }

  void nextItem({required bool isCorrect}) {
    final currentState = state.value!;
    final nextIndex = currentState.currentIndex + 1;
    final newCorrectCount = isCorrect
        ? currentState.correctCount + 1
        : currentState.correctCount;

    if (nextIndex >= currentState.items.length) {
      state = AsyncValue.data(
        currentState.copyWith(
          isFinished: true,
          correctCount: newCorrectCount,
          feedbackStatus: FeedbackStatus.none,
          currentInput: '',
          currentIndex: nextIndex - 1,
          shakeCount: 0,
        ),
      );
    } else {
      state = AsyncValue.data(
        currentState.copyWith(
          currentIndex: nextIndex,
          currentInput: '',
          feedbackStatus: FeedbackStatus.none,
          correctCount: newCorrectCount,
          shakeCount: 0,
        ),
      );
      speakCurrent();
    }
  }

  void retry() {
    final currentState = state.value!;
    state = AsyncValue.data(
      currentState.copyWith(
        feedbackStatus: FeedbackStatus.none,
        currentInput: '',
        shakeCount: 0,
      ),
    );
  }
}
