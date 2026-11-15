// Prints the hand signal and detected phases of a keypoints file.
// Usage: dart run tool/inspect.dart <file.gckp> [every=4]
import 'dart:io';

import 'package:analysis_core/analysis_core.dart';

void main(List<String> args) {
  final seq = KeypointSequence.decode(File(args[0]).readAsBytesSync());
  final every = args.length > 1 ? int.parse(args[1]) : 4;
  final s = HandSignal.from(seq);
  stdout.writeln('fps=${seq.fps.toStringAsFixed(1)} frames=${seq.frames.length} '
      'size=${seq.width}x${seq.height} torso=${s?.torso.toStringAsFixed(3)}');
  if (s == null) return stdout.writeln('no usable hand signal');
  for (var i = 0; i < s.length; i += every) {
    stdout.writeln('${s.t[i]}\ty=${s.y[i].toStringAsFixed(3)}\tx=${s.x[i].toStringAsFixed(3)}'
        '\tspeed=${s.speed[i].toStringAsFixed(2)}\tvis=${s.visibility[i].toStringAsFixed(2)}');
  }
  final r = const PhaseDetector().detect(seq);
  stdout.writeln('phases: ${r?.phases.map((m) => '${m.phase.wire}=${m.timestampMs}(${m.confidence.wire})').join(' ')}');
  stdout.writeln('tempo: ${r?.tempo?.toJson()}');
}
