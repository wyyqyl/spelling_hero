import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spelling_hero/core/database/app_database.dart';

part 'dictation_state.freezed.dart';

enum DictationMode { practice, quiz }

enum FeedbackStatus { none, correct, incorrect, revealed }

@freezed
abstract class DictationState with _$DictationState {
  const factory DictationState({
    required int listId,
    required List<DictationItem> items,
    @Default(0) int currentIndex,
    @Default('') String currentInput,
    @Default(FeedbackStatus.none) FeedbackStatus feedbackStatus,
    @Default(DictationMode.practice) DictationMode mode,
    @Default([]) List<DictationMistake> mistakes,
    @Default(0) int correctCount,
    @Default(0) int shakeCount,
    @Default(false) bool isFinished,
    @Default(false) bool isLoading,
  }) = _DictationState;
}

@freezed
abstract class DictationMistake with _$DictationMistake {
  const factory DictationMistake({
    required String correctSpelling,
    required String userInput,
  }) = _DictationMistake;
}
