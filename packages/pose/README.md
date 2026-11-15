# pose

Plugin native của Golf Coach AI: ước lượng tư thế trên máy bằng **MediaPipe Pose Landmarker (full)**, xem `docs/PLATFORM_DECISION.md` mục 3.2.

- iOS: MediaPipeTasksVision qua Swift Package Manager (ghim commit trong `ios/pose/Package.swift`). Đọc khung hình đã xoay đứng, cạnh dài tối đa 1280 px.
- Android: **chưa làm** (trả lỗi `unsupported`). Phải dùng cùng model và cùng định dạng tệp keypoints.
- Model: `assets/models/pose_landmarker_full.task` của app (33 điểm). Giấy phép Apache 2.0 theo model card "BlazePose GHUM 3D"; xem `assets/models/NOTICE`.
- Kết quả: tệp keypoints nhị phân. Định dạng mô tả ở `ios/pose/Sources/pose/VideoPoseRunner.swift` (`KeypointsWriter`) và được đọc bởi `packages/analysis_core`.

Sinh lại kênh: `cd packages/pose && dart run pigeon --input pigeons/pose_api.dart`
