// Prints group-A rule measurements for a keypoints file (threshold tuning).
// Usage: dart run tool/issues.dart <file.gckp> <face_on|down_the_line> [left]
import 'dart:io';

import 'package:analysis_core/analysis_core.dart';

void main(List<String> args) {
  var seq = KeypointSequence.decode(File(args[0]).readAsBytesSync());
  if (args.length > 2 && args[2] == 'left') seq = seq.mirrored();
  final angle = wireValue(CameraAngle.values, args[1]);
  final timing = const PhaseDetector().detect(seq);
  if (timing == null) return stdout.writeln('no swing detected');
  final report = const IssueDetector().detect(seq, timing, angle);
  if (report.angleMismatch) stdout.writeln('body does not look like $angle');
  for (final f in report.findings) {
    stdout.writeln('${f.issue.wire}\tmetric=${f.metric.toStringAsFixed(3)}'
        '\tlevel=${f.level.wire}\tconf=${f.confidence.wire}\tat=${f.evidenceFrameMs}');
  }
}
