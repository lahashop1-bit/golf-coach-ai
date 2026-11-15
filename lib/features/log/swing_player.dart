import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../app/labels.dart';
import '../../app/theme.dart';
import '../../widgets/common.dart';

/// Replay with 0.25x/0.5x/1x and frame stepping (UI_UX_SPEC §5.2).
/// Frame stepping seeks by 1/fps; accuracy is the Phase 1 spike to verify.
class SwingPlayer extends StatefulWidget {
  const SwingPlayer({super.key, required this.file, required this.fps});

  final File file;
  final double fps;

  @override
  State<SwingPlayer> createState() => _SwingPlayerState();
}

class _SwingPlayerState extends State<SwingPlayer> {
  late final VideoPlayerController _c;
  bool _failed = false;
  double _speed = 0.5;

  static const _speeds = [0.25, 0.5, 1.0];

  @override
  void initState() {
    super.initState();
    _c = VideoPlayerController.file(widget.file)..addListener(_onTick);
    _init();
  }

  Future<void> _init() async {
    if (!await widget.file.exists()) return setState(() => _failed = true);
    try {
      await _c.initialize();
      await _c.setVolume(0);
      await _c.setPlaybackSpeed(_speed);
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  void _onTick() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _c.removeListener(_onTick);
    _c.dispose();
    super.dispose();
  }

  Duration get _frame => Duration(
      microseconds: (1e6 / (widget.fps > 0 ? widget.fps : 30)).round());

  Future<void> _step(int frames) async {
    await _c.pause();
    final target = _c.value.position + _frame * frames;
    final clamped = target < Duration.zero
        ? Duration.zero
        : (target > _c.value.duration ? _c.value.duration : target);
    await _c.seekTo(clamped);
  }

  Future<void> _togglePlay() async {
    if (_c.value.isPlaying) return _c.pause();
    if (_c.value.position >= _c.value.duration) await _c.seekTo(Duration.zero);
    await _c.play();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (_failed) {
      return EmptyState(icon: Icons.videocam_off_outlined, message: l.videoMissing);
    }
    if (!_c.value.isInitialized) {
      return const AspectRatio(
          aspectRatio: 9 / 16, child: Center(child: CircularProgressIndicator()));
    }
    final v = _c.value;
    final durMs = v.duration.inMilliseconds.toDouble();
    return Column(children: [
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.55),
        child: AspectRatio(
          aspectRatio: v.aspectRatio,
          child: GestureDetector(onTap: _togglePlay, child: VideoPlayer(_c)),
        ),
      ),
      Slider(
        value: v.position.inMilliseconds.clamp(0, durMs).toDouble(),
        max: durMs <= 0 ? 1 : durMs,
        onChangeStart: (_) => _c.pause(),
        onChanged: (ms) => _c.seekTo(Duration(milliseconds: ms.round())),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(
          tooltip: l.prevFrame,
          iconSize: 32,
          onPressed: () => _step(-1),
          icon: const Icon(Icons.skip_previous_rounded),
        ),
        const SizedBox(width: Gap.m),
        IconButton.filled(
          tooltip: v.isPlaying ? l.pause : l.play,
          iconSize: 40,
          onPressed: _togglePlay,
          icon: Icon(v.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
        ),
        const SizedBox(width: Gap.m),
        IconButton(
          tooltip: l.nextFrame,
          iconSize: 32,
          onPressed: () => _step(1),
          icon: const Icon(Icons.skip_next_rounded),
        ),
      ]),
      const SizedBox(height: Gap.s),
      Semantics(
        label: l.speedLabel,
        child: SegmentedButton<double>(
          segments: [
            for (final s in _speeds)
              ButtonSegment(value: s, label: Text('${s == 1 ? '1' : s}x')),
          ],
          selected: {_speed},
          onSelectionChanged: (v) {
            setState(() => _speed = v.first);
            _c.setPlaybackSpeed(_speed);
          },
        ),
      ),
    ]);
  }
}
