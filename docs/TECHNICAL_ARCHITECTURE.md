# Technical Architecture

## 1. Nguyên tắc kiến trúc

MVP chạy trên iOS và Android: Flutter cho UI/domain/dữ liệu, module native cho camera và pose estimation (xem [PLATFORM_DECISION.md](PLATFORM_DECISION.md)). Tách rõ client, domain, data, video processing và AI backend. Tránh khóa sản phẩm vào một nhà cung cấp AI duy nhất.

## 2. Stack đề xuất

### Mobile (iOS + Android)
- Flutter (Dart): UI, điều hướng, state (Riverpod — đề xuất), domain.
- Analysis core thuần Dart dùng chung: QualityRules, PhaseDetector, TempoCalculator, IssueDetector, FocusSelector.
- Plugin native `capture`: AVFoundation (iOS), CameraX (Android); thử plugin `camera` chính thức trước.
- Plugin native `pose`: cùng một model pose trên hai nền tảng (ứng viên MediaPipe Pose Landmarker, cần kiểm tra giấy phép); phân tích file video sau khi quay; trả về tệp keypoints.
- Giao tiếp native: Pigeon.
- Nhập video: trình chọn hệ thống (PHPicker / Android Photo Picker).
- Playback: `video_player`, hoặc native nếu cần tua từng khung hình chính xác.
- Dữ liệu local: drift (SQLite) có migration version; video trong vùng lưu trữ riêng của app.
- Localization: ARB + `flutter gen-l10n`.
- Điều hướng: `go_router` (4 tab bằng StatefulShellRoute).
- Nội dung biên soạn (IssueGuide, Drill, ShotTroubleGuide): file JSON có version theo locale trong assets của app; không cần API ở MVP.
- Người dùng: một hồ sơ local, không đăng nhập ở MVP.
- Tua từng khung hình: thử `video_player.seekTo` theo bước 1/FPS ở Phase 1; nếu không chính xác khung hình trên một nền tảng, thêm player native trong plugin `capture`.

### Backend (khi cần cloud analysis)
- API service có xác thực.
- Object storage riêng tư cho video.
- Job queue cho phân tích video dài.
- Worker inference tách biệt khỏi API.
- Database quan hệ cho user/session/analysis metadata.
- Signed URL có thời hạn; không public bucket.
- Observability không ghi nội dung video hoặc secrets vào log.

Không chốt framework backend trước khi có prototype và ước tính chi phí. Có thể chọn TypeScript, Python hoặc Dart tùy đội ngũ và inference stack. MVP không cần backend: phân tích, báo cáo và nội dung đều trên máy.

## 3. Module gợi ý

Mỗi module là một feature folder trong Flutter (`lib/features/<name>`); analysis core là package Dart riêng (`packages/analysis_core`); plugin native ở `packages/capture`, `packages/pose`.

- AppShell: navigation, theme, localization.
- Onboarding: golfer profile.
- Camera: permissions, preview, capture.
- VideoLibrary: import, storage, playback.
- SwingSession: session lifecycle.
- Analysis: API client, local inference, result models.
- DrillLibrary: curated drills.
- Progress: history and comparisons.
- Settings: language, privacy, units.
- SharedDesignSystem: buttons, cards, typography, spacing.

## 4. Luồng dữ liệu

1. User tạo swing session.
2. Camera ghi video local.
3. App kiểm tra video metadata và quality cơ bản.
4. User xem lại và đồng ý phân tích.
5. Nếu on-device: xử lý local.
6. Nếu cloud: hiển thị rõ thông tin upload, xin consent, upload qua signed URL.
7. Backend tạo job và trả trạng thái.
8. Client nhận kết quả có version, confidence và limitations.
9. App hiển thị nội dung theo locale.
10. User lưu, xóa hoặc phản hồi kết quả.

## 5. API khái niệm

- POST /v1/sessions
- POST /v1/videos/upload-intents
- POST /v1/analyses
- GET /v1/analyses/{analysisId}
- GET /v1/drills?locale=vi-VN (sau MVP; MVP đóng gói nội dung trong app)
- GET /v1/sessions
- DELETE /v1/videos/{videoId}
- DELETE /v1/users/me/data

Đây là endpoint đề xuất, chưa phải API đã triển khai. Cần xác định auth, schema, rate limits và idempotency trước production.

## 6. Bảo mật

- Không commit token, private key, service account hay .env thật.
- HTTPS bắt buộc.
- Mã hóa video at rest và in transit.
- Signed URL có TTL ngắn.
- Authorization kiểm tra ownership ở mọi endpoint.
- Giới hạn kích thước, định dạng và thời lượng video.
- Xóa dữ liệu theo yêu cầu và có quy trình xóa backup theo retention policy.
- Không log URL ký, token hoặc dữ liệu nhạy cảm.
- Có privacy policy và consent rõ ràng trước cloud processing.

## 7. Offline-first

- Camera, xem video, ghi chú và thư viện drill cơ bản nên hoạt động offline.
- Phân tích cloud hiển thị trạng thái “Cần kết nối mạng”.
- Đồng bộ không ghi đè dữ liệu mới hơn.
- Cho phép người dùng chọn thời điểm upload.

## 8. Kiểm thử

- Unit test cho session state, localization fallback, schema validation.
- Camera tests trên thiết bị thật.
- UI tests cho onboarding → record → review → analyze → result → drill.
- Test video hỏng, dung lượng thấp, quyền camera bị từ chối, mất mạng và app background.
- Kiểm tra hiệu năng, nhiệt độ và pin khi xử lý video.

## 9. Module bổ sung cho MVP phân tích

- **QualityCheck:** kiểm tra sáng, toàn thân, rung, che khuất.
- **PoseEngine:** plugin native `pose` (cùng model trên iOS/Android); phía Dart làm mượt keypoints, giữ confidence. Giao diện qua abstract class để thay model.
- **PhaseDetector:** tìm 8 pha, chấp nhận mốc người dùng chỉnh.
- **TempoCalculator:** đo thời gian pha và tỷ lệ nhịp.
- **IssueDetector:** luật hình học theo từng `issueId`, có điều kiện áp dụng (góc, pha, confidence). Mỗi lỗi là một module nhỏ, bật/tắt bằng cấu hình.
- **FocusSelector:** chọn lỗi ưu tiên theo luật (tần suất, thứ tự biên tập, confidence).
- **GuideRepository:** IssueGuide và Drill theo locale, có version.
- **Insights/Report:** tổng hợp phiên/ngày (tính trên máy).
- **Overlay:** vẽ khung xương và đường tham chiếu lên video.
- **Goals / ShotFix:** Should have, tách module.

## 10. Luồng phân tích trên máy

QualityCheck → PoseEngine → PhaseDetector → TempoCalculator → IssueDetector → FocusSelector → ghi SwingAnalysis + IssueObservation → UI.

- Chạy ở nền bằng async/await, hỗ trợ cancellation, báo tiến trình.
- Kết quả có `modelVersion` và `schemaVersion`; có thể phân tích lại khi model nâng cấp mà không mất video gốc.
- Keypoints lưu ở tệp dẫn xuất, xóa cùng video.
- Feature flag từng `issueId` (cấu hình từ xa hoặc bundle) để tắt nhanh nếu phát hiện sai.
- Cloud chỉ là phương án dự phòng khi on-device không đủ; cần đồng ý riêng.
- Báo cáo ngày/tuần tính trên máy từ dữ liệu local ở MVP; không cần backend.

## 11. Kiểm thử bổ sung

- Bộ video chuẩn có nhãn để chạy đánh giá lặp lại (regression) cho từng lỗi và góc quay.
- Unit test cho PhaseDetector, TempoCalculator, FocusSelector bằng dữ liệu keypoints mẫu.
- Kiểm thử hiệu năng: thời gian phân tích mỗi cú, nhiệt, pin trên iPhone và máy Android thấp nhất trong ma trận thiết bị.
- Chạy bộ video regression trên cả hai nền tảng; so sánh kết quả để phát hiện lệch.
- Widget test cho UI Flutter; integration test (`integration_test`) cho luồng chính trên simulator/emulator.
