import 'package:flutter/widgets.dart';

import 'messages.g.dart';

/// Draws the native preview texture upright (and mirrored for the front
/// camera, like a mirror), filling the width at the picture's aspect ratio.
class NativeCameraPreview extends StatelessWidget {
  const NativeCameraPreview(this.info, {super.key});

  final CameraPreviewInfo info;

  @override
  Widget build(BuildContext context) {
    final turns = (info.rotationDegrees ~/ 90) % 4;
    final sideways = turns.isOdd;
    final w = (sideways ? info.height : info.width).toDouble();
    final h = (sideways ? info.width : info.height).toDouble();
    Widget view = RotatedBox(quarterTurns: turns, child: Texture(textureId: info.textureId));
    if (info.mirrored) {
      view = Transform.flip(flipX: true, child: view);
    }
    return AspectRatio(aspectRatio: w / h, child: view);
  }
}
