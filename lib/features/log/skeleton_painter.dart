import 'package:analysis_core/analysis_core.dart';
import 'package:flutter/material.dart';

/// Draws the detected pose over the video frame. Landmarks are normalized to
/// the upright frame, which is what the player shows, so they map directly
/// to the painter size. Keypoints are stored unmirrored, so no flip is needed.
class SkeletonPainter extends CustomPainter {
  SkeletonPainter(this.frame, {required this.color});

  final PoseFrame? frame;
  final Color color;

  /// Points less visible than this are not drawn.
  static const minVisibility = 0.3;

  @override
  void paint(Canvas canvas, Size size) {
    final pts = frame?.points;
    if (pts == null) return;
    Offset at(Landmark l) => Offset(l.x * size.width, l.y * size.height);
    final line = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final dot = Paint()..color = Colors.white;
    for (final e in Lm.edges) {
      final a = pts[e[0]], b = pts[e[1]];
      if (a.visibility < minVisibility || b.visibility < minVisibility) continue;
      canvas.drawLine(at(a), at(b), line);
    }
    for (final i in {for (final e in Lm.edges) ...e}) {
      if (pts[i].visibility >= minVisibility) canvas.drawCircle(at(pts[i]), 3.5, dot);
    }
  }

  @override
  bool shouldRepaint(SkeletonPainter old) => old.frame != frame || old.color != color;
}
