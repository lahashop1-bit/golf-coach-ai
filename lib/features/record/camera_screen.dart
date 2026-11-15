import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/labels.dart';
import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/swing_repository.dart';
import '../../domain/enums.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../widgets/common.dart';
import '../analysis/analysis_jobs.dart';
import 'recording_session.dart';
import 'swing_review_sheet.dart';

enum _Phase { idle, countdown, recording, saving }

enum _CameraError { denied, unavailable, failed }

/// One clip per swing: Start → Stop (or auto-stop) → save → next swing
/// (GOLF_FEATURES §2.1). No microphone: audio is disabled.
class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key, required this.setup});

  final SessionSetup setup;

  /// Auto-stop guard so a forgotten recording does not fill the phone.
  static const maxClip = Duration(seconds: 15);

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = const [];
  int _cameraIndex = 0;
  _CameraError? _error;
  _Phase _phase = _Phase.idle;
  int _countdown = 0;
  Duration _elapsed = Duration.zero;
  Timer? _ticker;
  late final RecordingSession _session;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _session = RecordingSession(ref.read(swingRepositoryProvider),
        ref.read(profileProvider).requireValue!, widget.setup);
    _initCameras();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    _controller?.dispose();
    _session.finish();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final c = _controller;
    if (state == AppLifecycleState.inactive) {
      // A recording interrupted by a call/background is discarded.
      _ticker?.cancel();
      _controller = null;
      c?.dispose();
      if (mounted) setState(() => _phase = _Phase.idle);
    } else if (state == AppLifecycleState.resumed && c == null && _error == null) {
      _openCamera();
    }
  }

  Future<void> _initCameras() async {
    try {
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      return _fail(e);
    }
    if (_cameras.isEmpty) {
      return setState(() => _error = _CameraError.unavailable);
    }
    final back = _cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.back);
    _cameraIndex = back < 0 ? 0 : back;
    await _openCamera();
  }

  Future<void> _openCamera() async {
    final description = _cameras[_cameraIndex];
    // Ask for 60 fps; fall back to the preset's default when unsupported.
    // The real FPS is always read back from the file.
    for (final fps in [60, null]) {
      final c = CameraController(description, ResolutionPreset.high,
          enableAudio: false, fps: fps);
      try {
        await c.initialize();
        await c.prepareForVideoRecording();
        if (!mounted) {
          await c.dispose();
          return;
        }
        setState(() {
          _controller = c;
          _error = null;
        });
        return;
      } on CameraException catch (e) {
        await c.dispose();
        if (_isPermissionError(e) || fps == null) return _fail(e);
      }
    }
  }

  bool _isPermissionError(CameraException e) => e.code.startsWith('CameraAccess');

  void _fail(CameraException e) {
    if (!mounted) return;
    setState(() => _error =
        _isPermissionError(e) ? _CameraError.denied : _CameraError.failed);
  }

  Future<void> _flip() async {
    if (_cameras.length < 2 || _phase != _Phase.idle) return;
    final old = _controller;
    setState(() {
      _controller = null;
      _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    });
    await old?.dispose();
    await _openCamera();
  }

  Future<void> _start() async {
    final seconds = widget.setup.timerSeconds;
    if (seconds > 0) {
      setState(() {
        _phase = _Phase.countdown;
        _countdown = seconds;
      });
      while (_countdown > 0) {
        await Future<void>.delayed(const Duration(seconds: 1));
        if (!mounted || _phase != _Phase.countdown) return;
        setState(() => _countdown--);
      }
    }
    final c = _controller;
    if (c == null) return;
    await c.startVideoRecording();
    final started = DateTime.now();
    setState(() {
      _phase = _Phase.recording;
      _elapsed = Duration.zero;
    });
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() => _elapsed = DateTime.now().difference(started));
      if (_elapsed >= CameraScreen.maxClip) _stop();
    });
  }

  Future<void> _stop() async {
    final c = _controller;
    if (_phase == _Phase.countdown) return setState(() => _phase = _Phase.idle);
    if (c == null || _phase != _Phase.recording) return;
    _ticker?.cancel();
    setState(() => _phase = _Phase.saving);
    try {
      final file = await c.stopVideoRecording();
      final swing = await _session.save(File(file.path));
      if (!mounted) return;
      setState(() => _phase = _Phase.idle);
      if (widget.setup.feedbackTiming == FeedbackTiming.afterEach &&
          !await showSwingReviewSheet(context, swing)) {
        await _session.discard(swing);
        if (mounted) setState(() {});
      }
      // Guided mode analyzes every kept swing in the background.
      if (widget.setup.mode == SessionMode.guidedAnalysis &&
          _session.kept.any((s) => s.id == swing.id)) {
        ref.read(analysisJobsProvider.notifier).enqueue(swing.id);
      }
      if (_session.isComplete) await _finish();
    } catch (_) {
      if (!mounted) return;
      setState(() => _phase = _Phase.idle);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    }
  }

  Future<void> _finish() async {
    await _session.finish();
    if (mounted) context.go('/log');
  }

  Future<bool> _confirmLeave() async {
    if (_phase == _Phase.idle) return true;
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(l.leaveRecordingTitle),
        content: Text(l.leaveRecordingBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.actionCancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l.finishSession)),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      canPop: _phase == _Phase.idle,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop && await _confirmLeave() && context.mounted) {
          _ticker?.cancel();
          _phase = _Phase.idle;
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(_summary(l)),
          actions: [
            if (_session.count > 0 && _phase == _Phase.idle)
              TextButton(
                onPressed: _finish,
                child: Text(l.finishSession, style: const TextStyle(color: Colors.white)),
              ),
          ],
        ),
        body: SafeArea(child: _body(l)),
      ),
    );
  }

  String _summary(AppLocalizations l) {
    final s = widget.setup;
    return [clubText(l, s.clubType, s.clubNumber), s.cameraAngle.shortLabel(l)]
        .join(' · ');
  }

  Widget _body(AppLocalizations l) {
    switch (_error) {
      case _CameraError.denied:
        return _message(Icons.no_photography_outlined, l.cameraPermissionDenied);
      case _CameraError.unavailable:
        return _message(Icons.videocam_off_outlined, l.cameraUnavailable);
      case _CameraError.failed:
        return _message(Icons.error_outline, l.errorGeneric);
      case null:
    }
    final c = _controller;
    if (c == null || !c.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    final planned = widget.setup.plannedSwingCount;
    final next = _session.count + 1;
    return Column(children: [
      Expanded(
        child: Stack(alignment: Alignment.center, children: [
          Center(child: CameraPreview(c)),
          if (_phase == _Phase.countdown)
            Text('$_countdown',
                style: const TextStyle(fontSize: 120, color: Colors.white,
                    fontWeight: FontWeight.bold)),
          if (_phase == _Phase.saving) const CircularProgressIndicator(),
          Positioned(top: Gap.s, left: Gap.s, child: _statusChip(l)),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.all(Gap.m),
        child: Row(children: [
          Expanded(
            child: Text(
              planned == null ? l.swingNumber(next) : l.swingProgress(next, planned),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          _recordButton(l),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _cameras.length > 1
                  ? IconButton(
                      tooltip: l.flipCamera,
                      color: Colors.white,
                      iconSize: 32,
                      onPressed: _phase == _Phase.idle ? _flip : null,
                      icon: const Icon(Icons.cameraswitch_outlined),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _statusChip(AppLocalizations l) {
    if (_phase != _Phase.recording) return const SizedBox.shrink();
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
        child: Text('● ${l.recordingLabel} ${formatSeconds(context, _elapsed.inMilliseconds)}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _recordButton(AppLocalizations l) {
    final active = _phase == _Phase.recording || _phase == _Phase.countdown;
    return Semantics(
      button: true,
      label: active ? l.stopRecording : l.startRecording,
      child: GestureDetector(
        onTap: _phase == _Phase.saving ? null : (active ? _stop : _start),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: active ? 32 : 64,
            height: active ? 32 : 64,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(active ? 6 : 32),
            ),
          ),
        ),
      ),
    );
  }

  Widget _message(IconData icon, String text) => Theme(
        data: ThemeData.dark(useMaterial3: true),
        child: EmptyState(icon: icon, message: text),
      );
}
