// Prints raw landmarks of selected points every N frames.
// Usage: dart run tool/raw.dart <file.gckp> [every=12]
import 'dart:io';

import 'package:analysis_core/analysis_core.dart';

void main(List<String> args) {
  final seq = KeypointSequence.decode(File(args[0]).readAsBytesSync());
  final every = args.length > 1 ? int.parse(args[1]) : 12;
  String f(Landmark l) =>
      '(${l.x.toStringAsFixed(2)},${l.y.toStringAsFixed(2)} v${l.visibility.toStringAsFixed(2)})';
  for (var i = 0; i < seq.frames.length; i += every) {
    final p = seq.frames[i].points;
    stdout.writeln('${seq.frames[i].timestampMs}\t${p == null ? '-' : 'Lw${f(p[Lm.leftWrist])} Rw${f(p[Lm.rightWrist])} Ls${f(p[Lm.leftShoulder])} Lh${f(p[Lm.leftHip])}'}');
  }
}
