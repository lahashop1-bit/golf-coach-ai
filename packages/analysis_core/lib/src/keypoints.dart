import 'dart:convert';
import 'dart:typed_data';

/// BlazePose / MediaPipe Pose Landmarker indices (33 points).
abstract final class Lm {
  static const nose = 0;
  static const leftEar = 7, rightEar = 8;
  static const leftShoulder = 11, rightShoulder = 12;
  static const leftElbow = 13, rightElbow = 14;
  static const leftWrist = 15, rightWrist = 16;
  static const leftHip = 23, rightHip = 24;
  static const leftKnee = 25, rightKnee = 26;
  static const leftAnkle = 27, rightAnkle = 28;
  static const count = 33;

  /// Left/right pairs swapped when mirroring.
  static const pairs = [
    [1, 4], [2, 5], [3, 6], [7, 8], [9, 10], [11, 12], [13, 14], [15, 16],
    [17, 18], [19, 20], [21, 22], [23, 24], [25, 26], [27, 28], [29, 30],
    [31, 32],
  ];

  /// Skeleton edges for the overlay.
  static const edges = [
    [11, 12], [11, 13], [13, 15], [12, 14], [14, 16], [11, 23], [12, 24],
    [23, 24], [23, 25], [25, 27], [24, 26], [26, 28], [7, 0], [0, 8],
  ];
}

/// Normalized 0–1 coordinates in the upright frame; y grows downward.
class Landmark {
  const Landmark(this.x, this.y, this.visibility);
  final double x, y, visibility;
}

class PoseFrame {
  const PoseFrame(this.timestampMs, this.points);
  final int timestampMs;

  /// Null when no person was detected in this frame.
  final List<Landmark>? points;
}

/// Decoded keypoints file (written by the native `pose` plugin).
///
/// Little-endian layout:
///   header: "GCKP" | u16 version=1 | u16 pointCount | u32 frameCount |
///           f32 fps | u32 width | u32 height | u16 modelLen | model utf8
///   frame:  u32 timestampMs | u8 detected | pointCount × (f32 x, f32 y, f32 visibility)
class KeypointSequence {
  const KeypointSequence({
    required this.fps,
    required this.width,
    required this.height,
    required this.model,
    required this.frames,
  });

  final double fps;
  final int width, height;
  final String model;
  final List<PoseFrame> frames;

  static const _magic = 'GCKP';

  factory KeypointSequence.decode(Uint8List bytes) {
    final d = ByteData.sublistView(bytes);
    if (bytes.length < 24 || ascii.decode(bytes.sublist(0, 4)) != _magic) {
      throw const FormatException('Not a keypoints file');
    }
    var o = 4;
    final version = d.getUint16(o, Endian.little);
    if (version != 1) throw FormatException('Unsupported version $version');
    final points = d.getUint16(o += 2, Endian.little);
    final frameCount = d.getUint32(o += 2, Endian.little);
    final fps = d.getFloat32(o += 4, Endian.little);
    final width = d.getUint32(o += 4, Endian.little);
    final height = d.getUint32(o += 4, Endian.little);
    final modelLen = d.getUint16(o += 4, Endian.little);
    o += 2;
    final model = utf8.decode(bytes.sublist(o, o + modelLen));
    o += modelLen;
    final frameSize = 5 + points * 12;
    if (bytes.length < o + frameCount * frameSize) {
      throw const FormatException('Truncated keypoints file');
    }
    final frames = <PoseFrame>[];
    for (var f = 0; f < frameCount; f++) {
      final t = d.getUint32(o, Endian.little);
      final detected = bytes[o + 4] == 1;
      var p = o + 5;
      List<Landmark>? lms;
      if (detected) {
        lms = List.generate(points, (i) {
          final b = p + i * 12;
          return Landmark(d.getFloat32(b, Endian.little),
              d.getFloat32(b + 4, Endian.little), d.getFloat32(b + 8, Endian.little));
        });
      }
      frames.add(PoseFrame(t, lms));
      o += frameSize;
    }
    return KeypointSequence(
        fps: fps, width: width, height: height, model: model, frames: frames);
  }

  /// Same layout as the native writer (used by tests and tools).
  Uint8List encode() {
    final points = frames
        .firstWhere((f) => f.points != null, orElse: () => const PoseFrame(0, null))
        .points
        ?.length ??
        Lm.count;
    final name = utf8.encode(model);
    final b = BytesBuilder();
    final header = ByteData(26);
    for (var i = 0; i < 4; i++) {
      header.setUint8(i, _magic.codeUnitAt(i));
    }
    header
      ..setUint16(4, 1, Endian.little)
      ..setUint16(6, points, Endian.little)
      ..setUint32(8, frames.length, Endian.little)
      ..setFloat32(12, fps, Endian.little)
      ..setUint32(16, width, Endian.little)
      ..setUint32(20, height, Endian.little)
      ..setUint16(24, name.length, Endian.little);
    b.add(header.buffer.asUint8List());
    b.add(name);
    for (final f in frames) {
      final fd = ByteData(5 + points * 12)
        ..setUint32(0, f.timestampMs, Endian.little)
        ..setUint8(4, f.points == null ? 0 : 1);
      for (var i = 0; i < points; i++) {
        final lm = f.points?[i];
        fd
          ..setFloat32(5 + i * 12, lm?.x ?? 0, Endian.little)
          ..setFloat32(9 + i * 12, lm?.y ?? 0, Endian.little)
          ..setFloat32(13 + i * 12, lm?.visibility ?? 0, Endian.little);
      }
      b.add(fd.buffer.asUint8List());
    }
    return b.toBytes();
  }

  /// Horizontal flip for left-handed golfers (AI_ANALYSIS_SPEC §14): rules
  /// are written for right-handers. Flip back when drawing the overlay.
  KeypointSequence mirrored() {
    final swap = List<int>.generate(Lm.count, (i) => i);
    for (final p in Lm.pairs) {
      swap[p[0]] = p[1];
      swap[p[1]] = p[0];
    }
    return KeypointSequence(
      fps: fps,
      width: width,
      height: height,
      model: model,
      frames: [
        for (final f in frames)
          PoseFrame(
            f.timestampMs,
            f.points == null
                ? null
                : List.generate(f.points!.length, (i) {
                    final src = f.points![swap[i]];
                    return Landmark(1 - src.x, src.y, src.visibility);
                  }),
          ),
      ],
    );
  }

  /// Frame closest to [ms] (binary search; frames are time-ordered).
  PoseFrame? frameAt(int ms) {
    if (frames.isEmpty) return null;
    var lo = 0, hi = frames.length - 1;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (frames[mid].timestampMs < ms) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    if (lo > 0 &&
        (ms - frames[lo - 1].timestampMs).abs() < (frames[lo].timestampMs - ms).abs()) {
      lo--;
    }
    return frames[lo];
  }
}
