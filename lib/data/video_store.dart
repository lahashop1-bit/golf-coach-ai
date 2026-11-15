import 'dart:io';

import 'package:path/path.dart' as p;

/// Video files live in the app's private documents directory. The DB stores
/// paths relative to [root] because the iOS container path changes between
/// installs/updates.
class VideoStore {
  VideoStore(this.root);

  final Directory root;

  static const _dir = 'swings';

  String clipRelativePath(String swingId, String extension) =>
      p.join(_dir, '$swingId$extension');

  String thumbnailRelativePath(String swingId) => p.join(_dir, '$swingId.jpg');

  String absolute(String relativePath) => p.join(root.path, relativePath);

  /// Moves (or copies when moving fails, e.g. across volumes) [source] into
  /// the store and returns the relative path.
  Future<String> importFile(File source, String swingId) async {
    final ext = p.extension(source.path).isEmpty
        ? '.mp4'
        : p.extension(source.path).toLowerCase();
    final rel = clipRelativePath(swingId, ext);
    final target = File(absolute(rel));
    await target.parent.create(recursive: true);
    try {
      await source.rename(target.path);
    } on FileSystemException {
      await source.copy(target.path);
    }
    return rel;
  }

  Future<void> deleteFiles(Iterable<String?> relativePaths) async {
    for (final rel in relativePaths) {
      if (rel == null) continue;
      final f = File(absolute(rel));
      if (await f.exists()) await f.delete();
    }
  }

  Future<void> deleteAll() async {
    final dir = Directory(p.join(root.path, _dir));
    if (await dir.exists()) await dir.delete(recursive: true);
  }
}
