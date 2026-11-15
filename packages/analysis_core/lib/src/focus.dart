import 'issues.dart';
import 'types.dart';

/// Picks the 1–2 issues to fix first (AI_ANALYSIS_SPEC §11). Deterministic
/// rules, no LLM.
///
/// Only visible findings at `attention` or `review` are candidates. Order:
/// 1. level (`review` before `attention`),
/// 2. how many swings in the set show the issue ([repeats], session view),
/// 3. editorial priority from the IssueGuide (smaller = more fundamental),
/// 4. confidence.
class FocusSelector {
  const FocusSelector({this.max = 2});
  final int max;

  List<IssueId> select(
    Iterable<IssueFinding> findings, {
    required Map<IssueId, int> editorialPriority,
    Map<IssueId, int> repeats = const {},
  }) {
    final best = <IssueId, IssueFinding>{};
    for (final f in findings) {
      if (f.hidden || f.level == Level.ok || f.level == Level.insufficientData) continue;
      final prev = best[f.issue];
      if (prev == null || _rank(f.level) > _rank(prev.level)) best[f.issue] = f;
    }
    final list = best.values.toList()
      ..sort((a, b) {
        var c = _rank(b.level).compareTo(_rank(a.level));
        if (c != 0) return c;
        c = (repeats[b.issue] ?? 1).compareTo(repeats[a.issue] ?? 1);
        if (c != 0) return c;
        c = (editorialPriority[a.issue] ?? 999).compareTo(editorialPriority[b.issue] ?? 999);
        if (c != 0) return c;
        return b.confidence.index.compareTo(a.confidence.index);
      });
    return [for (final f in list.take(max)) f.issue];
  }

  static int _rank(Level l) => switch (l) {
        Level.review => 2,
        Level.attention => 1,
        _ => 0,
      };
}
