import 'dart:io';

import 'package:camera/camera.dart' as plugin;
import 'package:capture/capture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

export 'package:capture/capture.dart' show CameraLens;

enum RecorderError { denied, unavailable, failed }

class RecorderException implements Exception {
  const RecorderException(this.error);
  final RecorderError error;
}

/// Camera used by the record screen. iOS records with the native `capture`
/// plugin (both lenses, upright, never mirrored). Android keeps the
/// `camera` plugin, back camera only, until the CameraX recorder exists.
abstract class SwingRecorder {
  factory SwingRecorder.forPlatform() =>
      Platform.isIOS ? _NativeRecorder() : _PluginRecorder();

  /// Lenses that can be opened; empty means no usable camera.
  Future<List<CameraLens>> lenses();

  /// Opens [lens], closing the current camera first.
  Future<void> open(CameraLens lens);

  bool get isOpen;

  Widget preview();

  Future<void> start();

  /// Finishes the clip and returns its file.
  Future<File> stop();

  Future<void> close();
}

/// Asks for 60 fps; the real rate is always read back from the file.
const _targetFps = 60;

class _NativeRecorder implements SwingRecorder {
  final _camera = NativeCamera();
  CameraPreviewInfo? _info;
  String? _path;

  @override
  Future<List<CameraLens>> lenses() => _guard(_camera.availableLenses);

  @override
  Future<void> open(CameraLens lens) async {
    _info = null;
    _info = await _guard(() => _camera.open(lens, targetFps: _targetFps));
  }

  @override
  bool get isOpen => _info != null;

  @override
  Widget preview() => NativeCameraPreview(_info!);

  @override
  Future<void> start() async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${const Uuid().v4()}.mp4';
    await _guard(() => _camera.startRecording(path));
    _path = path;
  }

  @override
  Future<File> stop() async {
    await _guard(_camera.stopRecording);
    final path = _path!;
    _path = null;
    return File(path);
  }

  @override
  Future<void> close() async {
    _info = null;
    await _camera.close();
  }

  static Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on PlatformException catch (e) {
      throw RecorderException(switch (e.code) {
        'permission_denied' => RecorderError.denied,
        'camera_unavailable' => RecorderError.unavailable,
        _ => RecorderError.failed,
      });
    }
  }
}

class _PluginRecorder implements SwingRecorder {
  plugin.CameraController? _controller;
  plugin.CameraDescription? _back;

  @override
  Future<List<CameraLens>> lenses() async {
    final cameras = await _guard(plugin.availableCameras);
    _back = cameras.where((c) => c.lensDirection == plugin.CameraLensDirection.back).firstOrNull;
    // The plugin mirrors front recordings, which swaps left and right.
    return _back == null ? const [] : const [CameraLens.back];
  }

  @override
  Future<void> open(CameraLens lens) async {
    await close();
    for (final fps in [_targetFps, null]) {
      final c = plugin.CameraController(_back!, plugin.ResolutionPreset.high,
          enableAudio: false, fps: fps);
      try {
        await c.initialize();
        // Portrait UI; without a lock the plugin can record sideways frames.
        await c.lockCaptureOrientation(DeviceOrientation.portraitUp);
        await c.prepareForVideoRecording();
        _controller = c;
        return;
      } on plugin.CameraException catch (e) {
        await c.dispose();
        if (e.code.startsWith('CameraAccess')) throw const RecorderException(RecorderError.denied);
        if (fps == null) throw const RecorderException(RecorderError.failed);
      }
    }
  }

  @override
  bool get isOpen => _controller?.value.isInitialized ?? false;

  @override
  Widget preview() => plugin.CameraPreview(_controller!);

  @override
  Future<void> start() => _guard(_controller!.startVideoRecording);

  @override
  Future<File> stop() async => File((await _guard(_controller!.stopVideoRecording)).path);

  @override
  Future<void> close() async {
    final c = _controller;
    _controller = null;
    await c?.dispose();
  }

  static Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on plugin.CameraException catch (e) {
      throw RecorderException(
          e.code.startsWith('CameraAccess') ? RecorderError.denied : RecorderError.failed);
    }
  }
}
