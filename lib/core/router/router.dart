import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spelling_hero/features/home/presentation/home_screen.dart';
import 'package:spelling_hero/features/scanner/presentation/scanner_screen.dart';
import 'package:spelling_hero/features/dictation/presentation/dictation_screen.dart';
import 'package:spelling_hero/features/summary/presentation/summary_screen.dart';
import 'package:spelling_hero/features/dictation/domain/dictation_state.dart';
import 'package:spelling_hero/features/list_editor/presentation/list_editor_screen.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/scanner',
        builder: (context, state) => const ScannerScreen(),
      ),
      GoRoute(
        path: '/edit-list/:listId',
        builder: (context, state) {
          final listId = int.parse(state.pathParameters['listId']!);
          return ListEditorScreen(listId: listId);
        },
      ),
      GoRoute(
        path: '/dictation/:listId',
        builder: (context, state) {
          final listId = int.parse(state.pathParameters['listId']!);
          final modeStr = state.uri.queryParameters['mode'];
          final mode = modeStr == 'quiz'
              ? DictationMode.quiz
              : DictationMode.practice;
          return DictationScreen(listId: listId, mode: mode);
        },
      ),
      GoRoute(
        path: '/summary',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return SummaryScreen(
            score: extra['score'] as int,
            total: extra['total'] as int,
            mistakes: extra['mistakes'] as List<DictationMistake>,
            listId: extra['listId'] as int,
          );
        },
      ),
    ],
  );
}
