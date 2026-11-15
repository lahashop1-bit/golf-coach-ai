import 'package:flutter_test/flutter_test.dart';
import 'package:golf_coach_ai/domain/enums.dart';
import 'package:golf_coach_ai/domain/quality.dart';

void main() {
  const rules = QualityRules();

  test('normal 60 fps clip is good', () {
    final r = rules.check(durationMs: 4000, fps: 60);
    expect(r.level, QualityLevel.good);
    expect(r.issues, isEmpty);
  });

  test('29.97 fps passes the fps check', () {
    expect(rules.check(durationMs: 4000, fps: 29.97).issues, isEmpty);
  });

  test('too short clip is poor', () {
    final r = rules.check(durationMs: 600, fps: 60);
    expect(r.level, QualityLevel.poor);
    expect(r.issues, [QualityIssue.tooShort]);
  });

  test('low fps is fair, not poor', () {
    final r = rules.check(durationMs: 4000, fps: 24);
    expect(r.level, QualityLevel.fair);
    expect(r.issues, [QualityIssue.lowFps]);
  });

  test('unknown fps (0) is not reported as low', () {
    expect(rules.check(durationMs: 4000, fps: 0).issues, isEmpty);
  });

  test('wire values match DATABASE_SCHEMA', () {
    expect(CameraAngle.downTheLine.wire, 'down_the_line');
    expect(SessionMode.guidedAnalysis.wire, 'guided_analysis');
    expect(wireValue(QualityIssue.values, 'low_fps'), QualityIssue.lowFps);
  });
}
