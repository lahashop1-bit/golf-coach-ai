# capture

Plugin native của Golf Coach AI cho camera/video (xem `docs/PLATFORM_DECISION.md` mục 3.1).

API hiện có:
- `Capture().probeVideo(path, thumbnailPath:)` → FPS thật, thời lượng, kích thước, hướng xoay, dung lượng; ghi ảnh bìa JPEG nếu được yêu cầu.
  - iOS: AVFoundation. Android: MediaMetadataRetriever + MediaExtractor.

Kênh native sinh bằng Pigeon. Sau khi sửa `pigeons/capture_api.dart`:

```sh
cd packages/capture && dart run pigeon --input pigeons/capture_api.dart
```
